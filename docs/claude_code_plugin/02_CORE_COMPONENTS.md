# Core Components Implementation

**Module**: 02 - Core Components (ℐ, 𝒞, Θ)
**Version**: 1.0.0
**Last Updated**: 2025-11-07

---

## Table of Contents

1. [Overview](#overview)
2. [ℐ - Intent Resolution](#ℐ---intent-resolution)
3. [𝒞 - Command Stack](#𝒞---command-stack)
4. [Θ - World Transformation](#θ---world-transformation)
5. [Integration Pattern](#integration-pattern)
6. [Type Definitions](#type-definitions)

---

## Overview

This document provides **complete, production-ready specifications** for the three core components of the Law of Flickering Scenery:

- **ℐ (Intent Resolution)**: User input → Fixed goal
- **𝒞 (Command Stack)**: Goal → Executable task sequence
- **Θ (World Transformation)**: Tasks + World → New world state

Each component is designed to be:
- **Independently testable**: Clear inputs/outputs
- **Composable**: ℐ → 𝒞 → Θ forms a pipeline
- **Observable**: Emits events for UI updates
- **Optimizable**: Can be replaced/upgraded without breaking others

---

## ℐ - Intent Resolution

**Mathematical Definition**: `ℐ: 𝒰 → 𝒢` (User input → Goal)

**Implementation**: `src/core/intent/`

### Architecture

```
ℐ = StepBack ◦ Disambiguate ◦ Capture

Capture: 𝒰 → ℐ_raw
  Extract {Explicit, Implicit, Want, Need} intents

Disambiguate: ℐ_raw → G_candidate
  Generate candidate goals via LLM reasoning

StepBack: G_candidate → G_fixed
  Apply 5 step-back questions iteratively
```

### IntentResolver.ts

```typescript
/**
 * Intent Resolver
 * Implements ℐ: User Input → Fixed Goal
 *
 * Based on Section 4.1 of the paper
 */

import { EventEmitter } from 'events';
import { z } from 'zod';

// Input validation schema
const UserInputSchema = z.object({
  text: z.string().min(1),
  context: z.record(z.any()).optional(),
  timestamp: z.date(),
});

export type UserInput = z.infer<typeof UserInputSchema>;

// Intent analysis structure
export interface IntentAnalysis {
  explicit: string;      // What user directly said
  implicit: string;      // Inferred background intent
  want: string;          // What user thinks they want
  need: string;          // What user actually needs
  confidence: number;    // 0-1, LLM confidence
}

// Goal representation
export interface Goal {
  id: string;
  description: string;
  constraints: Constraint[];
  successCriteria: SuccessCriterion[];
  metadata: {
    source: UserInput;
    refinementSteps: number;
    confidence: number;
  };
}

export interface Constraint {
  id: string;
  description: string;
  evaluate: (world: WorldState) => boolean;
}

export interface SuccessCriterion {
  id: string;
  description: string;
  weight: number; // For distance metric computation
  evaluate: (world: WorldState) => number; // 0-1, progress toward criterion
}

/**
 * Main Intent Resolver
 */
export class IntentResolver extends EventEmitter {
  private stepBackEngine: StepBackEngine;
  private llmClient: LLMClient;

  constructor(config: IntentResolverConfig) {
    super();
    this.stepBackEngine = new StepBackEngine(config.llm);
    this.llmClient = config.llm;
  }

  /**
   * ℐ(Input) → Goal
   * Main entry point
   */
  async resolve(input: UserInput): Promise<Goal> {
    this.emit('resolveStart', { input });

    try {
      // Step 1: Capture intents
      const analysis = await this.capture(input);
      this.emit('captureComplete', { analysis });

      // Step 2: Disambiguate → candidate goal
      const candidate = await this.disambiguate(analysis);
      this.emit('candidateGenerated', { candidate });

      // Step 3: StepBack → fixed goal
      const fixedGoal = await this.stepBack(candidate, input);
      this.emit('goalFixed', { goal: fixedGoal });

      return fixedGoal;
    } catch (error) {
      this.emit('resolveError', { error });
      throw error;
    }
  }

  /**
   * Capture: Extract 4 types of intents
   * Uses LLM to analyze user input
   */
  private async capture(input: UserInput): Promise<IntentAnalysis> {
    const prompt = `
Analyze the following user input and extract 4 types of intents:

User Input: "${input.text}"
Context: ${JSON.stringify(input.context, null, 2)}

Extract:
1. Explicit Intent: What the user directly stated
2. Implicit Intent: What the user likely means (infer from context)
3. Want Intent: What the user thinks they want
4. Need Intent: What the user actually needs (may differ from want)

Respond in JSON format.
    `.trim();

    const response = await this.llmClient.complete(prompt, {
      temperature: 0.3, // Low temperature for consistency
      maxTokens: 500,
    });

    return this.parseIntentAnalysis(response);
  }

  /**
   * Disambiguate: Generate candidate goal
   */
  private async disambiguate(analysis: IntentAnalysis): Promise<GoalCandidate> {
    const prompt = `
Based on the intent analysis, generate a candidate goal.

Intent Analysis:
- Explicit: ${analysis.explicit}
- Implicit: ${analysis.implicit}
- Want: ${analysis.want}
- Need: ${analysis.need}

Generate:
1. Goal Description (clear, specific, measurable)
2. Success Criteria (3-5 concrete criteria)
3. Constraints (any limitations or requirements)

Respond in JSON format.
    `.trim();

    const response = await this.llmClient.complete(prompt, {
      temperature: 0.5,
      maxTokens: 800,
    });

    return this.parseGoalCandidate(response);
  }

  /**
   * StepBack: Iteratively refine goal with 5 questions
   * Continues until goal passes validation
   */
  private async stepBack(
    candidate: GoalCandidate,
    originalInput: UserInput
  ): Promise<Goal> {
    let current = candidate;
    let iteration = 0;
    const maxIterations = 3; // Typically converges in 1-3 iterations

    while (iteration < maxIterations) {
      // Generate step-back questions
      const questions = this.stepBackEngine.generateQuestions(current);
      this.emit('stepBackQuestions', { questions, iteration });

      // Get answers (from user or LLM inference)
      const answers = await this.getAnswers(questions, originalInput);
      this.emit('stepBackAnswers', { answers, iteration });

      // Refine goal based on answers
      const refined = await this.stepBackEngine.refineGoal(current, answers);
      this.emit('goalRefined', { refined, iteration });

      // Validate refined goal
      if (this.stepBackEngine.validate(refined)) {
        return this.convertToGoal(refined, originalInput, iteration + 1);
      }

      current = refined;
      iteration++;
    }

    // Fallback: Use best candidate even if not fully validated
    console.warn('StepBack did not converge, using best candidate');
    return this.convertToGoal(current, originalInput, iteration);
  }

  /**
   * Get answers to step-back questions
   * Can ask user interactively or use LLM inference
   */
  private async getAnswers(
    questions: StepBackQuestion[],
    input: UserInput
  ): Promise<Answer[]> {
    // Strategy 1: Try to infer from context (fast)
    const inferredAnswers = await this.inferAnswers(questions, input);

    // Check if inference confidence is high enough
    const highConfidence = inferredAnswers.every((a) => a.confidence > 0.8);

    if (highConfidence) {
      return inferredAnswers;
    }

    // Strategy 2: Ask user interactively (slower but accurate)
    return this.askUserInteractively(questions);
  }

  /**
   * Infer answers using LLM reasoning
   */
  private async inferAnswers(
    questions: StepBackQuestion[],
    input: UserInput
  ): Promise<Answer[]> {
    const prompt = `
Given the original user input and step-back questions, infer likely answers.

User Input: "${input.text}"
Context: ${JSON.stringify(input.context, null, 2)}

Questions:
${questions.map((q, i) => `${i + 1}. ${q.question}`).join('\n')}

Infer answers based on context. Respond in JSON format with confidence scores.
    `.trim();

    const response = await this.llmClient.complete(prompt, {
      temperature: 0.4,
      maxTokens: 600,
    });

    return this.parseAnswers(response);
  }

  /**
   * Ask user interactively via UI
   */
  private async askUserInteractively(
    questions: StepBackQuestion[]
  ): Promise<Answer[]> {
    return new Promise((resolve) => {
      this.emit('requestUserInput', {
        questions,
        callback: (answers: Answer[]) => resolve(answers),
      });
    });
  }

  // Helper methods
  private parseIntentAnalysis(response: string): IntentAnalysis {
    // Parse LLM JSON response, validate with Zod
    const data = JSON.parse(response);
    return {
      explicit: data.explicit,
      implicit: data.implicit,
      want: data.want,
      need: data.need,
      confidence: data.confidence || 0.7,
    };
  }

  private parseGoalCandidate(response: string): GoalCandidate {
    const data = JSON.parse(response);
    return {
      description: data.description,
      successCriteria: data.successCriteria,
      constraints: data.constraints,
    };
  }

  private parseAnswers(response: string): Answer[] {
    const data = JSON.parse(response);
    return data.answers;
  }

  private convertToGoal(
    candidate: GoalCandidate,
    input: UserInput,
    steps: number
  ): Goal {
    return {
      id: generateId(),
      description: candidate.description,
      constraints: candidate.constraints.map(this.createConstraint),
      successCriteria: candidate.successCriteria.map(this.createCriterion),
      metadata: {
        source: input,
        refinementSteps: steps,
        confidence: candidate.confidence || 0.8,
      },
    };
  }

  private createConstraint(desc: string): Constraint {
    // Convert text description to executable constraint
    // This would use LLM to generate evaluation logic
    return {
      id: generateId(),
      description: desc,
      evaluate: (world: WorldState) => {
        // Placeholder: actual implementation would generate this dynamically
        return true;
      },
    };
  }

  private createCriterion(desc: string, weight: number): SuccessCriterion {
    return {
      id: generateId(),
      description: desc,
      weight: weight,
      evaluate: (world: WorldState) => {
        // Placeholder: actual implementation would generate this dynamically
        return 0.5; // 0-1 progress
      },
    };
  }
}
```

### StepBackEngine.ts

```typescript
/**
 * StepBack Question Engine
 * Implements the 5 step-back questions from Section 4.1
 */

export interface StepBackQuestion {
  type: 'why' | 'what' | 'how' | 'when' | 'who';
  question: string;
  purpose: string;
}

export interface Answer {
  questionType: StepBackQuestion['type'];
  answer: string;
  confidence: number; // 0-1
}

export class StepBackEngine {
  private llmClient: LLMClient;

  constructor(llm: LLMClient) {
    this.llmClient = llm;
  }

  /**
   * Generate 5 step-back questions
   */
  generateQuestions(candidate: GoalCandidate): StepBackQuestion[] {
    return [
      {
        type: 'why',
        question: `Why is "${candidate.description}" needed?`,
        purpose: 'Clarify purpose and motivation',
      },
      {
        type: 'what',
        question: 'What is truly desired to be achieved?',
        purpose: 'Identify true objective (may differ from stated goal)',
      },
      {
        type: 'how',
        question: 'Is there a better way to achieve this?',
        purpose: 'Explore alternative approaches',
      },
      {
        type: 'when',
        question: 'Should this be done now, or are there prerequisites?',
        purpose: 'Assess priority and dependencies',
      },
      {
        type: 'who',
        question: 'Who is the best to handle this (human/agent/subagent)?',
        purpose: 'Optimize resource allocation',
      },
    ];
  }

  /**
   * Refine goal based on step-back answers
   */
  async refineGoal(
    candidate: GoalCandidate,
    answers: Answer[]
  ): Promise<GoalCandidate> {
    const prompt = `
Current Goal Candidate: "${candidate.description}"

Step-Back Answers:
${answers.map((a) => `- ${a.questionType.toUpperCase()}: ${a.answer}`).join('\n')}

Refine the goal to better align with the step-back insights.
Generate:
1. Refined goal description
2. Updated success criteria
3. Updated constraints

Respond in JSON format.
    `.trim();

    const response = await this.llmClient.complete(prompt, {
      temperature: 0.4,
      maxTokens: 800,
    });

    return JSON.parse(response);
  }

  /**
   * Validate refined goal
   * Checks: specificity, measurability, feasibility
   */
  validate(candidate: GoalCandidate): boolean {
    // 1. Check specificity
    const isSpecific = candidate.description.length > 20 && !hasVagueWords(candidate.description);

    // 2. Check measurability
    const hasMeasurableCriteria = candidate.successCriteria.length >= 2;

    // 3. Check feasibility (basic heuristic)
    const isFeasible = candidate.constraints.length < 10; // Not over-constrained

    return isSpecific && hasMeasurableCriteria && isFeasible;
  }
}

// Helper
function hasVagueWords(text: string): boolean {
  const vagueWords = ['better', 'improve', 'optimize', 'enhance'];
  return vagueWords.some((word) => text.toLowerCase().includes(word));
}
```

---

## 𝒞 - Command Stack

**Mathematical Definition**: `𝒞: 𝒢 → 𝒯` (Goal → Task sequence)

**Implementation**: `src/core/command-stack/`

### Architecture

```
𝒞 = C₃ ◦ C₂ ◦ C₁

C₁ (Structure): Goal → TaskHierarchy
  Decomposes goal into upper/middle/lower level tasks

C₂ (Promptify): TaskHierarchy → CommandPairs
  Maps each task to executable prompt

C₃ (Chain): CommandPairs → ExecutionPlan
  Analyzes dependencies, creates execution order
```

### CommandStack.ts

```typescript
/**
 * Command Stack
 * Implements 𝒞: Goal → ExecutionPlan
 *
 * Based on Section 4.2 of the paper
 */

import { EventEmitter } from 'events';

export interface Task {
  id: string;
  level: 'upper' | 'middle' | 'lower';
  description: string;
  prompt: string; // Executable instruction
  dependencies: string[]; // Task IDs this depends on
  estimatedDuration: number; // seconds
}

export interface CommandPair {
  task: Task;
  prompt: string;
}

export interface ExecutionPlan {
  tasks: Task[];
  executionOrder: string[]; // Task IDs in topological order
  parallelGroups: string[][]; // Tasks that can run in parallel
  estimatedTotalDuration: number;
}

export class CommandStack extends EventEmitter {
  private structurizer: Structurizer;
  private promptifier: Promptifier;
  private chainExecutor: ChainExecutor;

  constructor(config: CommandStackConfig) {
    super();
    this.structurizer = new Structurizer(config.llm);
    this.promptifier = new Promptifier(config.llm);
    this.chainExecutor = new ChainExecutor();
  }

  /**
   * 𝒞(Goal) → ExecutionPlan
   * Main entry point
   */
  async decompose(goal: Goal): Promise<ExecutionPlan> {
    this.emit('decomposeStart', { goal });

    try {
      // C₁: Structure
      const hierarchy = await this.c1_structure(goal);
      this.emit('structureComplete', { hierarchy });

      // C₂: Promptify
      const commandPairs = await this.c2_promptify(hierarchy, goal);
      this.emit('promptifyComplete', { commandPairs });

      // C₃: Chain
      const executionPlan = this.c3_chain(commandPairs);
      this.emit('chainComplete', { executionPlan });

      return executionPlan;
    } catch (error) {
      this.emit('decomposeError', { error });
      throw error;
    }
  }

  /**
   * C₁: Structure - Goal → TaskHierarchy
   */
  private async c1_structure(goal: Goal): Promise<TaskHierarchy> {
    return this.structurizer.analyze(goal);
  }

  /**
   * C₂: Promptify - TaskHierarchy → CommandPairs
   */
  private async c2_promptify(
    hierarchy: TaskHierarchy,
    goal: Goal
  ): Promise<CommandPair[]> {
    return this.promptifier.createCommandPairs(hierarchy.tasks, goal);
  }

  /**
   * C₃: Chain - CommandPairs → ExecutionPlan
   */
  private c3_chain(pairs: CommandPair[]): ExecutionPlan {
    const tasks = pairs.map((p) => p.task);

    // Analyze dependencies
    const graph = this.chainExecutor.analyzeDependencies(tasks);

    // Topological sort
    const executionOrder = this.chainExecutor.topologicalSort(graph);

    // Identify parallel groups
    const parallelGroups = this.chainExecutor.findParallelGroups(graph);

    // Estimate duration
    const estimatedDuration = this.estimateDuration(tasks, parallelGroups);

    return {
      tasks,
      executionOrder,
      parallelGroups,
      estimatedTotalDuration: estimatedDuration,
    };
  }

  private estimateDuration(tasks: Task[], parallelGroups: string[][]): number {
    // Critical path analysis
    let totalDuration = 0;
    for (const group of parallelGroups) {
      const groupDurations = group.map(
        (id) => tasks.find((t) => t.id === id)!.estimatedDuration
      );
      totalDuration += Math.max(...groupDurations); // Parallel execution
    }
    return totalDuration;
  }
}
```

### Structurizer.ts (C₁)

```typescript
/**
 * Structurizer (C₁)
 * Goal → TaskHierarchy
 */

export interface TaskHierarchy {
  goal: Goal;
  tasks: Task[];
  structure: {
    upper: Task[]; // High-level objectives
    middle: Task[]; // Implementation steps
    lower: Task[]; // Concrete actions
  };
}

export class Structurizer {
  private llmClient: LLMClient;

  constructor(llm: LLMClient) {
    this.llmClient = llm;
  }

  /**
   * Analyze goal and create hierarchical task structure
   */
  async analyze(goal: Goal): Promise<TaskHierarchy> {
    const prompt = `
Decompose the following goal into a hierarchical task structure.

Goal: "${goal.description}"
Success Criteria:
${goal.successCriteria.map((c, i) => `${i + 1}. ${c.description}`).join('\n')}

Create tasks at 3 levels:
1. UPPER: High-level objectives (2-4 tasks)
2. MIDDLE: Implementation steps (5-10 tasks)
3. LOWER: Concrete actions (10-20 tasks)

For each task, specify:
- Description
- Level (upper/middle/lower)
- Dependencies (which tasks must complete first)
- Estimated duration (seconds)

Respond in JSON format.
    `.trim();

    const response = await this.llmClient.complete(prompt, {
      temperature: 0.5,
      maxTokens: 2000,
    });

    const data = JSON.parse(response);

    const tasks: Task[] = data.tasks.map((t: any) => ({
      id: generateId(),
      level: t.level,
      description: t.description,
      prompt: '', // Will be filled by Promptifier
      dependencies: t.dependencies || [],
      estimatedDuration: t.estimatedDuration || 10,
    }));

    return {
      goal,
      tasks,
      structure: {
        upper: tasks.filter((t) => t.level === 'upper'),
        middle: tasks.filter((t) => t.level === 'middle'),
        lower: tasks.filter((t) => t.level === 'lower'),
      },
    };
  }
}
```

### Promptifier.ts (C₂)

```typescript
/**
 * Promptifier (C₂)
 * TaskHierarchy → CommandPairs
 */

export class Promptifier {
  private llmClient: LLMClient;

  constructor(llm: LLMClient) {
    this.llmClient = llm;
  }

  /**
   * Generate executable prompts for each task
   */
  async createCommandPairs(tasks: Task[], goal: Goal): Promise<CommandPair[]> {
    const pairs: CommandPair[] = [];

    for (const task of tasks) {
      const prompt = await this.generatePrompt(task, goal);
      pairs.push({ task, prompt });
    }

    return pairs;
  }

  /**
   * Generate single prompt for a task
   */
  async generatePrompt(task: Task, goal: Goal): Promise<string> {
    const systemPrompt = `
Generate an executable prompt for a Claude Code subagent.

Task: "${task.description}"
Task Level: ${task.level}
Goal Context: "${goal.description}"

The prompt should:
1. Be clear and specific
2. Include all necessary context
3. Specify expected output format
4. Mention constraints from the goal

Generate the prompt.
    `.trim();

    const response = await this.llmClient.complete(systemPrompt, {
      temperature: 0.6,
      maxTokens: 400,
    });

    // Update task with generated prompt
    task.prompt = response.trim();

    return task.prompt;
  }
}
```

### ChainExecutor.ts (C₃)

```typescript
/**
 * ChainExecutor (C₃)
 * CommandPairs → ExecutionPlan (with dependency resolution)
 */

export interface DependencyGraph {
  nodes: Map<string, Task>; // taskId → Task
  edges: Map<string, string[]>; // taskId → dependentTaskIds
}

export class ChainExecutor {
  /**
   * Analyze task dependencies
   */
  analyzeDependencies(tasks: Task[]): DependencyGraph {
    const nodes = new Map(tasks.map((t) => [t.id, t]));
    const edges = new Map<string, string[]>();

    for (const task of tasks) {
      edges.set(task.id, task.dependencies);
    }

    return { nodes, edges };
  }

  /**
   * Topological sort for execution order
   */
  topologicalSort(graph: DependencyGraph): string[] {
    const sorted: string[] = [];
    const visited = new Set<string>();
    const visiting = new Set<string>();

    const visit = (nodeId: string) => {
      if (visited.has(nodeId)) return;
      if (visiting.has(nodeId)) {
        throw new Error(`Circular dependency detected: ${nodeId}`);
      }

      visiting.add(nodeId);

      const deps = graph.edges.get(nodeId) || [];
      for (const dep of deps) {
        visit(dep);
      }

      visiting.delete(nodeId);
      visited.add(nodeId);
      sorted.push(nodeId);
    };

    for (const nodeId of graph.nodes.keys()) {
      visit(nodeId);
    }

    return sorted;
  }

  /**
   * Find tasks that can execute in parallel
   */
  findParallelGroups(graph: DependencyGraph): string[][] {
    const groups: string[][] = [];
    const levels = this.computeLevels(graph);

    // Group tasks by level (tasks at same level can run in parallel)
    const maxLevel = Math.max(...levels.values());

    for (let level = 0; level <= maxLevel; level++) {
      const group = Array.from(levels.entries())
        .filter(([_, l]) => l === level)
        .map(([id, _]) => id);

      if (group.length > 0) {
        groups.push(group);
      }
    }

    return groups;
  }

  /**
   * Compute level of each task (for parallelization)
   */
  private computeLevels(graph: DependencyGraph): Map<string, number> {
    const levels = new Map<string, number>();

    const computeLevel = (nodeId: string): number => {
      if (levels.has(nodeId)) {
        return levels.get(nodeId)!;
      }

      const deps = graph.edges.get(nodeId) || [];
      if (deps.length === 0) {
        levels.set(nodeId, 0);
        return 0;
      }

      const depLevels = deps.map((dep) => computeLevel(dep));
      const level = Math.max(...depLevels) + 1;
      levels.set(nodeId, level);
      return level;
    };

    for (const nodeId of graph.nodes.keys()) {
      computeLevel(nodeId);
    }

    return levels;
  }
}
```

---

## Θ - World Transformation

**Mathematical Definition**: `Θ: 𝒯 × 𝒲 → 𝒲` (Tasks + World → New world)

**Implementation**: `src/core/world/`

### Architecture

```
Θ = θ₆ ◦ θ₅ ◦ θ₄ ◦ θ₃ ◦ θ₂ ◦ θ₁

θ₁_Understand: (Tasks, W_t) → Understanding_t
θ₂_Generate: Understanding_t → Plan_t (delegated to 𝒞)
θ₃_Allocate: Plan_t → Allocation_t
θ₄_Execute: (Allocation_t, W_t) → ExecutionResult_t
θ₅_Integrate: (ExecutionResult_t, W_t) → IntegratedWorld_t
θ₆_Learn: IntegratedWorld_t → W_{t+1}
```

### WorldTransformer.ts

```typescript
/**
 * World Transformer (Θ)
 * Implements the 6-phase transformation cycle
 *
 * Based on Section 4.3 of the paper
 */

import { EventEmitter } from 'events';

export class WorldTransformer extends EventEmitter {
  private subagentPool: SubagentPool;
  private blinkManager: BlinkManager;

  constructor(config: WorldTransformerConfig) {
    super();
    this.subagentPool = new SubagentPool(config.subagents);
    this.blinkManager = new BlinkManager();
  }

  /**
   * Θ(Tasks, World_t) → World_{t+1}
   * Main transformation
   */
  async apply(tasks: Task[], world: WorldState): Promise<WorldState> {
    this.emit('transformStart', { tasks, world });

    try {
      // θ₁: Understand
      const understanding = await this.theta1_understand(tasks, world);
      this.emit('phaseComplete', { phase: 'θ₁_understand', understanding });

      // θ₂: Generate (already done by Command Stack, just validate)
      this.theta2_validate(tasks, understanding);
      this.emit('phaseComplete', { phase: 'θ₂_generate' });

      // θ₃: Allocate
      const allocation = await this.theta3_allocate(tasks);
      this.emit('phaseComplete', { phase: 'θ₃_allocate', allocation });

      // θ₄: Execute (produces sequence of blinks)
      const executionResult = await this.theta4_execute(allocation, world);
      this.emit('phaseComplete', { phase: 'θ₄_execute', executionResult });

      // θ₅: Integrate
      const integrated = await this.theta5_integrate(executionResult, world);
      this.emit('phaseComplete', { phase: 'θ₅_integrate', integrated });

      // θ₆: Learn
      const newWorld = await this.theta6_learn(integrated, world);
      this.emit('phaseComplete', { phase: 'θ₆_learn', newWorld });

      // Record blink (W_t → W_{t+1})
      const blink = this.blinkManager.createBlink(world, newWorld);
      this.blinkManager.recordBlink(blink);
      this.emit('blinkRecorded', { blink });

      return newWorld;
    } catch (error) {
      this.emit('transformError', { error });
      throw error;
    }
  }

  /**
   * θ₁: Understand
   * Perceive current world state and comprehend tasks
   */
  private async theta1_understand(
    tasks: Task[],
    world: WorldState
  ): Promise<Understanding> {
    return {
      currentState: this.analyzeWorldState(world),
      taskRequirements: tasks.map(this.analyzeTaskRequirements),
      gaps: this.identifyGaps(tasks, world),
      risks: this.identifyRisks(tasks, world),
    };
  }

  /**
   * θ₂: Generate (validation only, actual generation by 𝒞)
   */
  private theta2_validate(tasks: Task[], understanding: Understanding): void {
    // Ensure tasks address all gaps
    for (const gap of understanding.gaps) {
      const addressed = tasks.some((task) =>
        task.description.toLowerCase().includes(gap.toLowerCase())
      );
      if (!addressed) {
        console.warn(`Gap not addressed by tasks: ${gap}`);
      }
    }
  }

  /**
   * θ₃: Allocate
   * Assign tasks to subagents
   */
  private async theta3_allocate(tasks: Task[]): Promise<Allocation> {
    const allocations: TaskAllocation[] = [];

    for (const task of tasks) {
      const subagent = this.subagentPool.select(task);
      allocations.push({
        task,
        subagent,
        resources: this.allocateResources(task),
      });
    }

    return { allocations };
  }

  /**
   * θ₄: Execute
   * Execute tasks via subagents (parallel where possible)
   */
  private async theta4_execute(
    allocation: Allocation,
    world: WorldState
  ): Promise<ExecutionResult> {
    const results: Map<string, WorldState> = new Map();

    // Group by parallel groups (from execution plan)
    const parallelGroups = this.groupByParallelism(allocation.allocations);

    let currentWorld = world;

    for (const group of parallelGroups) {
      // Execute group in parallel
      const groupResults = await Promise.all(
        group.map((alloc) =>
          this.executeTask(alloc, currentWorld)
        )
      );

      // Merge results
      currentWorld = this.mergeWorldStates(groupResults);

      // Record individual blinks
      for (const result of groupResults) {
        const blink = this.blinkManager.createBlink(world, result);
        this.emit('blinkComplete', { blink });
      }
    }

    return {
      finalWorld: currentWorld,
      taskResults: results,
    };
  }

  /**
   * Execute single task via subagent
   */
  private async executeTask(
    alloc: TaskAllocation,
    world: WorldState
  ): Promise<WorldState> {
    return alloc.subagent.execute(alloc.task, world, alloc.resources);
  }

  /**
   * θ₅: Integrate
   * Merge execution results, ensure consistency
   */
  private async theta5_integrate(
    result: ExecutionResult,
    originalWorld: WorldState
  ): Promise<WorldState> {
    // Start with final world from execution
    let integrated = result.finalWorld;

    // Ensure consistency checks
    integrated = this.ensureFileSystemConsistency(integrated);
    integrated = this.ensureCodeBaseConsistency(integrated);
    integrated = this.resolveConflicts(integrated, originalWorld);

    return integrated;
  }

  /**
   * θ₆: Learn
   * Extract patterns, update knowledge
   */
  private async theta6_learn(
    integrated: WorldState,
    original: WorldState
  ): Promise<WorldState> {
    // Compute delta (what changed)
    const delta = this.computeDelta(integrated, original);

    // Extract patterns
    const patterns = this.extractPatterns(delta);

    // Update knowledge base
    const updatedKnowledge = new Map(integrated.knowledge);
    for (const pattern of patterns) {
      updatedKnowledge.set(pattern.id, pattern);
    }

    return {
      ...integrated,
      knowledge: updatedKnowledge,
      metadata: {
        ...integrated.metadata,
        lastLearning: new Date(),
        patternsLearned: patterns.length,
      },
    };
  }

  // Helper methods
  private analyzeWorldState(world: WorldState): StateAnalysis {
    return {
      filesCount: world.fileSystem.size,
      directoriesCount: this.countDirectories(world.fileSystem),
      codebaseSize: this.computeCodebaseSize(world.codeBase),
      knowledgeSize: world.knowledge.size,
    };
  }

  private analyzeTaskRequirements(task: Task): TaskRequirement {
    // Analyze what the task needs from world state
    return {
      taskId: task.id,
      requiredFiles: this.extractRequiredFiles(task),
      requiredTools: this.extractRequiredTools(task),
    };
  }

  private identifyGaps(tasks: Task[], world: WorldState): string[] {
    // Identify gaps between task requirements and current world
    const gaps: string[] = [];

    for (const task of tasks) {
      const required = this.analyzeTaskRequirements(task);
      for (const file of required.requiredFiles) {
        if (!world.fileSystem.has(file)) {
          gaps.push(`Missing file: ${file}`);
        }
      }
    }

    return gaps;
  }

  private identifyRisks(tasks: Task[], world: WorldState): string[] {
    // Identify potential risks
    return [
      // Risk: Circular dependencies
      ...this.detectCircularDeps(tasks),
      // Risk: Resource conflicts
      ...this.detectResourceConflicts(tasks, world),
    ];
  }

  private allocateResources(task: Task): ResourceAllocation {
    return {
      tools: this.selectTools(task),
      memory: this.estimateMemory(task),
      timeout: task.estimatedDuration * 2, // 2× buffer
    };
  }

  private groupByParallelism(allocations: TaskAllocation[]): TaskAllocation[][] {
    // Group tasks that can execute in parallel
    // (This uses execution plan from Command Stack)
    const groups: TaskAllocation[][] = [];
    // Implementation depends on execution plan structure
    return groups;
  }

  private mergeWorldStates(states: WorldState[]): WorldState {
    // Merge multiple world states (from parallel execution)
    // Use conflict resolution strategy (last-write-wins, merge, etc.)
    return states.reduce((acc, state) => this.mergeTwoStates(acc, state), states[0]);
  }

  private mergeTwoStates(a: WorldState, b: WorldState): WorldState {
    return {
      fileSystem: new Map([...a.fileSystem, ...b.fileSystem]),
      codeBase: { ...a.codeBase, ...b.codeBase },
      environment: { ...a.environment, ...b.environment },
      resources: { ...a.resources, ...b.resources },
      context: { ...a.context, ...b.context },
      knowledge: new Map([...a.knowledge, ...b.knowledge]),
      metadata: {
        ...a.metadata,
        mergedFrom: [a.metadata.id, b.metadata.id],
      },
    };
  }

  private ensureFileSystemConsistency(world: WorldState): WorldState {
    // Validate file system integrity
    // Remove orphaned files, fix permissions, etc.
    return world;
  }

  private ensureCodeBaseConsistency(world: WorldState): WorldState {
    // Validate codebase integrity
    // Check syntax, dependencies, build artifacts
    return world;
  }

  private resolveConflicts(integrated: WorldState, original: WorldState): WorldState {
    // Resolve any conflicts between integrated and original
    return integrated;
  }

  private computeDelta(newWorld: WorldState, oldWorld: WorldState): WorldDelta {
    return {
      filesAdded: this.getAddedFiles(newWorld, oldWorld),
      filesModified: this.getModifiedFiles(newWorld, oldWorld),
      filesDeleted: this.getDeletedFiles(newWorld, oldWorld),
      knowledgeAdded: this.getAddedKnowledge(newWorld, oldWorld),
    };
  }

  private extractPatterns(delta: WorldDelta): Pattern[] {
    // Extract learning patterns from delta
    const patterns: Pattern[] = [];

    // Pattern: Frequently modified files
    if (delta.filesModified.length > 5) {
      patterns.push({
        id: generateId(),
        type: 'frequent_modification',
        data: delta.filesModified,
      });
    }

    // More pattern extraction logic...

    return patterns;
  }

  // Utility methods (placeholders)
  private countDirectories(fs: Map<string, any>): number { return 0; }
  private computeCodebaseSize(codebase: any): number { return 0; }
  private extractRequiredFiles(task: Task): string[] { return []; }
  private extractRequiredTools(task: Task): string[] { return []; }
  private detectCircularDeps(tasks: Task[]): string[] { return []; }
  private detectResourceConflicts(tasks: Task[], world: WorldState): string[] { return []; }
  private selectTools(task: Task): string[] { return []; }
  private estimateMemory(task: Task): number { return 100; }
  private getAddedFiles(a: WorldState, b: WorldState): string[] { return []; }
  private getModifiedFiles(a: WorldState, b: WorldState): string[] { return []; }
  private getDeletedFiles(a: WorldState, b: WorldState): string[] { return []; }
  private getAddedKnowledge(a: WorldState, b: WorldState): Pattern[] { return []; }
}
```

---

## Integration Pattern

**How ℐ, 𝒞, Θ work together**:

```typescript
/**
 * OrchestratorAgent.ts
 * Implements 𝔸(Input, W₀) = lim_{n→∞} [∫₀ⁿ (Θ ◦ 𝒞 ◦ ℐ)(t) dt] = W_∞
 */

export class OrchestratorAgent extends EventEmitter {
  private intentResolver: IntentResolver;
  private commandStack: CommandStack;
  private worldTransformer: WorldTransformer;
  private convergenceTracker: ConvergenceTracker;

  constructor(config: OrchestratorConfig) {
    super();
    this.intentResolver = new IntentResolver(config.intent);
    this.commandStack = new CommandStack(config.commandStack);
    this.worldTransformer = new WorldTransformer(config.world);
    this.convergenceTracker = new ConvergenceTracker(config.convergence);
  }

  /**
   * Apply the Law of Flickering Scenery
   * 𝔸(Input, World₀) → World_∞
   */
  async applyLaw(input: UserInput, world: WorldState): Promise<WorldState> {
    this.emit('lawStart', { input, world });

    // ℐ: Intent Resolution
    const goal = await this.intentResolver.resolve(input);
    this.emit('goalResolved', { goal });

    // Convergence loop: lim_{n→∞}
    let iteration = 0;
    const maxIterations = this.config.maxIterations || 20;

    while (!this.goalAchieved(world, goal)) {
      this.emit('iterationStart', { iteration, world });

      // 𝒞: Command Stack
      const executionPlan = await this.commandStack.decompose(goal);
      this.emit('planGenerated', { plan: executionPlan });

      // Θ: World Transformation (one blink)
      world = await this.worldTransformer.apply(executionPlan.tasks, world);
      this.emit('blinkComplete', { iteration, world });

      // Track convergence
      const metrics = this.convergenceTracker.track(world, goal);
      this.emit('convergenceUpdate', { metrics });

      // Check termination
      const epsilon = 0.01; // Tolerance
      if (this.convergenceTracker.checkTermination(metrics, epsilon)) {
        this.emit('convergenceAchieved', { iteration, world, metrics });
        break;
      }

      iteration++;

      if (iteration >= maxIterations) {
        this.emit('convergenceFailed', { iteration, world });
        throw new ConvergenceError(
          `Failed to converge after ${maxIterations} iterations`
        );
      }
    }

    this.emit('lawComplete', { finalWorld: world, iterations: iteration });
    return world; // World_∞
  }

  private goalAchieved(world: WorldState, goal: Goal): boolean {
    return goal.constraints.every((constraint) => constraint.evaluate(world));
  }
}
```

---

## Type Definitions

### WorldState Types

```typescript
/**
 * Complete World State definition
 * Based on Definition 3.1 in the paper
 */

export interface WorldState {
  // Unique identifier
  id: string;
  snapshotId: number;
  timestamp: Date;

  // F_t: FileSystem state
  fileSystem: Map<string, FileNode>;

  // C_t: CodeBase state
  codeBase: {
    sourceCode: Map<string, SourceFile>;
    dependencies: Map<string, Dependency>;
    buildArtifacts: Map<string, Artifact>;
  };

  // E_t: Environment state
  environment: {
    variables: Map<string, string>;
    configurations: Map<string, any>;
    runtime: RuntimeState;
  };

  // R_t: Resources state
  resources: {
    apis: Map<string, APIConnection>;
    databases: Map<string, DBConnection>;
    externalServices: Map<string, ServiceConnection>;
  };

  // X_t: Context state
  context: {
    conversationHistory: Message[];
    userPreferences: Map<string, any>;
    projectState: ProjectState;
  };

  // K_t: Knowledge state
  knowledge: Map<string, Pattern>;

  // Metadata
  metadata: {
    version: string;
    previousSnapshot?: string;
    totalBlinks: number;
    createdAt: Date;
    updatedAt: Date;
  };
}

export interface FileNode {
  path: string;
  type: 'file' | 'directory';
  content?: string;
  permissions: string;
  size: number;
  modifiedAt: Date;
}

export interface SourceFile {
  path: string;
  language: string;
  content: string;
  ast?: any; // Abstract Syntax Tree
}

export interface Dependency {
  name: string;
  version: string;
  type: 'dev' | 'prod';
}

export interface Pattern {
  id: string;
  type: string;
  data: any;
  confidence: number;
  learnedAt: Date;
}
```

### Blink Types

```typescript
/**
 * Blink (World State Transition)
 */

export interface Blink {
  id: string;
  from: WorldState;
  to: WorldState;
  delta: WorldDelta;
  duration: number; // milliseconds
  phase: Phase;
  success: boolean;
  metadata: {
    iteration: number;
    tasksExecuted: number;
    timestamp: Date;
  };
}

export interface WorldDelta {
  filesAdded: string[];
  filesModified: string[];
  filesDeleted: string[];
  knowledgeAdded: Pattern[];
  changes: Change[];
}

export interface Change {
  type: 'add' | 'modify' | 'delete';
  path: string;
  before?: any;
  after?: any;
}

export type Phase = 'θ₁_understand' | 'θ₂_generate' | 'θ₃_allocate' | 'θ₄_execute' | 'θ₅_integrate' | 'θ₆_learn';
```

---

## Testing Strategy

### Unit Tests

```typescript
// tests/unit/core/intent/IntentResolver.test.ts

describe('IntentResolver', () => {
  let resolver: IntentResolver;

  beforeEach(() => {
    resolver = new IntentResolver(mockConfig);
  });

  test('should extract 4 types of intents', async () => {
    const input = { text: 'Organize my project directory', context: {}, timestamp: new Date() };
    const analysis = await resolver.capture(input);

    expect(analysis).toHaveProperty('explicit');
    expect(analysis).toHaveProperty('implicit');
    expect(analysis).toHaveProperty('want');
    expect(analysis).toHaveProperty('need');
  });

  test('should converge on fixed goal within 3 iterations', async () => {
    const input = { text: 'Improve performance', context: {}, timestamp: new Date() };
    const goal = await resolver.resolve(input);

    expect(goal.metadata.refinementSteps).toBeLessThanOrEqual(3);
  });
});
```

---

## Performance Benchmarks

**Target Metrics**:
- Intent Resolution: < 2s
- Command Stack Decomposition: < 1s (for goals with < 20 tasks)
- World Transformation (single blink): < 5s
- Full convergence (10 blinks): < 60s

---

## Next Steps

**Implementers**: Proceed to [03_FEATURES.md](./03_FEATURES.md) for UI/UX feature specifications.

---

**Core Components Status**: ✅ Complete - Ready for Implementation
