#!/bin/bash
# Event Listener - tmux Event Monitoring
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
    exit 1
fi

# ============================================================
# Default Settings
# ============================================================

# tmux session to monitor (default: current session)
TMUX_SESSION="${TMUX_SESSION:-}"

# Panes to monitor (comma-separated, e.g., "0,1,2,3")
MONITOR_PANES="${MONITOR_PANES:-0,1,2,3,4,5,6,7}"

# Polling interval in seconds
POLL_INTERVAL="${POLL_INTERVAL:-1}"

# Event detection patterns
declare -A EVENT_PATTERNS=(
    ["phase_theta1_start"]="θ₁.*Understand|Phase 1.*Understand"
    ["phase_theta2_start"]="θ₂.*Generate|Phase 2.*Generate"
    ["phase_theta3_start"]="θ₃.*Allocate|Phase 3.*Allocate"
    ["phase_theta4_start"]="θ₄.*Execute|Phase 4.*Execute"
    ["phase_theta5_start"]="θ₅.*Integrate|Phase 5.*Integrate"
    ["phase_theta6_start"]="θ₆.*Learn|Phase 6.*Learn"
    ["convergence_25"]="Convergence:.*25%|Progress:.*25%"
    ["convergence_50"]="Convergence:.*50%|Progress:.*50%"
    ["convergence_75"]="Convergence:.*75%|Progress:.*75%"
    ["convergence_100"]="Convergence:.*100%|Progress:.*100%|Complete"
    ["error_api_fail"]="API.*[Ee]rror|API.*[Ff]ail"
    ["error_timeout"]="[Tt]imeout|[Tt]imed out"
    ["error_validation"]="[Vv]alidation.*[Ee]rror"
    ["task_complete"]="Task.*[Cc]omplete|[Ss]uccess"
    ["milestone_reached"]="Milestone.*[Rr]eached"
)

# ============================================================
# State Management
# ============================================================

# Last content for each pane
declare -A LAST_CONTENT

# Triggered events (to avoid duplicate triggers)
declare -A TRIGGERED_EVENTS

# ============================================================
# Logging
# ============================================================

log() {
    local level=$1
    local message=$2
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] [$level] [EventListener] $message" >> "${LOG_FILE:-/tmp/voicevox_narrator.log}"

    if [[ "${DEBUG_MODE:-false}" == "true" ]]; then
        echo "[$timestamp] [$level] $message"
    fi
}

# ============================================================
# tmux Monitoring
# ============================================================

monitor_panes() {
    log "INFO" "Starting pane monitoring (session: ${TMUX_SESSION:-current})"

    # Parse pane list
    IFS=',' read -ra PANES <<< "$MONITOR_PANES"

    while true; do
        for pane in "${PANES[@]}"; do
            monitor_single_pane "$pane"
        done

        sleep "$POLL_INTERVAL"
    done
}

monitor_single_pane() {
    local pane_id=$1

    # Capture pane content
    local content
    if [[ -n "$TMUX_SESSION" ]]; then
        content=$(tmux capture-pane -p -t "${TMUX_SESSION}:${pane_id}" 2>/dev/null || echo "")
    else
        content=$(tmux capture-pane -p -t "$pane_id" 2>/dev/null || echo "")
    fi

    # Check if content changed
    if [[ "${LAST_CONTENT[$pane_id]:-}" != "$content" ]]; then
        log "DEBUG" "Content changed in pane $pane_id"

        # Detect events
        detect_events "$pane_id" "$content"

        # Update last content
        LAST_CONTENT[$pane_id]="$content"
    fi
}

# ============================================================
# Event Detection
# ============================================================

detect_events() {
    local pane_id=$1
    local content=$2

    for event_name in "${!EVENT_PATTERNS[@]}"; do
        local pattern="${EVENT_PATTERNS[$event_name]}"

        if echo "$content" | grep -iE "$pattern" > /dev/null 2>&1; then
            # Check if event was already triggered recently (cooldown)
            if ! is_event_on_cooldown "$event_name"; then
                log "INFO" "Event detected in pane $pane_id: $event_name"
                trigger_event "$event_name"
                mark_event_triggered "$event_name"
            fi
        fi
    done
}

# ============================================================
# Event Triggering
# ============================================================

trigger_event() {
    local event_name=$1

    log "INFO" "Triggering event: $event_name"

    # Call narrator script asynchronously
    "${SCRIPT_DIR}/voicevox_narrator.sh" event "$event_name" >> "${LOG_FILE:-/tmp/voicevox_narrator.log}" 2>&1 &

    local narrator_pid=$!
    log "DEBUG" "Narrator started for $event_name (PID: $narrator_pid)"
}

# ============================================================
# Event Cooldown
# ============================================================

is_event_on_cooldown() {
    local event_name=$1
    local cooldown_seconds=30  # Don't trigger same event within 30 seconds

    local last_triggered="${TRIGGERED_EVENTS[$event_name]:-0}"
    local now=$(date +%s)
    local elapsed=$((now - last_triggered))

    if [[ $elapsed -lt $cooldown_seconds ]]; then
        log "DEBUG" "Event $event_name is on cooldown ($elapsed/$cooldown_seconds seconds)"
        return 0
    else
        return 1
    fi
}

mark_event_triggered() {
    local event_name=$1
    TRIGGERED_EVENTS[$event_name]=$(date +%s)
}

# ============================================================
# Custom Event Patterns
# ============================================================

add_event_pattern() {
    local event_name=$1
    local pattern=$2

    EVENT_PATTERNS[$event_name]="$pattern"
    log "INFO" "Added custom event pattern: $event_name -> $pattern"
}

remove_event_pattern() {
    local event_name=$1

    unset EVENT_PATTERNS[$event_name]
    log "INFO" "Removed event pattern: $event_name"
}

list_event_patterns() {
    echo "Event Detection Patterns:"
    echo "========================"

    for event_name in "${!EVENT_PATTERNS[@]}"; do
        echo "  $event_name: ${EVENT_PATTERNS[$event_name]}"
    done
}

# ============================================================
# Manual Event Triggering
# ============================================================

manual_trigger() {
    local event_name=$1

    if [[ -z "$event_name" ]]; then
        echo "ERROR: Event name required" >&2
        return 1
    fi

    log "INFO" "Manual trigger: $event_name"
    trigger_event "$event_name"
}

# ============================================================
# Status Display
# ============================================================

show_status() {
    cat << EOF
Event Listener Status
=====================

Configuration:
  Session: ${TMUX_SESSION:-current}
  Panes: $MONITOR_PANES
  Poll Interval: ${POLL_INTERVAL}s

Event Patterns:
  Total: ${#EVENT_PATTERNS[@]}

Recent Events:
EOF

    if [[ ${#TRIGGERED_EVENTS[@]} -eq 0 ]]; then
        echo "  (no events triggered yet)"
    else
        for event_name in "${!TRIGGERED_EVENTS[@]}"; do
            local timestamp=${TRIGGERED_EVENTS[$event_name]}
            local formatted_time=$(date -r "$timestamp" +'%Y-%m-%d %H:%M:%S' 2>/dev/null || date -d "@$timestamp" +'%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "$timestamp")
            echo "  - $event_name (at $formatted_time)"
        done
    fi
}

# ============================================================
# Help
# ============================================================

show_help() {
    cat << EOF
Event Listener - tmux Event Monitoring
Version: 1.0.0

Usage:
  $0 <command> [arguments]

Commands:
  start                     Start monitoring tmux panes
  trigger <event_name>      Manually trigger an event
  patterns                  List all event patterns
  status                    Show listener status
  help                      Show this help message

Environment Variables:
  TMUX_SESSION             tmux session to monitor (default: current)
  MONITOR_PANES            Panes to monitor (default: 0,1,2,3,4,5,6,7)
  POLL_INTERVAL            Polling interval in seconds (default: 1)

Examples:
  # Start monitoring current session
  $0 start

  # Monitor specific session
  TMUX_SESSION=my_session $0 start

  # Monitor specific panes
  MONITOR_PANES=0,1,2 $0 start

  # Manually trigger event
  $0 trigger phase_theta1_start

  # List event patterns
  $0 patterns
EOF
}

# ============================================================
# Signal Handling
# ============================================================

cleanup() {
    log "INFO" "Event listener shutting down"
    exit 0
}

trap cleanup EXIT INT TERM

# ============================================================
# Main Entry Point
# ============================================================

main() {
    local command=${1:-start}
    shift || true

    case $command in
        start)
            monitor_panes
            ;;
        trigger)
            manual_trigger "$@"
            ;;
        patterns)
            list_event_patterns
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
