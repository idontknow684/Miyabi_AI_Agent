# Plugin Features Specification

**Module**: 03 - Plugin Features
**Version**: 1.0.0
**Last Updated**: 2025-11-07

---

## Overview

Flickering Scenery plugin provides 7 core features that make AI agent execution transparent, debuggable, and production-ready.

---

## Feature 1: Visual "Blinks" Timeline

**Purpose**: Visualize discrete world state transitions in real-time

### UI Component

```typescript
// BlinkTimeline.tsx
interface BlinkTimelineProps {
  blinks: Blink[];
  currentBlink?: number;
  onBlinkSelect: (blinkId: string) => void;
}

export function BlinkTimeline({ blinks, currentBlink, onBlinkSelect }: BlinkTimelineProps) {
  return (
    <div className="blink-timeline">
      {blinks.map((blink, index) => (
        <BlinkCard
          key={blink.id}
          blink={blink}
          index={index}
          isActive={index === currentBlink}
          onClick={() => onBlinkSelect(blink.id)}
        />
      ))}
    </div>
  );
}
```

### Features
- **Animated transitions**: Smooth animations between W_n → W_{n+1}
- **Timeline scrubbing**: Click any blink to inspect that world state
- **Diff highlighting**: Visual diff showing what changed
- **Phase indicators**: Color-coded by current phase (θ₁-θ₆)

### Visualizations
- Timeline: Horizontal scrollable timeline
- Card view: Expandable cards with details
- Graph view: Tree/graph of state transitions

---

## Feature 2: Convergence Dashboard

**Purpose**: Real-time progress tracking toward goal achievement

### UI Component

```typescript
// ConvergenceDashboard.tsx
interface ConvergenceDashboardProps {
  metrics: ConvergenceMetrics;
  goal: Goal;
}

export function ConvergenceDashboard({ metrics, goal }: ConvergenceDashboardProps) {
  return (
    <div className="convergence-dashboard">
      <ProgressRing value={metrics.progress} />
      <MetricsList metrics={metrics} />
      <ConvergenceChart data={metrics.history} />
      <PredictionPanel prediction={metrics.predictedIterations} />
    </div>
  );
}
```

### Metrics Displayed
1. **Distance to Goal**: d(W_n, W_goal) over time
2. **Progress Rate**: Change per iteration
3. **Predicted Convergence**: Estimated iterations remaining
4. **Monotonicity Check**: ✓/✗ if progress is monotonic

### Charts
- Line chart: Distance over iterations
- Progress ring: Current completion %
- Velocity indicator: Speed of convergence

---

## Feature 3: Intent Clarification UI

**Purpose**: Interactive intent refinement with step-back questions

### UI Component

```typescript
// IntentClarifier.tsx
export function IntentClarifier() {
  const [questions, setQuestions] = useState<StepBackQuestion[]>([]);
  const [answers, setAnswers] = useState<Map<string, string>>(new Map());

  return (
    <Modal title="Clarify Your Intent">
      <QuestionList questions={questions} onAnswer={handleAnswer} />
      <AnswerSummary answers={answers} />
      <ActionButtons onSubmit={handleSubmit} />
    </Modal>
  );
}
```

### Features
- **5 Step-Back Questions**: Why, What, How, When, Who
- **Smart inference**: Auto-suggest answers based on context
- **Confidence indicators**: Show LLM confidence for inferred answers
- **Iterative refinement**: Multiple rounds if needed

---

## Feature 4: Execution Graph Visualization

**Purpose**: Visualize task dependencies and execution flow

### UI Component

```typescript
// ExecutionGraph.tsx
import * as d3 from 'd3';

export function ExecutionGraph({ plan }: { plan: ExecutionPlan }) {
  useEffect(() => {
    renderGraph(plan);
  }, [plan]);

  return <svg ref={svgRef} className="execution-graph" />;
}
```

### Features
- **Dependency graph**: DAG visualization
- **Parallel groups**: Highlight tasks running in parallel
- **Execution progress**: Real-time status (pending/running/complete)
- **Critical path**: Highlight longest execution path

### Interactions
- Click node: View task details
- Hover edge: Show dependency reason
- Zoom/pan: Navigate large graphs

---

## Feature 5: Learning Panel (θ₆)

**Purpose**: Display learned patterns and knowledge accumulation

### UI Component

```typescript
// LearningPanel.tsx
export function LearningPanel({ knowledge }: { knowledge: Map<string, Pattern> }) {
  return (
    <div className="learning-panel">
      <KnowledgeGrowth data={getGrowthData(knowledge)} />
      <PatternList patterns={Array.from(knowledge.values())} />
      <InsightsSummary insights={extractInsights(knowledge)} />
    </div>
  );
}
```

### Displays
- **Patterns learned**: Categorized by type
- **Knowledge growth**: Chart over time
- **Top insights**: Most impactful patterns
- **Pattern relationships**: How patterns connect

---

## Feature 6: Phase Indicator

**Purpose**: Show current execution phase (θ₁-θ₆)

### UI Component

```typescript
// PhaseIndicator.tsx
export function PhaseIndicator({ currentPhase }: { currentPhase: Phase }) {
  const phases = ['θ₁_understand', 'θ₂_generate', 'θ₃_allocate', 'θ₄_execute', 'θ₅_integrate', 'θ₆_learn'];

  return (
    <div className="phase-indicator">
      {phases.map((phase) => (
        <PhaseStep
          key={phase}
          phase={phase}
          isActive={phase === currentPhase}
          isComplete={isPhaseComplete(phase, currentPhase)}
        />
      ))}
    </div>
  );
}
```

### Features
- **Progress bar**: Visual flow θ₁ → θ₆
- **Time tracking**: Duration per phase
- **Bottleneck detection**: Highlight slow phases

---

## Feature 7: World State Diff Viewer

**Purpose**: Inspect changes between blinks

### UI Component

```typescript
// WorldDiffVisualizer.tsx
export function WorldDiffVisualizer({ blink }: { blink: Blink }) {
  const diff = computeDiff(blink.from, blink.to);

  return (
    <div className="world-diff">
      <FileSystemDiff files={diff.filesAdded} type="added" />
      <FileSystemDiff files={diff.filesModified} type="modified" />
      <FileSystemDiff files={diff.filesDeleted} type="deleted" />
      <KnowledgeDiff patterns={diff.knowledgeAdded} />
    </div>
  );
}
```

### Features
- **Unified diff**: Line-by-line changes
- **Syntax highlighting**: Code diffs with syntax colors
- **File tree**: Before/after file structure comparison

---

## Advanced Features (Post-MVP)

### 8. Custom Metrics Editor
Define custom distance metrics for domain-specific goals

### 9. Blink Replay
Replay execution from any previous blink

### 10. Multi-Goal Tracking
Track progress on multiple simultaneous goals

### 11. Export Reports
Generate PDF/HTML reports of execution history

### 12. Collaborative Debugging
Share blink timelines with team members

---

**Features Status**: ✅ Complete - 7 Core Features Specified
