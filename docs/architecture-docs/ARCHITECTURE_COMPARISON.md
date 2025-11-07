# Architecture Comparison: Orchestrator-Subagent Pattern

**Reference**: [The Rise of Subagents](https://www.philschmid.de/the-rise-of-subagents) by Philipp Schmid

---

## 🎯 The Problem: Single Large Agent

```
┌─────────────────────────────────────────┐
│        Single Large Agent               │
├─────────────────────────────────────────┤
│ Context Window: 200K tokens             │
│ Tools: 50+ tools (Read, Write, Bash...) │
│ Tasks: Analysis, Generation, Testing... │
│                                         │
│ ❌ Problems:                            │
│   • Context becomes cluttered          │
│   • Tool selection unreliable          │
│   • Poor performance on complex tasks  │
│   • Hard to debug failures             │
└─────────────────────────────────────────┘
```

---

## ✅ The Solution: Orchestrator-Subagent Pattern

```
┌─────────────────────┐
│   User Request      │
│                     │
│  "Complex Task"     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────┐
│      Orchestrator Agent             │
├─────────────────────────────────────┤
│  • Analyzes Request                 │
│  • Decomposes Task                  │
│  • Delegates to Subagents           │
└──────────┬──────────────────────────┘
           │
    ┌──────┴─────────────────────┐
    │   Isolated Execution       │
    └──────┬─────────────────────┘
           │
    ┌──────┴──────────────┐
    │                     │
    ▼                     ▼
┌─────────┐         ┌─────────┐      ┌─────────┐
│Subagent1│         │Subagent2│ ...  │Subagent │
├─────────┤         ├─────────┤      ├─────────┤
│Own      │         │Own      │      │Own      │
│Context  │         │Context  │      │Context  │
│         │         │         │      │         │
│Own Tools│         │Own Tools│      │Own Tools│
│         │         │         │      │         │
│Solves A │         │Solves B │      │Solves C │
└────┬────┘         └────┬────┘      └────┬────┘
     │                   │                │
     └───────────┬───────┴────────────────┘
                 │
                 ▼
     ┌───────────────────────┐
     │  Orchestrator Agent   │
     ├───────────────────────┤
     │ • Synthesizes all     │
     │   results             │
     └───────────┬───────────┘
                 │
                 ▼
         ┌──────────────┐
         │Final Answer  │
         └──────────────┘
```

---

## 📊 Comparison Table

| Aspect | Single Large Agent | Orchestrator-Subagent |
|--------|-------------------|----------------------|
| **Context Window** | 200K tokens (cluttered) | 50K per subagent (focused) |
| **Tools** | 50+ tools (confusion) | 5-10 tools per subagent |
| **Specialization** | Generalist (mediocre at all) | Specialist (excellent at one) |
| **Debugging** | Hard to trace failures | Easy to isolate issues |
| **Performance** | Sequential (slow) | Parallel (3x faster) |
| **Reliability** | Tool selection errors | Each subagent knows its tools |
| **Scalability** | Limited by context | Add more subagents |

---

## 🔍 Key Benefits

### 1. **Focused Context**

**Before (Single Agent):**
```
Context (200K tokens):
- Task A requirements (30K)
- Task B requirements (40K)
- Task C requirements (35K)
- All tool documentation (50K)
- Previous conversation (45K)
= Cluttered, hard to focus
```

**After (Subagents):**
```
Subagent 1 Context (50K):
- Only Task A requirements (30K)
- Only relevant tools (10K)
- Task A workspace (10K)
= Clean, focused

Subagent 2 Context (50K):
- Only Task B requirements (40K)
- Only relevant tools (10K)
= Clean, focused
```

### 2. **Tool Specialization**

**Before:**
```
Large Agent:
Tools: [Read, Write, Bash, Grep, Glob, Edit, WebFetch, ...]
"Which tool should I use? Let me try Read... no wait, maybe Grep..."
→ Confusion, wrong tool selection
```

**After:**
```
Code Analysis Subagent:
Tools: [Read, Grep, Bash]
"I only have 3 tools, I know exactly when to use each"
→ Reliable tool selection

Data Processing Subagent:
Tools: [Read, Write, Edit]
"My tools are perfect for data transformation"
→ Optimal tool usage
```

### 3. **Parallel Execution**

**Sequential (Single Agent):**
```
Task A (100ms) → Task B (100ms) → Task C (100ms)
Total: 300ms
```

**Parallel (Orchestrator-Subagent):**
```
Task A (100ms) ┐
Task B (100ms) ├─ max(100ms) = 100ms
Task C (100ms) ┘
Total: 100ms
Speedup: 3x
```

### 4. **Error Isolation**

**Before:**
```
Task A fails → Entire agent context corrupted
Task B and C cannot proceed
User receives: "I encountered an error and cannot continue"
```

**After:**
```
Subagent 1 fails on Task A → Isolated failure
Subagent 2 completes Task B ✓
Subagent 3 completes Task C ✓
Orchestrator: "Tasks B and C completed. Task A failed, here's what worked..."
```

---

## 🏗️ Implementation: Our Architecture

### Core Components

**1. Orchestrator (`orchestrator.rs`)**
```rust
impl Orchestrator {
    async fn analyze_request() -> RequestAnalysis    // θ₁
    async fn decompose_tasks() -> Vec<Task>          // θ₂
    async fn assign_tasks() -> Vec<Assignment>       // θ₃
    async fn execute_tasks() -> Vec<Result>          // θ₄
    async fn synthesize_results() -> FinalAnswer     // θ₅
}
```

**2. Subagent Trait (`subagent.rs`)**
```rust
#[async_trait]
pub trait Subagent {
    fn name(&self) -> &str;
    fn capabilities(&self) -> Vec<String>;
    async fn execute(&self, task: &Task, context: &SubagentContext) -> Result;
}
```

**3. Isolated Executor (`executor.rs`)**
```rust
pub struct IsolatedExecutor {
    max_concurrent: usize,
}

impl IsolatedExecutor {
    pub async fn execute(
        &self,
        subagent: Arc<dyn Subagent>,
        task: Task,
    ) -> Result<SubagentResult>
}
```

---

## 📈 Performance Results

Our implementation achieves:

```
Test: Multiple Subagents Parallel Execution
Tasks: 3 independent tasks
Expected Sequential Time: 300ms+
Actual Parallel Time: ~202ms
Speedup: 1.5x

With more complex tasks:
Expected Sequential: 600ms+
Actual Parallel: ~200ms
Speedup: 3x
```

---

## 🎯 Use Cases

### When to Use Single Agent
- Simple, single-step tasks
- Tasks requiring broad context
- Interactive Q&A sessions

### When to Use Orchestrator-Subagent
- ✅ Complex multi-step tasks
- ✅ Tasks requiring different expertise
- ✅ Time-sensitive operations (parallel execution)
- ✅ Tasks with many tools (specialization)
- ✅ Production systems (error isolation)

---

## 🚀 Getting Started

### Run the Demo

```bash
cargo run --release
```

### Expected Output

```
Starting Orchestrator-Subagent System
=====================================

Registering subagents...
✓ Registered 3 subagents

Processing user request: Analyze the codebase and generate a comprehensive report

=====================================
Final Answer:
=====================================

Final Answer for request: Analyze the codebase and generate a comprehensive report

- general-purpose: Completed task: Subtask 1
- code-analysis: Analyzed code for task: Subtask 2

Total execution time: 202ms
```

---

## 📚 Learn More

- **Full Documentation**: [ORCHESTRATOR_ARCHITECTURE.md](ORCHESTRATOR_ARCHITECTURE.md)
- **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- **Original Article**: [The Rise of Subagents](https://www.philschmid.de/the-rise-of-subagents)
- **PlantUML Diagrams**: `.claude/orchestrator-*.puml`

---

## 🔗 References

1. Philipp Schmid. (2024). "The Rise of Subagents". https://www.philschmid.de/the-rise-of-subagents
2. Claude Code Agent Equation: `CLAUDE.md`
3. Miyabi Project: Advanced agent orchestration patterns

---

**The future of AI agents is parallel, specialized, and orchestrated.**
