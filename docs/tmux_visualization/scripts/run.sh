#!/usr/bin/env bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Miyabi Multi-Agent Orchestration Visualization
#  Run Script - Launch Complete Visualization System
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
STATE_DIR="/tmp/miyabi_viz"
SESSION_NAME="miyabi_orchestrator"
TMUX_CONF="${HOME}/.tmux.conf.miyabi"

# Source color definitions
# shellcheck source=../config/colors.conf
source "${PROJECT_ROOT}/config/colors.conf"

# ══════════════════════════════════════════════════════════════════════
# Functions
# ══════════════════════════════════════════════════════════════════════

log_info() {
    echo -e "${BRIGHT_CYAN}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${BRIGHT_GREEN}[SUCCESS]${RESET} $1"
}

log_error() {
    echo -e "${BRIGHT_RED}[ERROR]${RESET} $1"
}

check_setup() {
    log_info "Checking setup..."

    if [ ! -d "${STATE_DIR}" ]; then
        log_error "State directory not found. Run ./scripts/setup.sh first"
        exit 1
    fi

    if [ ! -f "${TMUX_CONF}" ]; then
        log_error "tmux config not found. Run ./scripts/setup.sh first"
        exit 1
    fi

    log_success "Setup verified"
}

kill_existing_session() {
    if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
        log_info "Killing existing session: ${SESSION_NAME}"
        tmux kill-session -t "${SESSION_NAME}"
    fi
}

create_tmux_session() {
    log_info "Creating tmux session: ${SESSION_NAME}"

    # Create new session with custom config
    tmux -f "${TMUX_CONF}" new-session -d -s "${SESSION_NAME}" -n "Orchestrator"

    log_success "tmux session created"
}

create_layout() {
    log_info "Creating pane layout..."

    local session="${SESSION_NAME}:0"

    # Create 8-pane layout
    # Top row: 3 agent panes (θ₁, θ₂, θ₃)
    tmux split-window -h -t "${session}"
    tmux split-window -h -t "${session}"
    tmux select-layout -t "${session}" even-horizontal

    # Bottom row: 3 agent panes (θ₄, θ₅, θ₆)
    tmux split-window -v -t "${session}.0"
    tmux split-window -v -t "${session}.1"
    tmux split-window -v -t "${session}.2"

    # Large orchestrator pane in the middle
    tmux split-window -v -t "${session}.3" -p 60

    # Event log at the bottom
    tmux split-window -v -t "${session}.6" -p 20

    log_success "Layout created: 6 agents + orchestrator + event log"
}

start_agent_panes() {
    log_info "Starting agent panes..."

    local session="${SESSION_NAME}:0"

    # Start agent displays
    tmux send-keys -t "${session}.0" "${SCRIPT_DIR}/subagent.sh theta1 1" C-m
    tmux send-keys -t "${session}.1" "${SCRIPT_DIR}/subagent.sh theta2 2" C-m
    tmux send-keys -t "${session}.2" "${SCRIPT_DIR}/subagent.sh theta3 3" C-m
    tmux send-keys -t "${session}.3" "${SCRIPT_DIR}/subagent.sh theta4 4" C-m
    tmux send-keys -t "${session}.4" "${SCRIPT_DIR}/subagent.sh theta5 5" C-m
    tmux send-keys -t "${session}.5" "${SCRIPT_DIR}/subagent.sh theta6 6" C-m

    log_success "Agent panes started"
}

start_orchestrator_pane() {
    log_info "Starting orchestrator pane..."

    local session="${SESSION_NAME}:0"

    # Start orchestrator display
    tmux send-keys -t "${session}.6" "${SCRIPT_DIR}/orchestrator.sh" C-m

    log_success "Orchestrator pane started"
}

start_event_log_pane() {
    log_info "Starting event log pane..."

    local session="${SESSION_NAME}:0"

    # Start event log display
    tmux send-keys -t "${session}.7" "${SCRIPT_DIR}/event_log.sh" C-m

    log_success "Event log pane started"
}

start_simulator() {
    log_info "Starting agent simulator..."

    # Start simulator in background
    "${SCRIPT_DIR}/agent_simulator.sh" &
    local sim_pid=$!

    # Save PID for later cleanup
    echo "${sim_pid}" > "${STATE_DIR}/simulator.pid"

    log_success "Simulator started (PID: ${sim_pid})"
}

attach_session() {
    log_info "Attaching to tmux session..."
    echo ""
    echo -e "${BRIGHT_YELLOW}Press Ctrl-b then 'd' to detach${RESET}"
    echo -e "${BRIGHT_YELLOW}Press Ctrl-b then 'q' to quit${RESET}"
    echo ""
    sleep 2

    # Attach to session
    tmux attach-session -t "${SESSION_NAME}"
}

print_banner() {
    echo -e "${BRIGHT_CYAN}${BOLD}"
    cat << "EOF"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 __  __ _             _     _
|  \/  (_)_   _  __ _| |__ (_)
| |\/| | | | | |/ _` | '_ \| |
| |  | | | |_| | (_| | |_) | |
|_|  |_|_|\__, |\__,_|_.__/|_|
          |___/

    Multi-Agent Orchestration Visualization System

    Agent(Intent, World₀) = lim_{n→∞} (θ₆ ◦ θ₅ ◦ θ₄ ◦ θ₃ ◦ θ₂ ◦ θ₁)ⁿ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    echo -e "${RESET}"
    echo ""
}

# ══════════════════════════════════════════════════════════════════════
# Main Execution
# ══════════════════════════════════════════════════════════════════════

main() {
    print_banner

    check_setup
    kill_existing_session
    create_tmux_session
    create_layout
    start_agent_panes
    start_orchestrator_pane
    start_event_log_pane
    start_simulator

    echo ""
    echo -e "${BRIGHT_GREEN}${BOLD}✓ Visualization system launched!${RESET}"
    echo ""

    attach_session
}

# Run main function
main "$@"
