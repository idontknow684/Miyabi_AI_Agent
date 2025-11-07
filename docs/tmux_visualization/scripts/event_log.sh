#!/usr/bin/env bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Miyabi Multi-Agent Orchestration Visualization
#  Event Log Display - Real-time Event Stream
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
STATE_DIR="/tmp/miyabi_viz"
LOG_FILE="${STATE_DIR}/logs/events.log"

# Source color definitions
# shellcheck source=../config/colors.conf
source "${PROJECT_ROOT}/config/colors.conf"

# ══════════════════════════════════════════════════════════════════════
# Functions
# ══════════════════════════════════════════════════════════════════════

colorize_log_line() {
    local line="$1"

    # Extract log level
    local level=$(echo "$line" | grep -oP '\[(?:INFO|SUCCESS|WARNING|ERROR|DEBUG)\]' || echo "")

    case "$level" in
        "[INFO]")
            echo "$line" | sed "s/\[INFO\]/${BRIGHT_CYAN}[INFO]${RESET}/"
            ;;
        "[SUCCESS]")
            echo "$line" | sed "s/\[SUCCESS\]/${BRIGHT_GREEN}[SUCCESS]${RESET}/"
            ;;
        "[WARNING]")
            echo "$line" | sed "s/\[WARNING\]/${BRIGHT_YELLOW}[WARNING]${RESET}/"
            ;;
        "[ERROR]")
            echo "$line" | sed "s/\[ERROR\]/${BRIGHT_RED}[ERROR]${RESET}/"
            ;;
        "[DEBUG]")
            echo "$line" | sed "s/\[DEBUG\]/${DIM}[DEBUG]${RESET}/"
            ;;
        *)
            echo "$line"
            ;;
    esac
}

draw_log_header() {
    clear
    echo -e "${BRIGHT_CYAN}${BOX_TL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_TR}${RESET}"
    echo -e "${BRIGHT_CYAN}${BOX_V}${RESET}  ${BRIGHT_WHITE}${BOLD}EVENT LOG STREAM${RESET}                                             ${BRIGHT_CYAN}${BOX_V}${RESET}"
    echo -e "${BRIGHT_CYAN}${BOX_BL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_BR}${RESET}"
    echo ""
}

stream_logs() {
    # Follow log file and colorize output
    tail -n 20 -f "${LOG_FILE}" 2>/dev/null | while IFS= read -r line; do
        colorized=$(colorize_log_line "$line")
        echo -e "  ${colorized}"
    done
}

# ══════════════════════════════════════════════════════════════════════
# Main Execution
# ══════════════════════════════════════════════════════════════════════

main() {
    # Draw header once
    draw_log_header

    # Check if log file exists
    if [ ! -f "${LOG_FILE}" ]; then
        echo -e "  ${DIM}Waiting for events...${RESET}"
        # Create log file if it doesn't exist
        touch "${LOG_FILE}"
    fi

    # Stream logs with colors
    stream_logs
}

# Run main function
main "$@"
