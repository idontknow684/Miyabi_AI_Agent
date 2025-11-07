#!/bin/bash
# Cache Manager
# Version: 1.0.0

# ============================================================
# Cache File Management
# ============================================================

get_cache_file() {
    local character=$1
    local text=$2

    # Generate MD5 hash of character + text
    local hash=$(echo -n "${character}_${text}" | md5sum 2>/dev/null || echo -n "${character}_${text}" | md5)
    hash=$(echo "$hash" | cut -d' ' -f1)

    local cache_file="${CACHE_DIR}/${character}_${hash}.wav"

    echo "$cache_file"
}

cache_exists() {
    local character=$1
    local text=$2

    local cache_file=$(get_cache_file "$character" "$text")

    if [[ -f "$cache_file" ]]; then
        return 0
    else
        return 1
    fi
}

save_to_cache() {
    local character=$1
    local text=$2
    local audio_file=$3

    if [[ ! -f "$audio_file" ]]; then
        log "ERROR" "Audio file does not exist: $audio_file"
        return 1
    fi

    local cache_file=$(get_cache_file "$character" "$text")

    # Ensure cache directory exists
    mkdir -p "$CACHE_DIR" 2>/dev/null

    # Copy to cache
    cp "$audio_file" "$cache_file"

    if [[ $? -eq 0 ]]; then
        log "DEBUG" "Cached audio: $cache_file"
        return 0
    else
        log "ERROR" "Failed to cache audio: $cache_file"
        return 1
    fi
}

# ============================================================
# Cache Cleanup
# ============================================================

cleanup_cache() {
    local max_age_days=${1:-${CACHE_CLEANUP_AGE_DAYS:-7}}

    log "INFO" "Starting cache cleanup (max age: $max_age_days days)"

    if [[ ! -d "$CACHE_DIR" ]]; then
        log "WARN" "Cache directory does not exist: $CACHE_DIR"
        return 0
    fi

    # Count files before cleanup
    local before_count=$(find "$CACHE_DIR" -name "*.wav" -type f | wc -l)

    # Delete files older than max_age_days
    find "$CACHE_DIR" -name "*.wav" -type f -mtime "+${max_age_days}" -delete

    # Count files after cleanup
    local after_count=$(find "$CACHE_DIR" -name "*.wav" -type f | wc -l)
    local deleted_count=$((before_count - after_count))

    log "INFO" "Deleted $deleted_count old cache files"

    # Check cache size
    check_cache_size
}

check_cache_size() {
    if [[ ! -d "$CACHE_DIR" ]]; then
        return 0
    fi

    # Get cache size in MB
    local cache_size_mb=$(du -sm "$CACHE_DIR" 2>/dev/null | cut -f1)

    if [[ -z "$cache_size_mb" ]]; then
        cache_size_mb=0
    fi

    log "DEBUG" "Cache size: ${cache_size_mb}MB / ${CACHE_MAX_SIZE_MB:-500}MB"

    # If cache exceeds limit, delete oldest files
    if [[ $cache_size_mb -gt ${CACHE_MAX_SIZE_MB:-500} ]]; then
        log "WARN" "Cache size exceeds limit: ${cache_size_mb}MB > ${CACHE_MAX_SIZE_MB:-500}MB"

        local files_to_delete=10

        log "INFO" "Deleting $files_to_delete oldest cache files"

        # Find and delete oldest files
        find "$CACHE_DIR" -name "*.wav" -type f -printf '%T+ %p\n' 2>/dev/null | \
            sort | \
            head -n "$files_to_delete" | \
            cut -d' ' -f2- | \
            xargs rm -f

        log "INFO" "Deleted oldest cache files"

        # Re-check size
        cache_size_mb=$(du -sm "$CACHE_DIR" 2>/dev/null | cut -f1)
        log "INFO" "New cache size: ${cache_size_mb}MB"
    fi
}

# ============================================================
# Cache Statistics
# ============================================================

cache_stats() {
    if [[ ! -d "$CACHE_DIR" ]]; then
        echo "  Status: Not initialized"
        echo "  Directory: $CACHE_DIR"
        return 0
    fi

    local total_files=$(find "$CACHE_DIR" -name "*.wav" -type f | wc -l)
    local total_size_mb=$(du -sm "$CACHE_DIR" 2>/dev/null | cut -f1)

    if [[ -z "$total_size_mb" ]]; then
        total_size_mb=0
    fi

    local usage_percent=0
    if [[ ${CACHE_MAX_SIZE_MB:-500} -gt 0 ]]; then
        usage_percent=$((total_size_mb * 100 / CACHE_MAX_SIZE_MB))
    fi

    # Count files by character
    local reimu_count=$(find "$CACHE_DIR" -name "reimu_*.wav" -type f | wc -l)
    local marisa_count=$(find "$CACHE_DIR" -name "marisa_*.wav" -type f | wc -l)

    cat << EOF
  Total Files: $total_files
  Total Size: ${total_size_mb}MB / ${CACHE_MAX_SIZE_MB:-500}MB
  Usage: ${usage_percent}%
  By Character:
    Reimu: $reimu_count
    Marisa: $marisa_count
EOF
}

cache_stats_detailed() {
    echo "Cache Statistics (Detailed)"
    echo "==========================="
    echo ""

    if [[ ! -d "$CACHE_DIR" ]]; then
        echo "Cache directory does not exist: $CACHE_DIR"
        return 0
    fi

    cache_stats
    echo ""

    # Oldest files
    echo "Oldest 5 Files:"
    find "$CACHE_DIR" -name "*.wav" -type f -printf '%T+ %p\n' 2>/dev/null | \
        sort | \
        head -n 5 | \
        while read -r timestamp file; do
            local basename=$(basename "$file")
            echo "  - $basename (modified: $timestamp)"
        done
    echo ""

    # Newest files
    echo "Newest 5 Files:"
    find "$CACHE_DIR" -name "*.wav" -type f -printf '%T+ %p\n' 2>/dev/null | \
        sort -r | \
        head -n 5 | \
        while read -r timestamp file; do
            local basename=$(basename "$file")
            echo "  - $basename (modified: $timestamp)"
        done
    echo ""

    # Largest files
    echo "Largest 5 Files:"
    find "$CACHE_DIR" -name "*.wav" -type f -printf '%s %p\n' 2>/dev/null | \
        sort -rn | \
        head -n 5 | \
        while read -r size file; do
            local basename=$(basename "$file")
            local size_kb=$((size / 1024))
            echo "  - $basename (${size_kb}KB)"
        done
}

# ============================================================
# Cache Utilities
# ============================================================

clear_cache() {
    log "INFO" "Clearing entire cache"

    if [[ ! -d "$CACHE_DIR" ]]; then
        log "WARN" "Cache directory does not exist: $CACHE_DIR"
        return 0
    fi

    local file_count=$(find "$CACHE_DIR" -name "*.wav" -type f | wc -l)

    # Delete all cache files
    find "$CACHE_DIR" -name "*.wav" -type f -delete

    log "INFO" "Deleted $file_count cache files"
}

clear_cache_by_character() {
    local character=$1

    log "INFO" "Clearing cache for character: $character"

    if [[ ! -d "$CACHE_DIR" ]]; then
        log "WARN" "Cache directory does not exist: $CACHE_DIR"
        return 0
    fi

    local file_count=$(find "$CACHE_DIR" -name "${character}_*.wav" -type f | wc -l)

    # Delete cache files for specified character
    find "$CACHE_DIR" -name "${character}_*.wav" -type f -delete

    log "INFO" "Deleted $file_count cache files for $character"
}

rebuild_cache() {
    log "INFO" "Rebuilding cache"

    clear_cache
    mkdir -p "$CACHE_DIR"

    log "INFO" "Cache rebuilt"
}

# Verify cache integrity
verify_cache() {
    log "INFO" "Verifying cache integrity"

    if [[ ! -d "$CACHE_DIR" ]]; then
        log "WARN" "Cache directory does not exist: $CACHE_DIR"
        return 0
    fi

    local total=0
    local valid=0
    local invalid=0

    while IFS= read -r file; do
        total=$((total + 1))

        # Check if file is valid WAV
        if file "$file" | grep -q "RIFF.*WAVE"; then
            valid=$((valid + 1))
        else
            invalid=$((invalid + 1))
            log "WARN" "Invalid cache file: $file"
            rm -f "$file"
        fi
    done < <(find "$CACHE_DIR" -name "*.wav" -type f)

    log "INFO" "Cache verification complete: $valid valid, $invalid invalid (deleted)"

    echo "Cache Verification:"
    echo "  Total: $total"
    echo "  Valid: $valid"
    echo "  Invalid (deleted): $invalid"
}

# ============================================================
# Cache Warmup
# ============================================================

warmup_cache() {
    log "INFO" "Warming up cache with common phrases"

    # Common phrases
    local phrases=(
        "reimu:ねぇねぇ魔理沙"
        "marisa:何だ霊夢"
        "reimu:すごいね！"
        "marisa:まぁな"
        "reimu:へぇ〜"
        "marisa:要するにな"
        "reimu:よくわかんないけど"
        "marisa:簡単に言うと"
    )

    for phrase in "${phrases[@]}"; do
        local character=$(echo "$phrase" | cut -d':' -f1)
        local text=$(echo "$phrase" | cut -d':' -f2)

        log "DEBUG" "Warming up: $character - $text"

        # Check if already cached
        if ! cache_exists "$character" "$text"; then
            # Synthesize and cache
            ../scripts/voicevox_narrator.sh speak "$character" "$text" > /dev/null 2>&1
        fi
    done

    log "INFO" "Cache warmup complete"
}

# ============================================================
# Cache Monitoring
# ============================================================

monitor_cache() {
    local interval=${1:-60}

    log "INFO" "Starting cache monitor (interval: ${interval}s)"

    while true; do
        # Check cache size
        check_cache_size

        # Cleanup old entries
        cleanup_old_entries

        sleep "$interval"
    done
}

cleanup_old_entries() {
    local max_age=${1:-$((CACHE_CLEANUP_AGE_DAYS * 86400))}

    if [[ ! -d "$CACHE_DIR" ]]; then
        return 0
    fi

    local now=$(date +%s)
    local deleted=0

    while IFS= read -r file; do
        local mtime=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)

        if [[ -n "$mtime" ]]; then
            local age=$((now - mtime))

            if [[ $age -gt $max_age ]]; then
                rm -f "$file"
                deleted=$((deleted + 1))
            fi
        fi
    done < <(find "$CACHE_DIR" -name "*.wav" -type f)

    if [[ $deleted -gt 0 ]]; then
        log "INFO" "Cleaned up $deleted old cache entries"
    fi
}

# ============================================================
# Export Functions
# ============================================================

export -f get_cache_file
export -f cache_exists
export -f save_to_cache
export -f cleanup_cache
export -f cache_stats
export -f clear_cache
export -f verify_cache
