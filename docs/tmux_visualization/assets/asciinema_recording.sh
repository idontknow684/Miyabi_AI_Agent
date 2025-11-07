#!/usr/bin/env bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Miyabi Multi-Agent Orchestration Visualization
#  asciinema Recording Script - Automated Demo Recording
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ══════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_FILE="${PROJECT_ROOT}/miyabi_demo.cast"
SESSION_NAME="miyabi_orchestrator"

# Recording settings
TITLE="Miyabi Multi-Agent Orchestration Visualization"
IDLE_TIME_LIMIT=2  # Maximum pause between frames (seconds)

# ══════════════════════════════════════════════════════════════════════
# Colors
# ══════════════════════════════════════════════════════════════════════

RESET="\033[0m"
BRIGHT_CYAN="\033[1;36m"
BRIGHT_GREEN="\033[1;32m"
BRIGHT_YELLOW="\033[1;33m"
BRIGHT_RED="\033[1;31m"

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

check_asciinema() {
    if ! command -v asciinema &> /dev/null; then
        log_error "asciinema not found"
        echo ""
        echo "Install with:"
        echo "  macOS:        brew install asciinema"
        echo "  Ubuntu:       apt-get install asciinema"
        echo "  pip:          pip install asciinema"
        exit 1
    fi
}

check_terminal_size() {
    local cols=$(tput cols)
    local rows=$(tput lines)

    log_info "Terminal size: ${cols}x${rows}"

    if [ "$cols" -lt 180 ] || [ "$rows" -lt 60 ]; then
        log_warning "Terminal size is smaller than recommended (180x60)"
        echo "Current: ${cols}x${rows}"
        echo "Recommended: 180x60 or larger"
        echo ""
        echo -n "Continue anyway? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Aborted by user"
            exit 0
        fi
    fi
}

check_tmux_session() {
    if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
        log_warning "tmux session '${SESSION_NAME}' already exists"
        echo -n "Kill existing session and start fresh? (y/N): "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            tmux kill-session -t "${SESSION_NAME}"
            log_info "Killed existing session"
        else
            log_info "Aborted by user"
            exit 0
        fi
    fi
}

print_instructions() {
    echo ""
    echo -e "${BRIGHT_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BRIGHT_GREEN}Recording Instructions${RESET}"
    echo -e "${BRIGHT_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo "1. asciinema will start recording in 3 seconds"
    echo "2. The Miyabi visualization will launch automatically"
    echo "3. Follow the demo script timeline (3-4 minutes)"
    echo "4. Press 'q' in tmux when done, then Ctrl-D to stop recording"
    echo ""
    echo "Key shortcuts during demo:"
    echo "  1-6     Focus on specific agent"
    echo "  o       Focus on Orchestrator"
    echo "  l       Focus on event log"
    echo "  r       Restart simulation"
    echo "  p       Pause/resume"
    echo "  q       Quit (with confirmation)"
    echo ""
    echo -e "${BRIGHT_YELLOW}Tip: Practice the demo 2-3 times before recording${RESET}"
    echo ""
    echo -n "Ready to start recording? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        log_info "Aborted by user"
        exit 0
    fi
}

start_recording() {
    log_info "Starting recording in 3 seconds..."
    sleep 1
    echo "3..."
    sleep 1
    echo "2..."
    sleep 1
    echo "1..."
    sleep 1
    echo "GO!"

    # Start asciinema recording
    asciinema rec "${OUTPUT_FILE}" \
        --title "${TITLE}" \
        --idle-time-limit "${IDLE_TIME_LIMIT}" \
        --command "${PROJECT_ROOT}/scripts/run.sh"
}

post_recording_actions() {
    log_success "Recording complete!"
    echo ""
    echo "Output file: ${OUTPUT_FILE}"
    echo ""

    # Playback prompt
    echo -n "Play recording now? (y/N): "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        asciinema play "${OUTPUT_FILE}"
    fi

    # Upload prompt
    echo ""
    echo -n "Upload to asciinema.org? (y/N): "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        asciinema upload "${OUTPUT_FILE}"
        log_success "Upload complete!"
    fi

    # Conversion prompt
    echo ""
    echo "You can convert to GIF or video with:"
    echo "  GIF:   asciicast2gif ${OUTPUT_FILE} demo.gif"
    echo "  MP4:   docker run --rm -v \$PWD:/data asciinema/asciicast2gif -s 2 ${OUTPUT_FILE} demo.gif"
    echo ""
}

cleanup() {
    # Kill simulator if still running
    if [ -f "/tmp/miyabi_viz/simulator.pid" ]; then
        local pid=$(cat /tmp/miyabi_viz/simulator.pid)
        if kill -0 "$pid" 2>/dev/null; then
            log_info "Stopping agent simulator (PID: ${pid})"
            kill "$pid" 2>/dev/null || true
        fi
    fi

    # Kill tmux session if still running
    if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
        log_info "Killing tmux session"
        tmux kill-session -t "${SESSION_NAME}" 2>/dev/null || true
    fi
}

# ══════════════════════════════════════════════════════════════════════
# Main Execution
# ══════════════════════════════════════════════════════════════════════

main() {
    echo -e "${BRIGHT_CYAN}${BOLD}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " Miyabi Multi-Agent Orchestration Visualization"
    echo " asciinema Recording Script"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${RESET}"
    echo ""

    # Pre-flight checks
    check_asciinema
    check_terminal_size
    check_tmux_session

    # Show instructions
    print_instructions

    # Setup trap for cleanup
    trap cleanup EXIT INT TERM

    # Start recording
    start_recording

    # Post-recording actions
    post_recording_actions

    log_success "All done!"
}

# Run main function
main "$@"
