---
name: Agent Society Framework
version: 1.0.0
description: Multi-agent orchestration framework inspired by human organizations and societies
---

# Agent Society Framework

エージェント「ソサイエティ」は、複数の専門エージェントが協調して動作する組織構造です。人間の社会組織（企業、チーム、コミュニティ）からインスピレーションを得ています。

---

## 🏛️ ソサイエティの概念

### 人間社会のメタファー

```
人間社会                  → エージェントソサイエティ
├─ CEO/経営層           → Director Agent (orchestrator)
├─ 部門マネージャー      → Manager Agents (coordinators)
├─ 専門家/実務者        → Worker Agents (specialists)
├─ コミュニケーション    → Message Passing (tmux, files, APIs)
├─ 組織文化            → Shared Context (CLAUDE.md, policies)
└─ 意思決定プロセス     → Consensus Algorithms
```

### ソサイエティの階層構造

```
┌─────────────────────────────────────┐
│         Orchestrator Layer          │  ← 戦略・調整
│   (Director, Coordinator Agents)    │
├─────────────────────────────────────┤
│         Management Layer            │  ← 管理・監督
│    (Manager, Supervisor Agents)     │
├─────────────────────────────────────┤
│          Worker Layer               │  ← 実行・専門
│  (Specialist, Expert, Tool Agents)  │
├─────────────────────────────────────┤
│        Communication Layer          │  ← 通信・調整
│     (Message Bus, Event System)     │
└─────────────────────────────────────┘
```

---

## 🎭 ソサイエティの役割（Roles）

### 1. Orchestrator Agents（オーケストレーター）

**責任**:
- 全体戦略の立案
- リソース配分
- 優先順位付け
- 品質保証

**エージェント例**:
- `design-director`: デザインプロジェクト全体の指揮
- `project-coordinator`: 複数プロジェクトの調整
- `resource-allocator`: エージェント間のリソース配分

### 2. Manager Agents（マネージャー）

**責任**:
- チーム管理
- タスク割り当て
- 進捗監視
- 問題エスカレーション

**エージェント例**:
- `team-lead`: 特定チーム（フロントエンド、バックエンド等）のリード
- `sprint-manager`: スプリント管理
- `qa-manager`: 品質管理プロセスの監督

### 3. Worker Agents（ワーカー）

**責任**:
- 専門タスクの実行
- 成果物の作成
- 報告

**エージェント例**:
- `designer-worker`: UIデザイン作成
- `frontend-worker`: フロントエンド実装
- `tester-worker`: テスト実行
- `documentation-worker`: ドキュメント作成

### 4. Specialist Agents（スペシャリスト）

**責任**:
- 高度に専門的なタスク
- コンサルティング
- 検証・レビュー

**エージェント例**:
- `legal-document-analyzer`: 法律文書分析
- `security-auditor`: セキュリティ監査
- `performance-optimizer`: パフォーマンス最適化

---

## 🔄 通信パターン

### Pattern 1: Hierarchical (階層型)

```
Director
   ├─→ Manager A
   │     ├─→ Worker A1
   │     └─→ Worker A2
   └─→ Manager B
         ├─→ Worker B1
         └─→ Worker B2
```

**特徴**:
- 明確な指揮系統
- スケーラブル
- 責任範囲が明確

**使用例**: 大規模プロジェクト、複雑な組織構造

### Pattern 2: Peer-to-Peer (対等型)

```
Agent A ←→ Agent B
   ↕         ↕
Agent C ←→ Agent D
```

**特徴**:
- フラットな構造
- 直接通信
- 柔軟性が高い

**使用例**: 小規模チーム、協調タスク

### Pattern 3: Hub-and-Spoke (ハブ・スポーク型)

```
      Worker A
         ↑
Worker B ← Director → Worker C
         ↓
      Worker D
```

**特徴**:
- 中央集権的
- 統制が容易
- ボトルネックになりうる

**使用例**: 調整が重要なプロジェクト

### Pattern 4: Event-Driven (イベント駆動型)

```
Event Bus
  ↕   ↕   ↕
Agent A B C
```

**特徴**:
- 疎結合
- スケーラブル
- 非同期処理

**使用例**: リアルタイムシステム、大規模分散

---

## 🏗️ ソサイエティの構成例

### Example 1: Software Development Society

```yaml
society_name: "full-stack-dev-team"
purpose: "Complete software development lifecycle"

roles:
  orchestrator:
    - name: "tech-lead"
      agent: "design-director"
      responsibility: "Overall project coordination"

  managers:
    - name: "frontend-lead"
      agent: "frontend-manager"
      manages: ["ui-designer", "react-developer"]

    - name: "backend-lead"
      agent: "backend-manager"
      manages: ["api-developer", "database-admin"]

  workers:
    - name: "ui-designer"
      agent: "designer-worker"
      specialty: "UI/UX design"

    - name: "react-developer"
      agent: "frontend-worker"
      specialty: "React development"

    - name: "api-developer"
      agent: "backend-worker"
      specialty: "API implementation"

    - name: "database-admin"
      agent: "database-worker"
      specialty: "Database design"

  specialists:
    - name: "security-expert"
      agent: "security-auditor"
      consultancy: true

    - name: "performance-expert"
      agent: "performance-optimizer"
      consultancy: true

communication:
  type: "hierarchical"
  message_bus: "tmux"
  shared_context: ".claude/shared/"
```

### Example 2: Legal Analysis Society

```yaml
society_name: "legal-analysis-team"
purpose: "Comprehensive legal document review"

roles:
  orchestrator:
    - name: "chief-legal-analyst"
      agent: "legal-coordinator"
      responsibility: "Coordinate all legal analysis"

  specialists:
    - name: "contract-analyst"
      agent: "contract-reviewer"
      specialty: "Contract review and negotiation"

    - name: "compliance-analyst"
      agent: "compliance-gap-analyzer"
      specialty: "Compliance gap analysis"

    - name: "document-analyst"
      agent: "legal-document-analyzer"
      specialty: "Legal document analysis"

communication:
  type: "peer-to-peer"
  message_bus: "files"
  shared_context: "contracts/"
```

### Example 3: Design System Society

```yaml
society_name: "design-system-team"
purpose: "Build and maintain design system"

roles:
  orchestrator:
    - name: "design-director"
      agent: "design-director"
      responsibility: "Design system strategy"

  workers:
    - name: "component-designer"
      agent: "designer-worker"
      specialty: "Component design"
      parallel: true

    - name: "component-developer"
      agent: "frontend-worker"
      specialty: "Component implementation"
      parallel: true

    - name: "accessibility-specialist"
      agent: "a11y-worker"
      specialty: "Accessibility testing"

    - name: "documentation-writer"
      agent: "docs-worker"
      specialty: "Documentation"

communication:
  type: "hub-and-spoke"
  message_bus: "tmux"
  sync_method: "git"
```

---

## 🔧 ソサイエティの実装

### tmux-based Implementation

```bash
# Launch software development society
./scripts/tools/tmux-orchestrator.sh parallel \
  "tech-lead:Coordinate the development of user dashboard" \
  "ui-designer:Create dashboard mockups" \
  "react-developer:Implement dashboard components" \
  "api-developer:Build dashboard API endpoints"

# Sequential workflow
./scripts/tools/tmux-orchestrator.sh sequential \
  "legal-analyst:Analyze contract terms" \
  "compliance-analyst:Check regulatory compliance" \
  "contract-reviewer:Generate negotiation strategy"

# Pipeline workflow
./scripts/tools/tmux-orchestrator.sh pipeline \
  "researcher:Gather user requirements" \
  "designer:Create mockups from requirements" \
  "developer:Implement design" \
  "qa:Test implementation"
```

### File-based Communication

```bash
# Shared context directory
.claude/shared/
├── context.json          # Shared context
├── tasks/                # Task definitions
│   ├── task-001.json
│   └── task-002.json
├── results/              # Agent outputs
│   ├── designer-output.json
│   └── developer-output.json
└── messages/             # Inter-agent messages
    ├── from-designer.txt
    └── from-developer.txt
```

### API-based Communication (Future)

```json
{
  "agent_society_api": {
    "endpoints": {
      "post_task": "/api/tasks",
      "get_status": "/api/agents/{id}/status",
      "send_message": "/api/messages",
      "get_results": "/api/results/{task_id}"
    }
  }
}
```

---

## 🎯 ソサイエティのユースケース

### Use Case 1: Full-Stack Feature Development

```markdown
## Scenario
新機能「ユーザーダッシュボード」の開発

## Society Structure
- **Orchestrator**: tech-lead (design-director)
- **Frontend Team**:
  - ui-designer (designer-worker)
  - react-developer (frontend-worker)
- **Backend Team**:
  - api-developer (backend-worker)
  - database-admin (database-worker)
- **QA Team**:
  - qa-tester (qa-worker)

## Workflow
1. **Phase 1: Planning** (Orchestrator)
   - Decompose feature into tasks
   - Assign to teams
   - Set dependencies

2. **Phase 2: Design & API** (Parallel)
   - ui-designer: Create mockups
   - api-developer: Design API spec

3. **Phase 3: Implementation** (Parallel, after Phase 2)
   - react-developer: Implement UI
   - api-developer: Implement API
   - database-admin: Set up DB schema

4. **Phase 4: Integration & QA**
   - Integrate frontend + backend
   - qa-tester: Run tests

5. **Phase 5: Review & Deploy** (Orchestrator)
   - Review all outputs
   - Deploy to staging
```

### Use Case 2: Legal Document Review

```markdown
## Scenario
M&A契約書の包括的レビュー

## Society Structure
- **Orchestrator**: chief-legal-analyst
- **Specialists**:
  - contract-analyst (contract-reviewer)
  - compliance-analyst (compliance-gap-analyzer)
  - document-analyst (legal-document-analyzer)

## Workflow
1. **Parallel Analysis**
   - contract-analyst: Business terms review
   - compliance-analyst: Regulatory compliance check
   - document-analyst: Comprehensive legal analysis

2. **Synthesis** (Orchestrator)
   - Combine all findings
   - Identify conflicts
   - Prioritize issues

3. **Strategy Development** (contract-analyst)
   - Negotiation strategy
   - Fallback positions

4. **Final Report** (Orchestrator)
   - Executive summary
   - Detailed recommendations
```

### Use Case 3: Design System Overhaul

```markdown
## Scenario
既存デザインシステムの全面刷新

## Society Structure
- **Orchestrator**: design-director
- **Design Team**:
  - component-designer-1, 2, 3 (parallel)
- **Dev Team**:
  - component-developer-1, 2, 3 (parallel)
- **Specialists**:
  - accessibility-specialist
  - documentation-writer

## Workflow
1. **Inventory & Audit** (design-director)
   - Current components
   - Usage patterns
   - Pain points

2. **Parallel Design** (component-designers)
   - Designer 1: Navigation components
   - Designer 2: Form components
   - Designer 3: Data display components

3. **Parallel Implementation** (component-developers)
   - Dev 1: Navigation
   - Dev 2: Forms
   - Dev 3: Data display

4. **Continuous QA** (accessibility-specialist)
   - Review each component
   - Ensure WCAG compliance

5. **Documentation** (documentation-writer)
   - Component docs
   - Usage guidelines
   - Migration guide
```

---

## 📊 ソサイエティのメトリクス

### Performance Metrics

```yaml
metrics:
  efficiency:
    - parallel_execution_ratio: 0.75  # 75% of tasks run in parallel
    - idle_time_percentage: 0.15      # 15% idle time
    - task_throughput: 50             # Tasks per day

  quality:
    - error_rate: 0.05                # 5% error rate
    - rework_ratio: 0.10              # 10% rework
    - review_pass_rate: 0.90          # 90% pass first review

  collaboration:
    - handoff_smoothness: 0.85        # 85% smooth handoffs
    - communication_overhead: 0.20     # 20% time in communication
    - consensus_time: "2 hours"       # Avg time to reach consensus

  resource_utilization:
    - agent_utilization: 0.80         # 80% active time
    - compute_efficiency: 0.70        # 70% compute utilized
    - cost_per_task: "$5"             # Average cost
```

### Health Indicators

```markdown
## Society Health Dashboard

### Green (Healthy)
- ✅ All agents responding
- ✅ Tasks completing on time
- ✅ Low error rate
- ✅ Good communication

### Yellow (Attention Needed)
- ⚠️ Some delays in handoffs
- ⚠️ Higher than normal rework
- ⚠️ Communication bottlenecks

### Red (Critical)
- 🔴 Agent failures
- 🔴 Blocked dependencies
- 🔴 Quality issues
- 🔴 Communication breakdown
```

---

## 🚀 Best Practices

### Society Design

1. **Clear Roles**: Each agent has well-defined responsibilities
2. **Minimal Hierarchy**: Keep layers minimal for speed
3. **Autonomous Teams**: Enable self-organization where possible
4. **Shared Context**: Maintain common understanding
5. **Explicit Protocols**: Define communication patterns

### Orchestration

1. **Parallel by Default**: Maximize parallelism
2. **Smart Dependencies**: Only sequential when necessary
3. **Quick Handoffs**: Minimize idle time
4. **Async Communication**: Don't block on responses
5. **Graceful Degradation**: Handle agent failures

### Communication

1. **Message Standards**: Consistent message formats
2. **State Management**: Track shared state carefully
3. **Event Logging**: Log all significant events
4. **Error Handling**: Clear error propagation
5. **Feedback Loops**: Regular status updates

---

## 🔮 Future Enhancements

### Planned Features

- **Dynamic Scaling**: Add/remove agents based on load
- **Self-Healing**: Automatic recovery from failures
- **Learning**: Society learns from past executions
- **Reputation System**: Track agent performance
- **Market Mechanisms**: Resource allocation via bidding
- **Governance**: Democratic decision-making

---

## 📝 Society Configuration Files

### society.yaml

```yaml
name: "my-agent-society"
version: "1.0.0"
description: "Complete software development society"

orchestrator:
  type: "design-director"
  name: "tech-lead"

managers:
  - type: "team-manager"
    name: "frontend-lead"
    team: "frontend"

  - type: "team-manager"
    name: "backend-lead"
    team: "backend"

workers:
  frontend:
    - type: "designer-worker"
      name: "ui-designer"
      parallel: true

    - type: "frontend-worker"
      name: "react-dev"
      parallel: true

  backend:
    - type: "backend-worker"
      name: "api-dev"
      parallel: true

    - type: "database-worker"
      name: "db-admin"
      parallel: true

communication:
  method: "tmux"
  shared_dir: ".claude/shared"
  sync_interval: "5s"

policies:
  max_parallel_agents: 10
  timeout_per_task: "30m"
  retry_on_failure: 3
```

---

**Remember**: A well-designed agent society is more than the sum of its parts. The key is effective coordination, clear communication, and shared purpose.

*"Alone we can do so little; together we can do so much."* - Helen Keller
