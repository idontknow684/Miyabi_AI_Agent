# Miyabi tmux Visualization - Quick Reference Card

**Version**: 1.0.0

## Installation & Setup

```bash
# Install dependencies (macOS)
brew install tmux jq asciinema watch

# Navigate to project
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization

# Run setup (first time only)
./scripts/setup.sh

# Launch visualization
./scripts/run.sh

# Attach to existing session
tmux attach -t miyabi_orchestrator

# Kill session
tmux kill-session -t miyabi_orchestrator
```

---

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| **1-6** | Focus on agent θ₁-θ₆ |
| **o** | Focus on Orchestrator |
| **l** | Focus on event log |
| **h/j/k/l** | Navigate panes (Vi-style) |
| **r** | Restart simulation |
| **p** | Pause updates |
| **q** | Quit (with confirmation) |
| **Ctrl-b d** | Detach from session |
| **Ctrl-b ?** | Show all keybindings |

---

## Directory Structure

```
tmux_visualization/
├── README.md                    # Main documentation
├── INTEGRATION_GUIDE.md         # Rust integration guide
├── QUICK_REFERENCE.md           # This file
├── config/
│   ├── tmux.conf               # tmux configuration
│   └── colors.conf             # Color definitions
├── scripts/
│   ├── setup.sh                # Initial setup
│   ├── run.sh                  # Launch system
│   ├── agent_simulator.sh      # Demo simulator
│   ├── subagent.sh             # Agent pane display
│   ├── orchestrator.sh         # Orchestrator display
│   └── event_log.sh            # Event log display
├── mockups/
│   ├── layout_diagram.txt      # ASCII layout
│   └── convergence_animation.txt # Animation frames
└── assets/
    ├── demo_script.md          # Presentation script
    └── asciinema_recording.sh  # Recording tool
```

---

## State Files

### Agent State: `/tmp/miyabi_viz/agents/theta{N}_state.json`

```json
{
  "phase": "theta1",
  "status": "running",
  "progress": 65,
  "current_task": "Task description",
  "cpu": 45.2,
  "memory": 128.5,
  "timestamp": "2025-11-07T14:23:45Z",
  "tasks_completed": 5,
  "tasks_failed": 0
}
```

### World State: `/tmp/miyabi_viz/world_state.json`

```json
{
  "current_world": 3,
  "target_world": "∞",
  "convergence_percent": 67,
  "active_agents": 3,
  "total_agents": 6,
  "blink_count": 18,
  "timestamp": "2025-11-07T14:23:45Z"
}
```

### Event Log: `/tmp/miyabi_viz/logs/events.log`

```
[14:23:45] [θ₁] [INFO] Phase started
[14:23:47] [θ₁] [SUCCESS] Task completed
[14:23:50] [ORCHESTRATOR] [ERROR] Allocation failed
```

---

## Status Indicators

| Symbol | Status | Color |
|--------|--------|-------|
| **○** | Idle/Waiting | Gray |
| **▶** | Running | Green |
| **●** | Completed | Green |
| **✓** | Success | Green |
| **✗** | Error | Red |

---

## Color Scheme

| Agent | Color | Emoji |
|-------|-------|-------|
| **θ₁ Understand** | Blue | 🔵 |
| **θ₂ Generate** | Green | 🟢 |
| **θ₃ Allocate** | Yellow | 🟡 |
| **θ₄ Execute** | Red | 🔴 |
| **θ₅ Integrate** | Purple | 🟣 |
| **θ₆ Learn** | Cyan | 🔵 |

---

## Progress Bar Format

```
████████░░ 80%   # 80% complete
████░░░░░░ 40%   # 40% complete
░░░░░░░░░░  0%   # Not started
```

---

## Box Drawing Characters

```
┏ ┓ ┗ ┛  Top/bottom corners
┃        Vertical line
━        Horizontal line
┳ ┻ ┣ ┫  T-junctions
╋        Cross
```

---

## Common Commands

### View State Files
```bash
# View agent state
cat /tmp/miyabi_viz/agents/theta1_state.json | jq .

# View world state
cat /tmp/miyabi_viz/world_state.json | jq .

# Tail event log
tail -f /tmp/miyabi_viz/logs/events.log

# View all agent states
jq -s '.' /tmp/miyabi_viz/agents/*_state.json
```

### Manual State Updates (Testing)
```bash
# Set agent to running
echo '{
  "phase": "theta1",
  "status": "running",
  "progress": 50,
  "current_task": "Test task",
  "cpu": 25.0,
  "memory": 64.0,
  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
  "tasks_completed": 1,
  "tasks_failed": 0
}' | jq . > /tmp/miyabi_viz/agents/theta1_state.json

# Trigger error state
jq '.status = "error"' /tmp/miyabi_viz/agents/theta4_state.json > tmp.json && mv tmp.json /tmp/miyabi_viz/agents/theta4_state.json

# Reset world state
echo '{
  "current_world": 0,
  "target_world": "∞",
  "convergence_percent": 0,
  "active_agents": 0,
  "total_agents": 6,
  "blink_count": 0,
  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
}' | jq . > /tmp/miyabi_viz/world_state.json
```

### Recording
```bash
# Record demo with asciinema
./assets/asciinema_recording.sh

# Or manually
asciinema rec demo.cast --title "Miyabi" --idle-time-limit 2
# ... run demo ...
# Ctrl-D to stop

# Playback
asciinema play demo.cast

# Upload
asciinema upload demo.cast
```

---

## Troubleshooting

### Issue: "State directory not found"
```bash
./scripts/setup.sh  # Run setup first
```

### Issue: "tmux session already exists"
```bash
tmux kill-session -t miyabi_orchestrator
./scripts/run.sh
```

### Issue: "Permission denied"
```bash
chmod +x scripts/*.sh assets/*.sh
```

### Issue: Colors not showing
```bash
# Check terminal color support
echo $TERM  # Should be xterm-256color or screen-256color

# Set if needed
export TERM=xterm-256color
```

### Issue: Panes not updating
```bash
# Check if scripts are running
ps aux | grep -E "(subagent|orchestrator|event_log|agent_simulator)"

# Restart system
tmux kill-session -t miyabi_orchestrator
./scripts/run.sh
```

### Issue: High CPU usage
```bash
# Kill simulator
pkill -f agent_simulator.sh

# Check update intervals in scripts (default: 1 second)
```

---

## Demo Checklist

- [ ] Terminal size: 180x60 or larger
- [ ] Color support: 256 colors enabled
- [ ] Dependencies: tmux, jq installed
- [ ] Setup complete: `./scripts/setup.sh` ran successfully
- [ ] Practice run: Rehearsed demo script 2-3 times
- [ ] Recording ready: asciinema or screen recorder configured
- [ ] Audio: Microphone tested and working
- [ ] Background: Clean desktop, other windows closed

---

## Performance Tips

1. **Reduce update frequency**: Edit scripts to update every 2-5 seconds instead of 1
2. **Disable metrics**: Comment out CPU/memory polling in production
3. **Use release builds**: `cargo build --release` for Rust integration
4. **Limit log size**: Rotate logs periodically
   ```bash
   tail -n 1000 /tmp/miyabi_viz/logs/events.log > /tmp/miyabi_viz/logs/events.log.tmp
   mv /tmp/miyabi_viz/logs/events.log.tmp /tmp/miyabi_viz/logs/events.log
   ```

---

## Integration Quick Start

### 1. Add to `Cargo.toml`
```toml
[dependencies]
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
chrono = { version = "0.4", features = ["serde"] }
```

### 2. Write State in Agent
```rust
use serde::{Serialize, Deserialize};
use std::fs;

#[derive(Serialize, Deserialize)]
struct AgentState {
    phase: String,
    status: String,
    progress: u8,
    current_task: String,
    // ... other fields
}

impl Agent {
    fn write_state(&self) -> Result<(), Box<dyn std::error::Error>> {
        let json = serde_json::to_string_pretty(&self.state)?;
        fs::write("/tmp/miyabi_viz/agents/theta1_state.json", json)?;
        Ok(())
    }
}
```

### 3. Update During Execution
```rust
// Start task
self.state.status = "running".to_string();
self.state.progress = 0;
self.write_state()?;

// Update progress
for i in (0..=100).step_by(20) {
    self.state.progress = i;
    self.write_state()?;
    // ... do work ...
}

// Complete
self.state.status = "completed".to_string();
self.state.progress = 100;
self.write_state()?;
```

See **INTEGRATION_GUIDE.md** for full details.

---

## Resources

- **Full Documentation**: README.md
- **Integration Guide**: INTEGRATION_GUIDE.md
- **Demo Script**: assets/demo_script.md
- **Layout Mockups**: mockups/layout_diagram.txt
- **Animation Frames**: mockups/convergence_animation.txt

---

## Support

- **GitHub Issues**: [Your Repo]/issues
- **Documentation**: [Your Repo]/docs/tmux_visualization
- **Demo Video**: [YouTube Link]
- **Discord**: [Your Discord Link]

---

**Quick Start Command**:
```bash
git clone [YOUR_REPO] && cd miyabi/docs/tmux_visualization && ./scripts/setup.sh && ./scripts/run.sh
```

---

**Last Updated**: 2025-11-07
**Version**: 1.0.0
