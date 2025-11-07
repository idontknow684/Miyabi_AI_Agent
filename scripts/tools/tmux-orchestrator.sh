#!/bin/bash
# tmux-orchestrator.sh - Multi-Agent Orchestration using tmux
# Version: 1.0.0
# Description: Orchestrates multiple Claude Code agents in parallel using tmux sessions

set -euo pipefail

# Configuration
SESSION_NAME="ai-agent-society"
AGENT_DIR=".claude/agents"
LOG_DIR=".claude/logs"
SOCKET_DIR=".claude/sockets"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Initialize directories
init_dirs() {
    mkdir -p "$LOG_DIR"
    mkdir -p "$SOCKET_DIR"
    log "Initialized directories: $LOG_DIR, $SOCKET_DIR"
}

# Check if tmux is installed
check_tmux() {
    if ! command -v tmux &> /dev/null; then
        error "tmux is not installed. Please install tmux first."
        echo "  macOS: brew install tmux"
        echo "  Ubuntu: sudo apt-get install tmux"
        exit 1
    fi
    log "tmux is installed: $(tmux -V)"
}

# Create new tmux session for agent society
create_society_session() {
    local session_name="$1"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        warn "Session '$session_name' already exists. Killing it..."
        tmux kill-session -t "$session_name"
    fi

    tmux new-session -d -s "$session_name" -n "orchestrator"
    log "Created tmux session: $session_name"
}

# Launch agent in dedicated tmux window
launch_agent() {
    local session_name="$1"
    local agent_name="$2"
    local agent_task="$3"
    local window_name="${agent_name}"

    info "Launching agent: $agent_name"

    # Create new window for this agent
    tmux new-window -t "$session_name" -n "$window_name"

    # Set up logging
    local log_file="$LOG_DIR/${agent_name}.log"

    # Send command to agent window
    tmux send-keys -t "$session_name:$window_name" \
        "echo 'Agent: $agent_name' && \
         echo 'Task: $agent_task' && \
         echo 'Started: $(date)' && \
         claude --print \"$agent_task\" \
         --allowedTools 'Read,Write,Edit,Bash,Grep,Glob' \
         --permission-mode acceptEdits \
         2>&1 | tee $log_file" C-m

    log "Agent '$agent_name' launched in window '$window_name'"
}

# Monitor agent progress
monitor_agents() {
    local session_name="$1"

    info "Monitoring agents in session: $session_name"

    # Attach to session for monitoring
    tmux attach-session -t "$session_name"
}

# Get agent status
get_agent_status() {
    local session_name="$1"

    echo "=== Agent Society Status ==="
    echo "Session: $session_name"
    echo ""

    # List all windows (agents)
    tmux list-windows -t "$session_name" -F "#{window_name}: #{window_active} (#{window_panes} panes)"
}

# Broadcast message to all agents
broadcast_message() {
    local session_name="$1"
    local message="$2"

    info "Broadcasting message to all agents: $message"

    # Send to all windows except orchestrator
    tmux list-windows -t "$session_name" -F "#{window_name}" | while read -r window; do
        if [ "$window" != "orchestrator" ]; then
            tmux send-keys -t "$session_name:$window" "$message" C-m
            log "Message sent to $window"
        fi
    done
}

# Shutdown agent society
shutdown_society() {
    local session_name="$1"

    warn "Shutting down agent society: $session_name"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux kill-session -t "$session_name"
        log "Session terminated"
    else
        warn "Session '$session_name' not found"
    fi
}

# Orchestration patterns
orchestrate_parallel() {
    local session_name="$1"
    shift
    local agents=("$@")

    info "Parallel orchestration pattern"
    log "Agents: ${agents[*]}"

    create_society_session "$session_name"

    # Launch all agents in parallel
    for agent_spec in "${agents[@]}"; do
        IFS=':' read -r agent_name agent_task <<< "$agent_spec"
        launch_agent "$session_name" "$agent_name" "$agent_task"
        sleep 1  # Small delay to prevent race conditions
    done

    monitor_agents "$session_name"
}

orchestrate_sequential() {
    local session_name="$1"
    shift
    local agents=("$@")

    info "Sequential orchestration pattern"
    log "Agents: ${agents[*]}"

    create_society_session "$session_name"

    # Launch agents sequentially, waiting for each to complete
    for agent_spec in "${agents[@]}"; do
        IFS=':' read -r agent_name agent_task <<< "$agent_spec"
        launch_agent "$session_name" "$agent_name" "$agent_task"

        # Wait for agent to complete (monitor log file)
        local log_file="$LOG_DIR/${agent_name}.log"
        info "Waiting for $agent_name to complete..."

        # Simple completion detection (can be enhanced)
        while ! grep -q "completed\|finished\|done" "$log_file" 2>/dev/null; do
            sleep 5
        done

        log "Agent $agent_name completed"
    done

    log "All agents completed sequentially"
}

orchestrate_pipeline() {
    local session_name="$1"
    shift
    local agents=("$@")

    info "Pipeline orchestration pattern"
    log "Agents: ${agents[*]}"

    create_society_session "$session_name"

    local previous_output=""

    for agent_spec in "${agents[@]}"; do
        IFS=':' read -r agent_name agent_task <<< "$agent_spec"

        # Append previous output to task if exists
        if [ -n "$previous_output" ]; then
            agent_task="$agent_task (Previous output: $previous_output)"
        fi

        launch_agent "$session_name" "$agent_name" "$agent_task"

        # Wait and capture output
        local log_file="$LOG_DIR/${agent_name}.log"
        while ! grep -q "completed\|finished\|done" "$log_file" 2>/dev/null; do
            sleep 5
        done

        previous_output=$(tail -n 20 "$log_file")
        log "Agent $agent_name completed, output captured"
    done

    log "Pipeline completed"
}

# Usage function
usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Multi-Agent Orchestration using tmux

Commands:
    parallel <agent1:task1> <agent2:task2> ...
        Launch agents in parallel

    sequential <agent1:task1> <agent2:task2> ...
        Launch agents sequentially (wait for each)

    pipeline <agent1:task1> <agent2:task2> ...
        Launch agents in pipeline (output → input)

    monitor <session-name>
        Monitor existing session

    status <session-name>
        Show agent status

    broadcast <session-name> <message>
        Send message to all agents

    shutdown <session-name>
        Shutdown agent society

    society <config-file>
        Launch predefined agent society from config

Examples:
    # Parallel execution
    $0 parallel \\
        "designer:Create UI mockups for dashboard" \\
        "frontend:Implement navigation component" \\
        "qa:Set up testing environment"

    # Sequential execution
    $0 sequential \\
        "researcher:Analyze user requirements" \\
        "designer:Create mockups based on requirements" \\
        "developer:Implement the design"

    # Monitor society
    $0 monitor $SESSION_NAME

    # Shutdown
    $0 shutdown $SESSION_NAME

EOF
}

# Society configuration loader
load_society_config() {
    local config_file="$1"

    if [ ! -f "$config_file" ]; then
        error "Config file not found: $config_file"
        exit 1
    fi

    info "Loading society configuration: $config_file"

    # Parse YAML/JSON config and launch agents
    # This is a simplified example - enhance with proper YAML/JSON parsing

    log "Society loaded from $config_file"
}

# Main entry point
main() {
    check_tmux
    init_dirs

    if [ $# -eq 0 ]; then
        usage
        exit 1
    fi

    local command="$1"
    shift

    case "$command" in
        parallel)
            orchestrate_parallel "$SESSION_NAME" "$@"
            ;;
        sequential)
            orchestrate_sequential "$SESSION_NAME" "$@"
            ;;
        pipeline)
            orchestrate_pipeline "$SESSION_NAME" "$@"
            ;;
        monitor)
            local session="${1:-$SESSION_NAME}"
            monitor_agents "$session"
            ;;
        status)
            local session="${1:-$SESSION_NAME}"
            get_agent_status "$session"
            ;;
        broadcast)
            local session="${1:-$SESSION_NAME}"
            shift
            broadcast_message "$session" "$*"
            ;;
        shutdown)
            local session="${1:-$SESSION_NAME}"
            shutdown_society "$session"
            ;;
        society)
            load_society_config "$1"
            ;;
        *)
            error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

# Run main if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
