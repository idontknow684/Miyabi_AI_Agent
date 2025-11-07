#!/usr/bin/env python3
"""
VoiceVox Task Enqueue Client
タスクをバックグラウンドワーカーのキューに追加するクライアント

Usage:
    # 通常の優先度でタスクを追加
    python3 voicevox_enqueue.py "こんにちは" zundamon

    # 高優先度でタスクを追加
    python3 voicevox_enqueue.py --priority high "重要なメッセージ" metan

    # 緊急タスクを追加
    python3 voicevox_enqueue.py --priority critical "緊急メッセージ" tsumugi

    # 複数タスクをバッチ追加
    python3 voicevox_enqueue.py --batch tasks.json
"""

import sys
import json
import time
from pathlib import Path
from dataclasses import dataclass, asdict
from typing import Optional, List


# Configuration
TASK_QUEUE_FILE = "/tmp/voicevox_tasks.json"
MAX_QUEUE_SIZE = 100


@dataclass
class VoiceTask:
    """音声合成タスク"""
    text: str
    speaker: str = "zundamon"
    priority: int = 0  # 0 = normal, 1 = high, 2 = critical
    task_id: Optional[str] = None
    timestamp: Optional[float] = None

    def __post_init__(self):
        if self.task_id is None:
            self.task_id = f"task_{int(time.time() * 1000000)}"
        if self.timestamp is None:
            self.timestamp = time.time()


class TaskQueueClient:
    """タスクキュークライアント"""

    def __init__(self, queue_file: str = TASK_QUEUE_FILE):
        self.queue_file = Path(queue_file)

    def _load_queue(self) -> List[dict]:
        """キューからタスクを読み込み"""
        if self.queue_file.exists():
            try:
                with open(self.queue_file, 'r') as f:
                    return json.load(f)
            except Exception as e:
                print(f"⚠ Failed to load queue: {e}", file=sys.stderr)
                return []
        return []

    def _save_queue(self, tasks: List[dict]):
        """タスクをキューに保存"""
        try:
            # 優先度でソート（高い順）
            tasks.sort(key=lambda t: t.get("priority", 0), reverse=True)

            with open(self.queue_file, 'w') as f:
                json.dump(tasks, f, indent=2)

            return True
        except Exception as e:
            print(f"✗ Failed to save queue: {e}", file=sys.stderr)
            return False

    def enqueue(self, task: VoiceTask) -> bool:
        """タスクをキューに追加"""
        tasks = self._load_queue()

        # キューサイズをチェック
        if len(tasks) >= MAX_QUEUE_SIZE:
            print(f"✗ Queue is full (max: {MAX_QUEUE_SIZE})", file=sys.stderr)
            return False

        # タスクを追加
        tasks.append(asdict(task))

        # 保存
        if self._save_queue(tasks):
            priority_label = {0: "NORMAL", 1: "HIGH", 2: "CRITICAL"}.get(task.priority, "UNKNOWN")
            print(f"✓ Task enqueued: {task.task_id} (priority: {priority_label})", file=sys.stderr)
            print(f"  Text: \"{task.text[:50]}...\"", file=sys.stderr)
            print(f"  Speaker: {task.speaker}", file=sys.stderr)
            print(f"  Queue size: {len(tasks)}", file=sys.stderr)
            return True

        return False

    def enqueue_batch(self, tasks: List[VoiceTask]) -> int:
        """複数のタスクをバッチで追加"""
        existing_tasks = self._load_queue()
        success_count = 0

        for task in tasks:
            if len(existing_tasks) + success_count >= MAX_QUEUE_SIZE:
                print(f"⚠ Queue full, skipping remaining tasks", file=sys.stderr)
                break

            existing_tasks.append(asdict(task))
            success_count += 1

        if success_count > 0 and self._save_queue(existing_tasks):
            print(f"✓ Enqueued {success_count} tasks (total: {len(existing_tasks)})", file=sys.stderr)
            return success_count

        return 0

    def status(self):
        """キューの状態を表示"""
        tasks = self._load_queue()
        print(f"Queue size: {len(tasks)}", file=sys.stderr)

        if tasks:
            print("\nPending tasks:", file=sys.stderr)
            for i, task_data in enumerate(tasks[:10]):  # 最初の10件のみ表示
                task = VoiceTask(**task_data)
                priority_label = {0: "NORMAL", 1: "HIGH", 2: "CRITICAL"}.get(task.priority, "UNKNOWN")
                print(f"  [{i+1}] {task.task_id} - Priority: {priority_label}", file=sys.stderr)
                print(f"      Text: \"{task.text[:40]}...\"", file=sys.stderr)

            if len(tasks) > 10:
                print(f"  ... and {len(tasks) - 10} more tasks", file=sys.stderr)


def main():
    """メイン関数"""
    import argparse

    parser = argparse.ArgumentParser(description="Enqueue VoiceVox tasks")
    parser.add_argument("text", nargs="?", help="Text to speak")
    parser.add_argument("speaker", nargs="?", default="zundamon", help="Speaker (default: zundamon)")
    parser.add_argument("--priority", choices=["normal", "high", "critical"], default="normal", help="Task priority")
    parser.add_argument("--batch", help="Batch enqueue from JSON file")
    parser.add_argument("--status", action="store_true", help="Show queue status")

    args = parser.parse_args()

    client = TaskQueueClient()

    # ステータス表示
    if args.status:
        client.status()
        return

    # バッチモード
    if args.batch:
        try:
            with open(args.batch, 'r') as f:
                batch_data = json.load(f)

            tasks = []
            for item in batch_data:
                task = VoiceTask(
                    text=item["text"],
                    speaker=item.get("speaker", "zundamon"),
                    priority={"normal": 0, "high": 1, "critical": 2}.get(item.get("priority", "normal"), 0)
                )
                tasks.append(task)

            client.enqueue_batch(tasks)
            return

        except Exception as e:
            print(f"✗ Batch enqueue failed: {e}", file=sys.stderr)
            sys.exit(1)

    # 単一タスクモード
    if not args.text:
        parser.print_help()
        sys.exit(1)

    priority_map = {"normal": 0, "high": 1, "critical": 2}
    task = VoiceTask(
        text=args.text,
        speaker=args.speaker,
        priority=priority_map[args.priority]
    )

    if client.enqueue(task):
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
