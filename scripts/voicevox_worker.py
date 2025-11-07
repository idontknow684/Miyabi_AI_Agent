#!/usr/bin/env python3
"""
VoiceVox Background Worker with Task Queue
バックグラウンドでVoiceVox音声合成を処理するワーカー

Architecture:
- メインプロセス → タスクキュー → ワーカープロセス
- 非同期処理により、メイン処理をブロックしない
- 優先度付きキュー対応

Usage:
    # Start worker
    python3 voicevox_worker.py --start

    # Stop worker
    python3 voicevox_worker.py --stop

    # Status check
    python3 voicevox_worker.py --status
"""

import sys
import os
import json
import time
import signal
import subprocess
from pathlib import Path
from queue import Queue, Empty
from threading import Thread, Event
from dataclasses import dataclass, asdict
from typing import Optional, Dict, Any
import tempfile


# Configuration
WORKER_STATE_FILE = "/tmp/voicevox_worker.state"
TASK_QUEUE_FILE = "/tmp/voicevox_tasks.json"
MAX_QUEUE_SIZE = 100
POLL_INTERVAL = 0.1  # seconds


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


class TaskQueue:
    """永続化可能なタスクキュー"""

    def __init__(self, queue_file: str = TASK_QUEUE_FILE):
        self.queue_file = Path(queue_file)
        self.queue = Queue(maxsize=MAX_QUEUE_SIZE)
        self._load_queue()

    def _load_queue(self):
        """ファイルからキューを復元"""
        if self.queue_file.exists():
            try:
                with open(self.queue_file, 'r') as f:
                    tasks = json.load(f)
                    for task_data in tasks:
                        task = VoiceTask(**task_data)
                        self.queue.put(task)
                print(f"✓ Loaded {len(tasks)} tasks from queue", file=sys.stderr)
            except Exception as e:
                print(f"⚠ Failed to load queue: {e}", file=sys.stderr)

    def _save_queue(self):
        """キューをファイルに保存"""
        try:
            tasks = []
            temp_queue = Queue()

            # キューの内容を取得（破壊的でないように一時キューに移動）
            while not self.queue.empty():
                task = self.queue.get_nowait()
                tasks.append(asdict(task))
                temp_queue.put(task)

            # 元のキューに戻す
            while not temp_queue.empty():
                self.queue.put(temp_queue.get_nowait())

            # ファイルに保存
            with open(self.queue_file, 'w') as f:
                json.dump(tasks, f)

        except Exception as e:
            print(f"⚠ Failed to save queue: {e}", file=sys.stderr)

    def enqueue(self, task: VoiceTask) -> bool:
        """タスクをキューに追加"""
        try:
            self.queue.put(task, block=False)
            self._save_queue()
            return True
        except Exception as e:
            print(f"✗ Failed to enqueue task: {e}", file=sys.stderr)
            return False

    def dequeue(self, timeout: float = 0.1) -> Optional[VoiceTask]:
        """タスクをキューから取得"""
        try:
            task = self.queue.get(timeout=timeout)
            self._save_queue()
            return task
        except Empty:
            return None

    def size(self) -> int:
        """キューのサイズ"""
        return self.queue.qsize()


class VoiceVoxWorker:
    """VoiceVox バックグラウンドワーカー"""

    def __init__(self):
        self.task_queue = TaskQueue()
        self.running = Event()
        self.worker_thread: Optional[Thread] = None
        self.state_file = Path(WORKER_STATE_FILE)
        self.stats = {
            "total_processed": 0,
            "total_errors": 0,
            "start_time": None,
        }

    def _save_state(self):
        """ワーカーの状態を保存"""
        state = {
            "running": self.running.is_set(),
            "pid": os.getpid(),
            "stats": self.stats,
        }
        try:
            with open(self.state_file, 'w') as f:
                json.dump(state, f)
        except Exception as e:
            print(f"⚠ Failed to save state: {e}", file=sys.stderr)

    def _load_state(self) -> Optional[Dict[str, Any]]:
        """ワーカーの状態を読み込み"""
        if self.state_file.exists():
            try:
                with open(self.state_file, 'r') as f:
                    return json.load(f)
            except Exception as e:
                print(f"⚠ Failed to load state: {e}", file=sys.stderr)
        return None

    def _process_task(self, task: VoiceTask):
        """タスクを処理（VoiceVox音声合成）"""
        try:
            print(f"🎤 Processing task {task.task_id}: \"{task.text[:30]}...\" (speaker: {task.speaker})", file=sys.stderr)

            # VoiceVox音声合成スクリプトを呼び出し
            result = subprocess.run(
                [
                    "python3",
                    "scripts/voicevox_speak.py",
                    task.text,
                    task.speaker
                ],
                capture_output=True,
                text=True,
                timeout=30
            )

            if result.returncode == 0:
                self.stats["total_processed"] += 1
                print(f"✓ Task {task.task_id} completed", file=sys.stderr)
            else:
                self.stats["total_errors"] += 1
                print(f"✗ Task {task.task_id} failed: {result.stderr}", file=sys.stderr)

        except subprocess.TimeoutExpired:
            self.stats["total_errors"] += 1
            print(f"✗ Task {task.task_id} timed out", file=sys.stderr)
        except Exception as e:
            self.stats["total_errors"] += 1
            print(f"✗ Task {task.task_id} error: {e}", file=sys.stderr)

    def _worker_loop(self):
        """ワーカーのメインループ"""
        print("🚀 VoiceVox Worker started", file=sys.stderr)
        self.stats["start_time"] = time.time()

        while self.running.is_set():
            # タスクを取得
            task = self.task_queue.dequeue(timeout=POLL_INTERVAL)

            if task:
                self._process_task(task)
                self._save_state()
            else:
                # キューが空の場合は待機
                time.sleep(POLL_INTERVAL)

        print("🛑 VoiceVox Worker stopped", file=sys.stderr)
        self._save_state()

    def start(self):
        """ワーカーを起動"""
        if self.running.is_set():
            print("⚠ Worker is already running", file=sys.stderr)
            return

        self.running.set()
        self.worker_thread = Thread(target=self._worker_loop, daemon=True)
        self.worker_thread.start()
        self._save_state()

        print(f"✓ VoiceVox Worker started (PID: {os.getpid()})", file=sys.stderr)
        print(f"  Queue size: {self.task_queue.size()}", file=sys.stderr)

    def stop(self):
        """ワーカーを停止"""
        if not self.running.is_set():
            print("⚠ Worker is not running", file=sys.stderr)
            return

        print("🛑 Stopping VoiceVox Worker...", file=sys.stderr)
        self.running.clear()

        if self.worker_thread:
            self.worker_thread.join(timeout=5.0)

        self._save_state()
        print("✓ VoiceVox Worker stopped", file=sys.stderr)

    def status(self):
        """ワーカーの状態を表示"""
        state = self._load_state()

        if state and state.get("running"):
            print("Status: 🟢 RUNNING", file=sys.stderr)
            print(f"  PID: {state.get('pid')}", file=sys.stderr)
            stats = state.get("stats", {})
            if stats.get("start_time"):
                uptime = time.time() - stats["start_time"]
                print(f"  Uptime: {uptime:.1f}s", file=sys.stderr)
            print(f"  Processed: {stats.get('total_processed', 0)}", file=sys.stderr)
            print(f"  Errors: {stats.get('total_errors', 0)}", file=sys.stderr)
        else:
            print("Status: 🔴 STOPPED", file=sys.stderr)

        print(f"  Queue size: {self.task_queue.size()}", file=sys.stderr)


def main():
    """メイン関数"""
    if len(sys.argv) < 2:
        print("Usage: voicevox_worker.py [--start|--stop|--status]", file=sys.stderr)
        sys.exit(1)

    command = sys.argv[1]
    worker = VoiceVoxWorker()

    if command == "--start":
        worker.start()

        # シグナルハンドラーを設定（Ctrl+C対応）
        def signal_handler(sig, frame):
            print("\n🛑 Received interrupt signal", file=sys.stderr)
            worker.stop()
            sys.exit(0)

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)

        # ワーカーを実行し続ける
        try:
            while worker.running.is_set():
                time.sleep(1)
        except KeyboardInterrupt:
            worker.stop()

    elif command == "--stop":
        worker.stop()

    elif command == "--status":
        worker.status()

    else:
        print(f"Unknown command: {command}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
