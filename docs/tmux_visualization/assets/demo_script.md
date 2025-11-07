# Miyabi Orchestration Visualization - Demo Script

**Duration**: 3-4 minutes
**Target Audience**: CTOs, Investors, AI Engineers, YouTube viewers
**Goal**: Showcase stunning multi-agent orchestration with k9s-level polish

---

## Pre-Demo Setup

### Terminal Configuration
- **Size**: 180 columns x 60 rows (recommended)
- **Font**: Monospace, 12-14pt (Menlo, Monaco, or Fira Code)
- **Colors**: 256-color support enabled
- **Recording**: asciinema or screen recording software

### Launch Commands
```bash
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization
./scripts/setup.sh
./scripts/run.sh
```

---

## Demo Script Timeline

### 00:00 - 00:30: Introduction & Static Layout

**Narration**:
> "Welcome to Miyabi - a multi-agent orchestration system that brings AI agents to life.
> What you're seeing is a real-time visualization of six autonomous agents working together
> to transform the world state from W₀ to W∞ through a series of coordinated phases."

**Actions**:
- Show the full 8-pane tmux layout
- Highlight each component:
  - Top row: θ₁ (Understand), θ₂ (Generate), θ₃ (Allocate)
  - Bottom row: θ₄ (Execute), θ₅ (Integrate), θ₆ (Learn)
  - Center: Orchestrator (coordination hub)
  - Bottom: Event log stream
- Point out the global status bar showing world state and convergence

**Key Visual**: All agents idle, waiting to begin

---

### 00:30 - 01:00: Agent Activation (θ₁ → θ₂)

**Narration**:
> "The process begins with θ₁ - the Understanding agent. Watch as it analyzes
> the user's intent and decomposes the task. Notice the progress bar filling up,
> CPU and memory metrics updating in real-time, and events appearing in the log stream."

**Actions**:
- θ₁ activates (blue highlight)
- Progress bar: 0% → 20% → 40% → 60% → 80% → 100%
- Status transitions: ○ Waiting → ▶ Running → ● Done
- Event log shows: "[θ₁] [INFO] Phase started"
- World state: W₀ → W₁
- Convergence: 0% → 2%

**Pause for 2 seconds to show completed state**

**Then θ₂ activates**:
- θ₂ (green) begins generating execution plan
- Orchestrator shows: "Current Phase: θ₂ Generate"
- World progresses: W₁ → W₂

**Key Visual**: Color transitions (blue → green), progress bars, live metrics

---

### 01:00 - 01:30: Full Pipeline in Motion (θ₃ → θ₆)

**Narration**:
> "Now watch the full pipeline come alive. θ₃ allocates resources, θ₄ executes tasks,
> θ₅ integrates results, and θ₆ learns from the entire cycle. Each phase is color-coded
> for instant recognition: yellow for allocation, red for execution, purple for integration,
> and cyan for learning."

**Actions**:
- Rapid succession of agent activations:
  - θ₃ (yellow) - Allocate
  - θ₄ (red) - Execute
  - θ₅ (purple) - Integrate
  - θ₆ (cyan) - Learn

- World state progresses: W₂ → W₃ → W₄ → W₅ → W₆
- Convergence increases: 2% → 4% → 6% → 8% → 10% → 12%
- Agent status summary updates:
  - Running: 1
  - Completed: increments as each finishes
  - Waiting: decrements

- Event log fills with activity:
  ```
  [14:23:50] [θ₂] [SUCCESS] Phase completed
  [14:23:52] [θ₃] [INFO] Phase started
  [14:23:54] [θ₃] [INFO] Allocated 3 subagents
  [14:23:56] [θ₃] [SUCCESS] Phase completed
  [14:23:58] [θ₄] [INFO] Phase started
  ```

**Key Visual**: All six agents cycling through, rainbow of colors, convergence bar growing

---

### 01:30 - 02:00: Multiple Cycles & Convergence Acceleration

**Narration**:
> "The magic happens when cycles repeat. Each iteration brings the system closer
> to the optimal state - W∞. Watch the convergence percentage climb as we approach
> the goal. This is the 'flickering scenery' - discrete snapshots of world
> transformations, like frames in a movie."

**Actions**:
- Show 3-4 complete cycles (θ₁ through θ₆) running
- World state counter increases rapidly: W₆ → W₁₂ → W₁₈ → W₂₄
- Convergence jumps: 12% → 24% → 36% → 48%
- Blink count visible in orchestrator: 6 → 12 → 18 → 24

- Press `o` to focus on Orchestrator pane
- Zoom in on:
  - World state progression bar
  - Phase pipeline showing current phase
  - Agent status summary
  - Task queue

**Key Visual**: Accelerated convergence, orchestrator coordination

---

### 02:00 - 02:30: Error Recovery Demo

**Narration**:
> "Real-world systems must handle errors gracefully. Let's inject a failure
> into θ₄ Execute and watch how the system recovers."

**Actions**:
- Manually trigger error state for θ₄:
  ```bash
  # In another terminal
  echo '{"phase":"theta4","status":"error",...}' > /tmp/miyabi_viz/agents/theta4_state.json
  ```

- θ₄ shows: ✗ ERROR (red)
- Event log: "[θ₄] [ERROR] Task execution failed"
- Orchestrator detects error
- System retries θ₄
- θ₄ recovers: ✗ ERROR → ▶ Running → ● Done
- Event log: "[θ₄] [SUCCESS] Retry succeeded"

- World continues progressing: W₂₄ → W₂₅ → W₂₆
- Convergence resumes: 48% → 50% → 52%

**Key Visual**: Error state (red), recovery, resilience

---

### 02:30 - 03:00: High Convergence & Approaching W∞

**Narration**:
> "As we approach convergence, the system stabilizes. Notice how the metrics
> become more consistent, CPU usage drops, and the world state asymptotically
> approaches infinity."

**Actions**:
- World state: W₃₆ → W₄₂ → W₄₈ → W₅₀
- Convergence: 72% → 84% → 96% → 100%
- Convergence bar color changes:
  - Red/Yellow at <80%
  - Green at ≥80%
  - Bright green at 100%

- All agent panes show:
  - Completed tasks: High counts (8-12)
  - Failed tasks: Low (0-1)
  - CPU: Stabilized (5-15%)
  - Memory: Optimized (50-80 MB)

- Press `1` through `6` to quickly tour each agent
- Show each agent's metrics and completed task counts

**Key Visual**: Green convergence bar at 100%, stable metrics

---

### 03:00 - 03:30: Convergence Achieved & Summary

**Narration**:
> "Convergence achieved! The system has reached W∞ - the optimal state.
> Let's review the statistics."

**Actions**:
- World state shows: W₅₀ ≈ W∞
- Convergence: 100% (bright green)
- All agents: ● Completed

- Orchestrator displays final summary:
  ```
  ✅ CONVERGENCE ACHIEVED!

  θ₁ Understand:  8 cycles, avg 4.2s
  θ₂ Generate:    8 cycles, avg 3.8s
  θ₃ Allocate:    8 cycles, avg 2.1s
  θ₄ Execute:     8 cycles, avg 5.7s
  θ₅ Integrate:   8 cycles, avg 3.3s
  θ₆ Learn:       8 cycles, avg 4.5s

  Total Time: 3m 52s
  Total Blinks: 50
  Final Quality: 99.8%
  ```

- Event log shows: "[SYSTEM] [SUCCESS] Convergence reached! World_∞ achieved"

**Key Visual**: Victory state, summary statistics, all green indicators

---

### 03:30 - 04:00: Restart & Call to Action

**Narration**:
> "The system automatically resets and starts a new convergence journey.
> This is Miyabi - where autonomous agents orchestrate complex workflows
> with stunning visual clarity. Star us on GitHub, try it yourself,
> and join the future of AI orchestration."

**Actions**:
- System resets: W∞ → W₀
- All agents return to idle state
- Convergence resets to 0%
- Event log: "[SYSTEM] [INFO] Restarting simulation from W₀"

- Show call-to-action text:
  ```
  ⭐ Star on GitHub: github.com/YourRepo/miyabi
  📖 Docs: miyabi.dev/docs
  🐦 Twitter: @MiyabiAI
  💬 Discord: discord.gg/miyabi
  ```

- Press `q` to quit (show confirmation prompt)
- Fade to black

**Key Visual**: Clean restart, call-to-action overlay

---

## Keyboard Shortcuts Cheat Sheet

Show this overlay at 02:00-02:10:

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  KEYBOARD SHORTCUTS            ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  1-6     Focus agent θ₁-θ₆     ┃
┃  o       Focus Orchestrator    ┃
┃  l       Focus event log       ┃
┃  r       Restart simulation    ┃
┃  p       Pause/resume          ┃
┃  q       Quit                  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## Recording Tips

### asciinema
```bash
asciinema rec demo.cast --title "Miyabi Multi-Agent Orchestration" --idle-time-limit 2
# Follow demo script
# Press Ctrl-D when done
asciinema play demo.cast
asciinema upload demo.cast
```

### Screen Recording (macOS)
1. Open QuickTime Player → New Screen Recording
2. Select area: Full terminal window
3. Record at 60fps for smooth animations
4. Export as .mov file
5. Convert to .mp4 for web:
   ```bash
   ffmpeg -i demo.mov -vcodec h264 -acodec aac demo.mp4
   ```

### YouTube Upload
- **Title**: "Miyabi - Stunning Multi-Agent AI Orchestration Visualization"
- **Tags**: AI, agents, orchestration, tmux, visualization, autonomous, real-time
- **Thumbnail**: Screenshot of full layout at high convergence (80-100%)
- **Description**: Include GitHub link, installation instructions, and feature highlights

---

## Post-Demo Screenshots

Capture these key frames for documentation:

1. **Full Layout (Idle)**: All agents waiting, W₀
2. **Single Agent Active**: θ₁ running at 60%
3. **Full Pipeline**: All agents in various states
4. **High Convergence**: 84%, W₄₂
5. **Convergence Achieved**: 100%, W₅₀ ≈ W∞
6. **Error State**: θ₄ showing error and recovery
7. **Orchestrator Focus**: Zoomed on central control
8. **Event Log Focus**: Colorized log stream

Save as PNG files in `mockups/screenshots/`

---

## Common Demo Mistakes to Avoid

1. **Don't rush**: Let each phase complete (1-2 seconds visible)
2. **Terminal size**: Ensure 180x60 minimum or text wraps
3. **Color support**: Test terminal emulator supports 256 colors
4. **Font size**: Too small = hard to read on video
5. **Mouse cursor**: Hide it or keep still during recording
6. **Audio**: Script narration clearly, use good microphone
7. **Background**: Close other windows, clean desktop
8. **Timing**: Practice run-through 2-3 times before recording

---

## B-Roll Ideas

Intercut these clips for variety:

- Close-up of a single agent pane
- Rapid switching between agents (press 1-2-3-4-5-6)
- Orchestrator phase pipeline animation
- Event log scrolling at high speed
- World state progression bar filling
- Convergence percentage climbing

---

## Variations for Different Audiences

### For Developers (4-5 minutes)
- Spend more time on error recovery
- Show keyboard shortcuts in action
- Demonstrate pause/resume
- Inspect state files in another pane

### For Business/Investors (2-3 minutes)
- Focus on high-level orchestration
- Emphasize convergence and optimization
- Skip technical details
- Highlight scalability and performance

### For AI Researchers (5-7 minutes)
- Explain the mathematical model (θ₁-θ₆ transformations)
- Show world state theory
- Discuss convergence metrics
- Compare to other agent architectures

---

**End of Demo Script**

> "Go build something amazing with Miyabi!"
