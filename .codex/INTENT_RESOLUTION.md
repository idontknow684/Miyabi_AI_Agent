# Intent Resolution Framework - 意図解決フレームワーク

**Version**: 1.0.0
**Last Updated**: 2025-11-07
**Concept**: Intent → Goal → Tasks → Execution

---

## 🎯 概要

**Intent Resolution Framework**は、ユーザーの曖昧な意図を、実行可能なタスクに変換し、最終的な目標達成まで導く完全なフレームワーク。

### 核心プロセス

```
[Input] → [User Intent] → [Fixed Goal] → [Tasks] → [Agent Execution] → [Result]
```

---

## 📐 数学的定義

### Step-Back Question Formula（ステップバック質問公式）

```
F(Achieve Goal using Step-Back Question) = A to Z = ∫F(step) = Result

Where:
  F(Goal) = 目標達成関数
  A to Z = 完全なプロセス（開始から完了まで）
  ∫F(step) = 各ステップの積分（累積実行）
  Result = 最終成果物
```

**意味**:
- 目標達成は、個別のステップの累積（積分）である
- 各ステップを問い直す（step-back）ことで、最適な経路を見つける
- A（開始）からZ（完了）まで、連続的な変換プロセス

---

## 🔄 完全な実行フロー

### Phase 1: Intent Capture（意図捕捉）

```
[Input] → [User Intent] → [Intent Analysis]

Intent = {
  explicit_intent: ユーザーが明示的に述べた要求,
  implicit_intent: 文脈から推測される暗黙の意図,
  want_intent: ユーザーが本当に欲しいもの,
  need_intent: ユーザーが実際に必要なもの
}
```

**例**:
```
User Input: "ディレクトリを整理して"

Explicit Intent: "ディレクトリを整理する"
Implicit Intent: "プロジェクトを見つけやすくしたい"
Want Intent: "きれいなディレクトリ構造"
Need Intent: "効率的な開発環境"
```

### Phase 2: Intent Disambiguation（意図明確化）

```
[Intent Analysis] → [Step-Back Questions] → [Fixed Goal]

Step-Back Questions:
  Q1: "なぜこれが必要なのか？" (Why)
  Q2: "何を達成したいのか？" (What)
  Q3: "どのような状態が理想か？" (How)
  Q4: "制約条件は何か？" (Constraints)
```

**例**:
```
Q1 Answer: "ファイルが散らかっていて見つけにくい"
Q2 Answer: "論理的な階層構造にしたい"
Q3 Answer: "docs/, examples/, src/ のような標準構造"
Q4 Answer: ".claude/ と .codex/ は両方必要"

→ Fixed Goal: "標準的なプロジェクト構造に再編成し、両Agent設定を保持"
```

### Phase 3: Goal Decomposition（目標分解）

```
[Fixed Goal] → [Task Decomposition] → [Task List]

Goal = ∑(Task₁, Task₂, ..., Task_n)

Task Decomposition Process:
  1. Goal Analysis: 目標を構成要素に分解
  2. Dependency Mapping: タスク間の依存関係を特定
  3. Priority Assignment: 優先順位の割り当て
  4. Resource Estimation: 必要なリソース見積もり
```

**例**:
```
Fixed Goal: "標準的なプロジェクト構造に再編成"

→ Tasks:
  Task 1: 現在のディレクトリ構造を分析
  Task 2: 新しい構造を設計
  Task 3: docs/サブディレクトリを作成
  Task 4: ドキュメントファイルを移動
  Task 5: examples/を作成してサンプルを移動
  Task 6: 一時ファイルを削除
  Task 7: .gitignoreを作成
  Task 8: 両Agent設定を同期
```

### Phase 4: Task Execution（タスク実行）

```
[Task List] → [Agent Assignment] → [Execution Loop] → [Result]

For each Task in Task List:
  1. Select Agent: 適切なAgentを選択
  2. Generate Prompt: タスク実行用のプロンプト生成
  3. Assign Tool: 必要なツールを割り当て
  4. Execute: Agentがタスクを実行
  5. Feedback: 結果を検証
  6. Loop: 次のタスクへ or 再実行

Execution Formula:
  Result = Fold(Execute, Tasks, Initial_State)

Where:
  Fold = 畳み込み関数（各タスクを順次適用）
  Execute = タスク実行関数
  Initial_State = World₀
```

**例**:
```
Task 1: "現在のディレクトリ構造を分析"
  → Agent: file-operations-agent
  → Tool: ls, find, tree
  → Prompt: "ディレクトリ構造をスキャンし、問題点を特定"
  → Execute: 構造分析実行
  → Feedback: "15個のMDファイルがルートに散在"
  → Status: Complete ✓

Task 2: "新しい構造を設計"
  → Agent: architecture-planning-agent
  → Tool: design, documentation
  → Prompt: "標準構造を設計（docs/, examples/, src/）"
  → Execute: 設計書作成
  → Feedback: 設計承認
  → Status: Complete ✓

... (Task 3-8 同様に実行)

Final Result: "整理されたディレクトリ構造"
```

---

## 🔗 フレームワーク統合

### Intent Resolution × World Model Logic

```
[Phase 1: Intent Capture] = θ₁ Understand
  Input → Intent → Understanding
  World₀における意図の認識

[Phase 2: Intent Disambiguation] = θ₂ Generate (Part 1)
  Step-Back Questions → Fixed Goal
  明確な目標の生成

[Phase 3: Goal Decomposition] = θ₂ Generate (Part 2) + θ₃ Allocate
  Fixed Goal → Tasks → Agent Assignment
  実行計画の生成とリソース割り当て

[Phase 4: Task Execution] = θ₄ Execute + θ₅ Integrate + θ₆ Learn
  Tasks → Execution Loop → Result → Learning

  各Task実行 = 1回の「瞬き」:
    World₀ → Task₁ → World₁ → Task₂ → World₂ → ... → World_n
```

### Intent Resolution × Command Stack

```
Intent Resolution が「何を」決定し、
Command Stack が「どのように」実行する。

[Intent → Goal] (Intent Resolution)
   ↓
[Goal → Structure] (Command Stack C1)
   ↓
[Structure → Prompts] (Command Stack C2)
   ↓
[Prompts → Execution] (Command Stack C3)
   ↓
[Result]
```

**統合例**:
```
User Input: "APIドキュメントを作成して"

[Intent Resolution]
  Intent: "APIドキュメント作成"
  Step-Back Q: "どんなAPIか？誰が読むのか？"
  Fixed Goal: "RESTful API用のOpenAPI 3.0仕様書作成"
  Tasks: [概要, エンドポイント, スキーマ, 認証, エラー]

[Command Stack]
  [C1] Structure:
    1. API概要
    2. 認証
    3. エンドポイント
       3.1 GET /users
       3.2 POST /users
    4. データモデル
    5. エラーハンドリング

  [C2] Promptify:
    "1. API概要": "API名、バージョン、ベースURLを定義"
    "3.1 GET /users": "ユーザー一覧取得の完全仕様を記述"
    ...

  [C3] Execute:
    CommandRun 1-5 → 各セクション生成 → api-spec.yaml

[World Transformation]
  World₀ (空) → World₅ (完成したAPI仕様)
```

---

## 🎯 Step-Back Method（ステップバック手法）

### 定義

**Step-Back Method**は、目標達成の各ステップで「一歩下がって」本質的な問いを投げかけることで、最適な経路を見つける手法。

### 5つのStep-Back Questions

```
1. Why Step-Back: "なぜこれをするのか？"
   → 目的の明確化

2. What Step-Back: "本当に達成したいことは何か？"
   → 真の目標の発見

3. How Step-Back: "より良い方法はないか？"
   → 最適化の機会

4. When Step-Back: "今やるべきか？"
   → 優先順位の再評価

5. Who Step-Back: "誰がやるべきか？"
   → リソース最適化
```

### 積分的思考

```
∫F(step) = Σ(step₁ + step₂ + ... + step_n)

各ステップは独立ではなく、累積的に目標に近づく。
Step-Backすることで、各ステップの「微分」（変化率）を最適化。

dGoal/dStep = 最大化すべき効率
```

### 実践例

```
Goal: "プロジェクトのパフォーマンスを改善"

Step 1: コードを最適化する
  [Step-Back Q]: "なぜ遅いのか？"
  [Answer]: "データベースクエリが多すぎる"
  [Refined Step 1]: クエリを最適化する

Step 2: クエリを最適化する
  [Step-Back Q]: "より良い方法はないか？"
  [Answer]: "キャッシュを導入すれば根本解決"
  [Refined Step 2]: キャッシュレイヤーを追加

Step 3: キャッシュレイヤーを追加
  [Step-Back Q]: "今やるべきか？"
  [Answer]: "はい、これが最優先"
  [Execute Step 3]: Redis導入

Result: パフォーマンス10倍改善（最適経路の発見）
```

---

## 🛠️ 実装パターン

### Pattern 1: Feedback Loop Pattern

```rust
struct IntentResolution {
    intent: UserIntent,
    goal: Option<Goal>,
    tasks: Vec<Task>,
}

impl IntentResolution {
    fn resolve(&mut self) -> Result<Goal> {
        // Phase 1: Capture
        let intent = self.capture_intent()?;

        // Phase 2: Disambiguate with Step-Back
        let goal = loop {
            let candidate = self.generate_goal(&intent)?;
            let questions = self.step_back_questions(&candidate);

            if self.validate_with_user(questions)? {
                break candidate;
            }
            // Refine intent based on answers
            intent = self.refine_intent(intent, questions)?;
        };

        self.goal = Some(goal);
        Ok(goal)
    }

    fn decompose(&self) -> Vec<Task> {
        let goal = self.goal.as_ref().unwrap();

        // Goal → Tasks with dependency analysis
        let tasks = self.analyze_dependencies(goal);
        self.prioritize_tasks(tasks)
    }

    fn execute(&self) -> Result<ExecutionResult> {
        let tasks = self.decompose();

        // Fold pattern: accumulate World transformations
        tasks.into_iter().fold(
            Ok(World::initial()),
            |world, task| {
                let world = world?;

                // Assign agent
                let agent = self.select_agent(&task);

                // Execute with feedback
                let result = agent.execute(&task, &world)?;

                // Step-back validation
                if !self.validate_step(&result) {
                    return self.retry_with_refinement(&task);
                }

                Ok(world.apply(result))
            }
        )
    }
}
```

### Pattern 2: Command Stack Integration

```typescript
interface IntentResolutionWithCommandStack {
  // Phase 1-2: Intent → Goal
  resolveIntent(input: string): Goal;

  // Phase 3: Goal → Command Stack
  decompose(goal: Goal): CommandStack {
    return {
      c1: this.structurize(goal),     // Goal → Hierarchy
      c2: this.promptify(c1),          // Hierarchy → Prompts
      c3: this.chain(c2)               // Prompts → Execution Plan
    };
  }

  // Phase 4: Execute with World Transformation
  execute(stack: CommandStack): WorldState {
    let world = World.initial();

    for (const command of stack.c3) {
      // Step-back before execution
      const refined = this.stepBack(command, world);

      // Execute (1 blink)
      world = this.executeCommand(refined, world);
    }

    return world;
  }
}
```

---

## 📊 統合アーキテクチャ図

```
User Input
   ↓
[Intent Resolution Framework]
   ├─ Intent Capture (θ₁)
   ├─ Step-Back Questions
   ├─ Goal Fixation (θ₂)
   └─ Task Decomposition (θ₃)
   ↓
[Command Stack]
   ├─ [C1] Structure
   ├─ [C2] Promptify
   └─ [C3] Chain Execute
   ↓
[World Model Logic]
   ├─ World₀ → World₁ (Task 1 - 瞬き)
   ├─ World₁ → World₂ (Task 2 - 瞬き)
   └─ World_n-1 → World_n (Task n - 瞬き)
   ↓
[Orchestrator-Subagent]
   ├─ Agent Assignment
   ├─ Parallel Execution
   └─ Result Integration
   ↓
Final Result (Goal Achieved)
```

---

## 🎓 ベストプラクティス

### 1. Intent Captureの精度向上

```
❌ Bad: "ユーザーの入力をそのまま目標にする"
✅ Good: "Step-Back Questionsで真の意図を掘り下げる"
```

### 2. Goal Fixationの明確性

```
❌ Bad: "ファイルを整理する" (曖昧)
✅ Good: "docs/, examples/, src/の3層構造に再編成し、両Agent設定を保持" (具体的)
```

### 3. Task Decompositionの粒度

```
❌ Bad: "システムを改善する" (粗すぎ)
✅ Good: "1. パフォーマンス測定 → 2. ボトルネック特定 → 3. 最適化実装" (適切)
```

### 4. Feedback Loopの活用

```
各タスク完了後:
  1. 結果を検証
  2. Step-Back Question: "これで目標に近づいたか？"
  3. 必要なら軌道修正
```

---

## 🔗 関連ドキュメント

- `WORLD_MODEL_LOGIC.md` - 世界変換の理論基盤
- `COMMAND_STACK.md` - 実行手法
- `AGENT_SOCIETY.md` - Agent協調実行
- `../CLAUDE.md` - エージェント方程式

---

## 📚 用語集

| 用語 | 定義 |
|------|------|
| Intent | ユーザーの意図（明示的・暗黙的） |
| Fixed Goal | 明確化された目標 |
| Step-Back Question | 本質を問い直す質問 |
| Task Decomposition | 目標をタスクに分解 |
| Feedback Loop | 結果検証と軌道修正 |
| ∫F(step) | ステップの積分（累積実行） |

---

**Note**: Intent Resolution Frameworkは、ユーザーの曖昧な入力から明確な実行可能タスクへの完全な変換プロセスを提供します。World Model LogicとCommand Stackの上位レイヤーとして機能します。
