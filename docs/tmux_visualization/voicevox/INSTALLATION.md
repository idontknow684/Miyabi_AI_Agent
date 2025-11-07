# VOICEVOX Installation Guide

**Version**: 1.0.0
**Last Updated**: 2025-11-07

---

## 目次

1. [システム要件](#システム要件)
2. [VOICEVOX インストール](#voicevox-インストール)
3. [ナレーションシステム セットアップ](#ナレーションシステム-セットアップ)
4. [動作確認](#動作確認)
5. [トラブルシューティング](#トラブルシューティング)

---

## システム要件

### ハードウェア要件

- **CPU**: Intel Core i5 以上（推奨: i7 以上）
- **RAM**: 8GB 以上（推奨: 16GB 以上）
- **ディスク**: 5GB 以上の空き容量
- **オーディオ**: スピーカーまたはヘッドフォン

### ソフトウェア要件

- **OS**:
  - macOS 11.0 (Big Sur) 以上
  - Linux (Ubuntu 20.04 LTS 以上)
  - Windows 10/11 (64-bit)
- **依存ツール**:
  - `curl` または `wget`
  - `jq` (JSON パーサー)
  - `afplay` (macOS) または `paplay` (Linux) または `powershell` (Windows)

---

## VOICEVOX インストール

### macOS

#### 方法1: Homebrew 経由（推奨）

```bash
# Homebrew がインストールされていない場合
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# VOICEVOX インストール
brew install --cask voicevox

# インストール確認
ls /Applications/VOICEVOX.app
```

#### 方法2: 公式サイトからダウンロード

1. https://voicevox.hiroshiba.jp/ にアクセス
2. macOS 版をダウンロード（`.dmg` ファイル）
3. `.dmg` を開いて VOICEVOX.app を `/Applications` にドラッグ
4. 初回起動時は右クリック → 「開く」で許可

### Linux (Ubuntu/Debian)

```bash
# 依存パッケージインストール
sudo apt update
sudo apt install -y curl jq pulseaudio-utils

# VOICEVOX AppImage ダウンロード（最新版を確認）
cd ~/Downloads
wget https://github.com/VOICEVOX/voicevox/releases/latest/download/VOICEVOX.Linux.AppImage

# 実行権限付与
chmod +x VOICEVOX.Linux.AppImage

# 配置
sudo mv VOICEVOX.Linux.AppImage /opt/voicevox/
sudo ln -s /opt/voicevox/VOICEVOX.Linux.AppImage /usr/local/bin/voicevox

# 実行テスト
voicevox --version
```

### Windows

```powershell
# 公式サイトからインストーラーダウンロード
# https://voicevox.hiroshiba.jp/

# または winget 経由
winget install Hiroshiba.VOICEVOX

# インストール確認
Get-Process -Name VOICEVOX -ErrorAction SilentlyContinue
```

---

## ナレーションシステム セットアップ

### 1. 依存ツールインストール

#### macOS

```bash
# jq インストール
brew install jq

# tmux インストール（まだの場合）
brew install tmux

# afplay は標準搭載のため不要
```

#### Linux

```bash
# jq, paplay インストール
sudo apt install -y jq pulseaudio-utils tmux

# または yum/dnf (RHEL/CentOS/Fedora)
sudo yum install -y jq pulseaudio-utils tmux
```

#### Windows (WSL2 推奨)

```bash
# WSL2 Ubuntu 上で実行
sudo apt update
sudo apt install -y jq pulseaudio tmux
```

### 2. VOICEVOX エンジン起動

#### macOS

```bash
# GUI アプリとして起動
open -a VOICEVOX

# またはバックグラウンドで CLI 起動
/Applications/VOICEVOX.app/Contents/MacOS/run \
  --host 127.0.0.1 \
  --port 50021 \
  &> /tmp/voicevox_engine.log &
```

#### Linux

```bash
# AppImage 起動
voicevox --host 127.0.0.1 --port 50021 &> /tmp/voicevox_engine.log &

# systemd サービス化（オプション）
sudo tee /etc/systemd/system/voicevox.service > /dev/null <<EOF
[Unit]
Description=VOICEVOX Engine
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/voicevox --host 127.0.0.1 --port 50021
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable voicevox
sudo systemctl start voicevox
```

#### Windows

```powershell
# VOICEVOX を起動（GUI）
Start-Process "C:\Program Files\VOICEVOX\VOICEVOX.exe"

# またはバックグラウンド起動
Start-Process -WindowStyle Hidden "C:\Program Files\VOICEVOX\VOICEVOX Engine\run.exe" -ArgumentList "--host 127.0.0.1 --port 50021"
```

### 3. ナレーションスクリプト配置

```bash
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization/voicevox

# スクリプトに実行権限付与
chmod +x scripts/*.sh

# 設定ファイル作成
cp config/voicevox_config.example.sh config/voicevox_config.sh

# 設定編集（エディタはお好みで）
vim config/voicevox_config.sh
# または
nano config/voicevox_config.sh
```

### 4. 設定ファイル編集

`config/voicevox_config.sh` を編集:

```bash
#!/bin/bash
# VOICEVOX ナレーション設定

# VOICEVOX API エンドポイント
export VOICEVOX_HOST="127.0.0.1"
export VOICEVOX_PORT="50021"

# キャラクター音声モデル
export REIMU_SPEAKER_ID=0      # 四国めたん (ノーマル)
export MARISA_SPEAKER_ID=8     # 春日部つむぎ

# ナレーション設定
export NARRATION_ENABLED=true
export NARRATION_FREQUENCY="all"  # all | major | silent
export AUDIO_VOLUME=0.8           # 0.0 〜 1.0
export SPEECH_SPEED=1.0           # 0.5 〜 2.0

# キャッシュ設定
export CACHE_ENABLED=true
export CACHE_DIR="/tmp/voicevox_cache"
export CACHE_MAX_SIZE_MB=500

# フォールバック設定
export FALLBACK_TO_TEXT=true
export TEXT_DISPLAY_PANE=8        # tmux ペイン番号

# ログ設定
export LOG_FILE="/tmp/voicevox_narrator.log"
export LOG_LEVEL="INFO"           # DEBUG | INFO | WARN | ERROR
```

保存して閉じる（`:wq` または `Ctrl+X` → `Y` → `Enter`）

### 5. キャッシュディレクトリ作成

```bash
mkdir -p /tmp/voicevox_cache
chmod 755 /tmp/voicevox_cache
```

---

## 動作確認

### 1. VOICEVOX API 接続テスト

```bash
# バージョン確認
curl http://127.0.0.1:50021/version

# 期待される出力例:
# "0.14.5"

# スピーカー一覧取得
curl http://127.0.0.1:50021/speakers | jq '.[].name'

# 期待される出力例:
# "四国めたん"
# "ずんだもん"
# "春日部つむぎ"
# ...
```

### 2. 霊夢 ボイステスト

```bash
cd /Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization/voicevox

./scripts/voicevox_narrator.sh test reimu

# 「テスト音声です。霊夢だよ！」が聞こえれば成功
```

### 3. 魔理沙 ボイステスト

```bash
./scripts/voicevox_narrator.sh test marisa

# 「テスト音声だぜ。魔理沙だ！」が聞こえれば成功
```

### 4. イベントナレーションテスト

```bash
# θ₁ フェーズ開始ナレーション
./scripts/voicevox_narrator.sh event phase_theta1_start

# 霊夢と魔理沙の会話が聞こえれば成功
# 霊夢: 「ねぇねぇ魔理沙、これって何やってるの？」
# 魔理沙: 「今はθ₁の理解フェーズだぜ。ユーザーの意図を分析してるんだ」
```

### 5. tmux 統合テスト

```bash
# tmux セッション作成
tmux new-session -d -s narration_test

# ナレーション付きでコマンド実行
tmux send-keys -t narration_test "echo 'Phase θ₁ started' && ./scripts/voicevox_narrator.sh event phase_theta1_start" C-m

# セッションにアタッチして確認
tmux attach -t narration_test
```

---

## トラブルシューティング

### エラー: VOICEVOX エンジンに接続できない

```bash
# 問題確認
curl http://127.0.0.1:50021/version

# エラーが出る場合、以下を確認:

# 1. VOICEVOX が起動しているか？
ps aux | grep voicevox

# 2. ポート 50021 が使用されているか？
lsof -i :50021  # macOS/Linux
netstat -ano | findstr :50021  # Windows

# 3. ファイアウォールでブロックされていないか？
# macOS: システム環境設定 → セキュリティとプライバシー → ファイアウォール
# Linux: sudo ufw status
# Windows: Windows Defender ファイアウォール
```

**解決方法**:

```bash
# VOICEVOX を再起動
pkill -f voicevox
open -a VOICEVOX  # macOS
# または
voicevox --host 127.0.0.1 --port 50021 &  # Linux
```

### エラー: 音声が再生されない

```bash
# オーディオデバイス確認（macOS）
system_profiler SPAudioDataType

# オーディオデバイス確認（Linux）
pactl list sinks

# テスト音声再生
afplay /System/Library/Sounds/Ping.aiff  # macOS
paplay /usr/share/sounds/alsa/Front_Center.wav  # Linux
```

**解決方法**:

```bash
# macOS: 音量確認
osascript -e 'set volume output volume 50'

# Linux: PulseAudio 再起動
pulseaudio --kill
pulseaudio --start

# Windows: サウンド設定確認
# 設定 → システム → サウンド
```

### エラー: Permission denied

```bash
# スクリプト実行権限確認
ls -l scripts/voicevox_narrator.sh

# 権限がない場合:
chmod +x scripts/*.sh

# キャッシュディレクトリ権限確認
ls -ld /tmp/voicevox_cache

# 権限修正
chmod 755 /tmp/voicevox_cache
```

### エラー: jq: command not found

```bash
# jq インストール
# macOS
brew install jq

# Linux (Ubuntu/Debian)
sudo apt install -y jq

# Linux (RHEL/CentOS/Fedora)
sudo yum install -y jq

# インストール確認
jq --version
```

### エラー: Speaker ID が見つからない

```bash
# スピーカー一覧を取得
curl http://127.0.0.1:50021/speakers | jq '.[] | {name: .name, styles: [.styles[].id]}'

# 出力例:
# {
#   "name": "四国めたん",
#   "styles": [0, 1, 2, ...]
# }
# {
#   "name": "春日部つむぎ",
#   "styles": [8, 9, 10, ...]
# }

# config/voicevox_config.sh で正しい ID を設定
vim config/voicevox_config.sh
# REIMU_SPEAKER_ID=0
# MARISA_SPEAKER_ID=8
```

### ログ確認

```bash
# ナレーションログ表示
tail -f /tmp/voicevox_narrator.log

# VOICEVOX エンジンログ表示
tail -f /tmp/voicevox_engine.log

# デバッグモード有効化
export LOG_LEVEL="DEBUG"
./scripts/voicevox_narrator.sh test reimu
```

---

## 自動起動設定（オプション）

### macOS - LaunchAgent

```bash
# LaunchAgent plist 作成
mkdir -p ~/Library/LaunchAgents

cat > ~/Library/LaunchAgents/com.voicevox.engine.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.voicevox.engine</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/VOICEVOX.app/Contents/MacOS/run</string>
        <string>--host</string>
        <string>127.0.0.1</string>
        <string>--port</string>
        <string>50021</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/voicevox_engine.log</string>
    <key>StandardOutPath</key>
    <string>/tmp/voicevox_engine.log</string>
</dict>
</plist>
EOF

# サービス有効化
launchctl load ~/Library/LaunchAgents/com.voicevox.engine.plist

# 起動確認
launchctl list | grep voicevox
```

### Linux - systemd

```bash
# systemd サービスファイル作成（上記「VOICEVOX エンジン起動」セクション参照）
sudo systemctl enable voicevox
sudo systemctl start voicevox

# ステータス確認
sudo systemctl status voicevox
```

---

## アンインストール

### macOS

```bash
# VOICEVOX アプリ削除
rm -rf /Applications/VOICEVOX.app

# LaunchAgent 削除（設定した場合）
launchctl unload ~/Library/LaunchAgents/com.voicevox.engine.plist
rm ~/Library/LaunchAgents/com.voicevox.engine.plist

# キャッシュ削除
rm -rf /tmp/voicevox_cache
rm /tmp/voicevox_*.log
```

### Linux

```bash
# VOICEVOX AppImage 削除
sudo rm /usr/local/bin/voicevox
sudo rm -rf /opt/voicevox

# systemd サービス削除（設定した場合）
sudo systemctl stop voicevox
sudo systemctl disable voicevox
sudo rm /etc/systemd/system/voicevox.service
sudo systemctl daemon-reload

# キャッシュ削除
rm -rf /tmp/voicevox_cache
rm /tmp/voicevox_*.log
```

---

## 次のステップ

インストールが完了したら:

1. [DIALOGUE_GUIDE.md](DIALOGUE_GUIDE.md) - 台本の作成・カスタマイズ
2. [TECHNICAL_SPECS.md](TECHNICAL_SPECS.md) - API 仕様・アーキテクチャ
3. [README.md](README.md) - 全体概要に戻る

---

**セットアップ完了！** ナレーション付き tmux 可視化を楽しんでください！
