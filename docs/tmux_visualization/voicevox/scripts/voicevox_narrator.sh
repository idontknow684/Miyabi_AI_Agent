#!/bin/bash
# VOICEVOX Narrator - Main Narration Orchestrator
# Version: 1.0.0

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${BASE_DIR}/config/voicevox_config.sh"

# Load configuration
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "ERROR: Configuration file not found: $CONFIG_FILE" >&2
    echo "Please copy voicevox_config.example.sh to voicevox_config.sh" >&2
    exit 1
fi

# Load helper scripts
source "${SCRIPT_DIR}/voicevox_api.sh"
source "${SCRIPT_DIR}/audio_queue.sh"
source "${SCRIPT_DIR}/cache_manager.sh"

# ============================================================
# Logging
# ============================================================

log() {
    local level=$1
    local message=$2
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')

    # Check log level
    case $LOG_LEVEL in
        DEBUG) level_num=0 ;;
        INFO)  level_num=1 ;;
        WARN)  level_num=2 ;;
        ERROR) level_num=3 ;;
        *) level_num=1 ;;
    esac

    case $level in
        DEBUG) msg_level=0 ;;
        INFO)  msg_level=1 ;;
        WARN)  msg_level=2 ;;
        ERROR) msg_level=3 ;;
        *) msg_level=1 ;;
    esac

    if [[ $msg_level -ge $level_num ]]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"

        # Also print to stderr for ERROR and WARN
        if [[ $msg_level -ge 2 ]]; then
            echo "[$level] $message" >&2
        fi

        # Print to stdout in debug mode
        if [[ "${DEBUG_MODE:-false}" == "true" ]]; then
            echo "[$timestamp] [$level] $message"
        fi
    fi
}

# ============================================================
# Dialogue Management
# ============================================================

find_dialogue() {
    local event_name=$1
    local dialogue_file=""

    # Search in phase_transitions directory
    if [[ -f "${DIALOGUE_PHASE_DIR}/${event_name}.txt" ]]; then
        dialogue_file="${DIALOGUE_PHASE_DIR}/${event_name}.txt"
    # Search in convergence directory
    elif [[ -f "${DIALOGUE_CONVERGENCE_DIR}/${event_name}.txt" ]]; then
        dialogue_file="${DIALOGUE_CONVERGENCE_DIR}/${event_name}.txt"
    # Search in errors directory
    elif [[ -f "${DIALOGUE_ERROR_DIR}/${event_name}.txt" ]]; then
        dialogue_file="${DIALOGUE_ERROR_DIR}/${event_name}.txt"
    # Search in celebrations directory
    elif [[ -f "${DIALOGUE_CELEBRATION_DIR}/${event_name}.txt" ]]; then
        dialogue_file="${DIALOGUE_CELEBRATION_DIR}/${event_name}.txt"
    # Search in general directory
    elif [[ -f "${DIALOGUE_GENERAL_DIR}/${event_name}.txt" ]]; then
        dialogue_file="${DIALOGUE_GENERAL_DIR}/${event_name}.txt"
    fi

    if [[ -z "$dialogue_file" ]]; then
        log "WARN" "Dialogue not found for event: $event_name"
        return 1
    fi

    echo "$dialogue_file"
    return 0
}

execute_dialogue() {
    local dialogue_file=$1

    log "INFO" "Executing dialogue: $dialogue_file"

    local line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))

        # Skip comments and empty lines
        [[ $line =~ ^#.*$ ]] && continue
        [[ -z $line ]] && continue

        # Parse dialogue line
        if [[ $line =~ ^REIMU:[[:space:]]*(.+)$ ]]; then
            local text="${BASH_REMATCH[1]}"
            speak_text "reimu" "$text"
        elif [[ $line =~ ^MARISA:[[:space:]]*(.+)$ ]]; then
            local text="${BASH_REMATCH[1]}"
            speak_text "marisa" "$text"
        else
            log "WARN" "Invalid dialogue format at line $line_num: $line"
        fi
    done < "$dialogue_file"

    log "INFO" "Dialogue execution completed: $dialogue_file"
}

# ============================================================
# Speech Synthesis
# ============================================================

speak_text() {
    local character=$1
    local text=$2

    log "DEBUG" "Speaking as $character: $text"

    # Check if narration is enabled
    if [[ "${NARRATION_ENABLED:-true}" != "true" ]]; then
        log "DEBUG" "Narration disabled, skipping"
        return 0
    fi

    # Get speaker ID
    local speaker_id
    case $character in
        reimu)
            speaker_id=$REIMU_SPEAKER_ID
            ;;
        marisa)
            speaker_id=$MARISA_SPEAKER_ID
            ;;
        *)
            log "ERROR" "Unknown character: $character"
            return 1
            ;;
    esac

    # Process special syntax
    text=$(process_text_syntax "$text")

    # Check cache
    local cache_file=$(get_cache_file "$character" "$text")

    if [[ -f "$cache_file" ]] && [[ "${CACHE_ENABLED:-true}" == "true" ]]; then
        log "DEBUG" "Using cached audio: $cache_file"
        enqueue_audio "$cache_file" "normal"
        return 0
    fi

    # Synthesize voice
    local audio_file=$(synthesize_voice "$speaker_id" "$text")

    if [[ $? -ne 0 ]]; then
        log "ERROR" "Voice synthesis failed for: $text"
        fallback_text_display "$character" "$text"
        return 1
    fi

    # Save to cache
    if [[ "${CACHE_ENABLED:-true}" == "true" ]]; then
        cp "$audio_file" "$cache_file"
        log "DEBUG" "Cached audio: $cache_file"
    fi

    # Enqueue for playback
    enqueue_audio "$audio_file" "normal"

    log "DEBUG" "Audio enqueued: $audio_file"
    return 0
}

# Process special text syntax
process_text_syntax() {
    local text=$1

    # Remove pause markers {{seconds}}
    text=$(echo "$text" | sed 's/{{[0-9.]*}}//g')

    # Remove emotion markers [emotion]
    text=$(echo "$text" | sed 's/\[.*\]//g')

    # Remove volume markers <volume:X>...</volume>
    text=$(echo "$text" | sed 's/<volume:[0-9.]*>\(.*\)<\/volume>/\1/g')

    echo "$text"
}

# ============================================================
# Fallback Text Display
# ============================================================

fallback_text_display() {
    local character=$1
    local text=$2

    if [[ "${FALLBACK_TO_TEXT:-true}" != "true" ]]; then
        return 0
    fi

    log "INFO" "Fallback: Displaying text in tmux pane $TEXT_DISPLAY_PANE"

    # Display in tmux pane
    if command -v tmux > /dev/null 2>&1; then
        tmux send-keys -t "${TEXT_DISPLAY_PANE}" "echo '[$character] $text'" C-m
        sleep "${FALLBACK_TEXT_DURATION:-3}"
    else
        # Just print to stdout if tmux is not available
        echo "[$character] $text"
    fi
}

# ============================================================
# Event Handlers
# ============================================================

handle_event() {
    local event_name=$1

    log "INFO" "Handling event: $event_name"

    # Check narration frequency
    if [[ "${NARRATION_FREQUENCY:-all}" == "silent" ]]; then
        log "DEBUG" "Narration frequency is silent, skipping"
        return 0
    fi

    # Check if event is major (for "major" frequency mode)
    if [[ "${NARRATION_FREQUENCY:-all}" == "major" ]]; then
        if ! is_major_event "$event_name"; then
            log "DEBUG" "Event $event_name is not major, skipping"
            return 0
        fi
    fi

    # Find dialogue file
    local dialogue_file=$(find_dialogue "$event_name")

    if [[ $? -ne 0 ]]; then
        log "WARN" "No dialogue found for event: $event_name"
        return 1
    fi

    # Execute dialogue
    execute_dialogue "$dialogue_file"
}

is_major_event() {
    local event_name=$1

    # Major events: phase transitions, milestones, convergence 100%
    case $event_name in
        phase_theta*_start)
            return 0
            ;;
        convergence_100)
            return 0
            ;;
        milestone_reached)
            return 0
            ;;
        task_complete)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# ============================================================
# Test Functions
# ============================================================

test_voice() {
    local character=${1:-reimu}

    case $character in
        reimu)
            speak_text "reimu" "テスト音声です。霊夢だよ！"
            ;;
        marisa)
            speak_text "marisa" "テスト音声だぜ。魔理沙だ！"
            ;;
        both)
            speak_text "reimu" "ねぇねぇ魔理沙、テストしてるよ！"
            sleep 1
            speak_text "marisa" "ああ、ちゃんと動いてるぜ"
            ;;
        *)
            log "ERROR" "Unknown character for test: $character"
            echo "Usage: $0 test [reimu|marisa|both]" >&2
            return 1
            ;;
    esac

    log "INFO" "Voice test completed for: $character"
}

# ============================================================
# Status Display
# ============================================================

show_status() {
    cat << EOF
VOICEVOX Narrator Status
========================

Configuration:
  Narration Enabled: ${NARRATION_ENABLED:-false}
  Frequency: ${NARRATION_FREQUENCY:-all}
  Volume: ${AUDIO_VOLUME:-0.8}
  Speed: ${SPEECH_SPEED:-1.0}

Cache:
$(cache_stats)

Queue:
  Queue Size: $(queue_size)
  Queue Status: $(queue_status)

VOICEVOX API:
  Endpoint: ${VOICEVOX_API_URL}
  Status: $(check_voicevox_status)
  Version: $(get_voicevox_version)

Log File: ${LOG_FILE}
  Size: $(du -h "$LOG_FILE" 2>/dev/null | cut -f1 || echo "0")
  Last 5 entries:
$(tail -n 5 "$LOG_FILE" 2>/dev/null | sed 's/^/    /' || echo "    (no logs)")
EOF
}

check_voicevox_status() {
    if curl -s "${VOICEVOX_API_URL}/version" > /dev/null 2>&1; then
        echo "✓ Online"
    else
        echo "✗ Offline"
    fi
}

get_voicevox_version() {
    curl -s "${VOICEVOX_API_URL}/version" 2>/dev/null || echo "N/A"
}

# ============================================================
# Help
# ============================================================

show_help() {
    cat << EOF
VOICEVOX Narrator - Narration Orchestrator
Version: 1.0.0

Usage:
  $0 <command> [arguments]

Commands:
  event <event_name>         Trigger narration for an event
  speak <character> <text>   Speak arbitrary text
  test [character]           Test voice output (reimu|marisa|both)
  status                     Show system status
  help                       Show this help message

Examples:
  # Trigger phase θ₁ narration
  $0 event phase_theta1_start

  # Custom speech
  $0 speak reimu "ねぇねぇ、これってすごくない？"

  # Test Reimu voice
  $0 test reimu

  # Check status
  $0 status

For more information, see:
  ${BASE_DIR}/README.md
  ${BASE_DIR}/DIALOGUE_GUIDE.md
EOF
}

# ============================================================
# Main Entry Point
# ============================================================

main() {
    local command=${1:-help}
    shift || true

    case $command in
        event)
            if [[ $# -lt 1 ]]; then
                echo "ERROR: Event name required" >&2
                echo "Usage: $0 event <event_name>" >&2
                exit 1
            fi
            handle_event "$@"
            ;;
        speak)
            if [[ $# -lt 2 ]]; then
                echo "ERROR: Character and text required" >&2
                echo "Usage: $0 speak <character> <text>" >&2
                exit 1
            fi
            speak_text "$@"
            ;;
        test)
            test_voice "$@"
            ;;
        status)
            show_status
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo "ERROR: Unknown command: $command" >&2
            show_help
            exit 1
            ;;
    esac
}

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
