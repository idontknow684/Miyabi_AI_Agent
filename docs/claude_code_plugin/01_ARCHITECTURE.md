# Plugin Architecture Specification

**Module**: 01 - Architecture & Structure
**Version**: 1.0.0
**Last Updated**: 2025-11-07

---

## Table of Contents

1. [Overview](#overview)
2. [Directory Structure](#directory-structure)
3. [Core Modules](#core-modules)
4. [Data Flow Architecture](#data-flow-architecture)
5. [Extension Architecture](#extension-architecture)
6. [Dependencies](#dependencies)
7. [Build System](#build-system)

---

## Overview

The Flickering Scenery plugin follows a **modular, event-driven architecture** designed for:
- **Separation of concerns**: Clear boundaries between visualization, logic, and state
- **Extensibility**: Easy addition of new features
- **Performance**: Optimized for real-time updates
- **Testability**: Each module independently testable

### Architectural Principles

1. **Unidirectional Data Flow**: State → View (React-style)
2. **Event-Driven Updates**: Plugin ↔ Claude Code via events
3. **Immutable State**: All transformations create new states
4. **Functional Core, Imperative Shell**: Pure logic + side effects at edges

---

## Directory Structure

```
flickering-scenery/
│
├── package.json                    # Node.js dependencies
├── tsconfig.json                   # TypeScript configuration
├── esbuild.config.js               # Build configuration
├── .eslintrc.json                  # Linting rules
├── .prettierrc                     # Code formatting
│
├── README.md                       # GitHub-optimized README
├── CONTRIBUTING.md                 # Contribution guidelines
├── LICENSE                         # MIT license
├── CHANGELOG.md                    # Version history
│
├── src/
│   ├── extension.ts                # VS Code extension entry point
│   │
│   ├── core/                       # Core logic (framework implementation)
│   │   ├── intent/
│   │   │   ├── IntentResolver.ts   # ℐ (Intent Resolution)
│   │   │   ├── StepBackEngine.ts   # Step-back question generator
│   │   │   └── IntentTypes.ts      # Type definitions
│   │   │
│   │   ├── command-stack/
│   │   │   ├── CommandStack.ts     # 𝒞 (Command Stack)
│   │   │   ├── Structurizer.ts     # C₁: Goal → Hierarchy
│   │   │   ├── Promptifier.ts      # C₂: Hierarchy → Prompts
│   │   │   ├── ChainExecutor.ts    # C₃: Prompts → Execution
│   │   │   └── CommandTypes.ts     # Type definitions
│   │   │
│   │   ├── world/
│   │   │   ├── WorldState.ts       # World state representation
│   │   │   ├── WorldTransformer.ts # Θ (World Transformation)
│   │   │   ├── BlinkManager.ts     # Blink lifecycle management
│   │   │   ├── SixPhases.ts        # θ₁-θ₆ implementation
│   │   │   └── WorldTypes.ts       # Type definitions
│   │   │
│   │   ├── convergence/
│   │   │   ├── ConvergenceTracker.ts # Track progress to goal
│   │   │   ├── DistanceMetric.ts     # d(W_n, W_goal) computation
│   │   │   ├── ProgressAnalyzer.ts   # Monotonicity verification
│   │   │   └── ConvergenceTypes.ts   # Type definitions
│   │   │
│   │   └── agent/
│   │       ├── OrchestratorAgent.ts  # Main agent (𝔸 formula)
│   │       ├── SubagentPool.ts       # Subagent management
│   │       └── AgentTypes.ts         # Type definitions
│   │
│   ├── ui/                           # User interface components
│   │   ├── webview/
│   │   │   ├── App.tsx               # Root React component
│   │   │   ├── index.html            # WebView HTML template
│   │   │   ├── index.tsx             # React entry point
│   │   │   │
│   │   │   ├── components/
│   │   │   │   ├── BlinkTimeline.tsx       # Timeline visualization
│   │   │   │   ├── WorldStateViewer.tsx    # Current world state
│   │   │   │   ├── ConvergenceDashboard.tsx # Progress tracking
│   │   │   │   ├── IntentClarifier.tsx     # Intent disambiguation UI
│   │   │   │   ├── ExecutionGraph.tsx      # Command execution graph
│   │   │   │   ├── LearningPanel.tsx       # θ₆ learning metrics
│   │   │   │   ├── PhaseIndicator.tsx      # Current phase (θ₁-θ₆)
│   │   │   │   └── MetricsPanel.tsx        # Performance metrics
│   │   │   │
│   │   │   ├── visualizations/
│   │   │   │   ├── BlinkAnimation.tsx      # Animated blink transitions
│   │   │   │   ├── ConvergenceChart.tsx    # d(W_n, W_goal) over time
│   │   │   │   ├── PhaseFlowDiagram.tsx    # θ₁→θ₂→...→θ₆ flow
│   │   │   │   └── WorldDiffVisualizer.tsx # W_n → W_{n+1} diff
│   │   │   │
│   │   │   ├── hooks/
│   │   │   │   ├── useBlinkState.ts        # Blink state management
│   │   │   │   ├── useConvergence.ts       # Convergence tracking
│   │   │   │   └── useWebSocket.ts         # Real-time updates
│   │   │   │
│   │   │   └── styles/
│   │   │       ├── tailwind.css            # Tailwind base
│   │   │       └── custom.css              # Custom styles
│   │   │
│   │   └── panels/
│   │       ├── FlickeringSceneryPanel.ts   # Main VS Code panel
│   │       └── DebugPanel.ts               # Advanced debugging
│   │
│   ├── api/                          # API layer
│   │   ├── ClaudeCodeAdapter.ts      # Claude Code integration
│   │   ├── EventBridge.ts            # Event handling
│   │   ├── StateSync.ts              # State synchronization
│   │   └── ApiTypes.ts               # API type definitions
│   │
│   ├── storage/                      # Persistence layer
│   │   ├── StateStore.ts             # SQLite state storage
│   │   ├── HistoryManager.ts         # Blink history management
│   │   ├── CacheManager.ts           # Performance caching
│   │   └── StorageTypes.ts           # Storage type definitions
│   │
│   ├── utils/                        # Utility functions
│   │   ├── logger.ts                 # Structured logging
│   │   ├── telemetry.ts              # Usage analytics (opt-in)
│   │   ├── validators.ts             # Input validation
│   │   ├── serializers.ts            # State serialization
│   │   └── mathUtils.ts              # Mathematical computations
│   │
│   └── types/                        # Global type definitions
│       ├── global.d.ts               # Global types
│       ├── vscode.d.ts               # VS Code API types
│       └── plugin.d.ts               # Plugin-specific types
│
├── media/                            # Static assets
│   ├── icons/
│   │   ├── logo.svg                  # Plugin logo
│   │   ├── blink.svg                 # Blink icon
│   │   └── phases/                   # θ₁-θ₆ icons
│   ├── animations/
│   │   └── blink-transition.json     # Lottie animation
│   └── images/
│       ├── banner.png                # GitHub banner
│       └── screenshots/              # Feature screenshots
│
├── scripts/                          # Build & dev scripts
│   ├── build.js                      # Production build
│   ├── watch.js                      # Development watch
│   ├── test.js                       # Test runner
│   └── package-vsix.js               # VSIX packaging
│
├── tests/                            # Test suites
│   ├── unit/
│   │   ├── core/                     # Core logic tests
│   │   ├── ui/                       # UI component tests
│   │   └── utils/                    # Utility tests
│   │
│   ├── integration/
│   │   ├── claude-code.test.ts       # Claude Code integration
│   │   └── end-to-end.test.ts        # Full workflow tests
│   │
│   └── fixtures/
│       ├── sample-worlds.ts          # Sample world states
│       └── sample-intents.ts         # Sample intents
│
├── docs/                             # Documentation
│   ├── api/                          # API documentation
│   ├── guides/                       # User guides
│   └── architecture/                 # Architecture docs
│
└── examples/                         # Example usage
    ├── basic-usage.ts                # Simple examples
    ├── advanced-patterns.ts          # Advanced usage
    └── custom-metrics.ts             # Custom distance metrics
```

---

## Core Modules

### 1. Intent Resolution Module (`src/core/intent/`)

**Purpose**: Implements ℐ (Intent Resolution) - transforms user input into fixed goals

**Key Components**:

```typescript
// IntentResolver.ts
export class IntentResolver {
  resolve(input: UserInput): Promise<Goal>;
  capture(input: UserInput): IntentAnalysis;
  disambiguate(analysis: IntentAnalysis): GoalCandidate;
  stepBack(candidate: GoalCandidate): Promise<Goal>;
}

// StepBackEngine.ts
export class StepBackEngine {
  generateQuestions(candidate: GoalCandidate): StepBackQuestion[];
  refineGoal(candidate: GoalCandidate, answers: Answer[]): GoalCandidate;
  validate(goal: Goal): boolean;
}
```

**Responsibilities**:
- Parse user input
- Extract explicit/implicit/want/need intents
- Generate step-back questions
- Refine goals through iteration
- Validate goal feasibility

### 2. Command Stack Module (`src/core/command-stack/`)

**Purpose**: Implements 𝒞 (Command Stack) - decomposes goals into executable tasks

**Key Components**:

```typescript
// CommandStack.ts
export class CommandStack {
  decompose(goal: Goal): ExecutionPlan;

  private c1_structure(goal: Goal): Hierarchy;
  private c2_promptify(hierarchy: Hierarchy): CommandPair[];
  private c3_chain(pairs: CommandPair[]): ExecutionPlan;
}

// Structurizer.ts (C₁)
export class Structurizer {
  analyze(goal: Goal): TaskHierarchy;
  decompose(hierarchy: TaskHierarchy, level: Level): Task[];
}

// Promptifier.ts (C₂)
export class Promptifier {
  generatePrompt(task: Task, goal: Goal): Prompt;
  createCommandPairs(tasks: Task[]): CommandPair[];
}

// ChainExecutor.ts (C₃)
export class ChainExecutor {
  analyzeDependencies(pairs: CommandPair[]): DependencyGraph;
  topologicalSort(graph: DependencyGraph): ExecutionPlan;
}
```

**Responsibilities**:
- Hierarchical task decomposition (upper/middle/lower)
- Prompt generation for each task
- Dependency analysis
- Execution order optimization

### 3. World Transformation Module (`src/core/world/`)

**Purpose**: Implements Θ (World Transformation) - applies 6-phase transformation cycle

**Key Components**:

```typescript
// WorldTransformer.ts
export class WorldTransformer {
  apply(tasks: Task[], world: WorldState): Promise<WorldState>;

  private theta1_understand(tasks: Task[], world: WorldState): Understanding;
  private theta2_generate(understanding: Understanding): Plan;
  private theta3_allocate(plan: Plan): Allocation;
  private theta4_execute(allocation: Allocation, world: WorldState): Promise<ExecutionResult>;
  private theta5_integrate(result: ExecutionResult, world: WorldState): WorldState;
  private theta6_learn(world: WorldState): WorldState;
}

// BlinkManager.ts
export class BlinkManager {
  createBlink(from: WorldState, to: WorldState): Blink;
  recordBlink(blink: Blink): void;
  getHistory(): Blink[];
  analyzeBlink(blink: Blink): BlinkAnalysis;
}

// SixPhases.ts
export class SixPhases {
  executePhase<T>(phase: Phase, input: T): Promise<PhaseResult>;
  trackPhaseMetrics(phase: Phase, duration: number): void;
}
```

**Responsibilities**:
- Execute 6-phase transformation (θ₁-θ₆)
- Manage blink lifecycle
- Track world state transitions
- Record transformation history

### 4. Convergence Module (`src/core/convergence/`)

**Purpose**: Track progress toward goal, verify convergence guarantees

**Key Components**:

```typescript
// ConvergenceTracker.ts
export class ConvergenceTracker {
  track(world: WorldState, goal: Goal): ConvergenceMetrics;
  checkTermination(metrics: ConvergenceMetrics, epsilon: number): boolean;
  predictConvergence(history: ConvergenceMetrics[]): number;
}

// DistanceMetric.ts
export class DistanceMetric {
  compute(world: WorldState, goal: Goal): number;

  // Domain-specific metrics
  fileStructureDistance(world: WorldState, goal: Goal): number;
  codeQualityDistance(world: WorldState, goal: Goal): number;
  testCoverageDistance(world: WorldState, goal: Goal): number;
}

// ProgressAnalyzer.ts
export class ProgressAnalyzer {
  verifyMonotonicity(history: WorldState[]): boolean;
  detectRegression(current: WorldState, previous: WorldState, goal: Goal): boolean;
  computeProgressRate(history: WorldState[], goal: Goal): number;
}
```

**Responsibilities**:
- Compute d(W_n, W_goal)
- Verify monotonicity (Progress(W_{n+1}) ≥ Progress(W_n))
- Predict convergence time
- Detect regressions

### 5. Orchestrator Module (`src/core/agent/`)

**Purpose**: Main agent implementing 𝔸(Input, W₀) = lim_{n→∞} [∫₀ⁿ (Θ ◦ 𝒞 ◦ ℐ)(t) dt] = W_∞

**Key Components**:

```typescript
// OrchestratorAgent.ts
export class OrchestratorAgent {
  /**
   * Apply the Law of Flickering Scenery
   * 𝔸(Input, World₀) → World_∞
   */
  async applyLaw(input: UserInput, world: WorldState): Promise<WorldState> {
    // ℐ: Intent Resolution
    const goal = await this.intentResolver.resolve(input);

    // Convergence loop: lim_{n→∞}
    let iteration = 0;
    while (!this.goalAchieved(world, goal)) {
      // 𝒞: Command Stack
      const tasks = this.commandStack.decompose(goal);

      // Θ: World Transformation (one blink)
      world = await this.worldTransformer.apply(tasks, world);

      // Track convergence
      this.convergenceTracker.track(world, goal);

      iteration++;

      if (iteration >= this.config.maxIterations) {
        throw new ConvergenceError('Failed to converge');
      }
    }

    return world; // World_∞
  }
}

// SubagentPool.ts
export class SubagentPool {
  register(agent: Subagent): void;
  select(task: Task): Subagent;
  executeParallel(tasks: Task[], world: WorldState): Promise<WorldState[]>;
}
```

**Responsibilities**:
- Orchestrate entire agent lifecycle
- Manage convergence loop
- Coordinate subagent execution
- Handle errors and recovery

---

## Data Flow Architecture

### High-Level Flow

```
User Input (Claude Code)
    ↓
[IntentResolver] → Goal
    ↓
[CommandStack] → ExecutionPlan (Tasks)
    ↓
[OrchestratorAgent] (Convergence Loop)
    ├─ [WorldTransformer] (θ₁-θ₆)
    │   ├─ θ₁: Understand
    │   ├─ θ₂: Generate
    │   ├─ θ₃: Allocate
    │   ├─ θ₄: Execute (SubagentPool)
    │   ├─ θ₅: Integrate
    │   └─ θ₆: Learn
    ├─ [BlinkManager] → Record Blink (W_n → W_{n+1})
    ├─ [ConvergenceTracker] → Check termination
    └─ Loop or Terminate
    ↓
World_∞ (Goal Achieved)
    ↓
[UI Updates] → User sees results
```

### Event Flow (Plugin ↔ Claude Code)

```
Claude Code                    Plugin
    │                            │
    ├─ User Types Input          │
    ├─ Emit "input" event ───────▶ IntentResolver
    │                            ├─ Process intent
    │                            ├─ Emit "intentResolved" ────▶ UI Update
    │                            │
    ◀──── Request Clarification ─┤ StepBackEngine
    │                            │
    ├─ User Answers ─────────────▶ Refine Goal
    │                            ├─ Emit "goalFixed" ────────▶ UI Update
    │                            │
    │                            ├─ CommandStack.decompose()
    │                            ├─ Emit "planGenerated" ────▶ UI Update
    │                            │
    │                            ├─ Start Convergence Loop
    │                            │   ├─ θ₁-θ₆ execution
    │                            │   ├─ Emit "blinkComplete" ──▶ UI Animation
    │                            │   ├─ Emit "convergenceUpdate" ▶ Dashboard
    │                            │   └─ Loop...
    │                            │
    ├─ Task Execution ───────────▶ SubagentPool
    ◀──── Execute Command ───────┤
    ├─ Command Result ───────────▶ Integrate Results
    │                            │
    │                            ├─ Goal Achieved!
    │                            ├─ Emit "convergenceComplete" ▶ Final UI
    │                            │
    ◀──── Display Results ───────┤
```

### State Flow (Unidirectional)

```
Global State (Zustand Store)
    ├─ intentState: IntentState
    ├─ worldState: WorldState
    ├─ blinkHistory: Blink[]
    ├─ convergenceMetrics: ConvergenceMetrics
    ├─ executionPlan: ExecutionPlan
    └─ uiState: UIState

Updates: State → UI (one direction)
User Actions → Dispatch Actions → State Updates → UI Re-renders
```

---

## Extension Architecture

### VS Code Extension Structure

```typescript
// extension.ts
export function activate(context: vscode.ExtensionContext) {
  // 1. Initialize plugin
  const orchestrator = new OrchestratorAgent(config);
  const panel = new FlickeringSceneryPanel(context.extensionUri);

  // 2. Register commands
  context.subscriptions.push(
    vscode.commands.registerCommand('flickeringScenery.open', () => {
      panel.show();
    }),

    vscode.commands.registerCommand('flickeringScenery.showTimeline', () => {
      panel.showTimeline();
    }),

    vscode.commands.registerCommand('flickeringScenery.resetState', () => {
      orchestrator.reset();
    })
  );

  // 3. Listen to Claude Code events
  const claudeAdapter = new ClaudeCodeAdapter();
  claudeAdapter.onInput((input) => {
    orchestrator.applyLaw(input, currentWorld).then((finalWorld) => {
      panel.update(finalWorld);
    });
  });

  // 4. Setup WebView communication
  panel.webview.onDidReceiveMessage((message) => {
    handleWebViewMessage(message, orchestrator, panel);
  });
}
```

### WebView Integration

```typescript
// ui/webview/App.tsx
export function App() {
  const { blinks, convergence, currentWorld } = usePluginState();

  return (
    <div className="flickering-scenery-app">
      <PhaseIndicator currentPhase={convergence.currentPhase} />
      <BlinkTimeline blinks={blinks} />
      <ConvergenceDashboard metrics={convergence} />
      <WorldStateViewer world={currentWorld} />
      <ExecutionGraph plan={convergence.executionPlan} />
    </div>
  );
}
```

---

## Dependencies

### Production Dependencies

```json
{
  "dependencies": {
    "@vscode/webview-ui-toolkit": "^1.4.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "zustand": "^4.5.0",
    "d3": "^7.8.5",
    "socket.io-client": "^4.6.1",
    "better-sqlite3": "^9.4.0",
    "zod": "^3.22.4"
  }
}
```

### Development Dependencies

```json
{
  "devDependencies": {
    "@types/vscode": "^1.85.0",
    "@types/react": "^18.2.0",
    "@types/node": "^20.11.0",
    "typescript": "^5.3.0",
    "esbuild": "^0.20.0",
    "vitest": "^1.2.0",
    "eslint": "^8.56.0",
    "prettier": "^3.2.0",
    "tailwindcss": "^3.4.0",
    "autoprefixer": "^10.4.17",
    "typedoc": "^0.25.0"
  }
}
```

---

## Build System

### esbuild Configuration

```javascript
// esbuild.config.js
const esbuild = require('esbuild');

// Extension bundle
esbuild.build({
  entryPoints: ['src/extension.ts'],
  bundle: true,
  outfile: 'dist/extension.js',
  external: ['vscode'],
  format: 'cjs',
  platform: 'node',
  target: 'node20',
  sourcemap: true,
  minify: process.env.NODE_ENV === 'production',
});

// WebView bundle
esbuild.build({
  entryPoints: ['src/ui/webview/index.tsx'],
  bundle: true,
  outfile: 'dist/webview.js',
  format: 'iife',
  platform: 'browser',
  target: 'es2020',
  loader: { '.css': 'css' },
  sourcemap: true,
  minify: process.env.NODE_ENV === 'production',
});
```

### Development Scripts

```json
{
  "scripts": {
    "build": "node scripts/build.js",
    "watch": "node scripts/watch.js",
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "lint": "eslint src --ext ts,tsx",
    "format": "prettier --write 'src/**/*.{ts,tsx}'",
    "package": "vsce package",
    "publish": "vsce publish"
  }
}
```

---

## Performance Considerations

### Optimization Strategies

1. **Lazy Loading**: Load UI components on demand
2. **Virtual Scrolling**: For large blink histories (1000+ blinks)
3. **State Memoization**: Cache expensive computations (distance metrics)
4. **Worker Threads**: Offload heavy computation (D3 rendering) to workers
5. **Incremental Updates**: Only re-render changed UI components

### Memory Management

```typescript
// Limit blink history to prevent memory leaks
const MAX_BLINKS_IN_MEMORY = 1000;

class BlinkManager {
  private history: Blink[] = [];

  recordBlink(blink: Blink) {
    this.history.push(blink);

    if (this.history.length > MAX_BLINKS_IN_MEMORY) {
      // Archive old blinks to SQLite
      const toArchive = this.history.slice(0, 100);
      this.storage.archive(toArchive);
      this.history = this.history.slice(100);
    }
  }
}
```

---

## Security Considerations

1. **Input Validation**: Validate all user input (Zod schemas)
2. **CSP Headers**: Strict Content Security Policy for WebView
3. **No Eval**: Never use `eval()` or `Function()`
4. **Telemetry Opt-in**: User must explicitly enable analytics
5. **Local-First**: All data stored locally (no cloud by default)

---

## Testing Strategy

1. **Unit Tests**: All core modules (95%+ coverage)
2. **Integration Tests**: Claude Code adapter, WebView communication
3. **E2E Tests**: Full workflows (intent → convergence)
4. **Performance Tests**: Benchmark blink rendering, convergence speed
5. **Visual Regression**: Screenshot comparison (Percy/Chromatic)

---

## Next Steps

**Implementers**: Proceed to [02_CORE_COMPONENTS.md](./02_CORE_COMPONENTS.md) for detailed component specifications.

**Reviewers**: Check dependency versions, suggest architectural improvements.

---

**Architecture Status**: ✅ Complete - Ready for Implementation
