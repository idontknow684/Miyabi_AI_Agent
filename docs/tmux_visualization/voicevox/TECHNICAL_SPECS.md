# VOICEVOX Integration - Technical Specifications

**Version**: 1.0.0
**Last Updated**: 2025-11-07

---

## 目次

1. [アーキテクチャ概要](#アーキテクチャ概要)
2. [VOICEVOX API 仕様](#voicevox-api-仕様)
3. [システムコンポーネント](#システムコンポーネント)
4. [データフロー](#データフロー)
5. [パフォーマンス最適化](#パフォーマンス最適化)
6. [セキュリティ考慮事項](#セキュリティ考慮事項)

---

## アーキテクチャ概要

### システム構成図

```
┌─────────────────────────────────────────────────────────┐
│                   tmux Visualization                     │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐      │
│  │  Pane1  │ │  Pane2  │ │  Pane3  │ │  Pane4  │      │
│  │ θ₁-θ₂   │ │ θ₃-θ₄   │ │ θ₅-θ₆   │ │ Monitor │      │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘      │
│       │           │           │           │            │
│       └───────────┴───────────┴───────────┘            │
│                      │                                  │
│                      ▼                                  │
│            ┌──────────────────┐                         │
│            │  Event Listener  │                         │
│            └────────┬─────────┘                         │
└─────────────────────┼──────────────────────────────────┘
                      │
                      ▼
        ┌─────────────────────────┐
        │  Narration Orchestrator │
        └────────┬────────────────┘
                 │
     ┌───────────┼───────────┐
     │           │           │
     ▼           ▼           ▼
┌─────────┐ ┌─────────┐ ┌──────────┐
│Dialogue │ │ Audio   │ │ Cache    │
│ Manager │ │ Queue   │ │ Manager  │
└────┬────┘ └────┬────┘ └────┬─────┘
     │           │           │
     └───────────┼───────────┘
                 │
                 ▼
       ┌──────────────────┐
       │  VOICEVOX API    │
       └─────────┬────────┘
                 │
     ┌───────────┼───────────┐
     │           │           │
     ▼           ▼           ▼
┌─────────┐ ┌─────────┐ ┌─────────┐
│ Reimu   │ │ Marisa  │ │ Audio   │
│ Voice   │ │ Voice   │ │ Output  │
└─────────┘ └─────────┘ └─────────┘
```

### コンポーネント一覧

| コンポーネント | 責務 | 実装ファイル |
|--------------|------|-------------|
| Event Listener | tmux イベント監視 | `event_listener.sh` |
| Narration Orchestrator | ナレーション統制 | `voicevox_narrator.sh` |
| Dialogue Manager | 台本選択・管理 | `dialogue_manager.sh` |
| Audio Queue | オーディオキュー管理 | `audio_queue.sh` |
| Cache Manager | 音声キャッシュ管理 | `cache_manager.sh` |
| VOICEVOX API Wrapper | API 抽象化レイヤー | `voicevox_api.sh` |

---

## VOICEVOX API 仕様

### エンドポイント一覧

#### 1. バージョン情報取得

```bash
GET http://127.0.0.1:50021/version
```

**レスポンス**:
```json
"0.14.5"
```

#### 2. スピーカー一覧取得

```bash
GET http://127.0.0.1:50021/speakers
```

**レスポンス**:
```json
[
  {
    "name": "四国めたん",
    "speaker_uuid": "7ffcb7ce-00ec-4bdc-82cd-45a8889e43ff",
    "styles": [
      {"name": "ノーマル", "id": 0},
      {"name": "あまあま", "id": 1},
      {"name": "ツンツン", "id": 2}
    ],
    "version": "0.14.5"
  },
  {
    "name": "春日部つむぎ",
    "speaker_uuid": "35b2c544-660e-401e-b503-0e14c635303a",
    "styles": [
      {"name": "ノーマル", "id": 8}
    ],
    "version": "0.14.5"
  }
]
```

#### 3. 音声合成クエリ作成

```bash
POST http://127.0.0.1:50021/audio_query?text={text}&speaker={speaker_id}
```

**パラメータ**:
- `text`: 読み上げテキスト（UTF-8 URL エンコード）
- `speaker`: スピーカー ID（整数）

**レスポンス**:
```json
{
  "accent_phrases": [...],
  "speedScale": 1.0,
  "pitchScale": 0.0,
  "intonationScale": 1.0,
  "volumeScale": 1.0,
  "prePhonemeLength": 0.1,
  "postPhonemeLength": 0.1,
  "outputSamplingRate": 24000,
  "outputStereo": false,
  "kana": "テストオンセイデス"
}
```

#### 4. 音声合成

```bash
POST http://127.0.0.1:50021/synthesis?speaker={speaker_id}
Content-Type: application/json

{音声合成クエリ JSON}
```

**レスポンス**:
- `Content-Type: audio/wav`
- WAV ファイルバイナリ

### API 使用フロー

```bash
# 1. 音声合成クエリ作成
QUERY=$(curl -s -X POST "http://127.0.0.1:50021/audio_query?text=こんにちは&speaker=0")

# 2. 音声合成実行
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d "$QUERY" \
  "http://127.0.0.1:50021/synthesis?speaker=0" \
  -o output.wav

# 3. 音声再生
afplay output.wav  # macOS
```

### エラーハンドリング

| HTTP ステータス | 意味 | 対処方法 |
|----------------|------|---------|
| 200 | 成功 | - |
| 400 | パラメータ不正 | パラメータを確認 |
| 404 | エンドポイント不正 | URL を確認 |
| 422 | スピーカー ID 不正 | 利用可能な ID を確認 |
| 500 | サーバーエラー | VOICEVOX 再起動 |
| 503 | サービス利用不可 | 起動確認 |

---

## システムコンポーネント

### 1. Event Listener (`event_listener.sh`)

**責務**:
- tmux ペインの出力を監視
- フェーズ遷移を検出
- 収束率の変化を検出
- イベントトリガー

**実装詳細**:
```bash
#!/bin/bash

# tmux ペイン出力監視
monitor_pane() {
    local pane_id=$1
    local last_content=""

    while true; do
        current_content=$(tmux capture-pane -p -t "$pane_id")

        # 差分検出
        if [[ "$current_content" != "$last_content" ]]; then
            detect_events "$current_content"
            last_content="$current_content"
        fi

        sleep 1
    done
}

# イベント検出
detect_events() {
    local content=$1

    # フェーズ遷移検出
    if echo "$content" | grep -q "θ₁.*Understand"; then
        trigger_event "phase_theta1_start"
    fi

    # 収束率検出
    if echo "$content" | grep -oP 'Convergence: \K\d+' | tail -1; then
        local percent=$?
        if [[ $percent -eq 25 ]] || [[ $percent -eq 50 ]] || \
           [[ $percent -eq 75 ]] || [[ $percent -eq 100 ]]; then
            trigger_event "convergence_$percent"
        fi
    fi
}

# イベントトリガー
trigger_event() {
    local event_name=$1
    ./voicevox_narrator.sh event "$event_name" &
}
```

### 2. Narration Orchestrator (`voicevox_narrator.sh`)

**責務**:
- イベント受信
- 台本選択
- オーディオキュー管理
- フォールバック処理

**コマンドラインインターフェース**:
```bash
# イベントトリガー
./voicevox_narrator.sh event <event_name>

# 直接発話
./voicevox_narrator.sh speak <character> <text>

# テスト
./voicevox_narrator.sh test <character>

# ステータス確認
./voicevox_narrator.sh status
```

**実装詳細**:
```bash
#!/bin/bash

source config/voicevox_config.sh

# メイン処理
main() {
    local command=$1
    shift

    case $command in
        event)
            handle_event "$@"
            ;;
        speak)
            speak_text "$@"
            ;;
        test)
            test_voice "$@"
            ;;
        status)
            show_status
            ;;
        *)
            show_help
            ;;
    esac
}

# イベントハンドラー
handle_event() {
    local event_name=$1

    # 台本ファイル検索
    local dialogue_file=$(find_dialogue "$event_name")

    if [[ -z "$dialogue_file" ]]; then
        log "ERROR" "Dialogue not found: $event_name"
        return 1
    fi

    # 台本実行
    execute_dialogue "$dialogue_file"
}

# 台本実行
execute_dialogue() {
    local dialogue_file=$1

    while IFS= read -r line; do
        # コメント・空行スキップ
        [[ $line =~ ^#.*$ ]] || [[ -z $line ]] && continue

        # 話者とセリフ分離
        if [[ $line =~ ^REIMU:\ (.+)$ ]]; then
            speak_text "reimu" "${BASH_REMATCH[1]}"
        elif [[ $line =~ ^MARISA:\ (.+)$ ]]; then
            speak_text "marisa" "${BASH_REMATCH[1]}"
        fi
    done < "$dialogue_file"
}

# 発話処理
speak_text() {
    local character=$1
    local text=$2

    # Speaker ID 取得
    local speaker_id
    case $character in
        reimu)
            speaker_id=$REIMU_SPEAKER_ID
            ;;
        marisa)
            speaker_id=$MARISA_SPEAKER_ID
            ;;
        *)
            log "ERROR" "Unknown character: $character"
            return 1
            ;;
    esac

    # キャッシュチェック
    local cache_file=$(get_cache_file "$character" "$text")

    if [[ -f "$cache_file" ]]; then
        log "DEBUG" "Using cache: $cache_file"
        play_audio "$cache_file"
        return 0
    fi

    # 音声合成
    local audio_file=$(synthesize_voice "$speaker_id" "$text")

    if [[ $? -ne 0 ]]; then
        log "ERROR" "Voice synthesis failed"
        fallback_text_display "$character" "$text"
        return 1
    fi

    # キャッシュ保存
    cp "$audio_file" "$cache_file"

    # 音声再生
    play_audio "$audio_file"
}

main "$@"
```

### 3. VOICEVOX API Wrapper (`voicevox_api.sh`)

**責務**:
- VOICEVOX API 呼び出し
- リトライ処理
- エラーハンドリング

**実装詳細**:
```bash
#!/bin/bash

source config/voicevox_config.sh

# 音声合成
synthesize_voice() {
    local speaker_id=$1
    local text=$2
    local output_file="/tmp/voicevox_$$.wav"

    # Step 1: 音声合成クエリ作成
    local query=$(create_audio_query "$speaker_id" "$text")

    if [[ $? -ne 0 ]]; then
        log "ERROR" "Audio query creation failed"
        return 1
    fi

    # Step 2: 音声合成実行
    local response=$(curl -s -w "\n%{http_code}" -X POST \
        -H "Content-Type: application/json" \
        -d "$query" \
        "${VOICEVOX_HOST}:${VOICEVOX_PORT}/synthesis?speaker=$speaker_id" \
        -o "$output_file")

    local http_code=$(echo "$response" | tail -1)

    if [[ $http_code -ne 200 ]]; then
        log "ERROR" "Synthesis failed: HTTP $http_code"
        rm -f "$output_file"
        return 1
    fi

    echo "$output_file"
    return 0
}

# 音声合成クエリ作成
create_audio_query() {
    local speaker_id=$1
    local text=$2
    local encoded_text=$(urlencode "$text")

    local query=$(curl -s -X POST \
        "${VOICEVOX_HOST}:${VOICEVOX_PORT}/audio_query?text=$encoded_text&speaker=$speaker_id")

    if [[ -z "$query" ]]; then
        return 1
    fi

    # パラメータ調整（オプション）
    query=$(echo "$query" | jq \
        --arg speed "$SPEECH_SPEED" \
        --arg volume "$AUDIO_VOLUME" \
        '.speedScale = ($speed | tonumber) | .volumeScale = ($volume | tonumber)')

    echo "$query"
    return 0
}

# URL エンコード
urlencode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for ((pos=0; pos<strlen; pos++)); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9])
                o="$c"
                ;;
            *)
                printf -v o '%%%02x' "'$c"
                ;;
        esac
        encoded+="$o"
    done

    echo "$encoded"
}
```

### 4. Audio Queue Manager (`audio_queue.sh`)

**責務**:
- オーディオ再生キュー管理
- 同時再生防止
- キュー優先度制御

**実装詳細**:
```bash
#!/bin/bash

QUEUE_FILE="/tmp/voicevox_audio_queue"
LOCK_FILE="/tmp/voicevox_audio_queue.lock"
MAX_QUEUE_SIZE=5

# キューに追加
enqueue_audio() {
    local audio_file=$1
    local priority=${2:-normal}  # high | normal | low

    # ロック取得
    exec 200>"$LOCK_FILE"
    flock -x 200

    # キューサイズチェック
    local queue_size=$(wc -l < "$QUEUE_FILE" 2>/dev/null || echo 0)

    if [[ $queue_size -ge $MAX_QUEUE_SIZE ]]; then
        log "WARN" "Queue full, dropping oldest entry"
        tail -n $((MAX_QUEUE_SIZE - 1)) "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
        mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"
    fi

    # キューに追加
    echo "$priority|$audio_file" >> "$QUEUE_FILE"

    # ロック解放
    flock -u 200

    # プレイヤー起動（未起動の場合）
    if ! pgrep -f "audio_queue_player" > /dev/null; then
        audio_queue_player &
    fi
}

# キュープレイヤー
audio_queue_player() {
    while true; do
        # ロック取得
        exec 200>"$LOCK_FILE"
        flock -x 200

        # キューから取り出し
        if [[ -f "$QUEUE_FILE" ]] && [[ -s "$QUEUE_FILE" ]]; then
            local entry=$(head -n 1 "$QUEUE_FILE")
            tail -n +2 "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
            mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"

            # ロック解放
            flock -u 200

            # 再生
            local priority=$(echo "$entry" | cut -d'|' -f1)
            local audio_file=$(echo "$entry" | cut -d'|' -f2)

            if [[ -f "$audio_file" ]]; then
                afplay "$audio_file" 2>/dev/null || \
                paplay "$audio_file" 2>/dev/null
            fi
        else
            # ロック解放
            flock -u 200
        fi

        sleep 0.1
    done
}
```

### 5. Cache Manager (`cache_manager.sh`)

**責務**:
- 音声ファイルキャッシュ
- キャッシュサイズ管理
- 古いキャッシュ削除

**実装詳細**:
```bash
#!/bin/bash

source config/voicevox_config.sh

# キャッシュファイルパス生成
get_cache_file() {
    local character=$1
    local text=$2

    # MD5 ハッシュ生成
    local hash=$(echo -n "${character}_${text}" | md5sum | cut -d' ' -f1)

    echo "${CACHE_DIR}/${character}_${hash}.wav"
}

# キャッシュクリーンアップ
cleanup_cache() {
    local max_age_days=${1:-7}

    log "INFO" "Starting cache cleanup (max age: $max_age_days days)"

    # 7日以上古いファイル削除
    find "$CACHE_DIR" -name "*.wav" -mtime +$max_age_days -delete

    # サイズチェック
    local cache_size_mb=$(du -sm "$CACHE_DIR" | cut -f1)

    if [[ $cache_size_mb -gt $CACHE_MAX_SIZE_MB ]]; then
        log "WARN" "Cache size exceeds limit: ${cache_size_mb}MB > ${CACHE_MAX_SIZE_MB}MB"

        # 最も古いファイルから削除
        find "$CACHE_DIR" -name "*.wav" -type f -printf '%T+ %p\n' | \
            sort | \
            head -n 10 | \
            cut -d' ' -f2- | \
            xargs rm -f

        log "INFO" "Deleted 10 oldest cache files"
    fi

    log "INFO" "Cache cleanup completed"
}

# キャッシュ統計
cache_stats() {
    local total_files=$(find "$CACHE_DIR" -name "*.wav" | wc -l)
    local total_size_mb=$(du -sm "$CACHE_DIR" | cut -f1)
    local usage_percent=$((total_size_mb * 100 / CACHE_MAX_SIZE_MB))

    echo "Cache Statistics:"
    echo "  Total files: $total_files"
    echo "  Total size: ${total_size_mb}MB / ${CACHE_MAX_SIZE_MB}MB"
    echo "  Usage: ${usage_percent}%"
}
```

---

## データフロー

### 通常フロー

```
1. tmux イベント発生
   │
   ▼
2. Event Listener が検出
   │
   ▼
3. Narration Orchestrator にイベント通知
   │
   ▼
4. Dialogue Manager が台本選択
   │
   ▼
5. Cache Manager がキャッシュチェック
   │
   ├─ キャッシュあり → 9. へ
   │
   └─ キャッシュなし
       │
       ▼
6. VOICEVOX API で音声合成
   │
   ▼
7. Cache Manager にキャッシュ保存
   │
   ▼
8. Audio Queue に追加
   │
   ▼
9. Audio Queue Player が再生
```

### エラー時フォールバックフロー

```
1. VOICEVOX API エラー
   │
   ▼
2. リトライ（最大3回）
   │
   ├─ 成功 → 通常フローへ
   │
   └─ 失敗
       │
       ▼
3. フォールバックモード起動
   │
   ▼
4. テキスト表示（tmux ペイン8）
   │
   ▼
5. ログ記録
```

---

## パフォーマンス最適化

### 1. キャッシュ戦略

**利点**:
- API 呼び出し削減（99% ヒット率目標）
- レスポンス時間短縮（50ms vs 500ms）
- VOICEVOX 負荷軽減

**実装**:
- キャッシュキー: `MD5(character + text)`
- キャッシュサイズ: 500MB（約1,000ファイル）
- TTL: 7日間

### 2. オーディオキュー

**利点**:
- 重複再生防止
- スムーズな音声遷移
- システムリソース保護

**実装**:
- キューサイズ: 5件
- 優先度制御: high > normal > low
- バックグラウンドプレイヤー

### 3. 非同期処理

```bash
# ブロッキング（同期）
./voicevox_narrator.sh event phase_theta1_start --wait

# ノンブロッキング（非同期）
./voicevox_narrator.sh event phase_theta1_start &
```

### 4. バッチ処理

```bash
# 複数イベントを一括処理
./voicevox_narrator.sh batch << EOF
event phase_theta1_start
event phase_theta2_start
event convergence_50
EOF
```

---

## セキュリティ考慮事項

### 1. ローカル実行

- VOICEVOX は `127.0.0.1` でのみリッスン
- 外部ネットワークからアクセス不可
- ファイアウォール設定不要

### 2. 入力サニタイゼーション

```bash
# 特殊文字エスケープ
sanitize_text() {
    local text=$1
    # SQLインジェクション対策（不要だが念のため）
    echo "$text" | sed 's/[;&|]//g'
}
```

### 3. ファイルパーミッション

```bash
# キャッシュディレクトリ
chmod 755 /tmp/voicevox_cache

# スクリプトファイル
chmod 755 scripts/*.sh

# 設定ファイル
chmod 644 config/*.sh
```

### 4. ログ管理

```bash
# 機密情報のログ出力防止
log() {
    local level=$1
    local message=$2

    # API キーなどは出力しない
    if [[ $message =~ (api_key|token|password) ]]; then
        message="[REDACTED]"
    fi

    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}
```

---

## 拡張性

### 新しいキャラクター追加

```bash
# config/voicevox_config.sh に追加
export SAKURA_SPEAKER_ID=10  # ずんだもん

# dialogues/に台本追加
# SAKURA: セリフ内容

# voicevox_narrator.sh で対応
case $character in
    reimu) speaker_id=$REIMU_SPEAKER_ID ;;
    marisa) speaker_id=$MARISA_SPEAKER_ID ;;
    sakura) speaker_id=$SAKURA_SPEAKER_ID ;;  # 追加
esac
```

### カスタムイベント追加

```bash
# config/narration_events.json に追加
{
  "custom_events": [
    {
      "event_name": "deployment_start",
      "dialogue_file": "custom/deployment.txt",
      "priority": "high"
    }
  ]
}
```

---

## 依存関係

### 必須

- VOICEVOX Engine 0.14.0+
- bash 4.0+
- curl 7.0+
- jq 1.5+
- afplay (macOS) / paplay (Linux)

### オプション

- tmux 3.0+（tmux統合の場合）
- flock（キュー管理）
- md5sum（キャッシュ管理）

---

**次のステップ**: 実際のスクリプトファイルを確認して実装を開始しましょう！
