#!/usr/bin/env bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Miyabi Multi-Agent Orchestration Visualization
#  Subagent Display - Real-time Agent State Visualization
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════

AGENT_NAME="${1:-theta1}"
AGENT_NUM="${2:-1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
STATE_DIR="/tmp/miyabi_viz"
STATE_FILE="${STATE_DIR}/agents/${AGENT_NAME}_state.json"

# Source color definitions
# shellcheck source=../config/colors.conf
source "${PROJECT_ROOT}/config/colors.conf"

# ══════════════════════════════════════════════════════════════════════
# Agent Configuration
# ══════════════════════════════════════════════════════════════════════

declare -A AGENT_COLORS=(
    [theta1]="${BRIGHT_BLUE}"
    [theta2]="${BRIGHT_GREEN}"
    [theta3]="${BRIGHT_YELLOW}"
    [theta4]="${BRIGHT_RED}"
    [theta5]="${BRIGHT_PURPLE}"
    [theta6]="${BRIGHT_CYAN}"
)

declare -A AGENT_EMOJIS=(
    [theta1]="🔵"
    [theta2]="🟢"
    [theta3]="🟡"
    [theta4]="🔴"
    [theta5]="🟣"
    [theta6]="🔵"
)

declare -A AGENT_NAMES=(
    [theta1]="θ₁ Understand"
    [theta2]="θ₂ Generate"
    [theta3]="θ₃ Allocate"
    [theta4]="θ₄ Execute"
    [theta5]="θ₅ Integrate"
    [theta6]="θ₆ Learn"
)

# ══════════════════════════════════════════════════════════════════════
# Functions
# ══════════════════════════════════════════════════════════════════════

get_status_display() {
    local status="$1"

    case "$status" in
        "running")
            echo -e "${BRIGHT_GREEN}▶ RUNNING${RESET}"
            ;;
        "completed"|"done")
            echo -e "${BRIGHT_GREEN}● DONE${RESET}"
            ;;
        "waiting"|"pending")
            echo -e "${BRIGHT_YELLOW}○ WAITING${RESET}"
            ;;
        "error"|"failed")
            echo -e "${BRIGHT_RED}✗ ERROR${RESET}"
            ;;
        "idle")
            echo -e "${DIM}◯ IDLE${RESET}"
            ;;
        *)
            echo -e "${DIM}◯ IDLE${RESET}"
            ;;
    esac
}

draw_progress_bar() {
    local percent=$1
    local width=10
    local filled=$((percent * width / 100))
    local empty=$((width - filled))

    local bar=""
    for ((i=0; i<filled; i++)); do
        bar+="${BRIGHT_GREEN}█${RESET}"
    done
    for ((i=0; i<empty; i++)); do
        bar+="${DIM}░${RESET}"
    done

    echo -e "${bar} ${BRIGHT_WHITE}${percent}%${RESET}"
}

draw_agent_pane() {
    local agent_color="${AGENT_COLORS[$AGENT_NAME]}"
    local agent_emoji="${AGENT_EMOJIS[$AGENT_NAME]}"
    local agent_display="${AGENT_NAMES[$AGENT_NAME]}"

    # Read state from JSON file
    if [ ! -f "${STATE_FILE}" ]; then
        # Show initialization message
        clear
        echo -e "${agent_color}${BOX_TL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_TR}${RESET}"
        echo -e "${agent_color}${BOX_V}${RESET}  ${agent_emoji} ${agent_color}${BOLD}${agent_display}${RESET}"
        echo -e "${agent_color}${BOX_BL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_BR}${RESET}"
        echo ""
        echo -e "${DIM}Initializing...${RESET}"
        return
    fi

    # Parse JSON state
    local status=$(jq -r '.status' "${STATE_FILE}")
    local progress=$(jq -r '.progress' "${STATE_FILE}")
    local current_task=$(jq -r '.current_task' "${STATE_FILE}")
    local cpu=$(jq -r '.cpu' "${STATE_FILE}")
    local memory=$(jq -r '.memory' "${STATE_FILE}")
    local tasks_completed=$(jq -r '.tasks_completed' "${STATE_FILE}")
    local tasks_failed=$(jq -r '.tasks_failed' "${STATE_FILE}")

    # Clear screen and draw pane
    clear

    # Header
    echo -e "${agent_color}${BOX_TL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_TR}${RESET}"
    echo -e "${agent_color}${BOX_V}${RESET}  ${agent_emoji} ${agent_color}${BOLD}${agent_display}${RESET}            ${agent_color}${BOX_V}${RESET}"
    echo -e "${agent_color}${BOX_BL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_BR}${RESET}"

    echo ""

    # Status
    echo -e "  ${BRIGHT_CYAN}Status:${RESET}  $(get_status_display "$status")"
    echo ""

    # Progress bar
    echo -e "  ${BRIGHT_CYAN}Progress:${RESET}"
    echo -e "  $(draw_progress_bar "$progress")"
    echo ""

    # Current task
    if [ -n "$current_task" ] && [ "$current_task" != "null" ]; then
        echo -e "  ${BRIGHT_CYAN}Task:${RESET}"
        echo -e "  ${DIM}${current_task}${RESET}"
        echo ""
    fi

    # Metrics
    echo -e "${agent_color}${BOX_H}${BOX_H}${BOX_H} Metrics ${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${RESET}"
    echo ""
    printf "  ${BRIGHT_CYAN}CPU:${RESET}       %5.1f%%\n" "$cpu"
    printf "  ${BRIGHT_CYAN}Memory:${RESET}    %5.1f MB\n" "$memory"
    echo ""
    echo -e "  ${BRIGHT_CYAN}Completed:${RESET} ${BRIGHT_GREEN}${tasks_completed}${RESET}"
    echo -e "  ${BRIGHT_CYAN}Failed:${RESET}    ${BRIGHT_RED}${tasks_failed}${RESET}"
    echo ""

    # Footer
    echo -e "${agent_color}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${RESET}"
}

# ══════════════════════════════════════════════════════════════════════
# Main Loop
# ══════════════════════════════════════════════════════════════════════

main() {
    # Initial draw
    draw_agent_pane

    # Update loop
    while true; do
        sleep 1
        draw_agent_pane
    done
}

# Run main function
main "$@"
