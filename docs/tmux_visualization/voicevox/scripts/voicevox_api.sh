#!/bin/bash
# VOICEVOX API Wrapper
# Version: 1.0.0

# ============================================================
# Voice Synthesis
# ============================================================

synthesize_voice() {
    local speaker_id=$1
    local text=$2
    local output_file="${TEMP_DIR}/voicevox_audio_$$.wav"

    log "DEBUG" "Synthesizing voice: speaker=$speaker_id, text='$text'"

    # Step 1: Create audio query
    local query=$(create_audio_query "$speaker_id" "$text")

    if [[ $? -ne 0 ]] || [[ -z "$query" ]]; then
        log "ERROR" "Audio query creation failed"
        return 1
    fi

    log "DEBUG" "Audio query created successfully"

    # Step 2: Synthesize audio
    local http_code=$(curl -s -w "%{http_code}" \
        -X POST \
        -H "Content-Type: application/json" \
        -H "accept: audio/wav" \
        -d "$query" \
        "${VOICEVOX_API_URL}/synthesis?speaker=$speaker_id" \
        -o "$output_file")

    if [[ $http_code -ne 200 ]]; then
        log "ERROR" "Voice synthesis failed: HTTP $http_code"
        rm -f "$output_file"

        # Retry logic
        if [[ ${API_RETRY_COUNT:-3} -gt 0 ]]; then
            log "INFO" "Retrying voice synthesis..."
            sleep "${API_RETRY_DELAY:-1}"
            synthesize_voice_with_retry "$speaker_id" "$text" 1
            return $?
        fi

        return 1
    fi

    # Verify output file
    if [[ ! -f "$output_file" ]] || [[ ! -s "$output_file" ]]; then
        log "ERROR" "Output file is empty or does not exist"
        return 1
    fi

    log "DEBUG" "Voice synthesis successful: $output_file"
    echo "$output_file"
    return 0
}

synthesize_voice_with_retry() {
    local speaker_id=$1
    local text=$2
    local attempt=$3

    if [[ $attempt -gt ${API_RETRY_COUNT:-3} ]]; then
        log "ERROR" "Max retry attempts reached"
        return 1
    fi

    log "INFO" "Retry attempt $attempt/${API_RETRY_COUNT:-3}"

    local output_file="${TEMP_DIR}/voicevox_audio_$$_retry${attempt}.wav"
    local query=$(create_audio_query "$speaker_id" "$text")

    if [[ $? -ne 0 ]]; then
        sleep "${API_RETRY_DELAY:-1}"
        synthesize_voice_with_retry "$speaker_id" "$text" $((attempt + 1))
        return $?
    fi

    local http_code=$(curl -s -w "%{http_code}" \
        -X POST \
        -H "Content-Type: application/json" \
        -H "accept: audio/wav" \
        -d "$query" \
        "${VOICEVOX_API_URL}/synthesis?speaker=$speaker_id" \
        -o "$output_file")

    if [[ $http_code -eq 200 ]] && [[ -f "$output_file" ]] && [[ -s "$output_file" ]]; then
        echo "$output_file"
        return 0
    else
        rm -f "$output_file"
        sleep "${API_RETRY_DELAY:-1}"
        synthesize_voice_with_retry "$speaker_id" "$text" $((attempt + 1))
        return $?
    fi
}

# ============================================================
# Audio Query Creation
# ============================================================

create_audio_query() {
    local speaker_id=$1
    local text=$2

    # URL encode text
    local encoded_text=$(urlencode "$text")

    log "DEBUG" "Creating audio query for speaker $speaker_id"

    # Make API call
    local query=$(curl -s -X POST \
        "${VOICEVOX_API_URL}/audio_query?text=${encoded_text}&speaker=${speaker_id}")

    if [[ -z "$query" ]]; then
        log "ERROR" "Empty response from audio_query endpoint"
        return 1
    fi

    # Check if response is valid JSON
    if ! echo "$query" | jq empty 2>/dev/null; then
        log "ERROR" "Invalid JSON response from audio_query"
        return 1
    fi

    # Apply audio parameters
    query=$(echo "$query" | jq \
        --arg speed "${SPEECH_SPEED:-1.0}" \
        --arg volume "${AUDIO_VOLUME:-1.0}" \
        --arg pitch "${PITCH_SCALE:-0.0}" \
        --arg intonation "${INTONATION_SCALE:-1.0}" \
        '.speedScale = ($speed | tonumber) |
         .volumeScale = ($volume | tonumber) |
         .pitchScale = ($pitch | tonumber) |
         .intonationScale = ($intonation | tonumber)')

    if [[ $? -ne 0 ]]; then
        log "ERROR" "Failed to apply audio parameters"
        return 1
    fi

    echo "$query"
    return 0
}

# ============================================================
# URL Encoding
# ============================================================

urlencode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for ((pos=0; pos<strlen; pos++)); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9])
                o="$c"
                ;;
            *)
                printf -v o '%%%02x' "'$c"
                ;;
        esac
        encoded+="$o"
    done

    echo "$encoded"
}

# ============================================================
# API Health Check
# ============================================================

check_voicevox_api() {
    log "DEBUG" "Checking VOICEVOX API availability"

    local response=$(curl -s -w "\n%{http_code}" "${VOICEVOX_API_URL}/version")
    local http_code=$(echo "$response" | tail -1)
    local version=$(echo "$response" | head -1)

    if [[ $http_code -eq 200 ]]; then
        log "INFO" "VOICEVOX API is available (version: $version)"
        return 0
    else
        log "ERROR" "VOICEVOX API is not available (HTTP $http_code)"
        return 1
    fi
}

# ============================================================
# Speaker Information
# ============================================================

get_speakers() {
    log "DEBUG" "Fetching speaker list"

    local speakers=$(curl -s "${VOICEVOX_API_URL}/speakers")

    if [[ -z "$speakers" ]]; then
        log "ERROR" "Failed to fetch speakers"
        return 1
    fi

    echo "$speakers" | jq .
}

list_speakers() {
    echo "Available Speakers:"
    echo "==================="

    get_speakers | jq -r '.[] | "[\(.speaker_uuid | .[0:8])] \(.name)"'
}

list_speaker_styles() {
    local speaker_name=$1

    if [[ -z "$speaker_name" ]]; then
        echo "ERROR: Speaker name required" >&2
        return 1
    fi

    echo "Styles for: $speaker_name"
    echo "=========================="

    get_speakers | jq -r \
        --arg name "$speaker_name" \
        '.[] | select(.name == $name) | .styles[] | "  ID: \(.id) - \(.name)"'
}

get_speaker_id_by_name() {
    local speaker_name=$1
    local style_name=${2:-"ノーマル"}

    get_speakers | jq -r \
        --arg speaker "$speaker_name" \
        --arg style "$style_name" \
        '.[] | select(.name == $speaker) | .styles[] | select(.name == $style) | .id'
}

# ============================================================
# Preset Management
# ============================================================

get_presets() {
    curl -s "${VOICEVOX_API_URL}/presets" | jq .
}

apply_preset() {
    local preset_id=$1
    local query=$2

    # Fetch preset
    local preset=$(get_presets | jq --arg id "$preset_id" '.[] | select(.id == ($id | tonumber))')

    if [[ -z "$preset" ]]; then
        log "ERROR" "Preset not found: $preset_id"
        return 1
    fi

    # Apply preset to query
    echo "$query" | jq \
        --argjson preset "$preset" \
        '.speedScale = $preset.speedScale |
         .pitchScale = $preset.pitchScale |
         .intonationScale = $preset.intonationScale |
         .volumeScale = $preset.volumeScale'
}

# ============================================================
# Utility Functions
# ============================================================

# Get VOICEVOX version
get_api_version() {
    curl -s "${VOICEVOX_API_URL}/version" 2>/dev/null
}

# Check if VOICEVOX is running
is_voicevox_running() {
    if check_voicevox_api > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Get supported features
get_supported_features() {
    curl -s "${VOICEVOX_API_URL}/supported_devices" 2>/dev/null | jq .
}

# Get core versions
get_core_versions() {
    curl -s "${VOICEVOX_API_URL}/core_versions" 2>/dev/null | jq -r '.[]'
}

# ============================================================
# Pronunciation Dictionary
# ============================================================

add_pronunciation() {
    local word=$1
    local pronunciation=$2

    local payload=$(jq -n \
        --arg word "$word" \
        --arg yomi "$pronunciation" \
        '{
            surface: $word,
            pronunciation: $yomi,
            accent_type: 0,
            priority: 5
        }')

    curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "${VOICEVOX_API_URL}/user_dict_word"
}

get_user_dict() {
    curl -s "${VOICEVOX_API_URL}/user_dict" | jq .
}

# ============================================================
# Debug Functions
# ============================================================

debug_api_call() {
    local endpoint=$1
    shift

    echo "=== API Debug Info ==="
    echo "Endpoint: ${VOICEVOX_API_URL}${endpoint}"
    echo "Parameters: $@"
    echo ""
    echo "=== Response ==="

    curl -v "${VOICEVOX_API_URL}${endpoint}" "$@" 2>&1
}

# Test all API endpoints
test_api_endpoints() {
    echo "Testing VOICEVOX API Endpoints"
    echo "=============================="
    echo ""

    echo "1. Version:"
    curl -s "${VOICEVOX_API_URL}/version"
    echo ""
    echo ""

    echo "2. Speakers (first 3):"
    get_speakers | jq -r '.[0:3] | .[] | "  - \(.name)"'
    echo ""

    echo "3. Core Versions:"
    get_core_versions | sed 's/^/  - /'
    echo ""

    echo "4. Synthesis Test (四国めたん):"
    local test_audio=$(synthesize_voice 0 "テストです")
    if [[ $? -eq 0 ]]; then
        echo "  ✓ Success: $test_audio"
        rm -f "$test_audio"
    else
        echo "  ✗ Failed"
    fi
    echo ""
}

# ============================================================
# Export Functions
# ============================================================

# Make functions available to other scripts
export -f synthesize_voice
export -f create_audio_query
export -f urlencode
export -f check_voicevox_api
export -f get_speakers
export -f is_voicevox_running
