#!/bin/bash
# Audio Queue Manager
# Version: 1.0.0

# ============================================================
# Queue File Paths
# ============================================================

QUEUE_FILE="${TEMP_DIR:-/tmp}/voicevox_audio_queue"
LOCK_FILE="${TEMP_DIR:-/tmp}/voicevox_audio_queue.lock"
PLAYER_PID_FILE="${TEMP_DIR:-/tmp}/voicevox_audio_player.pid"

# ============================================================
# Queue Operations
# ============================================================

enqueue_audio() {
    local audio_file=$1
    local priority=${2:-normal}

    if [[ ! -f "$audio_file" ]]; then
        log "ERROR" "Audio file does not exist: $audio_file"
        return 1
    fi

    log "DEBUG" "Enqueueing audio: $audio_file (priority: $priority)"

    # Acquire lock
    exec 200>"$LOCK_FILE"
    flock -x 200

    # Create queue file if it doesn't exist
    touch "$QUEUE_FILE"

    # Check queue size
    local queue_size=$(wc -l < "$QUEUE_FILE" 2>/dev/null || echo 0)

    if [[ $queue_size -ge ${QUEUE_MAX_SIZE:-5} ]]; then
        log "WARN" "Queue full (size: $queue_size), dropping oldest entry"

        # Remove oldest entry (first line)
        tail -n $((QUEUE_MAX_SIZE - 1)) "$QUEUE_FILE" > "${QUEUE_FILE}.tmp"
        mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
    fi

    # Add to queue with priority
    echo "${priority}|${audio_file}|$(date +%s)" >> "$QUEUE_FILE"

    # Release lock
    flock -u 200
    exec 200>&-

    # Start player if not running
    ensure_player_running

    log "DEBUG" "Audio enqueued successfully"
    return 0
}

dequeue_audio() {
    # Acquire lock
    exec 200>"$LOCK_FILE"
    flock -x 200

    local entry=""

    if [[ -f "$QUEUE_FILE" ]] && [[ -s "$QUEUE_FILE" ]]; then
        # Get first entry
        entry=$(head -n 1 "$QUEUE_FILE")

        # Remove first entry
        tail -n +2 "$QUEUE_FILE" > "${QUEUE_FILE}.tmp"
        mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
    fi

    # Release lock
    flock -u 200
    exec 200>&-

    if [[ -n "$entry" ]]; then
        local priority=$(echo "$entry" | cut -d'|' -f1)
        local audio_file=$(echo "$entry" | cut -d'|' -f2)
        local timestamp=$(echo "$entry" | cut -d'|' -f3)

        echo "$audio_file"
        return 0
    else
        return 1
    fi
}

# ============================================================
# Queue Player
# ============================================================

audio_queue_player() {
    log "INFO" "Audio queue player started (PID: $$)"

    # Save PID
    echo $$ > "$PLAYER_PID_FILE"

    # Trap signals
    trap cleanup_player EXIT INT TERM

    while true; do
        # Check if queue has items
        if [[ ! -f "$QUEUE_FILE" ]] || [[ ! -s "$QUEUE_FILE" ]]; then
            # Queue is empty, sleep
            sleep 0.5
            continue
        fi

        # Dequeue next audio file
        local audio_file=$(dequeue_audio)

        if [[ $? -ne 0 ]] || [[ -z "$audio_file" ]]; then
            sleep 0.1
            continue
        fi

        log "DEBUG" "Playing audio: $audio_file"

        # Play audio
        play_audio "$audio_file"

        # Clean up temporary files
        if [[ "$audio_file" =~ ^${TEMP_DIR}.*\.wav$ ]]; then
            rm -f "$audio_file"
        fi
    done
}

play_audio() {
    local audio_file=$1

    if [[ ! -f "$audio_file" ]]; then
        log "ERROR" "Audio file not found: $audio_file"
        return 1
    fi

    # Detect platform and play audio
    if command -v afplay > /dev/null 2>&1; then
        # macOS
        afplay "$audio_file" 2>/dev/null
    elif command -v paplay > /dev/null 2>&1; then
        # Linux (PulseAudio)
        paplay "$audio_file" 2>/dev/null
    elif command -v aplay > /dev/null 2>&1; then
        # Linux (ALSA)
        aplay -q "$audio_file" 2>/dev/null
    elif command -v powershell > /dev/null 2>&1; then
        # Windows (PowerShell)
        powershell -Command "(New-Object Media.SoundPlayer '$audio_file').PlaySync()" 2>/dev/null
    else
        log "ERROR" "No audio player found"
        return 1
    fi

    log "DEBUG" "Audio playback completed: $audio_file"
    return 0
}

# ============================================================
# Player Management
# ============================================================

ensure_player_running() {
    # Check if player is already running
    if is_player_running; then
        return 0
    fi

    log "INFO" "Starting audio queue player"

    # Start player in background
    audio_queue_player &

    # Wait a bit to ensure it starts
    sleep 0.2

    if is_player_running; then
        log "INFO" "Audio queue player started successfully"
        return 0
    else
        log "ERROR" "Failed to start audio queue player"
        return 1
    fi
}

is_player_running() {
    if [[ -f "$PLAYER_PID_FILE" ]]; then
        local pid=$(cat "$PLAYER_PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            return 0
        else
            # PID file exists but process is dead
            rm -f "$PLAYER_PID_FILE"
            return 1
        fi
    fi

    return 1
}

stop_player() {
    if [[ -f "$PLAYER_PID_FILE" ]]; then
        local pid=$(cat "$PLAYER_PID_FILE")

        if kill -0 "$pid" 2>/dev/null; then
            log "INFO" "Stopping audio queue player (PID: $pid)"
            kill "$pid"
            sleep 0.5

            # Force kill if still running
            if kill -0 "$pid" 2>/dev/null; then
                kill -9 "$pid"
            fi
        fi

        rm -f "$PLAYER_PID_FILE"
    fi
}

cleanup_player() {
    log "INFO" "Cleaning up audio queue player"
    rm -f "$PLAYER_PID_FILE"
}

# ============================================================
# Queue Status
# ============================================================

queue_size() {
    if [[ -f "$QUEUE_FILE" ]]; then
        wc -l < "$QUEUE_FILE"
    else
        echo "0"
    fi
}

queue_status() {
    local size=$(queue_size)

    if [[ $size -eq 0 ]]; then
        echo "Empty"
    elif is_player_running; then
        echo "Playing ($size items)"
    else
        echo "Stopped ($size items)"
    fi
}

queue_list() {
    if [[ ! -f "$QUEUE_FILE" ]] || [[ ! -s "$QUEUE_FILE" ]]; then
        echo "Queue is empty"
        return 0
    fi

    echo "Audio Queue:"
    echo "============"

    local line_num=1
    while IFS='|' read -r priority audio_file timestamp; do
        local age=$(($(date +%s) - timestamp))
        echo "$line_num. [$priority] $audio_file (queued ${age}s ago)"
        line_num=$((line_num + 1))
    done < "$QUEUE_FILE"
}

# ============================================================
# Queue Maintenance
# ============================================================

clear_queue() {
    log "INFO" "Clearing audio queue"

    # Acquire lock
    exec 200>"$LOCK_FILE"
    flock -x 200

    # Clear queue file
    : > "$QUEUE_FILE"

    # Release lock
    flock -u 200
    exec 200>&-

    log "INFO" "Queue cleared"
}

cleanup_old_entries() {
    local max_age=${1:-300}  # 5 minutes default

    log "DEBUG" "Cleaning up queue entries older than ${max_age}s"

    # Acquire lock
    exec 200>"$LOCK_FILE"
    flock -x 200

    if [[ -f "$QUEUE_FILE" ]]; then
        local now=$(date +%s)
        local temp_file="${QUEUE_FILE}.tmp"

        : > "$temp_file"

        while IFS='|' read -r priority audio_file timestamp; do
            local age=$((now - timestamp))

            if [[ $age -lt $max_age ]]; then
                echo "${priority}|${audio_file}|${timestamp}" >> "$temp_file"
            else
                log "DEBUG" "Removing old queue entry: $audio_file (age: ${age}s)"
            fi
        done < "$QUEUE_FILE"

        mv "$temp_file" "$QUEUE_FILE"
    fi

    # Release lock
    flock -u 200
    exec 200>&-
}

# ============================================================
# Priority Management
# ============================================================

prioritize_entry() {
    local audio_file=$1
    local new_priority=${2:-high}

    # Acquire lock
    exec 200>"$LOCK_FILE"
    flock -x 200

    if [[ -f "$QUEUE_FILE" ]]; then
        local temp_file="${QUEUE_FILE}.tmp"

        : > "$temp_file"

        while IFS='|' read -r priority file timestamp; do
            if [[ "$file" == "$audio_file" ]]; then
                echo "${new_priority}|${file}|${timestamp}" >> "$temp_file"
            else
                echo "${priority}|${file}|${timestamp}" >> "$temp_file"
            fi
        done < "$QUEUE_FILE"

        mv "$temp_file" "$QUEUE_FILE"
    fi

    # Release lock
    flock -u 200
    exec 200>&-
}

# Sort queue by priority
resort_queue() {
    log "DEBUG" "Resorting queue by priority"

    # Acquire lock
    exec 200>"$LOCK_FILE"
    flock -x 200

    if [[ -f "$QUEUE_FILE" ]]; then
        # Priority order: high=1, normal=2, low=3
        sort -t'|' -k1,1 -k3,3n "$QUEUE_FILE" | \
            sed 's/^high/1/' | sed 's/^normal/2/' | sed 's/^low/3/' | \
            sort -t'|' -k1,1n -k3,3n | \
            sed 's/^1/high/' | sed 's/^2/normal/' | sed 's/^3/low/' \
            > "${QUEUE_FILE}.tmp"

        mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
    fi

    # Release lock
    flock -u 200
    exec 200>&-
}

# ============================================================
# Export Functions
# ============================================================

export -f enqueue_audio
export -f dequeue_audio
export -f play_audio
export -f queue_size
export -f queue_status
export -f is_player_running
export -f ensure_player_running
export -f stop_player
export -f clear_queue
