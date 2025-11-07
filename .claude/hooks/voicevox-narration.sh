#!/bin/bash
# VOICEVOX Narration Hook for Claude Code
# 霊夢と魔理沙がClaude Codeの操作を読み上げる

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

VOICEVOX_URL="${VOICEVOX_URL:-http://127.0.0.1:50021}"
CACHE_DIR="${HOME}/.claude/voicevox_cache"
REIMU_SPEAKER_ID="${REIMU_SPEAKER_ID:-0}"    # 四国めたん（霊夢役）
MARISA_SPEAKER_ID="${MARISA_SPEAKER_ID:-8}"  # 春日部つむぎ（魔理沙役）

# ============================================================
# Helper Functions
# ============================================================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

check_voicevox() {
    if ! curl -s "${VOICEVOX_URL}/version" >/dev/null 2>&1; then
        log "WARNING: VOICEVOX is not running at ${VOICEVOX_URL}"
        return 1
    fi
    return 0
}

synthesize_audio() {
    local text="$1"
    local speaker_id="$2"
    local output_file="$3"

    # Generate audio query
    local query=$(curl -s -X POST \
        "${VOICEVOX_URL}/audio_query?speaker=${speaker_id}&text=${text}" \
        -H "Content-Type: application/json")

    if [ -z "$query" ]; then
        log "ERROR: Failed to generate audio query"
        return 1
    fi

    # Synthesize audio
    curl -s -X POST \
        "${VOICEVOX_URL}/synthesis?speaker=${speaker_id}" \
        -H "Content-Type: application/json" \
        -d "$query" \
        -o "$output_file"

    return 0
}

play_audio() {
    local file="$1"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        afplay "$file" 2>/dev/null &
    elif command -v paplay >/dev/null 2>&1; then
        paplay "$file" 2>/dev/null &
    elif command -v aplay >/dev/null 2>&1; then
        aplay "$file" 2>/dev/null &
    else
        log "WARNING: No audio player found"
        return 1
    fi

    return 0
}

get_cache_file() {
    local text="$1"
    local speaker_id="$2"
    local hash=$(echo -n "${text}_${speaker_id}" | md5sum | cut -d' ' -f1)
    echo "${CACHE_DIR}/${hash}.wav"
}

narrate() {
    local character="$1"
    local text="$2"

    # Determine speaker ID
    local speaker_id
    case "$character" in
        reimu) speaker_id="$REIMU_SPEAKER_ID" ;;
        marisa) speaker_id="$MARISA_SPEAKER_ID" ;;
        *) log "ERROR: Unknown character: $character"; return 1 ;;
    esac

    # Check cache
    local cache_file=$(get_cache_file "$text" "$speaker_id")

    if [ ! -f "$cache_file" ]; then
        log "Synthesizing: [$character] $text"
        mkdir -p "$CACHE_DIR"
        if ! synthesize_audio "$text" "$speaker_id" "$cache_file"; then
            log "ERROR: Failed to synthesize audio"
            return 1
        fi
    fi

    # Play audio
    play_audio "$cache_file"
}

# ============================================================
# Event Handlers
# ============================================================

handle_tool_call() {
    local tool_name="$1"

    # Check VOICEVOX availability
    if ! check_voicevox; then
        return 0  # Silent fail
    fi

    case "$tool_name" in
        Read)
            narrate reimu "ファイルを読むよ！"
            ;;
        Write)
            narrate marisa "ファイルに書き込むぜ"
            ;;
        Edit)
            narrate marisa "コードを編集してるんだ"
            ;;
        Bash)
            narrate reimu "コマンドを実行するね"
            ;;
        Grep)
            narrate marisa "検索してるぜ"
            ;;
        Task)
            narrate reimu "エージェントを起動したよ！"
            narrate marisa "複雑な作業を分解して実行するんだ"
            ;;
        *)
            # Default narration
            narrate reimu "${tool_name}を実行中..."
            ;;
    esac
}

handle_user_prompt() {
    # Check VOICEVOX availability
    if ! check_voicevox; then
        return 0  # Silent fail
    fi

    # Random chance to narrate (10%)
    if [ $((RANDOM % 10)) -eq 0 ]; then
        narrate marisa "新しいタスクだぜ！頑張ろう！"
    fi
}

handle_task_complete() {
    # Check VOICEVOX availability
    if ! check_voicevox; then
        return 0  # Silent fail
    fi

    narrate reimu "やったね！完了したよ！"
    narrate marisa "いい仕事だったぜ"
}

# ============================================================
# Main
# ============================================================

main() {
    local hook_type="${1:-}"
    local tool_name="${2:-}"

    case "$hook_type" in
        tool-call)
            handle_tool_call "$tool_name"
            ;;
        user-prompt-submit)
            handle_user_prompt
            ;;
        task-complete)
            handle_task_complete
            ;;
        *)
            log "Unknown hook type: $hook_type"
            exit 1
            ;;
    esac
}

# Run main if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
