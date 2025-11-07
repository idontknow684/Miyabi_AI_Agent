#!/usr/bin/env bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Miyabi Multi-Agent Orchestration Visualization
#  Orchestrator Display - Central Control & Coordination View
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
STATE_DIR="/tmp/miyabi_viz"
ORCHESTRATOR_STATE="${STATE_DIR}/agents/orchestrator_state.json"
WORLD_STATE="${STATE_DIR}/world_state.json"

# Source color definitions
# shellcheck source=../config/colors.conf
source "${PROJECT_ROOT}/config/colors.conf"

# ══════════════════════════════════════════════════════════════════════
# Functions
# ══════════════════════════════════════════════════════════════════════

get_convergence_color() {
    local percent=$1

    if [ "$percent" -ge 80 ]; then
        echo -e "${BRIGHT_GREEN}"
    elif [ "$percent" -ge 40 ]; then
        echo -e "${BRIGHT_YELLOW}"
    else
        echo -e "${BRIGHT_RED}"
    fi
}

draw_world_convergence() {
    local current_world=$(jq -r '.current_world' "${WORLD_STATE}")
    local convergence=$(jq -r '.convergence_percent' "${WORLD_STATE}")
    local blink_count=$(jq -r '.blink_count' "${WORLD_STATE}")

    local conv_color=$(get_convergence_color "$convergence")

    echo -e "  ${BRIGHT_CYAN}World State:${RESET}"
    echo -e "  W${BRIGHT_WHITE}${current_world}${RESET} ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━→${RESET} W${BRIGHT_PURPLE}∞${RESET}"
    echo ""
    echo -e "  ${BRIGHT_CYAN}Convergence:${RESET} ${conv_color}${convergence}%${RESET}"
    echo -e "  ${BRIGHT_CYAN}Blinks:${RESET}      ${BRIGHT_WHITE}${blink_count}${RESET}"
    echo ""
}

draw_task_queue() {
    # Parse current task from orchestrator state
    if [ ! -f "${ORCHESTRATOR_STATE}" ]; then
        echo -e "  ${BRIGHT_CYAN}Task Queue:${RESET} ${DIM}Empty${RESET}"
        return
    fi

    local current_task=$(jq -r '.current_task' "${ORCHESTRATOR_STATE}")
    local status=$(jq -r '.status' "${ORCHESTRATOR_STATE}")

    echo -e "  ${BRIGHT_CYAN}Task Queue:${RESET}"

    if [ -n "$current_task" ] && [ "$current_task" != "null" ]; then
        case "$status" in
            "running")
                echo -e "    ${BRIGHT_GREEN}▶${RESET} ${current_task}"
                ;;
            "completed")
                echo -e "    ${BRIGHT_GREEN}✓${RESET} ${DIM}${current_task}${RESET}"
                ;;
            *)
                echo -e "    ${BRIGHT_YELLOW}○${RESET} ${current_task}"
                ;;
        esac
    else
        echo -e "    ${DIM}No active tasks${RESET}"
    fi

    echo ""
}

draw_phase_pipeline() {
    local current_phase=$(jq -r '.phase' "${ORCHESTRATOR_STATE}" 2>/dev/null || echo "idle")

    echo -e "  ${BRIGHT_CYAN}Phase Pipeline:${RESET}"
    echo ""

    # Define phases
    local phases=("θ₁ Understand" "θ₂ Generate" "θ₃ Allocate" "θ₄ Execute" "θ₅ Integrate" "θ₆ Learn")
    local phase_colors=("${BRIGHT_BLUE}" "${BRIGHT_GREEN}" "${BRIGHT_YELLOW}" "${BRIGHT_RED}" "${BRIGHT_PURPLE}" "${BRIGHT_CYAN}")

    for i in "${!phases[@]}"; do
        local phase="${phases[$i]}"
        local color="${phase_colors[$i]}"

        # Check if this phase is current
        if [[ "$current_phase" == "theta$((i+1))" ]]; then
            echo -e "    ${color}▶ ${phase}${RESET} ${BRIGHT_GREEN}← CURRENT${RESET}"
        else
            echo -e "    ${DIM}○ ${phase}${RESET}"
        fi
    done

    echo ""
}

draw_agent_status_summary() {
    echo -e "  ${BRIGHT_CYAN}Agent Status Summary:${RESET}"
    echo ""

    local running=0
    local completed=0
    local waiting=0
    local failed=0

    # Count agent statuses
    for i in {1..6}; do
        local agent_state="${STATE_DIR}/agents/theta${i}_state.json"
        if [ -f "${agent_state}" ]; then
            local status=$(jq -r '.status' "${agent_state}")
            case "$status" in
                "running")
                    ((running++))
                    ;;
                "completed"|"done")
                    ((completed++))
                    ;;
                "waiting"|"pending")
                    ((waiting++))
                    ;;
                "error"|"failed")
                    ((failed++))
                    ;;
            esac
        fi
    done

    echo -e "    ${BRIGHT_GREEN}▶ Running:${RESET}   ${running}"
    echo -e "    ${BRIGHT_GREEN}● Completed:${RESET} ${completed}"
    echo -e "    ${BRIGHT_YELLOW}○ Waiting:${RESET}   ${waiting}"
    echo -e "    ${BRIGHT_RED}✗ Failed:${RESET}    ${failed}"
    echo ""
}

draw_orchestrator_pane() {
    # Clear screen
    clear

    # Header
    echo -e "${BRIGHT_CYAN}${BOX_TL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_TR}${RESET}"
    echo -e "${BRIGHT_CYAN}${BOX_V}${RESET}  ${BRIGHT_WHITE}${BOLD}ORCHESTRATOR${RESET} - Multi-Agent Coordination & Control      ${BRIGHT_CYAN}${BOX_V}${RESET}"
    echo -e "${BRIGHT_CYAN}${BOX_BL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BOX_BR}${RESET}"
    echo ""

    # World state & convergence
    draw_world_convergence

    # Separator
    echo -e "${BRIGHT_CYAN}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${RESET}"
    echo ""

    # Phase pipeline
    draw_phase_pipeline

    # Separator
    echo -e "${BRIGHT_CYAN}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${RESET}"
    echo ""

    # Task queue
    draw_task_queue

    # Separator
    echo -e "${BRIGHT_CYAN}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${RESET}"
    echo ""

    # Agent status summary
    draw_agent_status_summary

    # Footer
    echo -e "${BRIGHT_CYAN}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${RESET}"

    # Timestamp
    echo ""
    echo -e "  ${DIM}Last updated: $(date '+%H:%M:%S')${RESET}"
}

# ══════════════════════════════════════════════════════════════════════
# Main Loop
# ══════════════════════════════════════════════════════════════════════

main() {
    # Initial draw
    draw_orchestrator_pane

    # Update loop
    while true; do
        sleep 1
        draw_orchestrator_pane
    done
}

# Run main function
main "$@"
