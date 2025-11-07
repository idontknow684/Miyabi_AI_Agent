# AI Agent Development Framework

**Version**: 2.0.0
**Last Updated**: 2025-11-07
**Author**: Claude Code + Shunsuke Hayashi

完全な自律型AIエージェント開発フレームワーク。**Orchestrator-Subagent Architecture**を実装し、Director-Workerパターンに基づいて複雑なタスクを並列実行します。Claude Codeを基盤とし、Sub-agents、Hooks、Skills、Slash Commandsの4つのコア機能を統合しています。

## ⚡ New in v2.0: Orchestrator-Subagent Architecture

並列実行による**3倍のパフォーマンス向上**を実現する、完全に書き直されたアーキテクチャ。

```
User Request → Orchestrator Agent → Isolated Execution (Parallel)
                                    ├─ Subagent 1
                                    ├─ Subagent 2
                                    └─ Subagent n
                                         ↓
                                   Final Answer (100-200ms)
```

---

## 🎯 プロジェクト概要

このフレームワークは、Claude Codeのエージェント方程式に基づいて構築されています：

```
Agent(Intent, World₀) = lim_{n→∞} (θ₆_{Learn} ◦ θ₅_{Integrate} ◦ θ₄_{Execute} ◦ θ₃_{Allocate} ◦ θ₂_{Generate} ◦ θ₁_{Understand})ⁿ(Intent, World₀)
```

### コア原則

1. **θ₁ Understand**: ユーザーの意図を理解し、タスクを分解
2. **θ₂ Generate**: 実行計画を生成し、適切なツールを選択
3. **θ₃ Allocate**: リソースを割り当て、Sub-agentsに委譲
4. **θ₄ Execute**: 計画に基づいて実行
5. **θ₅ Integrate**: 結果を統合し、一貫性を保つ
6. **θ₆ Learn**: 実行から学習し、次のイテレーションを改善

---

## 📁 プロジェクト構造

```
AI_Agent/
├── CLAUDE.md                              # エージェント方程式の定義
├── README.md                              # このファイル
├── ORCHESTRATOR_ARCHITECTURE.md           # 🆕 アーキテクチャ詳細ガイド
├── QUICKSTART.md                          # 🆕 クイックスタートガイド
│
├── src/
│   └── main.rs                            # Orchestratorデモ
│
├── crates/
│   ├── orchestrator-core/                 # 🆕 Orchestrator実装
│   │   ├── src/
│   │   │   ├── orchestrator.rs           # Orchestrator Agent
│   │   │   ├── subagent.rs               # Subagent trait & 実装
│   │   │   ├── executor.rs               # Isolated Executor
│   │   │   ├── types.rs                  # コアデータ型
│   │   │   └── lib.rs                    # エントリポイント
│   │   └── tests/
│   │       └── integration_test.rs       # 統合テスト
│   │
│   ├── mahjong-core/                      # Mahjong AI (既存)
│   ├── contract-core/                     # Contract Analysis (既存)
│   └── ...                                # その他のcrates
│
└── .claude/
    ├── orchestrator-architecture.puml     # 🆕 アーキテクチャ図
    ├── orchestrator-execution-flow.puml   # 🆕 実行フロー図
    ├── orchestrator-state-machine.puml    # 🆕 状態機械図
    ├── subagent-isolation.puml            # 🆕 分離環境図
    │
    ├── MCP_INTEGRATION.md                 # MCP統合ガイド
    ├── agents/                            # Sub-agentsの定義
    ├── hooks/                             # Hooksの定義
    ├── skills/                            # Skillsの定義
    ├── commands/                          # Slash Commandsの定義
    ├── agent-lifecycle.puml               # メインエージェントライフサイクル
    ├── agent-state-machine.puml           # エージェント状態機械
    ├── system-overview.puml               # システム全体図
    ├── mcp-integration.puml               # MCP統合アーキテクチャ
    └── mcp-usage-flow.puml                # MCP使用フロー
```

---

## 🚀 クイックスタート

### 前提条件

- **Rust 2021 Edition** (必須)
- Claude Code CLI (推奨)
- Node.js 18+ (MCP stdio サーバー用)
- Git

### インストール & 実行

```bash
# ビルド (Release mode)
cargo build --release

# テスト実行
cargo test

# Orchestratorデモ実行
cargo run --release
```

**出力例:**
```
Starting Orchestrator-Subagent System
=====================================

✓ Registered 3 subagents

Processing user request: Analyze the codebase...
Final Answer for request: ...

Total execution time: 202ms
```

### 📖 詳しい使い方

**完全なクイックスタートガイド**: [QUICKSTART.md](QUICKSTART.md)

### Claude Code統合

```bash
# Claude Codeを起動
claude

# Sub-agents一覧を表示
/agents

# 利用可能なMCPサーバーを確認
/mcp

# Slash Commands一覧
/commands
```

---

## 🎭 主要機能

### 1. Sub-agents（サブエージェント）

複雑なタスクを専門的なSub-agentsに委譲して並列実行。

**組み込みSub-agents:**
- **general-purpose**: 汎用的なマルチステップタスク
- **Explore**: コードベース探索（quick/medium/very thorough）
- **Plan**: アーキテクチャ計画とタスク分解

**カスタムSub-agents:**
- **legal-document-analyzer**: 契約書・法律文書の包括分析
- **contract-reviewer**: ビジネス契約のレビューと交渉戦略
- **compliance-gap-analyzer**: 法律と実運用の乖離分析
- **design-director**: 複数ワーカーの調整（Lovartスタイル）

**詳細**: [.claude/agents/readme.md](.claude/agents/readme.md)

### 2. Hooks（フック）

イベント駆動型の自動化を実現。

**主要Hookタイプ:**
- **PreToolUse**: ツール実行前（検証・ブロック可能）
- **PostToolUse**: ツール実行後（フォーマット・通知）
- **UserPromptSubmit**: プロンプト送信時
- **Notification**: 通知イベント時
- **Stop**: エージェント停止時

**使用例:**
- コミット前のLintチェック
- ファイル書き込み前のバックアップ
- Markdown自動フォーマット
- デスクトップ通知

**詳細**: [.claude/hooks/readme.md](.claude/hooks/readme.md)

### 3. Skills（スキル）

ドメイン特化の専門知識をパッケージ化。

**主要Skills:**
- **PDF Processing**: PDF読み取り・生成・フォーム入力
- **Excel Processing**: スプレッドシート分析・ピボットテーブル
- **API Testing**: REST APIテスト・検証
- **Code Review**: コード品質・セキュリティレビュー

**Skills構造:**
```
skill-name/
├── SKILL.md           # メイン定義（必須）
├── reference.md       # 詳細リファレンス
├── examples.md        # 使用例
└── scripts/          # ヘルパースクリプト
```

**詳細**: [.claude/skills/readme.md](.claude/skills/readme.md)

### 4. Slash Commands（スラッシュコマンド）

繰り返し実行される定型タスクをコマンド化。

**主要Commands:**
- **/review-pr**: GitHub PRのコードレビュー
- **/test**: テスト実行と失敗修正
- **/deploy**: 環境へのデプロイ
- **/refactor**: コードリファクタリング
- **/docs**: ドキュメント生成

**Command構造:**
```markdown
---
description: "コマンドの説明"
---

# プロンプトテンプレート
コマンド実行時に展開される指示
```

**詳細**: [.claude/commands/readme.md](.claude/commands/readme.md)

---

## 🔌 MCP統合

Model Context Protocol (MCP)により、100以上の外部サービスと統合可能。

### 主要MCPサーバー

**Development & Testing:**
- Sentry（エラー監視）
- Socket（セキュリティ分析）
- Jam（デバッグ録画）

**Project Management:**
- Asana、Atlassian、Linear、Notion

**Databases & Data:**
- Airtable、HubSpot、Daloopa

**Payments & Commerce:**
- Stripe、PayPal、Square

**Design & Media:**
- Figma、Canva、invideo

**Infrastructure & DevOps:**
- Cloudflare、Netlify、Vercel

**Automation:**
- Zapier、Workato

### MCP使用例

```bash
# GitHub MCPサーバーを追加
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 認証
/mcp

# リソース参照
> @github:issue://123 を分析して修正を提案して

# プロンプト実行
> /mcp__github__pr_review 456
```

**詳細**: [.claude/MCP_INTEGRATION.md](.claude/MCP_INTEGRATION.md)

---

## 📊 アーキテクチャ図

### システム全体図

![System Overview](.claude/system-overview.puml)

### エージェントライフサイクル

![Agent Lifecycle](.claude/agent-lifecycle.puml)

### 状態機械

![State Machine](.claude/agent-state-machine.puml)

### MCP統合

![MCP Integration](.claude/mcp-integration.puml)

全てのPlantUML図は`.claude/`ディレクトリ内にあります。

---

## 🎓 使用例

### 例1: 契約書の包括分析

```
> 法律文書分析エージェントを使って、contracts/nda.pdf を分析して

[legal-document-analyzer sub-agentが自動起動]
→ 文書構造分析
→ 重要条項の特定
→ リスク評価
→ レッドフラグ検出
→ 包括的な分析レポート生成
```

### 例2: コンプライアンスギャップ分析

```
> GDPR準拠状況を確認して、実運用との乖離を分析して

[compliance-gap-analyzer sub-agentが自動起動]
→ GDPR要件のマッピング
→ コード・システム分析
→ ギャップの特定（5つのタイプ分類）
→ ルートコーズ分析
→ 是正計画の提案
```

### 例3: デザインプロジェクトの調整

```
> 新しいダッシュボードUIを設計・実装して

[design-director sub-agentが自動起動]
→ プロジェクトを4つのワークストリームに分解
→ Designer Worker: UIモックアップ作成
→ Frontend Worker: React実装（並列）
→ UX Researcher: ユーザーテスト（並列）
→ QA Worker: 品質テスト
→ 成果物の統合と最終レビュー
```

### 例4: MCPを活用したワークフロー

```
> JIRAのENG-123を実装してGitHubにPRを作成

[MCPサーバー連携]
→ @jira:issue://ENG-123 からissue詳細取得
→ 仕様に基づいてコード実装
→ GitHub MCPでPR作成
→ 実装完了！
```

---

## 🛠️ 開発ガイド

### カスタムSub-agentの作成

```bash
# プロジェクトレベル
mkdir -p .claude/agents
cat > .claude/agents/my-agent.md << 'EOF'
---
name: my-agent
description: 専門的なタスクの説明
tools: Read, Write, Bash
model: opus
---

# My Custom Agent

エージェントの動作を定義...
EOF
```

### カスタムHookの追加

```bash
# /hooks コマンドを実行してGUIで追加
/hooks

# または、設定ファイルを直接編集
~/.claude/settings.json
```

### カスタムSkillの作成

```bash
mkdir -p .claude/skills/my-skill
cat > .claude/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: スキルの説明と使用タイミング
---

# My Skill

スキルの詳細...
EOF
```

### カスタムSlash Commandの作成

```bash
mkdir -p .claude/commands
cat > .claude/commands/my-command.md << 'EOF'
---
description: "コマンドの説明"
---

# コマンドプロンプト

実行内容...
EOF
```

---

## 📚 ドキュメント

### コアドキュメント

- [CLAUDE.md](CLAUDE.md) - エージェント方程式の定義
- [Sub-agents README](.claude/agents/readme.md) - Sub-agents完全ガイド
- [Hooks README](.claude/hooks/readme.md) - Hooks完全ガイド
- [Skills README](.claude/skills/readme.md) - Skills完全ガイド
- [Commands README](.claude/commands/readme.md) - Commands完全ガイド
- [MCP Integration](.claude/MCP_INTEGRATION.md) - MCP統合ガイド

### 🌐 Detail Control Documentation (New!)

**完全ガイド**: [Claude Codeでのディテールレベル制御](docs/index.md)

Claude CodeのTask tool（sub-agents）使用時に、詳細度や自律性をどのように制御するかを解説したドキュメントサイト：

- **[Controlling Detail Levels - 完全ガイド](docs/guides/controlling-detail-levels.md)**
  - Architecture comparison（Claude Code vs Phil Schmid's approaches）
  - Control mechanisms（agent types, thoroughness, tools）
  - Detail level configuration methods
  - Best practices & advanced patterns

- **[Detail Control Examples - 実践例](docs/examples/detail-control-examples.md)**
  - Real-world scenarios（onboarding, bug hunting, audits）
  - Code snippets & patterns
  - CLI usage examples
  - Configuration files
  - Troubleshooting guide

**🚀 Deployment**: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)でVercelへのデプロイ方法を解説

### アーキテクチャ図

全てのPlantUML図は`.claude/`ディレクトリ内：

**構造図:**
- `agents/structure.puml` - Sub-agents構造
- `hooks/structure.puml` - Hooks構造
- `skills/structure.puml` - Skills構造
- `commands/structure.puml` - Commands構造

**ライフサイクル図:**
- `agent-lifecycle.puml` - メインエージェント
- `agents/lifecycle.puml` - Sub-agent実行
- `hooks/lifecycle.puml` - Hook実行
- `skills/lifecycle.puml` - Skill実行
- `commands/lifecycle.puml` - Command実行

**システム図:**
- `system-overview.puml` - システム全体
- `agent-state-machine.puml` - 状態機械
- `mcp-integration.puml` - MCP統合
- `mcp-usage-flow.puml` - MCP使用フロー

---

## 🔐 セキュリティ

### Hooksのセキュリティ

- Hookスクリプトは実行権限が必要: `chmod +x script.sh`
- 信頼できないコマンドは実行しない
- 環境変数の検証を実施
- `failureMode`を適切に設定（error/warn/ignore）

### MCPのセキュリティ

- サードパーティMCPサーバーは自己責任で使用
- OAuth認証を使用（静的キーを避ける）
- エンタープライズ環境では`allowedMcpServers`でホワイトリスト化
- `deniedMcpServers`でブラックリスト化

### Sub-agentsのセキュリティ

- `tools`フィールドで利用可能なツールを制限
- 機密データへのアクセスが必要なSub-agentsは慎重に設計
- プロジェクトレベルとユーザーレベルで適切にスコープ分け

---

## 🤝 貢献

このプロジェクトへの貢献を歓迎します！

### 貢献方法

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-agent`)
3. 変更をコミット (`git commit -m 'Add amazing agent'`)
4. ブランチにプッシュ (`git push origin feature/amazing-agent`)
5. Pull Requestを作成

### 貢献できる領域

- 新しいSub-agentsの追加
- 業界特化のSkills開発
- 便利なHooksの共有
- ドキュメントの改善
- バグ修正

---

## 📝 ライセンス

このプロジェクトは研究・教育目的で公開されています。

---

## 🙏 謝辞

- **Anthropic**: Claude Code CLIと優れたドキュメント
- **MCP Community**: 豊富なMCPサーバーエコシステム
- **Lovart**: ディレクター・ワーカーモデルのインスピレーション

---

## 📞 サポート

質問や問題がある場合：

1. [Discord - Miyabi](https://discord.gg/ZpY9sxfYNm) - AIエージェント開発コミュニティ（リアルタイムサポート）
2. [ドキュメント](.claude/)を確認
3. [Issue](https://github.com/your-repo/issues)を作成
4. [Claude Code公式ドキュメント](https://docs.claude.com/en/docs/claude-code)を参照

---

## 🔄 更新履歴

### Version 1.0.0 (2025-11-06)

**追加:**
- 完全なSub-agentsフレームワーク
- Hooks統合とサンプル
- Skills定義テンプレート
- Slash Commands構造
- MCP統合ガイド
- 包括的なPlantUML図
- 専門的なSub-agents（法律文書分析、コンプライアンス、デザインディレクター）

**ドキュメント:**
- 全機能の完全ドキュメント
- アーキテクチャ図（PlantUML）
- ライフサイクルフロー図
- 実践的な使用例

---

**Built with ❤️ using Claude Code**
