#!/usr/bin/env bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Miyabi Multi-Agent Orchestration Visualization
#  Agent Simulator - Simulate Agent State Transitions for Demo
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
STATE_DIR="/tmp/miyabi_viz"
LOG_FILE="${STATE_DIR}/logs/events.log"
WORLD_STATE_FILE="${STATE_DIR}/world_state.json"

# Simulation speed (seconds)
PHASE_DURATION=5

# ══════════════════════════════════════════════════════════════════════
# Functions
# ══════════════════════════════════════════════════════════════════════

log_event() {
    local phase="$1"
    local level="$2"
    local message="$3"

    local timestamp=$(date '+%H:%M:%S')
    echo "[${timestamp}] [${phase}] [${level}] ${message}" >> "${LOG_FILE}"
}

update_agent_state() {
    local agent="$1"
    local status="$2"
    local progress="$3"
    local task="$4"
    local cpu="${5:-0.0}"
    local memory="${6:-0.0}"

    local state_file="${STATE_DIR}/agents/${agent}_state.json"

    # Read current state
    local tasks_completed=$(jq -r '.tasks_completed' "${state_file}")
    local tasks_failed=$(jq -r '.tasks_failed' "${state_file}")

    # Update counters
    if [ "$status" == "completed" ]; then
        tasks_completed=$((tasks_completed + 1))
    elif [ "$status" == "error" ]; then
        tasks_failed=$((tasks_failed + 1))
    fi

    # Write updated state
    cat > "${state_file}" <<EOF
{
  "phase": "${agent}",
  "status": "${status}",
  "progress": ${progress},
  "current_task": "${task}",
  "cpu": ${cpu},
  "memory": ${memory},
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "tasks_completed": ${tasks_completed},
  "tasks_failed": ${tasks_failed}
}
EOF
}

update_world_state() {
    local current_world="$1"
    local convergence="$2"
    local active_agents="$3"
    local blink_count="$4"

    cat > "${WORLD_STATE_FILE}" <<EOF
{
  "current_world": ${current_world},
  "target_world": "∞",
  "convergence_percent": ${convergence},
  "active_agents": ${active_agents},
  "total_agents": 6,
  "blink_count": ${blink_count},
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
}

simulate_agent_phase() {
    local agent="$1"
    local phase_name="$2"
    local task_description="$3"

    log_event "${phase_name}" "INFO" "Phase started"

    # Start phase
    update_agent_state "${agent}" "running" 0 "${task_description}" 15.5 64.2
    sleep 1

    # Progress through phase
    for progress in 20 40 60 80; do
        local cpu=$(awk -v min=10 -v max=80 'BEGIN{srand(); print min+rand()*(max-min)}')
        local memory=$(awk -v min=50 -v max=200 'BEGIN{srand(); print min+rand()*(max-min)}')

        update_agent_state "${agent}" "running" ${progress} "${task_description}" "${cpu}" "${memory}"
        sleep 1
    done

    # Complete phase
    update_agent_state "${agent}" "completed" 100 "${task_description}" 5.0 60.0
    log_event "${phase_name}" "SUCCESS" "Phase completed"
    sleep 1

    # Set to idle
    update_agent_state "${agent}" "idle" 0 "" 0.0 0.0
}

run_orchestration_cycle() {
    local cycle_num="$1"

    log_event "ORCHESTRATOR" "INFO" "Starting orchestration cycle ${cycle_num}"

    # Define phases
    local -A phases=(
        ["theta1"]="θ₁ Understand|Analyzing user intent and decomposing task"
        ["theta2"]="θ₂ Generate|Generating execution plan and selecting tools"
        ["theta3"]="θ₃ Allocate|Allocating resources and delegating to subagents"
        ["theta4"]="θ₄ Execute|Executing tasks with allocated resources"
        ["theta5"]="θ₅ Integrate|Integrating results and ensuring consistency"
        ["theta6"]="θ₆ Learn|Learning from execution and improving model"
    )

    local phase_order=("theta1" "theta2" "theta3" "theta4" "theta5" "theta6")

    # Run each phase sequentially
    for i in "${!phase_order[@]}"; do
        local agent="${phase_order[$i]}"
        local phase_info="${phases[$agent]}"
        local phase_name=$(echo "$phase_info" | cut -d'|' -f1)
        local task_desc=$(echo "$phase_info" | cut -d'|' -f2)

        # Update orchestrator state
        update_agent_state "orchestrator" "running" $((i * 16)) "Current: ${phase_name}" 25.0 128.0

        # Update world state
        local world_num=$((cycle_num * 6 + i))
        local convergence=$(((world_num * 100) / 50))  # Converge to 100% at world 50
        if [ $convergence -gt 100 ]; then convergence=100; fi

        update_world_state "${world_num}" "${convergence}" $((i + 1)) "${world_num}"

        # Simulate this agent phase
        simulate_agent_phase "${agent}" "${phase_name}" "${task_desc}"
    done

    # Complete cycle
    update_agent_state "orchestrator" "completed" 100 "Cycle ${cycle_num} completed" 5.0 100.0
    log_event "ORCHESTRATOR" "SUCCESS" "Orchestration cycle ${cycle_num} completed"

    # World state blink
    local final_world=$((cycle_num * 6 + 6))
    local final_convergence=$(((final_world * 100) / 50))
    if [ $final_convergence -gt 100 ]; then final_convergence=100; fi

    update_world_state "${final_world}" "${final_convergence}" 0 "${final_world}"

    sleep 2
}

# ══════════════════════════════════════════════════════════════════════
# Main Simulation Loop
# ══════════════════════════════════════════════════════════════════════

main() {
    log_event "SYSTEM" "INFO" "Agent simulator started"

    # Run multiple orchestration cycles
    local cycle=0

    while true; do
        cycle=$((cycle + 1))

        run_orchestration_cycle "${cycle}"

        # Check if we should stop (convergence reached)
        local convergence=$(jq -r '.convergence_percent' "${WORLD_STATE_FILE}")
        if [ "$convergence" -ge 100 ]; then
            log_event "SYSTEM" "SUCCESS" "Convergence reached! World_∞ achieved"

            # Set all agents to completed
            for i in {1..6}; do
                update_agent_state "theta${i}" "completed" 100 "Convergence achieved" 0.0 0.0
            done
            update_agent_state "orchestrator" "completed" 100 "System converged to optimal state" 0.0 0.0

            # Wait before restarting
            sleep 10

            # Reset and restart
            cycle=0
            log_event "SYSTEM" "INFO" "Restarting simulation from W₀"
            update_world_state 0 0 0 0
        fi

        # Small delay between cycles
        sleep 2
    done
}

# Run main function
main "$@"
