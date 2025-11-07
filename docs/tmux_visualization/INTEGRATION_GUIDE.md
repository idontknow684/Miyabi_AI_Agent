# Miyabi Integration Guide

**Version**: 1.0.0
**Last Updated**: 2025-11-07

This guide explains how to integrate the tmux visualization system with your actual Miyabi Rust implementation.

---

## Overview

The visualization system reads agent state from JSON files in `/tmp/miyabi_viz/`. Your Miyabi agents should write their state to these files, and the tmux panes will automatically update.

---

## Integration Architecture

```
┏━━━━━━━━━━━━━━━━━━━┓         ┏━━━━━━━━━━━━━━━━━━━┓
┃  Miyabi Rust       ┃         ┃  tmux              ┃
┃  Orchestrator      ┃         ┃  Visualization     ┃
┃                    ┃         ┃                    ┃
┃  ┌─────────────┐  ┃  JSON   ┃  ┌─────────────┐  ┃
┃  │ θ₁ Agent    │──┼────────>┼──│ θ₁ Pane     │  ┃
┃  └─────────────┘  ┃  files  ┃  └─────────────┘  ┃
┃                    ┃         ┃                    ┃
┃  ┌─────────────┐  ┃         ┃  ┌─────────────┐  ┃
┃  │ θ₂ Agent    │──┼────────>┼──│ θ₂ Pane     │  ┃
┃  └─────────────┘  ┃         ┃  └─────────────┘  ┃
┃                    ┃         ┃                    ┃
┃       ...          ┃         ┃       ...          ┃
┗━━━━━━━━━━━━━━━━━━━┛         ┗━━━━━━━━━━━━━━━━━━━┛
         │                              ↑
         │                              │
         └──────────> Writes state ─────┘
                      Reads state
```

---

## State File Format

### Agent State (`/tmp/miyabi_viz/agents/theta{N}_state.json`)

```json
{
  "phase": "theta1",
  "status": "running",
  "progress": 65,
  "current_task": "Analyzing user intent and decomposing task",
  "cpu": 45.2,
  "memory": 128.5,
  "timestamp": "2025-11-07T14:23:45Z",
  "tasks_completed": 5,
  "tasks_failed": 0
}
```

**Fields**:
- `phase`: Agent identifier (`theta1` - `theta6`, `orchestrator`)
- `status`: One of `idle`, `running`, `completed`, `waiting`, `error`
- `progress`: Integer 0-100 (percentage complete)
- `current_task`: Human-readable description of current operation
- `cpu`: CPU usage percentage (float)
- `memory`: Memory usage in MB (float)
- `timestamp`: ISO 8601 timestamp
- `tasks_completed`: Total completed tasks counter
- `tasks_failed`: Total failed tasks counter

### World State (`/tmp/miyabi_viz/world_state.json`)

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

**Fields**:
- `current_world`: Current world state number (W₃)
- `target_world`: Target (always "∞")
- `convergence_percent`: Integer 0-100 (how close to W∞)
- `active_agents`: Number of currently running agents
- `total_agents`: Total number of agents (6)
- `blink_count`: Total world transformations (blinks)
- `timestamp`: ISO 8601 timestamp

---

## Rust Integration

### 1. Add Dependencies to `Cargo.toml`

```toml
[dependencies]
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
chrono = { version = "0.4", features = ["serde"] }
sysinfo = "0.30"  # For CPU/memory metrics
```

### 2. Create State Module (`src/visualization/state.rs`)

```rust
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum AgentStatus {
    Idle,
    Running,
    Completed,
    Waiting,
    Error,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AgentState {
    pub phase: String,
    pub status: AgentStatus,
    pub progress: u8,  // 0-100
    pub current_task: String,
    pub cpu: f64,
    pub memory: f64,
    pub timestamp: DateTime<Utc>,
    pub tasks_completed: u64,
    pub tasks_failed: u64,
}

impl AgentState {
    pub fn new(phase: &str) -> Self {
        Self {
            phase: phase.to_string(),
            status: AgentStatus::Idle,
            progress: 0,
            current_task: String::new(),
            cpu: 0.0,
            memory: 0.0,
            timestamp: Utc::now(),
            tasks_completed: 0,
            tasks_failed: 0,
        }
    }

    pub fn write_to_file(&self, state_dir: &Path) -> Result<(), Box<dyn std::error::Error>> {
        let file_path = state_dir.join("agents").join(format!("{}_state.json", self.phase));
        let json = serde_json::to_string_pretty(self)?;
        fs::write(file_path, json)?;
        Ok(())
    }

    pub fn update_status(&mut self, status: AgentStatus, progress: u8, task: &str) {
        self.status = status;
        self.progress = progress;
        self.current_task = task.to_string();
        self.timestamp = Utc::now();
    }

    pub fn update_metrics(&mut self, cpu: f64, memory: f64) {
        self.cpu = cpu;
        self.memory = memory;
        self.timestamp = Utc::now();
    }

    pub fn increment_completed(&mut self) {
        self.tasks_completed += 1;
    }

    pub fn increment_failed(&mut self) {
        self.tasks_failed += 1;
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WorldState {
    pub current_world: u64,
    pub target_world: String,  // Always "∞"
    pub convergence_percent: u8,  // 0-100
    pub active_agents: u8,
    pub total_agents: u8,
    pub blink_count: u64,
    pub timestamp: DateTime<Utc>,
}

impl WorldState {
    pub fn new() -> Self {
        Self {
            current_world: 0,
            target_world: "∞".to_string(),
            convergence_percent: 0,
            active_agents: 0,
            total_agents: 6,
            blink_count: 0,
            timestamp: Utc::now(),
        }
    }

    pub fn write_to_file(&self, state_dir: &Path) -> Result<(), Box<dyn std::error::Error>> {
        let file_path = state_dir.join("world_state.json");
        let json = serde_json::to_string_pretty(self)?;
        fs::write(file_path, json)?;
        Ok(())
    }

    pub fn blink(&mut self) {
        self.current_world += 1;
        self.blink_count += 1;
        self.convergence_percent = ((self.current_world as f64 / 50.0) * 100.0).min(100.0) as u8;
        self.timestamp = Utc::now();
    }

    pub fn update_active_agents(&mut self, count: u8) {
        self.active_agents = count;
        self.timestamp = Utc::now();
    }
}
```

### 3. Integrate into Agent Implementation

```rust
use crate::visualization::state::{AgentState, AgentStatus};
use std::path::PathBuf;
use sysinfo::{System, SystemExt, ProcessExt};

pub struct ThetaOneAgent {
    state: AgentState,
    state_dir: PathBuf,
    system: System,
}

impl ThetaOneAgent {
    pub fn new(state_dir: PathBuf) -> Self {
        let mut state = AgentState::new("theta1");
        state.write_to_file(&state_dir).ok();

        Self {
            state,
            state_dir,
            system: System::new_all(),
        }
    }

    pub async fn run(&mut self, task: &str) -> Result<(), Box<dyn std::error::Error>> {
        // Start phase
        self.state.update_status(
            AgentStatus::Running,
            0,
            "Analyzing user intent and decomposing task"
        );
        self.write_state()?;

        // Simulate work with progress updates
        for progress in (0..=100).step_by(20) {
            // Do actual work here...
            tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;

            // Update progress
            self.state.progress = progress;
            self.update_metrics();
            self.write_state()?;
        }

        // Complete
        self.state.update_status(AgentStatus::Completed, 100, "Task analysis complete");
        self.state.increment_completed();
        self.write_state()?;

        Ok(())
    }

    fn update_metrics(&mut self) {
        self.system.refresh_all();

        // Get current process metrics
        let pid = sysinfo::get_current_pid().ok();
        if let Some(pid) = pid {
            if let Some(process) = self.system.process(pid) {
                self.state.update_metrics(
                    process.cpu_usage() as f64,
                    process.memory() as f64 / 1024.0 / 1024.0,  // Convert to MB
                );
            }
        }
    }

    fn write_state(&self) -> Result<(), Box<dyn std::error::Error>> {
        self.state.write_to_file(&self.state_dir)
    }
}
```

### 4. Integrate into Orchestrator

```rust
use crate::visualization::state::{WorldState, AgentStatus};
use std::path::PathBuf;

pub struct Orchestrator {
    world_state: WorldState,
    state_dir: PathBuf,
    agents: Vec<Box<dyn Agent>>,
}

impl Orchestrator {
    pub fn new(state_dir: PathBuf) -> Self {
        let world_state = WorldState::new();
        world_state.write_to_file(&state_dir).ok();

        Self {
            world_state,
            state_dir,
            agents: Vec::new(),
        }
    }

    pub async fn run_cycle(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        // Run all agents in sequence
        for (i, agent) in self.agents.iter_mut().enumerate() {
            // Update world state
            self.world_state.update_active_agents(1);
            self.world_state.write_to_file(&self.state_dir)?;

            // Run agent
            agent.run().await?;

            // Blink (world state transition)
            self.world_state.blink();
            self.world_state.write_to_file(&self.state_dir)?;
        }

        // All agents done
        self.world_state.update_active_agents(0);
        self.world_state.write_to_file(&self.state_dir)?;

        Ok(())
    }
}
```

---

## Event Logging

### Log Format

Write logs to `/tmp/miyabi_viz/logs/events.log`:

```
[HH:MM:SS] [PHASE] [LEVEL] Message
```

**Levels**: `INFO`, `SUCCESS`, `WARNING`, `ERROR`, `DEBUG`

### Rust Implementation

```rust
use chrono::Local;
use std::fs::OpenOptions;
use std::io::Write;
use std::path::Path;

pub enum LogLevel {
    Info,
    Success,
    Warning,
    Error,
    Debug,
}

impl LogLevel {
    fn as_str(&self) -> &str {
        match self {
            Self::Info => "INFO",
            Self::Success => "SUCCESS",
            Self::Warning => "WARNING",
            Self::Error => "ERROR",
            Self::Debug => "DEBUG",
        }
    }
}

pub fn log_event(
    state_dir: &Path,
    phase: &str,
    level: LogLevel,
    message: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    let log_file = state_dir.join("logs").join("events.log");
    let timestamp = Local::now().format("%H:%M:%S");
    let log_line = format!(
        "[{}] [{}] [{}] {}\n",
        timestamp,
        phase,
        level.as_str(),
        message
    );

    let mut file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(log_file)?;

    file.write_all(log_line.as_bytes())?;
    Ok(())
}
```

**Usage**:
```rust
log_event(&state_dir, "θ₁", LogLevel::Info, "Phase started")?;
log_event(&state_dir, "θ₁", LogLevel::Success, "Task decomposition complete")?;
log_event(&state_dir, "ORCHESTRATOR", LogLevel::Error, "Resource allocation failed")?;
```

---

## Testing Integration

### 1. Test State Writing

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;

    #[test]
    fn test_agent_state_write() {
        let temp_dir = TempDir::new().unwrap();
        let state_dir = temp_dir.path().to_path_buf();

        // Create agents directory
        std::fs::create_dir_all(state_dir.join("agents")).unwrap();

        // Write state
        let mut state = AgentState::new("theta1");
        state.update_status(AgentStatus::Running, 50, "Testing");
        state.write_to_file(&state_dir).unwrap();

        // Verify file exists
        let file_path = state_dir.join("agents").join("theta1_state.json");
        assert!(file_path.exists());

        // Verify contents
        let contents = std::fs::read_to_string(file_path).unwrap();
        assert!(contents.contains("\"phase\": \"theta1\""));
        assert!(contents.contains("\"status\": \"running\""));
        assert!(contents.contains("\"progress\": 50"));
    }
}
```

### 2. Test with Visualization

```bash
# Terminal 1: Start visualization
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization
./scripts/run.sh

# Terminal 2: Run Miyabi orchestrator
cd /Users/shunsuke/Dev/AI_Agent
cargo run --release
```

The visualization should automatically pick up state changes from your Rust implementation.

---

## Performance Considerations

### Update Frequency

- **State files**: Update every 100-500ms (not more than 10 times/sec)
- **Log events**: Write immediately (buffered by filesystem)
- **Metrics**: Update every 1-2 seconds (CPU/memory polling is expensive)

### Buffering

Consider buffering state updates:

```rust
use std::time::{Duration, Instant};

pub struct BufferedStateWriter {
    state: AgentState,
    state_dir: PathBuf,
    last_write: Instant,
    min_interval: Duration,
}

impl BufferedStateWriter {
    pub fn new(state: AgentState, state_dir: PathBuf, min_interval: Duration) -> Self {
        Self {
            state,
            state_dir,
            last_write: Instant::now(),
            min_interval,
        }
    }

    pub fn update_and_write(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let now = Instant::now();
        if now.duration_since(self.last_write) >= self.min_interval {
            self.state.write_to_file(&self.state_dir)?;
            self.last_write = now;
        }
        Ok(())
    }

    pub fn force_write(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        self.state.write_to_file(&self.state_dir)?;
        self.last_write = Instant::now();
        Ok(())
    }
}
```

---

## Troubleshooting

### Issue: State files not updating

**Check**:
1. Verify state directory exists: `ls -la /tmp/miyabi_viz/agents/`
2. Check file permissions: `ls -l /tmp/miyabi_viz/agents/*_state.json`
3. Verify JSON is valid: `cat /tmp/miyabi_viz/agents/theta1_state.json | jq .`
4. Check Rust logs for write errors

### Issue: Visualization not showing updates

**Check**:
1. tmux session is running: `tmux ls`
2. Pane scripts are running: `tmux list-panes -t miyabi_orchestrator`
3. Script has correct permissions: `ls -l scripts/*.sh`
4. State file paths match: Check hardcoded `/tmp/miyabi_viz` in both systems

### Issue: High CPU usage

**Solutions**:
1. Increase update interval (reduce write frequency)
2. Use buffered state writer
3. Disable metrics collection in production
4. Use `--release` build (not debug)

---

## Production Deployment

### Option 1: Disable Visualization

```rust
// Add feature flag to Cargo.toml
[features]
visualization = []

// Conditionally compile visualization code
#[cfg(feature = "visualization")]
fn write_state(&self) {
    self.state.write_to_file(&self.state_dir).ok();
}

#[cfg(not(feature = "visualization"))]
fn write_state(&self) {
    // No-op
}
```

### Option 2: Environment Variable

```rust
use std::env;

fn should_write_state() -> bool {
    env::var("MIYABI_VISUALIZATION")
        .map(|v| v == "1" || v.to_lowercase() == "true")
        .unwrap_or(false)
}

fn write_state(&self) -> Result<(), Box<dyn std::error::Error>> {
    if should_write_state() {
        self.state.write_to_file(&self.state_dir)?;
    }
    Ok(())
}
```

**Usage**:
```bash
# Enable visualization
export MIYABI_VISUALIZATION=1
cargo run --release

# Disable visualization (default)
unset MIYABI_VISUALIZATION
cargo run --release
```

---

## Advanced Features

### Custom Metrics

Extend `AgentState` with custom metrics:

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AgentMetrics {
    pub cpu: f64,
    pub memory: f64,
    pub disk_io: f64,
    pub network_tx: f64,
    pub network_rx: f64,
    pub custom: HashMap<String, f64>,
}
```

### Real-time Notifications

Send desktop notifications on key events:

```rust
use notify_rust::Notification;

fn notify_convergence_achieved() {
    Notification::new()
        .summary("Miyabi")
        .body("Convergence achieved! W∞ reached")
        .show()
        .ok();
}
```

### Prometheus Metrics

Export metrics to Prometheus:

```rust
use prometheus::{Counter, Gauge, Histogram};

lazy_static! {
    static ref TASKS_COMPLETED: Counter = Counter::new("miyabi_tasks_completed", "Tasks").unwrap();
    static ref CONVERGENCE: Gauge = Gauge::new("miyabi_convergence", "Percent").unwrap();
    static ref TASK_DURATION: Histogram = Histogram::new("miyabi_task_duration", "Seconds").unwrap();
}

// Update metrics
TASKS_COMPLETED.inc();
CONVERGENCE.set(self.world_state.convergence_percent as f64);
TASK_DURATION.observe(duration.as_secs_f64());
```

---

## Next Steps

1. Implement state writing in your Miyabi agents
2. Test with the simulator to verify integration
3. Create production configuration (enable/disable visualization)
4. Add custom metrics specific to your use case
5. Record demo video for presentations

---

**Questions? Check the main README or open an issue on GitHub!**
