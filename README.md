# 🚀 Miyabi AI Agent Framework

<div align="center">

**エージェントの幻想を捨てて、プロンプト設計を学べ**

[![GitHub Stars](https://img.shields.io/github/stars/ShunsukeHayashi/Miyabi_AI_Agent?style=social)](https://github.com/ShunsukeHayashi/Miyabi_AI_Agent)
[![Discord](https://img.shields.io/discord/DISCORD_ID?color=7289da&label=Discord&logo=discord&logoColor=white)](https://discord.gg/ZpY9sxfYNm)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge)](https://github.com/ShunsukeHayashi/Miyabi_AI_Agent/generate)

*プロンプト設計 × Tool Call構造化 × フック設計のフレームワーク*

[🎯 5分で開始](#-5分クイックスタート) • [📖 ドキュメント](#-ドキュメント) • [💬 Discord](https://discord.gg/ZpY9sxfYNm) • [💀 現実を見ろ](#-エージェントの正体)

</div>

---

## 💀 エージェントの正体

**「AIエージェントすごい！」って言ってるヤツ、騙されてない？**

```python
# これがエージェントの全て
while True:
  text = llm.generate()
  if has_tool_call(text):
    result = execute(tool)
    context.append(result)
  else:
    break
```

**それ以上でも、それ以下でもない。**

- ❌ 「自律的に考える」→ LLMがループしてるだけ
- ❌ 「複雑な問題を解決」→ プロンプト設計次第
- ❌ 「AGI目前」→ バカなの？

**現実:**
- 7割は失敗する
- プロンプト設計が全て
- Tool Callの構造化が命
- デバッグは人間がやる

**エージェント = LLMのFunction Call発火条件を束ねた関数群**

---

## 🎉 このテンプレートの本当の価値

```
❌ マーケティングの幻想
├─ 「エージェントが勝手にやってくれる」
├─ 「もうコード書かなくていい」
└─ 「AGI目前だ」

✅ このテンプレートの現実
├─ プロンプト設計ガイドライン（瞬く景色の法則）
├─ Tool Call構造化パターン（Command Stack）
├─ フック設計の原則（Intent Resolution）
└─ while文をどう回すか（World Transformation）
```

### 💡 3つの現実

1. **プロンプト設計が全て**
   - 61,251行のプロンプト設計ドキュメント
   - 物理学的原理による構造化手法
   - 失敗パターンと成功パターン

2. **Tool Call構造化が命**
   - Command Stackによる分解手法
   - Intent Resolutionによる意図解決
   - フック設計による制御

3. **幻想に騙されるな**
   - while文の精密な設計
   - LLMループ制御理論
   - 実務的なデバッグ手法

---

## ⚡ 5分クイックスタート

### ステップ1: テンプレートを使用（30秒）

```bash
# このリポジトリの "Use this template" をクリック
# または
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

### ステップ2: プロンプト設計を学ぶ（2分）

```bash
# プロンプト設計の理論を読む
cat .claude/UNIFIED_FORMULA.md
cat .claude/LAW_OF_FLICKERING_SCENERY.md
cat .claude/COMMAND_STACK.md
```

### ステップ3: あなたのプロンプトを設計（2分）

```bash
# CLAUDE.mdであなたのプロンプト戦略を定義
code CLAUDE.md

# 重要: 「エージェントが勝手にやる」なんて夢は見るな
# プロンプトとフック設計を精密にやれ
```

### ステップ4: while文を回す（30秒）

```bash
# Claude Codeで実行
claude code

# 実際に起こっていること:
# while True:
#   text = llm.generate()
#   if has_tool_call(text):
#     result = execute(tool)
#     context.append(result)
```

**🎉 完了！現実を理解した上でLLMループ制御を開始！**

詳細ガイド: [USE_THIS_TEMPLATE.md](USE_THIS_TEMPLATE.md)

---

## 🌟 このテンプレートに含まれるもの

<table>
<tr>
<td width="50%">

### ✅ 完成済み

**理論フレームワーク**
- 📐 統一エージェント方程式
- 🌊 瞬く景色の法則
- 🧠 World Model Logic
- 🎯 Intent Resolution
- 📦 Command Stack

**Claude Code統合**
- 🤖 11種類の専門エージェント
- 🎨 15個のPlantUML図
- ⚙️ 48設定ファイル

**ビジネス戦略**
- 💼 完全なビジネス計画
- 💰 資金調達戦略
- 📢 マーケティング戦略

</td>
<td width="50%">

### ⚙️ あなたが追加

**実装コード**
- 🦀 Rust実装（自由に）
- 🐍 Python実装（自由に）
- 📝 TypeScript実装（自由に）

**カスタマイズ**
- 🎯 ドメイン特化エージェント
- 🔧 独自の理論追加
- 🎨 UIカスタマイズ

**ビジネス展開**
- 🚀 独自のマネタイズ
- 🌐 グローバル展開
- 👥 コミュニティ構築

</td>
</tr>
</table>

---

## 🎯 核心理論: 瞬く景色の法則

### 物理学×AI の革新的アプローチ

```
𝔸(Input, World₀) = lim_{n→∞} [∫₀ⁿ (Θ ◦ 𝒞 ◦ ℐ)(t) dt] = World_∞
```

**世界は「瞬き」のように離散的に変化する**

```
World₀ → [瞬き] → World₁ → [瞬き] → World₂ → ... → World_∞
```

#### 3つの核心原理

1. **ℐ (Intent Resolution)**: 曖昧な入力 → 明確な目標
2. **𝒞 (Command Stack)**: 目標 → 実行可能なタスク
3. **Θ (World Transformation)**: タスク → 世界の変換

> 速度の積分 = 距離
> **世界変換の積分 = 目標達成**

詳細: [瞬く景色の法則](。claude/LAW_OF_FLICKERING_SCENERY.md)

---

## 🎨 使用例

### 例1: プロンプト設計の基本（5分）

```markdown
<!-- CLAUDE.md -->
# My Hello Project

## プロンプト戦略
### Intent Resolution
- Input: ユーザーの曖昧な挨拶
- Goal: 明確な返答内容の決定

### Tool Call構造
- Read: コンテキスト取得
- Write: 返答生成

## while文制御
ループ回数: 最大3回
失敗時: デフォルト返答
```

**現実**: プロンプト設計に基づいてLLMループが回る ✅

---

### 例2: Tool Call構造化（30分）

```markdown
<!-- CLAUDE.md -->
# Financial Analysis Project

## プロンプト設計
### Command Stack (C1→C2→C3)
1. C1: データ収集タスクに分解
2. C2: 各タスクをTool Callに変換
3. C3: 順次実行してコンテキスト構築

### Tool Call発火条件
- Grep: キーワード検索
- Read: ファイル読み込み
- Bash: 計算実行

## 失敗パターン
- プロンプトが曖昧 → Tool Call失敗
- コンテキスト不足 → 判断ミス
- ループ回数過多 → タイムアウト
```

**現実**: 精密なプロンプト設計でwhile文を制御 ✅

---

### 例3: 本気の実装（1週間）

```rust
// crates/my-core/src/lib.rs
// プロンプト設計理論をコードに落とし込む
pub struct PromptController {
    intent_resolver: IntentResolver,  // ℐ: プロンプト解析
    command_stack: CommandStack,      // 𝒞: Tool Call構造化
    world_transformer: WorldTransformer, // Θ: コンテキスト更新
}

impl PromptController {
    pub fn run_loop(&self, input: Input, world: World) -> World {
        // while True:
        loop {
            let text = self.llm.generate();
            if let Some(tool_call) = self.parse_tool_call(&text) {
                let result = self.execute(tool_call);
                world.context.append(result);
            } else {
                break;
            }
        }
        world
    }
}
```

**現実**: while文の精密な制御実装 ✅

---

## 📚 ドキュメント

### 🚀 開始ガイド

| ドキュメント | 内容 | 時間 |
|------------|------|------|
| [USE_THIS_TEMPLATE.md](USE_THIS_TEMPLATE.md) | テンプレート使用方法 | 5分 |
| [QUICKSTART.md](docs/QUICKSTART.md) | 詳細クイックスタート | 15分 |
| [PROJECT_ORGANIZATION_REPORT.md](PROJECT_ORGANIZATION_REPORT.md) | プロジェクト全体像 | 30分 |

### 📖 理論

| ドキュメント | 内容 |
|------------|------|
| [統一エージェント方程式](.claude/UNIFIED_FORMULA.md) | 完全な数学的定義 |
| [瞬く景色の法則](.claude/LAW_OF_FLICKERING_SCENERY.md) | 核心理論 |
| [World Model Logic](.claude/WORLD_MODEL_LOGIC.md) | 世界モデル |
| [Intent Resolution](.claude/INTENT_RESOLUTION.md) | 意図解決 |
| [Command Stack](.claude/COMMAND_STACK.md) | タスク分解 |

### 🤖 実装

| ドキュメント | 内容 |
|------------|------|
| [エージェント一覧](.claude/agents/readme.md) | 11種類のエージェント |
| [MCP統合](.claude/MCP_INTEGRATION.md) | 外部サービス連携 |
| [アーキテクチャ](docs/architecture-docs/) | システム設計 |

### 💼 ビジネス

| ドキュメント | 内容 |
|------------|------|
| [バイラル戦略](VIRAL_STRATEGY.md) | 成長戦略 |
| [ビジネス計画](docs/business_plan/) | 資金調達・収益化 |
| [マーケティング](docs/marketing/) | プロモーション |

### 🎓 学術

| ドキュメント | 内容 |
|------------|------|
| [学術論文 (PDF)](docs/paper_law_of_flickering_scenery.pdf) | 完全版論文 |
| [LaTeXソース](docs/paper_law_of_flickering_scenery.tex) | 論文ソース |
| [arXiv投稿戦略](docs/arxiv_submission_strategy.md) | 学術発表計画 |

---

## 🎭 Tool Call構造化パターン（11種類）

**これらは「エージェント」ではなく、プロンプト設計パターンです。**

<details>
<summary><b>🎮 ゲーム・3D開発パターン</b></summary>

- **3d-designer** - Three.js向けTool Call構造
- **game-creator** - ゲーム開発向けプロンプト設計

**現実**: Read→Write→Bashの最適化パターン

</details>

<details>
<summary><b>🀄 麻雀AIパターン</b></summary>

- **mahjong-master** - 戦略計算向けループ制御
- **opponent-hand-reader** - 読み解析向けプロンプト
- **tile-efficiency-analyzer** - 計算特化Tool Call

**現実**: Bash計算→Read結果→Write出力のループ

</details>

<details>
<summary><b>📊 コンテンツ制作パターン</b></summary>

- **slide-generator** - YAML生成向けプロンプト構造
- **design-director** - 複数Tool Call調整パターン

**現実**: Read→Edit→Write→Bashの連鎖制御

</details>

<details>
<summary><b>⚖️ 法務・コンプライアンスパターン</b></summary>

- **legal-document-analyzer** - 文書解析向けGrep活用
- **contract-reviewer** - 比較分析プロンプト設計
- **compliance-gap-analyzer** - ギャップ検出ループ制御

**現実**: Grep→Read→分析→Write判定のパターン

</details>

<details>
<summary><b>🎨 UI/UXパターン</b></summary>

- **ui-ux-reviewer** - インターフェース評価プロンプト

**現実**: Read→分析→Write推奨の単純ループ

</details>

詳細: [Tool Call構造化パターン一覧](.claude/agents/readme.md)

---

## 🚀 現実的な成長戦略

### エージェントバブル崩壊後のポジショニング

```
Stage 1: 現実を直視したコミュニティ (Month 1-3)
  → 「エージェント幻想」から目覚めた開発者が集まる

Stage 2: プロンプト設計の知識共有 (Month 3-6)
  → 実務的な失敗/成功パターンの蓄積

Stage 3: while文制御の最適化手法確立 (Month 6-12)
  → バブル崩壊後も残る本質的価値

Stage 4: 本質的な価値の提供 (Year 2+)
  → プロンプト設計のデファクトスタンダード
```

### 現実的な成功指標

**6ヶ月後:**
- 🎯 1,000 真剣な開発者
- 👥 実務経験の共有コミュニティ
- 💰 本質的価値による収益

**1年後:**
- 🎯 「エージェント」幻想が弾けた後も残る理論
- 👥 プロンプト設計のベストプラクティス確立
- 💰 実装可能な知識による収益

**バブルが弾けても残るもの:**
- プロンプト設計理論
- Tool Call構造化パターン
- LLMループ制御の最適化手法

詳細: [VIRAL_STRATEGY.md](VIRAL_STRATEGY.md)

---

## 💰 マネタイゼーション

### 4 Tier戦略（現実的価値）

| Tier | 価格 | 内容 |
|------|------|------|
| **Free** | $0 | 全プロンプト設計ドキュメント、失敗/成功パターン |
| **Pro** | $49/年 | 追加Tool Call構造化パターン、実務相談 |
| **Enterprise** | $499/年 | プロンプト設計コンサル、while文最適化支援 |
| **Consulting** | Custom | 実装支援、デバッグ支援、実務研修 |

**現実的想定:**
- バブル価格ではなく、実務価値に基づく価格
- プロンプト設計の専門知識による収益
- 失敗パターンと成功パターンの提供

---

## 🌐 コミュニティ

<div align="center">

### 💬 Discord - Miyabi

**「エージェント幻想」から目覚めた開発者のコミュニティ**

[![Discord](https://img.shields.io/discord/DISCORD_ID?color=7289da&label=Join%20Discord&logo=discord&logoColor=white&style=for-the-badge)](https://discord.gg/ZpY9sxfYNm)

**チャンネル:**
- 💀 reality-check - 現実を直視
- 💬 prompt-design - プロンプト設計議論
- 🆘 debug-help - デバッグ相談
- 🚀 while-loop - ループ制御最適化
- 💡 tool-call-patterns - Tool Call構造化
- 🛠️ failure-success - 失敗/成功パターン共有

**現実:**
- 初心者向けではなく、真剣な開発者向け
- 「AIが勝手にやる」なんて夢は見ない
- プロンプト設計とフック設計を学ぶ場

</div>

---

## 🤝 貢献

このプロジェクトへの貢献を歓迎します！

### 貢献方法

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. Pull Requestを作成

### 優先度の高い貢献

- 🤖 新しい専門エージェントの追加
- 📖 ドキュメントの改善（翻訳含む）
- 🎨 使用例の追加
- 🐛 バグ修正
- 💡 新機能のアイデア

---

## 🏆 使用プロジェクト

このテンプレートを使った素晴らしいプロジェクト:

<table>
<tr>
<td align="center" width="25%">
<b>あなたのプロジェクト</b><br>
<a href="YOUR_REPO">
<img src="https://via.placeholder.com/150" width="150"><br>
プロジェクト名
</a>
</td>
<td align="center" width="25%">
<b>あなたのプロジェクト</b><br>
<a href="YOUR_REPO">
<img src="https://via.placeholder.com/150" width="150"><br>
プロジェクト名
</a>
</td>
<td align="center" width="25%">
<b>あなたのプロジェクト</b><br>
<a href="YOUR_REPO">
<img src="https://via.placeholder.com/150" width="150"><br>
プロジェクト名
</a>
</td>
<td align="center" width="25%">
<b>あなたのプロジェクト</b><br>
<a href="YOUR_REPO">
<img src="https://via.placeholder.com/150" width="150"><br>
プロジェクト名
</a>
</td>
</tr>
</table>

**あなたのプロジェクトを追加！** [Discussionsで共有](https://github.com/ShunsukeHayashi/Miyabi_AI_Agent/discussions)

---

## 📊 統計

<div align="center">

**このテンプレートの規模**

| カテゴリ | 数量 |
|---------|------|
| 📄 プロンプト設計ドキュメント | 100+ ファイル |
| 📝 総行数 | 61,251 行 |
| 🔧 Tool Call構造化パターン | 11 種類 |
| 🎨 PlantUML図 | 15 個 |
| 📚 学術論文 | 1 本 (完全版) |
| 💼 ビジネス計画 | 完全装備 |

**現実:**
- while文の制御パターン
- プロンプト設計の失敗/成功例
- Tool Call構造化の実例
- フック設計の理論

</div>

---

## 🎓 学術的価値

### 独自性

1. **物理学的原理 × プロンプト設計**
   - ニュートン力学 → LLMループ制御理論
   - 量子力学 → 離散的状態遷移
   - 熱力学 → コンテキスト蓄積理論

2. **MABATAKU（瞬き）概念**
   - 離散的世界認識 = while文の各イテレーション
   - 映画フレームのメタファー = LLM生成の離散性
   - 実装可能な抽象化 = Tool Call構造化

3. **現実的な理論**
   - 幻想ではなく、実装可能な理論
   - プロンプト設計の物理学的基盤
   - Tool Call構造化の数学的定式化

### 現実を見た学術価値

**エージェントバブルが弾けた後も残る理論:**
- LLMループ制御の最適化手法
- プロンプト設計の構造化理論
- Tool Call発火条件の定式化

論文: [Law of Flickering Scenery (PDF)](docs/paper_law_of_flickering_scenery.pdf)

---

## 📱 ソーシャルメディア

<div align="center">

[![Twitter Follow](https://img.shields.io/twitter/follow/YOUR_HANDLE?style=social)](https://twitter.com/YOUR_HANDLE)
[![YouTube Channel](https://img.shields.io/youtube/channel/subscribers/YOUR_CHANNEL?style=social)](https://youtube.com/YOUR_CHANNEL)
[![Medium](https://img.shields.io/badge/Medium-Follow-black?logo=medium)](https://medium.com/@YOUR_HANDLE)

**最新情報をチェック！**

</div>

---

## ❓ FAQ

<details>
<summary><b>Q: エージェントって何なの？</b></summary>

A: **while文です。** LLMがテキスト生成→Tool Call→コンテキスト追加をループしてるだけ。「自律的に考える」なんて幻想。プロンプト設計とTool Call構造化が全て。

</details>

<details>
<summary><b>Q: このテンプレートで何が手に入るの？</b></summary>

A: **プロンプト設計の理論とパターン**です。61,251行のドキュメントは全てプロンプト設計・Tool Call構造化・フック設計の知識。実装コードはあなたが書く。

</details>

<details>
<summary><b>Q: Rust以外の言語でも使える？</b></summary>

A: はい。理論フレームワークは言語非依存。Python、TypeScript、Go、何でも。while文を回す言語ならなんでもOK。

</details>

<details>
<summary><b>Q: 7割失敗するって本当？</b></summary>

A: **本当。** プロンプト設計が甘いと失敗する。Tool Call構造化が曖昧だと失敗する。コンテキスト管理がずさんだと失敗する。このテンプレートはその失敗パターンと成功パターンを提供する。

</details>

<details>
<summary><b>Q: 商用利用は可能？</b></summary>

A: はい！MITライセンスで自由に商用利用できます。

</details>

<details>
<summary><b>Q: サポートはありますか？</b></summary>

A: [Discord - Miyabi](https://discord.gg/ZpY9sxfYNm)で無料サポートを提供しています。Pro版では優先サポートもあります。

</details>

<details>
<summary><b>Q: フォーク後も元のリポジトリとの同期は必要？</b></summary>

A: いいえ。フォーク後は完全に独立したプロジェクトです。自由にカスタマイズしてください。

</details>

---

## 📞 サポート

質問や問題がある場合：

1. 🎮 [Discord - Miyabi](https://discord.gg/ZpY9sxfYNm) でリアルタイムサポート
2. 📖 [ドキュメント](.claude/)を確認
3. 💬 [Discussions](https://github.com/ShunsukeHayashi/Miyabi_AI_Agent/discussions)で質問
4. 🐛 [Issues](https://github.com/ShunsukeHayashi/Miyabi_AI_Agent/issues)でバグ報告

---

## 📝 ライセンス

このプロジェクトは[MITライセンス](LICENSE)のもとで公開されています。

---

## 🙏 謝辞

- **Anthropic**: [Claude Code](https://claude.com/claude-code)の優れたツール
- **MCP Community**: 豊富なMCPサーバーエコシステム
- **Lovart**: ディレクター・ワーカーモデルのインスピレーション
- **コミュニティ**: 全ての貢献者とユーザーの皆様

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=ShunsukeHayashi/Miyabi_AI_Agent&type=Date)](https://star-history.com/#ShunsukeHayashi/Miyabi_AI_Agent&Date)

---

<div align="center">

## 🚀 今すぐ始めよう！

[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge&logo=github)](https://github.com/ShunsukeHayashi/Miyabi_AI_Agent/generate)
[![Join Discord](https://img.shields.io/badge/Join%20Discord-7289da?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/ZpY9sxfYNm)
[![Star Repo](https://img.shields.io/badge/Star%20Repo-ffd700?style=for-the-badge&logo=github)](https://github.com/ShunsukeHayashi/Miyabi_AI_Agent)

---

**Built with ❤️ using [Claude Code](https://claude.com/claude-code)**

*"Stop dreaming. Start designing prompts."*
*「幻想を捨てろ。プロンプト設計を始めろ。」*

*"Agent = while True: LLM → Tool Call → Context"*
*「エージェント = while文。それ以上でも以下でもない。」*

*"Through infinite blinks, the world converges to its ideal."*
*「無限の瞬きの先に、理想は現実となる」*

---

**© 2025 Miyabi AI Agent Framework • MIT License**

</div>
