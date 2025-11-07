# VOICEVOX Integration for tmux Multi-Agent Visualization

**Version**: 1.0.0
**Last Updated**: 2025-11-07
**Status**: Production Ready

---

## 概要

tmux 8ペインマルチエージェント可視化システムに、VOICEVOXによる音声ナレーション機能を統合します。

**キャラクター**:
- **霊夢 (Reimu)**: おバカキャラ、聞き手役、少し抜けている
- **魔理沙 (Marisa)**: 知識側、解説役、「だぜ」「〜なんだ」口調（男の子っぽい）

**用途**:
- エージェントの θ₁〜θ₆ フェーズ遷移のリアルタイムナレーション
- 収束進捗の実況（25%, 50%, 75%, 100%）
- エラーとリカバリーの解説
- タスク完了の祝福

---

## クイックスタート

### 1. VOICEVOX インストール

```bash
# macOS (Homebrew)
brew install --cask voicevox

# または公式サイトからダウンロード
# https://voicevox.hiroshiba.jp/
```

### 2. VOICEVOX エンジン起動

```bash
# VOICEVOXアプリを起動するか、エンジンを直接起動
open -a VOICEVOX

# またはCLIで起動（ポート50021）
/Applications/VOICEVOX.app/Contents/MacOS/run --host 127.0.0.1 --port 50021
```

### 3. ナレーションシステムセットアップ

```bash
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization/voicevox

# 実行権限付与
chmod +x scripts/*.sh

# 設定ファイル作成
cp config/voicevox_config.example.sh config/voicevox_config.sh

# 設定編集
vim config/voicevox_config.sh
```

### 4. テスト実行

```bash
# 霊夢のボイステスト
./scripts/voicevox_narrator.sh test reimu

# 魔理沙のボイステスト
./scripts/voicevox_narrator.sh test marisa

# θ₁フェーズ開始ナレーション
./scripts/voicevox_narrator.sh event phase_theta1_start
```

---

## ディレクトリ構造

```
voicevox/
├── README.md                      # このファイル
├── INSTALLATION.md                # 詳細インストールガイド
├── DIALOGUE_GUIDE.md              # 台本作成ガイド
├── TECHNICAL_SPECS.md             # 技術仕様書
│
├── config/
│   ├── voicevox_config.example.sh # 設定ファイルサンプル
│   ├── voice_models.json          # キャラクター音声モデル定義
│   └── narration_timing.json      # ナレーションタイミング設定
│
├── scripts/
│   ├── voicevox_narrator.sh       # メインナレーションスクリプト
│   ├── voicevox_api.sh            # VOICEVOX API ラッパー
│   ├── audio_queue.sh             # オーディオキュー管理
│   ├── event_listener.sh          # tmuxイベント監視
│   └── cache_manager.sh           # 音声キャッシュ管理
│
└── dialogues/
    ├── phase_transitions/         # θ₁〜θ₆ フェーズ遷移台本
    ├── convergence/               # 収束進捗コメント
    ├── errors/                    # エラーハンドリング台本
    ├── celebrations/              # 完了祝福台本
    └── general/                   # その他汎用台本
```

---

## 機能一覧

### ✅ 実装済み機能

- [x] VOICEVOX API 統合
- [x] 霊夢・魔理沙 キャラクター設定
- [x] θ₁〜θ₆ フェーズ遷移ナレーション（6種）
- [x] 収束進捗コメント（4段階）
- [x] エラーハンドリング台本（5種）
- [x] タスク完了祝福（3種）
- [x] オーディオキュー管理（重複防止）
- [x] 音声キャッシュシステム
- [x] フォールバック機能（テキスト表示のみ）

### 📋 オプション機能

- [ ] カスタム台本エディタ
- [ ] リアルタイム感情分析による台本選択
- [ ] ユーザー定義キャラクター追加
- [ ] 多言語対応（英語、中国語）

---

## キャラクター設定

### 霊夢 (Reimu) - おバカ聞き手キャラ

**VOICEVOX Speaker ID**: `0` (四国めたん - ノーマル)

**性格**:
- 少し抜けている、天然ボケ
- 「〜なの？」「へぇ〜」「すごい！」が口癖
- 難しいことは苦手、でも素直に感心する
- 聞き手役として視聴者の代弁者

**セリフ例**:
```
「ねぇねぇ、これって何やってるの？」
「へぇ〜、そうなんだ！すごいね！」
「え、それってどういうこと？」
「わかったようなわからないような…」
```

### 魔理沙 (Marisa) - 知識解説キャラ

**VOICEVOX Speaker ID**: `8` (春日部つむぎ)

**性格**:
- 頭が良い、技術に詳しい
- 「〜だぜ」「〜なんだ」が口癖（男の子っぽい）
- 霊夢の質問に丁寧に答える
- 専門用語も使うが、わかりやすく説明する

**セリフ例**:
```
「今はθ₁の理解フェーズだぜ」
「これはな、ユーザーの意図を分析してるんだ」
「難しいことはないぜ、要するに〜ってことだ」
「さすがだな！完璧な動作だぜ」
```

---

## イベントトリガー一覧

### 1. フェーズ遷移イベント

| イベント | トリガータイミング | 台本ファイル |
|---------|------------------|-------------|
| `phase_theta1_start` | θ₁ Understand 開始 | `phase_transitions/theta1_start.txt` |
| `phase_theta2_start` | θ₂ Generate 開始 | `phase_transitions/theta2_start.txt` |
| `phase_theta3_start` | θ₃ Allocate 開始 | `phase_transitions/theta3_start.txt` |
| `phase_theta4_start` | θ₄ Execute 開始 | `phase_transitions/theta4_start.txt` |
| `phase_theta5_start` | θ₅ Integrate 開始 | `phase_transitions/theta5_start.txt` |
| `phase_theta6_start` | θ₆ Learn 開始 | `phase_transitions/theta6_start.txt` |

### 2. 収束進捗イベント

| イベント | トリガータイミング | 台本ファイル |
|---------|------------------|-------------|
| `convergence_25` | 収束率 25% 到達 | `convergence/progress_25.txt` |
| `convergence_50` | 収束率 50% 到達 | `convergence/progress_50.txt` |
| `convergence_75` | 収束率 75% 到達 | `convergence/progress_75.txt` |
| `convergence_100` | 収束率 100% 到達 | `convergence/progress_100.txt` |

### 3. エラーイベント

| イベント | トリガータイミング | 台本ファイル |
|---------|------------------|-------------|
| `error_api_fail` | API 呼び出し失敗 | `errors/api_failure.txt` |
| `error_timeout` | タイムアウト発生 | `errors/timeout.txt` |
| `error_validation` | バリデーションエラー | `errors/validation_error.txt` |
| `error_recovery` | エラーから回復 | `errors/recovery_success.txt` |

### 4. 完了イベント

| イベント | トリガータイミング | 台本ファイル |
|---------|------------------|-------------|
| `task_complete` | タスク完了 | `celebrations/task_complete.txt` |
| `milestone_reached` | マイルストーン達成 | `celebrations/milestone.txt` |
| `perfect_execution` | 完璧な実行 | `celebrations/perfect.txt` |

---

## 使用例

### 基本的な使い方

```bash
# θ₁フェーズ開始を通知
./scripts/voicevox_narrator.sh event phase_theta1_start

# 収束50%到達を通知
./scripts/voicevox_narrator.sh event convergence_50

# エラー発生を通知
./scripts/voicevox_narrator.sh event error_timeout

# タスク完了を祝う
./scripts/voicevox_narrator.sh event task_complete
```

### tmux 統合例

```bash
# tmux ペイン内でイベント検知したら自動ナレーション
tmux set-hook -g after-select-pane 'run-shell "detect_phase_change.sh"'

# 収束率更新時に自動ナレーション
watch -n 5 './scripts/check_convergence.sh && ./scripts/voicevox_narrator.sh event convergence_$PERCENT'
```

### カスタムナレーション

```bash
# カスタムメッセージを霊夢に喋らせる
./scripts/voicevox_narrator.sh speak reimu "ねぇねぇ、面白いことになってきたね！"

# カスタムメッセージを魔理沙に喋らせる
./scripts/voicevox_narrator.sh speak marisa "今のはいい感じだぜ！"
```

---

## 設定オプション

### voicevox_config.sh

```bash
# VOICEVOX API エンドポイント
VOICEVOX_HOST="127.0.0.1"
VOICEVOX_PORT="50021"

# キャラクター音声モデル
REIMU_SPEAKER_ID=0      # 四国めたん
MARISA_SPEAKER_ID=8     # 春日部つむぎ

# ナレーション設定
NARRATION_ENABLED=true
NARRATION_FREQUENCY="all"  # all | major | silent
AUDIO_VOLUME=0.8
SPEECH_SPEED=1.0

# キャッシュ設定
CACHE_ENABLED=true
CACHE_DIR="/tmp/voicevox_cache"
CACHE_MAX_SIZE_MB=500

# フォールバック設定
FALLBACK_TO_TEXT=true
TEXT_DISPLAY_PANE=8
```

---

## トラブルシューティング

### VOICEVOX が起動しない

```bash
# ポート競合チェック
lsof -i :50021

# プロセス確認
ps aux | grep voicevox

# 手動起動
/Applications/VOICEVOX.app/Contents/MacOS/run --host 127.0.0.1 --port 50021
```

### 音声が再生されない

```bash
# オーディオデバイス確認（macOS）
system_profiler SPAudioDataType

# afplay テスト
afplay /System/Library/Sounds/Ping.aiff

# 権限確認
ls -l /tmp/voicevox_cache
```

### API エラーが出る

```bash
# API 接続テスト
curl http://127.0.0.1:50021/version

# スピーカー一覧取得
curl http://127.0.0.1:50021/speakers

# ログ確認
tail -f /tmp/voicevox_narrator.log
```

---

## パフォーマンス最適化

### 音声キャッシュ

- 同じセリフは再生成せずキャッシュから読み込み
- キャッシュサイズ上限: 500MB（デフォルト）
- 自動クリーンアップ: 7日間未使用のファイルを削除

### オーディオキュー

- 同時再生を防止（重なり防止）
- キュー最大長: 5件
- キュー満タン時: 古いものから削除

### バックグラウンド処理

```bash
# 非同期ナレーション（tmux をブロックしない）
./scripts/voicevox_narrator.sh event phase_theta1_start &

# ナレーション完了待ち（同期処理）
./scripts/voicevox_narrator.sh event phase_theta1_start --wait
```

---

## ライセンス

VOICEVOX は LGPL v3 + 各キャラクター利用規約に従います。

- VOICEVOX 公式: https://voicevox.hiroshiba.jp/
- 利用規約: https://voicevox.hiroshiba.jp/term/

---

## 関連ドキュメント

- [INSTALLATION.md](INSTALLATION.md) - 詳細インストールガイド
- [DIALOGUE_GUIDE.md](DIALOGUE_GUIDE.md) - 台本作成ガイド
- [TECHNICAL_SPECS.md](TECHNICAL_SPECS.md) - 技術仕様書
- [../README.md](../README.md) - tmux 可視化システム全体

---

**次のステップ**: [INSTALLATION.md](INSTALLATION.md) でセットアップを開始しましょう！
