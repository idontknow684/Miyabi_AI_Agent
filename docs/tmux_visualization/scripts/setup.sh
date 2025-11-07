#!/usr/bin/env bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Miyabi Multi-Agent Orchestration Visualization
#  Setup Script - Initial Environment Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
STATE_DIR="/tmp/miyabi_viz"
SESSION_NAME="miyabi_orchestrator"

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

log_warning() {
    echo -e "${BRIGHT_YELLOW}[WARNING]${RESET} $1"
}

log_error() {
    echo -e "${BRIGHT_RED}[ERROR]${RESET} $1"
}

check_dependencies() {
    log_info "Checking dependencies..."

    local missing_deps=()

    # Check tmux
    if ! command -v tmux &> /dev/null; then
        missing_deps+=("tmux")
    fi

    # Check jq
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi

    # Check watch
    if ! command -v watch &> /dev/null; then
        log_warning "watch not found (optional for live updates)"
    fi

    # Check asciinema (optional)
    if ! command -v asciinema &> /dev/null; then
        log_warning "asciinema not found (optional for recording)"
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Install with:"
        echo "  macOS:        brew install ${missing_deps[*]}"
        echo "  Ubuntu:       apt-get install ${missing_deps[*]}"
        echo "  Arch Linux:   pacman -S ${missing_deps[*]}"
        exit 1
    fi

    log_success "All required dependencies found"
}

create_state_directory() {
    log_info "Creating state directory: ${STATE_DIR}"

    # Remove old state if exists
    if [ -d "${STATE_DIR}" ]; then
        log_warning "Removing old state directory"
        rm -rf "${STATE_DIR}"
    fi

    # Create fresh state directory
    mkdir -p "${STATE_DIR}"

    # Create subdirectories
    mkdir -p "${STATE_DIR}/agents"
    mkdir -p "${STATE_DIR}/logs"

    log_success "State directory created"
}

initialize_agent_states() {
    log_info "Initializing agent states..."

    local agents=("theta1" "theta2" "theta3" "theta4" "theta5" "theta6" "orchestrator")

    for agent in "${agents[@]}"; do
        local state_file="${STATE_DIR}/agents/${agent}_state.json"

        cat > "${state_file}" <<EOF
{
  "phase": "${agent}",
  "status": "idle",
  "progress": 0,
  "current_task": "",
  "cpu": 0.0,
  "memory": 0.0,
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "tasks_completed": 0,
  "tasks_failed": 0
}
EOF
    done

    log_success "Agent states initialized"
}

initialize_world_state() {
    log_info "Initializing world state..."

    local world_state_file="${STATE_DIR}/world_state.json"

    cat > "${world_state_file}" <<EOF
{
  "current_world": 0,
  "target_world": "∞",
  "convergence_percent": 0,
  "active_agents": 0,
  "total_agents": 6,
  "blink_count": 0,
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

    log_success "World state initialized"
}

copy_tmux_config() {
    log_info "Setting up tmux configuration..."

    local tmux_conf_source="${PROJECT_ROOT}/config/tmux.conf"
    local tmux_conf_target="${HOME}/.tmux.conf.miyabi"

    # Copy config
    cp "${tmux_conf_source}" "${tmux_conf_target}"

    log_success "tmux configuration copied to ${tmux_conf_target}"
    log_warning "To use: tmux -f ${tmux_conf_target} new-session -s ${SESSION_NAME}"
}

make_scripts_executable() {
    log_info "Making scripts executable..."

    find "${SCRIPT_DIR}" -type f -name "*.sh" -exec chmod +x {} \;

    log_success "Scripts are now executable"
}

create_event_log() {
    log_info "Creating event log..."

    local log_file="${STATE_DIR}/logs/events.log"

    # Create initial log entry
    echo "[$(date +"%H:%M:%S")] [SYSTEM] [INFO] Miyabi Orchestrator initialized" > "${log_file}"

    log_success "Event log created: ${log_file}"
}

print_summary() {
    echo ""
    echo -e "${BORDER_BRIGHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BRIGHT_GREEN}${BOLD}✓ Setup Complete!${RESET}"
    echo -e "${BORDER_BRIGHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${BRIGHT_CYAN}State directory:${RESET}   ${STATE_DIR}"
    echo -e "${BRIGHT_CYAN}tmux config:${RESET}       ${HOME}/.tmux.conf.miyabi"
    echo -e "${BRIGHT_CYAN}Session name:${RESET}      ${SESSION_NAME}"
    echo ""
    echo -e "${BRIGHT_YELLOW}Next steps:${RESET}"
    echo -e "  1. Launch visualization:  ${BRIGHT_WHITE}./scripts/run.sh${RESET}"
    echo -e "  2. View in tmux:          ${BRIGHT_WHITE}tmux attach -t ${SESSION_NAME}${RESET}"
    echo -e "  3. Stop:                  ${BRIGHT_WHITE}tmux kill-session -t ${SESSION_NAME}${RESET}"
    echo ""
    echo -e "${BORDER_BRIGHT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

# ══════════════════════════════════════════════════════════════════════
# Main Execution
# ══════════════════════════════════════════════════════════════════════

main() {
    echo -e "${BRIGHT_CYAN}${BOLD}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " Miyabi Multi-Agent Orchestration Visualization"
    echo " Setup Script"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${RESET}"
    echo ""

    check_dependencies
    create_state_directory
    initialize_agent_states
    initialize_world_state
    create_event_log
    copy_tmux_config
    make_scripts_executable

    print_summary
}

# Run main function
main "$@"
