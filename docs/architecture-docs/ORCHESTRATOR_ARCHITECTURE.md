# Orchestrator-Subagent Architecture

**Version**: 1.0.0
**Last Updated**: 2025-11-07

This document describes the orchestrator-subagent architecture implementation based on the director-worker pattern.

---

## 🏗️ Architecture Overview

```
┌─────────────────┐
│  User Request   │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│      Orchestrator Agent             │
│  - Analyzes Request                 │
│  - Decomposes Task                  │
│  - Delegates to Subagents           │
└────────┬────────────────────────────┘
         │
         │
    ┌────┴──────────────────────────────┐
    │   Isolated Execution              │
    └────┬──────────────────────────────┘
         │
    ┌────┴────────────────────────┐
    │                             │
    ▼                             ▼
┌──────────────┐            ┌──────────────┐
│  Subagent 1  │            │  Subagent 2  │ ...
│ - Own Context│            │ - Own Context│
│ - Own Tools  │            │ - Own Tools  │
│ - Solves A   │            │ - Solves B   │
└──────┬───────┘            └──────┬───────┘
       │                           │
       └───────────┬───────────────┘
                   │
                   ▼
         ┌─────────────────────┐
         │  Orchestrator Agent │
         │ - Synthesizes all   │
         │   results           │
         └──────────┬──────────┘
                    │
                    ▼
            ┌──────────────┐
            │ Final Answer │
            └──────────────┘
```

---

## 📦 Core Components

### 1. Orchestrator Agent (`orchestrator.rs`)

The central coordinator that manages the entire workflow.

**Responsibilities:**

1. **Analyze Request** (`θ₁ Understand`)
   - Parse user intent
   - Assess complexity
   - Identify required capabilities

2. **Decompose Tasks** (`θ₂ Generate`)
   - Break down into subtasks
   - Determine dependencies
   - Prioritize execution order

3. **Delegate to Subagents** (`θ₃ Allocate`)
   - Select appropriate subagents
   - Assign tasks based on capabilities
   - Manage task queue

4. **Execute via Isolated Executor** (`θ₄ Execute`)
   - Launch subagents in parallel
   - Monitor execution progress
   - Handle failures gracefully

5. **Synthesize Results** (`θ₅ Integrate`)
   - Combine subagent outputs
   - Resolve conflicts
   - Generate coherent final answer

**Key Methods:**

```rust
impl Orchestrator {
    pub async fn process(&self, request: UserRequest) -> Result<FinalAnswer>
    async fn analyze_request(&self, request: &UserRequest) -> Result<RequestAnalysis>
    async fn decompose_tasks(&self, ...) -> Result<Vec<Task>>
    async fn assign_tasks(&self, tasks: &[Task]) -> Result<Vec<TaskAssignment>>
    async fn execute_tasks(&self, ...) -> Result<Vec<SubagentResult>>
    async fn synthesize_results(&self, ...) -> Result<String>
}
```

---

### 2. Subagent (`subagent.rs`)

Specialized workers that execute specific types of tasks in isolation.

**Trait Definition:**

```rust
#[async_trait]
pub trait Subagent: Send + Sync {
    fn name(&self) -> &str;
    fn capabilities(&self) -> Vec<String>;
    async fn execute(&self, task: &Task, context: &SubagentContext) -> Result<SubagentResult>;
}
```

**Key Properties:**

- **Own Context**: Each subagent has isolated execution context
- **Own Tools**: Access to specific tools (Read, Write, Bash, etc.)
- **Specialized**: Solves specific task types (analysis, generation, testing)

**Built-in Subagents:**

1. **GeneralPurposeSubagent**
   - Capabilities: general, analysis, generation
   - Use case: Generic multi-step tasks

2. **CodeAnalysisSubagent**
   - Capabilities: code-review, static-analysis, testing
   - Use case: Code quality, security analysis

3. **DataProcessingSubagent**
   - Capabilities: data-analysis, transformation, validation
   - Use case: Data pipelines, ETL tasks

---

### 3. Isolated Executor (`executor.rs`)

Manages isolated execution environments for subagents.

**Key Features:**

- **Parallel Execution**: Multiple subagents run concurrently
- **Resource Isolation**: Each subagent has separate context/workspace
- **Result Collection**: Gathers results independently

**Usage:**

```rust
pub struct IsolatedExecutor {
    max_concurrent: usize,
}

impl IsolatedExecutor {
    pub async fn execute(
        &self,
        subagent: Arc<dyn Subagent>,
        task: Task,
        subagent_name: String,
    ) -> Result<SubagentResult>
}
```

---

### 4. Types (`types.rs`)

Core data structures for the orchestrator system.

**Key Types:**

```rust
pub struct UserRequest {
    pub id: Uuid,
    pub content: String,
    pub context: HashMap<String, String>,
}

pub struct Task {
    pub id: Uuid,
    pub description: String,
    pub priority: u8,
    pub dependencies: Vec<Uuid>,
    pub assigned_subagent: Option<String>,
}

pub struct SubagentResult {
    pub task_id: Uuid,
    pub subagent_name: String,
    pub success: bool,
    pub output: String,
    pub artifacts: HashMap<String, String>,
    pub execution_time_ms: u64,
}

pub struct FinalAnswer {
    pub request_id: Uuid,
    pub answer: String,
    pub subagent_results: Vec<SubagentResult>,
    pub total_time_ms: u64,
}
```

---

## 🔄 Execution Flow

### Step-by-Step Process

```
1. User Request
   └─> UserRequest { content, context }

2. Orchestrator: Analyze
   └─> Complexity analysis
   └─> Capability identification
   └─> RequestAnalysis { complexity, capabilities, estimated_subtasks }

3. Orchestrator: Decompose
   └─> Break into Tasks
   └─> Vec<Task> { id, description, priority, dependencies }

4. Orchestrator: Delegate
   └─> Select subagents based on capabilities
   └─> TaskAssignment { task, subagent_name }

5. Isolated Executor: Execute (Parallel)
   ├─> Subagent 1 executes Task A in isolated context
   ├─> Subagent 2 executes Task B in isolated context
   └─> Subagent n executes Task C in isolated context

   Each produces: SubagentResult { task_id, output, artifacts, time }

6. Orchestrator: Synthesize
   └─> Combine all SubagentResults
   └─> Resolve conflicts
   └─> Generate coherent answer
   └─> FinalAnswer { request_id, answer, results, total_time }
```

---

## 🚀 Usage Examples

### Example 1: Basic Usage

```rust
use orchestrator_core::{Orchestrator, UserRequest};
use std::sync::Arc;
use uuid::Uuid;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Create orchestrator
    let mut orchestrator = Orchestrator::new();

    // Register subagents
    orchestrator.register_subagent(
        "general-purpose".to_string(),
        Arc::new(GeneralPurposeSubagent::new()),
    );

    // Create request
    let request = UserRequest {
        id: Uuid::new_v4(),
        content: "Analyze and improve the codebase".to_string(),
        context: HashMap::new(),
    };

    // Process
    let result = orchestrator.process(request).await?;
    println!("{}", result.answer);

    Ok(())
}
```

### Example 2: Custom Subagent

```rust
use orchestrator_core::subagent::{Subagent, SubagentContext};
use async_trait::async_trait;

pub struct CustomSubagent {
    name: String,
}

#[async_trait]
impl Subagent for CustomSubagent {
    fn name(&self) -> &str {
        &self.name
    }

    fn capabilities(&self) -> Vec<String> {
        vec!["custom-analysis".to_string()]
    }

    async fn execute(&self, task: &Task, context: &SubagentContext) -> Result<SubagentResult> {
        // Custom logic here
        Ok(SubagentResult {
            task_id: task.id,
            subagent_name: self.name.clone(),
            success: true,
            output: "Custom output".to_string(),
            artifacts: HashMap::new(),
            execution_time_ms: 100,
        })
    }
}

// Register with orchestrator
orchestrator.register_subagent(
    "custom".to_string(),
    Arc::new(CustomSubagent::new()),
);
```

---

## 🎯 Integration with Claude Code Agent Equation

This architecture directly implements the agent equation phases:

```
Agent(Intent, World₀) = lim_{n→∞} (θ₆ ◦ θ₅ ◦ θ₄ ◦ θ₃ ◦ θ₂ ◦ θ₁)ⁿ(Intent, World₀)
```

**Mapping:**

- **θ₁ Understand**: `analyze_request()` - Parse intent and complexity
- **θ₂ Generate**: `decompose_tasks()` - Generate execution plan
- **θ₃ Allocate**: `assign_tasks()` - Allocate resources to subagents
- **θ₄ Execute**: `execute_tasks()` - Execute via isolated executor
- **θ₅ Integrate**: `synthesize_results()` - Combine subagent outputs
- **θ₆ Learn**: (Future) Feedback loop for continuous improvement

---

## 🔒 Security & Isolation

### Subagent Isolation

Each subagent execution is isolated:

1. **Context Isolation**: Separate `SubagentContext` per execution
2. **Tool Isolation**: Limited tool access per subagent
3. **Workspace Isolation**: Separate working directories

### Resource Management

- **Concurrent Limit**: `max_concurrent` in `IsolatedExecutor`
- **Timeout Handling**: (Future) Per-task timeouts
- **Error Isolation**: Failures don't affect other subagents

---

## 📊 Performance Characteristics

### Parallel Execution

Multiple subagents execute simultaneously:

```
Sequential Time:  Task₁ + Task₂ + Task₃ = 300ms
Parallel Time:    max(Task₁, Task₂, Task₃) ≈ 100ms
Speedup:          3x (with 3 independent tasks)
```

### Scalability

- **Horizontal**: Add more subagents for specialized capabilities
- **Vertical**: Increase `max_concurrent` for more parallelism

---

## 🧪 Testing

### Integration Tests

Located in `crates/orchestrator-core/tests/integration_test.rs`:

```bash
cargo test --package orchestrator-core
```

**Test Coverage:**

1. `test_orchestrator_basic_flow`: Basic end-to-end flow
2. `test_multiple_subagents_parallel_execution`: Parallel execution verification
3. `test_isolated_execution`: Context isolation verification

---

## 🔮 Future Enhancements

### Phase 1: Advanced Features

- [ ] Dynamic subagent loading
- [ ] Priority-based task scheduling
- [ ] Task dependency resolution
- [ ] Failure recovery & retry logic

### Phase 2: Learning & Optimization

- [ ] θ₆ Learn implementation
- [ ] Subagent performance profiling
- [ ] Intelligent task assignment
- [ ] Result quality scoring

### Phase 3: Distributed Execution

- [ ] Remote subagent execution
- [ ] Distributed task queue
- [ ] Cross-machine orchestration

---

## 📚 References

- **CLAUDE.md**: Agent equation definition
- **README.md**: Project overview
- **Miyabi Project**: Advanced agent orchestration patterns

---

## 🤝 Contributing

To add a new subagent:

1. Implement the `Subagent` trait
2. Define capabilities
3. Register with orchestrator
4. Add integration tests

Example:

```rust
// 1. Implement trait
pub struct MySubagent { /* ... */ }

#[async_trait]
impl Subagent for MySubagent {
    fn name(&self) -> &str { "my-subagent" }
    fn capabilities(&self) -> Vec<String> { vec!["my-capability".to_string()] }
    async fn execute(&self, task: &Task, context: &SubagentContext) -> Result<SubagentResult> {
        // Implementation
    }
}

// 2. Register
orchestrator.register_subagent("my-subagent".to_string(), Arc::new(MySubagent::new()));
```

---

**Built with ❤️ using Rust and the Orchestrator-Subagent Pattern**
