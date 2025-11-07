# Model Context Protocol (MCP) Integration Guide

**Last Updated**: 2025-11-06
**Version**: 1.0.0

このドキュメントでは、Claude CodeにおけるModel Context Protocol (MCP)の統合方法と活用法を説明します。

---

## 📚 概要

Model Context Protocol (MCP)は、AI-ツール統合のためのオープンスタンダードです。MCPサーバーを通じて、Claude Codeは数百の外部ツールやデータソースに接続できます。

### MCPでできること

- **Issue Trackerからの機能実装**: "JIRAのENG-4521の機能を実装してGitHubにPRを作成して"
- **モニタリングデータの分析**: "SentryとStatsigで機能ENG-4521の使用状況を確認して"
- **データベースクエリ**: "機能ENG-4521を使用した10人のランダムユーザーのメールをPostgresから取得して"
- **デザイン統合**: "Slackに投稿された新しいFigmaデザインに基づいて標準メールテンプレートを更新して"
- **ワークフロー自動化**: "この10人のユーザーに新機能のフィードバックセッションへの招待Gmailドラフトを作成して"

---

## 🎯 主要なMCPサーバー

### Development & Testing Tools

| サーバー | 説明 | コマンド例 |
|---------|------|-----------|
| **Sentry** | エラー監視、本番環境デバッグ | `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` |
| **Socket** | 依存関係のセキュリティ分析 | `claude mcp add --transport http socket https://mcp.socket.dev/` |
| **Hugging Face** | Hugging Face Hubとその情報へのアクセス | `claude mcp add --transport http huggingface https://huggingface.co/mcp` |
| **Jam** | Jam録画を使用した高速デバッグ | `claude mcp add --transport http jam https://mcp.jam.dev/mcp` |

### Project Management & Documentation

| サーバー | 説明 | コマンド例 |
|---------|------|-----------|
| **Asana** | Asanaワークスペースと対話 | `claude mcp add --transport sse asana https://mcp.asana.com/sse` |
| **Atlassian** | JiraチケットとConfluenceドキュメント管理 | `claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse` |
| **ClickUp** | タスク管理、プロジェクト追跡 | `claude mcp add --transport stdio clickup --env CLICKUP_API_KEY=YOUR_KEY --env CLICKUP_TEAM_ID=YOUR_TEAM_ID -- npx -y @hauptsache.net/clickup-mcp` |
| **Intercom** | リアルタイム顧客会話、チケット、ユーザーデータ | `claude mcp add --transport http intercom https://mcp.intercom.com/mcp` |
| **Linear** | Linearのissue tracking、プロジェクト管理 | `claude mcp add --transport http linear https://mcp.linear.app/mcp` |
| **Notion** | ドキュメント読み取り、ページ更新、タスク管理 | `claude mcp add --transport http notion https://mcp.notion.com/mcp` |
| **Box** | エンタープライズコンテンツ、非構造化データからのインサイト | `claude mcp add --transport http box https://mcp.box.com/` |
| **Fireflies** | 会議の文字起こしとサマリーからの洞察抽出 | `claude mcp add --transport http fireflies https://api.fireflies.ai/mcp` |
| **Monday** | monday.comボード管理 | `claude mcp add --transport http monday https://mcp.monday.com/mcp` |

### Databases & Data Management

| サーバー | 説明 | コマンド例 |
|---------|------|-----------|
| **Airtable** | レコード読み書き、ベース・テーブル管理 | `claude mcp add --transport stdio airtable --env AIRTABLE_API_KEY=YOUR_KEY -- npx -y airtable-mcp-server` |
| **HubSpot** | HubSpot CRMデータへのアクセスと管理 | `claude mcp add --transport http hubspot https://mcp.hubspot.com/anthropic` |
| **Daloopa** | SEC Filings、投資家プレゼンテーションからの財務データ | `claude mcp add --transport http daloopa https://mcp.daloopa.com/server/mcp` |

### Payments & Commerce

| サーバー | 説明 | コマンド例 |
|---------|------|-----------|
| **PayPal** | PayPal commerce機能統合、決済処理 | `claude mcp add --transport http paypal https://mcp.paypal.com/mcp` |
| **Plaid** | Plaid統合の分析、トラブルシューティング、最適化 | `claude mcp add --transport sse plaid https://api.dashboard.plaid.com/mcp/sse` |
| **Square** | Square APIでの構築（決済、在庫、注文等） | `claude mcp add --transport sse square https://mcp.squareup.com/sse` |
| **Stripe** | 決済処理、サブスクリプション管理 | `claude mcp add --transport http stripe https://mcp.stripe.com` |

### Design & Media

| サーバー | 説明 | コマンド例 |
|---------|------|-----------|
| **Figma** | 完全なFigmaコンテキストを取り込んでより良いコードを生成 | `claude mcp add --transport http figma https://mcp.figma.com/mcp` |
| **Cloudinary** | メディアアセットのアップロード、管理、変換、分析 | OAuth認証が必要（ドキュメント参照） |
| **invideo** | アプリケーションへの動画作成機能の統合 | `claude mcp add --transport sse invideo https://mcp.invideo.io/sse` |
| **Canva** | Claude から直接 Canva デザインの閲覧、要約、自動入力、生成 | `claude mcp add --transport http canva https://mcp.canva.com/mcp` |

### Infrastructure & DevOps

| サーバー | 説明 | コマンド例 |
|---------|------|-----------|
| **Cloudflare** | アプリ構築、トラフィック分析、パフォーマンス監視 | Cloudflare CLIが必要（ドキュメント参照） |
| **Netlify** | Netlifyでのウェブサイト作成、デプロイ、管理 | `claude mcp add --transport http netlify https://netlify-mcp.netlify.app/mcp` |
| **Stytch** | Stytch認証サービスの設定と管理 | `claude mcp add --transport http stytch http://mcp.stytch.dev/mcp` |
| **Vercel** | Vercel公式MCPサーバー（ドキュメント検索、プロジェクト管理等） | `claude mcp add --transport http vercel https://mcp.vercel.com/` |

### Automation & Integration

| サーバー | 説明 | コマンド例 |
|---------|------|-----------|
| **Workato** | Workatoを介して任意のアプリ、ワークフロー、データにアクセス | プログラム生成MCPサーバー（ドキュメント参照） |
| **Zapier** | Zapierの自動化プラットフォームを介して約8,000のアプリに接続 | mcp.zapier.comでユーザー固有のURL生成 |

---

## 🔧 MCPサーバーのインストール

### Option 1: リモートHTTPサーバーの追加

HTTPサーバーは、リモートMCPサーバーに接続するための推奨オプションです。

```bash
# 基本構文
claude mcp add --transport http <name> <url>

# 実例: Notionに接続
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Bearerトークン付きの例
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### Option 2: リモートSSEサーバーの追加

<Warning>
  SSE (Server-Sent Events) トランスポートは非推奨です。可能な限りHTTPサーバーを使用してください。
</Warning>

```bash
# 基本構文
claude mcp add --transport sse <name> <url>

# 実例: Asanaに接続
claude mcp add --transport sse asana https://mcp.asana.com/sse

# 認証ヘッダー付きの例
claude mcp add --transport sse private-api https://api.company.com/sse \
  --header "X-API-Key: your-key-here"
```

### Option 3: ローカルstdioサーバーの追加

Stdioサーバーはマシン上でローカルプロセスとして実行されます。

```bash
# 基本構文
claude mcp add --transport stdio <name> <command> [args...]

# 実例: Airtableサーバー追加
claude mcp add --transport stdio airtable --env AIRTABLE_API_KEY=YOUR_KEY \
  -- npx -y airtable-mcp-server
```

<Note>
  **"--" パラメータの理解:**
  `--` (ダブルダッシュ) は、ClaudeのCLIフラグとMCPサーバーに渡されるコマンド・引数を分離します。

  例:
  - `claude mcp add --transport stdio myserver -- npx server` → `npx server`を実行
  - `claude mcp add --transport stdio myserver --env KEY=value -- python server.py --port 8080` → `python server.py --port 8080`を実行（環境変数`KEY=value`付き）
</Note>

---

## 📋 MCPサーバーの管理

```bash
# 設定された全サーバーをリスト表示
claude mcp list

# 特定サーバーの詳細取得
claude mcp get github

# サーバーの削除
claude mcp remove github

# (Claude Code内で) サーバーステータス確認
/mcp
```

<Tip>
  ヒント:

  - `--scope`フラグで設定の保存場所を指定:
    - `local` (デフォルト): 現在のプロジェクトのみで利用可能
    - `project`: プロジェクト全体で共有（`.mcp.json`ファイル経由）
    - `user`: 全プロジェクトで利用可能
  - `--env`フラグで環境変数を設定（例: `--env KEY=value`）
  - MCP\_TIMEOUT環境変数でサーバー起動タイムアウトを設定（例: `MCP_TIMEOUT=10000 claude`で10秒）
  - `/mcp`でOAuth 2.0認証が必要なリモートサーバーを認証
</Tip>

---

## 🔐 リモートMCPサーバーでの認証

多くのクラウドベースのMCPサーバーは認証が必要です。Claude CodeはOAuth 2.0をサポートしています。

1. **認証が必要なサーバーを追加**
   ```bash
   claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
   ```

2. **Claude Code内で /mcp コマンドを使用**
   ```
   > /mcp
   ```
   ブラウザの手順に従ってログインします。

---

## 🎨 MCP リソースの使用

MCPサーバーは、@メンションで参照できるリソースを公開できます。

### リソースの参照

1. **利用可能なリソースをリスト表示**
   プロンプトで`@`を入力すると、接続されたMCPサーバーのリソースが表示されます。

2. **特定のリソースを参照**
   `@server:protocol://resource/path`の形式を使用:
   ```
   > @github:issue://123 を分析して修正を提案して
   ```

3. **複数リソースの参照**
   ```
   > @postgres:schema://users と @docs:file://database/user-model を比較して
   ```

---

## 💬 MCPプロンプトをSlash Commandsとして使用

MCPサーバーは、Claude CodeでSlash Commandsとして利用可能なプロンプトを公開できます。

### MCPプロンプトの実行

1. **利用可能なプロンプトを検索**
   `/`を入力すると、MCPサーバーからのコマンドが`/mcp__servername__promptname`形式で表示されます。

2. **引数なしでプロンプトを実行**
   ```
   > /mcp__github__list_prs
   ```

3. **引数付きでプロンプトを実行**
   ```
   > /mcp__github__pr_review 456
   > /mcp__jira__create_issue "ログインフローのバグ" high
   ```

---

## 🏢 エンタープライズMCP設定

組織が中央管理されたMCPサーバーを必要とする場合、Claude Codeはエンタープライズ管理のMCP設定をサポートしています。

### エンタープライズMCP設定のセットアップ

システム管理者は、管理設定ファイルと一緒にエンタープライズMCP設定ファイルをデプロイできます:

- **macOS**: `/Library/Application Support/ClaudeCode/managed-mcp.json`
- **Windows**: `C:\ProgramData\ClaudeCode\managed-mcp.json`
- **Linux**: `/etc/claude-code/managed-mcp.json`

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"],
      "env": {
        "COMPANY_API_URL": "https://internal.company.com"
      }
    }
  }
}
```

### AllowlistとDenylistによるMCPサーバーの制限

`managed-settings.json`の`allowedMcpServers`と`deniedMcpServers`を使用して、ユーザーが設定できるMCPサーバーを制御できます:

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverName": "sentry" },
    { "serverName": "company-internal" }
  ],
  "deniedMcpServers": [
    { "serverName": "filesystem" }
  ]
}
```

---

## 🔄 実践例

### Sentryでエラーを監視

```bash
# 1. Sentry MCPサーバーを追加
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# 2. /mcpで認証
> /mcp

# 3. 本番環境の問題をデバッグ
> "過去24時間で最も一般的なエラーは何ですか？"
> "エラーID abc123のスタックトレースを表示して"
> "これらの新しいエラーを導入したデプロイはどれですか？"
```

### GitHubでコードレビュー

```bash
# 1. GitHub MCPサーバーを追加
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 2. 必要に応じて認証
> /mcp

# 3. GitHubで作業
> "PR #456をレビューして改善を提案して"
> "見つけたバグの新しいissueを作成して"
> "私にアサインされた全てのオープンPRを表示して"
```

### PostgreSQLデータベースのクエリ

```bash
# 1. 接続文字列でデータベースサーバーを追加
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@prod.db.com:5432/analytics"

# 2. データベースを自然言語でクエリ
> "今月の総収益はいくらですか？"
> "ordersテーブルのスキーマを表示して"
> "90日間購入していない顧客を見つけて"
```

---

## 📖 参考リソース

- [MCP公式ドキュメント](https://modelcontextprotocol.io/introduction)
- [Claude Code MCP統合ガイド](https://docs.claude.com/en/docs/claude-code/mcp)
- [GitHub: MCPサーバー一覧](https://github.com/modelcontextprotocol/servers)
- [MCP SDK](https://modelcontextprotocol.io/quickstart/server)

---

## 🔄 更新履歴

- **2025-11-06**: 初版作成
  - 主要MCPサーバーの説明追加
  - インストール方法の詳細追加
  - 実践例の追加
  - エンタープライズ設定ガイド追加
