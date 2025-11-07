# .claude/ - Claude Code Configuration Directory

**Last Updated**: 2025-11-07
**Version**: 2.0.0

このディレクトリは、Claude Code Agent用の設定・カスタマイズファイルを格納します。

---

## 📁 ディレクトリ構造

```
.claude/
├── readme.md                        # このファイル
├── AGENT_SOCIETY.md                 # Agent Society アーキテクチャ
├── MCP_INTEGRATION.md               # MCP統合ガイド
│
├── agents/                          # Specialized Sub-agents
│   ├── readme.md
│   ├── 3d-designer.md              # Three.js専門家
│   ├── game-creator.md             # ゲーム開発専門家
│   ├── mahjong-master.md           # 麻雀AI統括
│   ├── opponent-hand-reader.md     # 対戦相手分析
│   ├── tile-efficiency-analyzer.md # 牌効率計算
│   ├── slide-generator.md          # スライド生成
│   ├── design-director.md          # デザインプロジェクト統括
│   ├── ui-ux-reviewer.md           # UI/UXレビュー
│   ├── legal-document-analyzer.md  # 法務文書分析
│   ├── contract-reviewer.md        # 契約書レビュー
│   └── compliance-gap-analyzer.md  # コンプライアンスギャップ分析
│
├── societies/                       # Agent Society定義
│   ├── mahjong-society.yaml        # 麻雀AI Society
│   └── content-production-society.yaml
│
├── commands/                        # Slash Commands
│   └── readme.md
│
├── hooks/                           # Lifecycle Hooks
│   └── readme.md
│
├── skills/                          # Reusable Skills
│   └── readme.md
│
└── *.puml                          # Architecture Diagrams
    ├── orchestrator-architecture.puml
    ├── orchestrator-execution-flow.puml
    ├── orchestrator-state-machine.puml
    ├── agent-lifecycle.puml
    ├── agent-state-machine.puml
    ├── mcp-integration.puml
    ├── subagent-isolation.puml
    ├── system-overview.puml
    └── before-after-comparison.puml
```

---

## 🎯 主要コンポーネント

### 1. Specialized Sub-agents (`agents/`)

タスク特化型のサブエージェント定義。各エージェントは独立した専門知識を持ちます。

**カテゴリ:**

#### 🎮 ゲーム・3D開発
- `3d-designer.md` - Three.js専門家（3Dシーン、WebGL）
- `game-creator.md` - ゲーム開発統括（企画→実装→バランス調整）

#### 🀄 麻雀AI
- `mahjong-master.md` - 麻雀AI統括（戦略最適化）
- `opponent-hand-reader.md` - 捨て牌読み専門家
- `tile-efficiency-analyzer.md` - 牌効率計算専門家

#### 📊 コンテンツ制作
- `slide-generator.md` - スライド生成（オンラインコース、プレゼン）
- `design-director.md` - デザインプロジェクト統括

#### ⚖️ 法務・コンプライアンス
- `legal-document-analyzer.md` - 法務文書分析
- `contract-reviewer.md` - 契約書レビュー
- `compliance-gap-analyzer.md` - 法規制ギャップ分析

#### 🎨 UI/UX
- `ui-ux-reviewer.md` - インターフェース設計レビュー

### 2. Agent Societies (`societies/`)

複数のエージェントを協調動作させるSociety定義（YAML形式）。

**利用可能なSocieties:**
- `mahjong-society.yaml` - 麻雀AI Society（Master + HandReader + TileAnalyzer）
- `content-production-society.yaml` - コンテンツ制作Society

### 3. Slash Commands (`commands/`)

カスタムスラッシュコマンド定義。

**使い方:**
```bash
/your-command [args]
```

### 4. Hooks (`hooks/`)

エージェントライフサイクルフック。

**利用可能なフック:**
- `before-task` - タスク実行前
- `after-task` - タスク実行後
- `on-error` - エラー発生時

### 5. Skills (`skills/`)

再利用可能なスキル定義。

---

## 🏗️ アーキテクチャ図 (PlantUML)

### システム全体
- `orchestrator-architecture.puml` - Orchestrator-Subagent アーキテクチャ
- `system-overview.puml` - システム全体概要
- `before-after-comparison.puml` - v1.0とv2.0の比較

### 実行フロー
- `orchestrator-execution-flow.puml` - Orchestratorの実行フロー
- `orchestrator-state-machine.puml` - Orchestrator状態マシン
- `agent-lifecycle.puml` - Agent ライフサイクル
- `agent-state-machine.puml` - Agent 状態マシン

### 統合
- `mcp-integration.puml` - MCP統合フロー
- `subagent-isolation.puml` - サブエージェント分離

**図の生成:**
```bash
# PlantUMLをインストール
brew install plantuml

# PNG生成
plantuml .claude/*.puml

# SVG生成
plantuml -tsvg .claude/*.puml
```

---

## 🚀 使用方法

### Sub-agentの呼び出し

Claude Codeは、タスクに応じて自動的に適切なSub-agentを起動します。

**例:**
```
User: "Three.jsで3Dキューブを回転させて"
→ Claude Codeが自動的に `3d-designer` agentを起動

User: "この契約書をレビューして"
→ Claude Codeが自動的に `contract-reviewer` agentを起動
```

### Agent Societyの活用

複雑なタスクは複数のAgentが協調して処理します。

**例（麻雀AI）:**
```
User: "この局面の最善手を教えて"
→ mahjong-society起動
  ├─ tile-efficiency-analyzer: 牌効率計算
  ├─ opponent-hand-reader: 対戦相手分析
  └─ mahjong-master: 戦略統合・最終決定
```

---

## 📖 関連ドキュメント

### プロジェクトルート
- `../README.md` - プロジェクト全体概要
- `../CLAUDE.md` - エージェント方程式定義
- `../docs/QUICKSTART.md` - クイックスタートガイド
- `../docs/architecture-docs/ORCHESTRATOR_ARCHITECTURE.md` - アーキテクチャ詳細

### 詳細ガイド
- `AGENT_SOCIETY.md` - Agent Society設計原則
- `MCP_INTEGRATION.md` - MCP統合ガイド
- `agents/readme.md` - エージェント一覧

---

## 🔧 カスタマイズ

### 新しいSub-agentの追加

1. `agents/`に新しいMarkdownファイルを作成
2. エージェント定義を記述
3. Claude Codeが自動的に認識

### 新しいSocietyの定義

1. `societies/`に新しいYAMLファイルを作成
2. 協調するエージェントを定義
3. タスク分担・統合方法を記述

---

## 🔄 同期

`.codex/`ディレクトリと同期されています（Codex Agent用）。
両ディレクトリは同じ構造・内容を保持します。

---

**Note**: このディレクトリは Claude Code が自動的に参照します。
変更はプロジェクト全体のエージェント挙動に影響します。
