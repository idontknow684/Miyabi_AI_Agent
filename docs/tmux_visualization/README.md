# Multi-Agent Orchestration Visualization System

**Version**: 1.0.0
**Last Updated**: 2025-11-07
**Author**: Claude Code + Shunsuke Hayashi

A stunning, real-time visualization system for the Orchestrator-Subagent architecture using tmux. This system provides k9s-level polish, htop clarity, and lazygit beauty for monitoring multi-agent AI operations.

---

## Features

- **Real-time Multi-pane Dashboard**: 8-pane tmux layout showing Orchestrator + 6 subagents
- **Stunning Visuals**: ANSI colors, box-drawing characters, progress bars, status indicators
- **Live Updates**: Agent state transitions, task queues, world state progression
- **Interactive Controls**: Keyboard shortcuts for navigation and control
- **Convergence Tracking**: Visual representation of World₀ → W_∞ progression
- **Resource Monitoring**: CPU, Memory, and task metrics per agent
- **Demo-Ready**: Perfect for investor presentations and YouTube videos

---

## Quick Start

```bash
# Navigate to tmux visualization directory
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization

# Make scripts executable
chmod +x scripts/*.sh

# Launch the visualization system
./scripts/run.sh
```

---

## Architecture Overview

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
│                    GLOBAL STATUS BAR                            │
│  World: W₃ → W_∞  │  Convergence: 67%  │  Active: 3/6 agents  │
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━┓
│   θ₁ (🔵)   │   θ₂ (🟢)   │   θ₃ (🟡)   │
│  Understand │  Generate   │  Allocate   │
│  ▶ RUNNING  │  ● DONE     │  ○ WAITING  │
│  ████░░ 60% │  ██████ 100%│  ░░░░░░  0% │
┣━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━━┫
│   θ₄ (🔴)   │   θ₅ (🟣)   │   θ₆ (🔵)   │
│   Execute   │  Integrate  │    Learn    │
│  ○ WAITING  │  ○ WAITING  │  ○ WAITING  │
│  ░░░░░░  0% │  ░░░░░░  0% │  ░░░░░░  0% │
┗━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
│                       ORCHESTRATOR                              │
│  Current Phase: θ₁ Understand                                   │
│  Task Queue: [Task 1, Task 2, Task 3]                          │
│  Next: θ₂ Generate → Allocate resources to subagents           │
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
│                      EVENT LOG STREAM                           │
│  [14:23:45] θ₁ → Task decomposition complete                   │
│  [14:23:50] θ₂ → Generated execution plan                      │
│  [14:23:52] θ₃ → Allocated 3 subagents                         │
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## Directory Structure

```
tmux_visualization/
├── README.md                    # This file
├── config/
│   ├── tmux.conf               # tmux configuration
│   └── colors.conf             # Color scheme definitions
├── scripts/
│   ├── setup.sh                # Initial setup
│   ├── run.sh                  # Launch visualization
│   ├── agent_simulator.sh      # Agent state simulator
│   ├── status_bar.sh           # Global status bar updater
│   ├── orchestrator.sh         # Orchestrator pane updater
│   ├── subagent.sh             # Subagent pane updater
│   └── event_log.sh            # Event log streamer
├── mockups/
│   ├── layout_diagram.txt      # ASCII art layout
│   ├── convergence_animation.txt # World convergence animation
│   └── screenshots/            # Demo screenshots
└── assets/
    ├── demo_script.md          # YouTube demo script
    └── asciinema_recording.sh  # Recording configuration
```

---

## Key Features

### 1. Color-Coded Agents

Each agent phase has a distinct color:

- **θ₁ Understand**: 🔵 Blue (Calm, analytical)
- **θ₂ Generate**: 🟢 Green (Creative, productive)
- **θ₃ Allocate**: 🟡 Yellow (Strategic, resource management)
- **θ₄ Execute**: 🔴 Red (Active, intense)
- **θ₅ Integrate**: 🟣 Purple (Synthesis, harmony)
- **θ₆ Learn**: 🔵 Cyan (Reflective, adaptive)

### 2. Status Indicators

- **Running**: 🟢 ▶ (Green play icon)
- **Completed**: ✅ ● (Green dot)
- **Waiting**: 🟡 ○ (Yellow circle)
- **Error**: 🔴 ✗ (Red X)
- **Idle**: ⚪ ◯ (White circle)

### 3. Progress Visualization

ASCII progress bars with percentage:
```
████████░░ 80%   # 80% complete
████░░░░░░ 40%   # 40% complete
░░░░░░░░░░  0%   # Not started
```

### 4. World State Convergence

Visual representation of convergence to ideal state:
```
W₀ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ W_∞
    ↑
    Current: W₃ (67% converged)
```

---

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `1` | Focus θ₁ Understand |
| `2` | Focus θ₂ Generate |
| `3` | Focus θ₃ Allocate |
| `4` | Focus θ₄ Execute |
| `5` | Focus θ₅ Integrate |
| `6` | Focus θ₆ Learn |
| `o` | Focus Orchestrator |
| `l` | Toggle event log |
| `s` | Show global status |
| `r` | Restart system |
| `p` | Pause updates |
| `q` | Quit |

---

## Integration with Miyabi

### State Update Protocol

Agents write state updates to shared files:

```bash
# Each agent writes to its state file
/tmp/miyabi_viz/theta1_state.json
/tmp/miyabi_viz/theta2_state.json
...
/tmp/miyabi_viz/orchestrator_state.json
```

**State File Format:**
```json
{
  "phase": "θ₁",
  "status": "running",
  "progress": 65,
  "current_task": "Analyzing user intent",
  "cpu": 45.2,
  "memory": 128.5,
  "timestamp": "2025-11-07T14:23:45Z"
}
```

### Log Format

Agents write structured logs:

```
[TIMESTAMP] [PHASE] [LEVEL] Message
[14:23:45] [θ₁] [INFO] Task decomposition started
[14:23:50] [θ₂] [SUCCESS] Generated execution plan
[14:23:52] [θ₃] [ERROR] Resource allocation failed
```

---

## Demo & Recording

### asciinema Recording

```bash
# Start recording
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization
./assets/asciinema_recording.sh

# This will:
# 1. Launch tmux visualization
# 2. Start asciinema recording
# 3. Run demo scenario
# 4. Save to demo.cast file
```

### YouTube Demo Script

See `assets/demo_script.md` for full presentation flow:

1. **Introduction** (0:00-0:30): Show static layout
2. **Agent Activation** (0:30-1:00): Trigger θ₁ → θ₆ sequence
3. **Convergence** (1:00-1:30): Show world state progression
4. **Error Recovery** (1:30-2:00): Demonstrate error handling
5. **Completion** (2:00-2:30): Final state and metrics

---

## Installation Requirements

- **tmux** 3.0+
- **bash** 4.0+
- **jq** (for JSON parsing)
- **asciinema** (for recording)
- **watch** (for real-time updates)

```bash
# macOS
brew install tmux jq asciinema watch

# Ubuntu/Debian
apt-get install tmux jq asciinema watch
```

---

## Advanced Configuration

### Custom Color Schemes

Edit `config/colors.conf` to customize colors:

```bash
# Define custom colors
THETA1_COLOR="\033[1;34m"  # Bright blue
THETA2_COLOR="\033[1;32m"  # Bright green
# ... etc
```

### Custom Layouts

Modify `config/tmux.conf` to adjust pane sizes and positions.

### State Synchronization

Choose state backend:

- **File-based** (default): Simple, no dependencies
- **Redis**: High-performance, real-time updates
- **SQLite**: Persistent, queryable history

---

## Troubleshooting

**Issue**: Panes not updating
- Check that state files exist in `/tmp/miyabi_viz/`
- Ensure scripts have execute permission: `chmod +x scripts/*.sh`

**Issue**: Colors not displaying
- Verify terminal supports 256 colors: `echo $TERM`
- Should be `xterm-256color` or `screen-256color`

**Issue**: tmux session not found
- Run `./scripts/setup.sh` first
- Check session exists: `tmux ls`

---

## Contributing

Contributions welcome! Areas to improve:

- Additional color schemes
- Custom layouts for different screen sizes
- Integration with other monitoring tools
- Performance optimizations

---

## License

This visualization system is part of the AI Agent Development Framework and follows the same license terms.

---

**Built with ❤️ for stunning AI orchestration demos**
