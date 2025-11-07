#!/bin/bash
# VOICEVOX Narration System Configuration
# Copy this file to voicevox_config.sh and customize

# ============================================================
# VOICEVOX API Settings
# ============================================================

# VOICEVOX API endpoint
export VOICEVOX_HOST="127.0.0.1"
export VOICEVOX_PORT="50021"

# API URL (constructed from HOST and PORT)
export VOICEVOX_API_URL="http://${VOICEVOX_HOST}:${VOICEVOX_PORT}"

# ============================================================
# Character Voice Models
# ============================================================

# Reimu (Hakurei Reimu) - おバカ聞き手キャラ
# Using 四国めたん (Shikoku Metan) - ノーマル
export REIMU_SPEAKER_ID=0

# Marisa (Kirisame Marisa) - 知識解説キャラ
# Using 春日部つむぎ (Kasukabe Tsumugi)
export MARISA_SPEAKER_ID=8

# Alternative voice models (uncomment to use)
# export REIMU_SPEAKER_ID=1   # 四国めたん - あまあま
# export REIMU_SPEAKER_ID=2   # 四国めたん - ツンツン
# export MARISA_SPEAKER_ID=9  # 波音リツ

# ============================================================
# Narration Settings
# ============================================================

# Enable/disable narration system
export NARRATION_ENABLED=true

# Narration frequency
# - "all": Narrate all events
# - "major": Only major events (phase transitions, milestones)
# - "silent": Disable all narration (text fallback only)
export NARRATION_FREQUENCY="all"

# Audio settings
export AUDIO_VOLUME=0.8          # 0.0 ~ 1.0
export SPEECH_SPEED=1.0          # 0.5 ~ 2.0 (slower ~ faster)
export PITCH_SCALE=0.0           # -1.0 ~ 1.0 (lower ~ higher)
export INTONATION_SCALE=1.0      # 0.0 ~ 2.0 (flat ~ expressive)

# ============================================================
# Cache Settings
# ============================================================

# Enable audio caching (highly recommended)
export CACHE_ENABLED=true

# Cache directory
export CACHE_DIR="/tmp/voicevox_cache"

# Maximum cache size in MB
export CACHE_MAX_SIZE_MB=500

# Cache cleanup age in days (files older than this will be deleted)
export CACHE_CLEANUP_AGE_DAYS=7

# ============================================================
# Fallback Settings
# ============================================================

# Fallback to text display if VOICEVOX is unavailable
export FALLBACK_TO_TEXT=true

# tmux pane for text display (0-indexed)
export TEXT_DISPLAY_PANE=8

# Display duration for fallback text (seconds)
export FALLBACK_TEXT_DURATION=5

# ============================================================
# Queue Settings
# ============================================================

# Maximum audio queue size
export QUEUE_MAX_SIZE=5

# Queue priority levels
export PRIORITY_HIGH="high"
export PRIORITY_NORMAL="normal"
export PRIORITY_LOW="low"

# ============================================================
# Logging Settings
# ============================================================

# Log file path
export LOG_FILE="/tmp/voicevox_narrator.log"

# Log level: DEBUG | INFO | WARN | ERROR
export LOG_LEVEL="INFO"

# Maximum log file size in MB (auto-rotate)
export LOG_MAX_SIZE_MB=10

# ============================================================
# Advanced Settings
# ============================================================

# API retry settings
export API_RETRY_COUNT=3
export API_RETRY_DELAY=1  # seconds

# Audio output device (empty = default)
export AUDIO_OUTPUT_DEVICE=""

# Temporary file directory
export TEMP_DIR="/tmp"

# Enable debug mode (verbose logging)
export DEBUG_MODE=false

# ============================================================
# Dialogue Paths
# ============================================================

# Base dialogue directory
export DIALOGUE_BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dialogues"

# Dialogue categories
export DIALOGUE_PHASE_DIR="${DIALOGUE_BASE_DIR}/phase_transitions"
export DIALOGUE_CONVERGENCE_DIR="${DIALOGUE_BASE_DIR}/convergence"
export DIALOGUE_ERROR_DIR="${DIALOGUE_BASE_DIR}/errors"
export DIALOGUE_CELEBRATION_DIR="${DIALOGUE_BASE_DIR}/celebrations"
export DIALOGUE_GENERAL_DIR="${DIALOGUE_BASE_DIR}/general"

# ============================================================
# Helper Functions
# ============================================================

# Validate configuration
validate_config() {
    local errors=0

    # Check VOICEVOX availability
    if ! curl -s "${VOICEVOX_API_URL}/version" > /dev/null 2>&1; then
        echo "ERROR: Cannot connect to VOICEVOX at ${VOICEVOX_API_URL}" >&2
        errors=$((errors + 1))
    fi

    # Check cache directory
    if [[ ! -d "$CACHE_DIR" ]]; then
        echo "WARNING: Cache directory does not exist: $CACHE_DIR" >&2
        echo "Creating cache directory..." >&2
        mkdir -p "$CACHE_DIR" || errors=$((errors + 1))
    fi

    # Check dialogue directories
    if [[ ! -d "$DIALOGUE_BASE_DIR" ]]; then
        echo "ERROR: Dialogue directory does not exist: $DIALOGUE_BASE_DIR" >&2
        errors=$((errors + 1))
    fi

    # Check log directory
    local log_dir=$(dirname "$LOG_FILE")
    if [[ ! -d "$log_dir" ]]; then
        echo "WARNING: Log directory does not exist: $log_dir" >&2
        mkdir -p "$log_dir" || errors=$((errors + 1))
    fi

    # Check required commands
    for cmd in curl jq; do
        if ! command -v "$cmd" > /dev/null 2>&1; then
            echo "ERROR: Required command not found: $cmd" >&2
            errors=$((errors + 1))
        fi
    done

    # Check audio player
    if ! command -v afplay > /dev/null 2>&1 && \
       ! command -v paplay > /dev/null 2>&1 && \
       ! command -v powershell > /dev/null 2>&1; then
        echo "ERROR: No audio player found (afplay/paplay/powershell)" >&2
        errors=$((errors + 1))
    fi

    return $errors
}

# Display current configuration
show_config() {
    cat << EOF
VOICEVOX Narration Configuration
=================================

API Settings:
  Endpoint: ${VOICEVOX_API_URL}
  Reimu Speaker ID: ${REIMU_SPEAKER_ID}
  Marisa Speaker ID: ${MARISA_SPEAKER_ID}

Narration Settings:
  Enabled: ${NARRATION_ENABLED}
  Frequency: ${NARRATION_FREQUENCY}
  Volume: ${AUDIO_VOLUME}
  Speed: ${SPEECH_SPEED}

Cache Settings:
  Enabled: ${CACHE_ENABLED}
  Directory: ${CACHE_DIR}
  Max Size: ${CACHE_MAX_SIZE_MB}MB

Logging:
  Log File: ${LOG_FILE}
  Log Level: ${LOG_LEVEL}

Dialogue Directory: ${DIALOGUE_BASE_DIR}
EOF
}

# Initialize (create necessary directories)
init_config() {
    mkdir -p "$CACHE_DIR" 2>/dev/null
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
    touch "$LOG_FILE" 2>/dev/null
}

# Auto-initialize on load
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being run directly
    init_config
    show_config
else
    # Script is being sourced
    init_config
fi
