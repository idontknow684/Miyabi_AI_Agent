#!/usr/bin/env python3
"""
VoiceVox Text-to-Speech Script
音声読み上げスクリプト

Usage:
    python3 voicevox_speak.py "読み上げるテキスト" [speaker_id]
"""

import sys
import json
import subprocess
import tempfile
from pathlib import Path
from urllib import request, error
from urllib.parse import urlencode

# VoiceVox API Configuration
VOICEVOX_URL = "http://localhost:50021"

# Speaker IDs (VoiceVox標準)
SPEAKERS = {
    "zundamon": 3,       # ずんだもん（ノーマル）
    "metan": 2,          # 四国めたん（ノーマル）
    "tsumugi": 8,        # 春日部つむぎ（ノーマル）
    "ritsu": 9,          # 雨晴はう（ノーマル）
    "default": 3         # デフォルト: ずんだもん
}


def check_voicevox_running():
    """Check if VoiceVox engine is running"""
    try:
        with request.urlopen(f"{VOICEVOX_URL}/version", timeout=2) as response:
            version = json.loads(response.read().decode())
            print(f"✓ VoiceVox Engine v{version} detected", file=sys.stderr)
            return True
    except (error.URLError, error.HTTPError):
        print("✗ VoiceVox Engine not running", file=sys.stderr)
        print("  Please start VoiceVox Engine first:", file=sys.stderr)
        print("  https://voicevox.hiroshiba.jp/", file=sys.stderr)
        return False


def text_to_speech(text: str, speaker_id: int = 3):
    """
    Convert text to speech using VoiceVox API

    Args:
        text: Text to convert to speech
        speaker_id: Speaker ID (default: 3 = ずんだもん)

    Returns:
        bytes: Audio data (wav format)
    """
    # Step 1: Generate audio query
    query_params = urlencode({"text": text, "speaker": speaker_id})
    query_url = f"{VOICEVOX_URL}/audio_query?{query_params}"

    try:
        req = request.Request(query_url, method="POST")
        with request.urlopen(req, timeout=10) as response:
            audio_query = response.read()
    except (error.URLError, error.HTTPError) as e:
        raise Exception(f"Failed to generate audio query: {e}")

    # Step 2: Synthesize speech
    synthesis_url = f"{VOICEVOX_URL}/synthesis?speaker={speaker_id}"
    headers = {"Content-Type": "application/json"}

    try:
        req = request.Request(
            synthesis_url,
            data=audio_query,
            headers=headers,
            method="POST"
        )
        with request.urlopen(req, timeout=30) as response:
            audio_data = response.read()
    except (error.URLError, error.HTTPError) as e:
        raise Exception(f"Failed to synthesize speech: {e}")

    return audio_data


def play_audio(audio_data: bytes):
    """
    Play audio data using system audio player

    Args:
        audio_data: Audio data in wav format
    """
    # Create temporary file
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as temp_file:
        temp_path = temp_file.name
        temp_file.write(audio_data)

    try:
        # Try different audio players based on platform
        players = [
            ["afplay", temp_path],          # macOS
            ["play", temp_path],            # Linux (sox)
            ["aplay", temp_path],           # Linux (alsa)
            ["ffplay", "-nodisp", "-autoexit", temp_path]  # Cross-platform (ffmpeg)
        ]

        played = False
        for player_cmd in players:
            try:
                subprocess.run(
                    player_cmd,
                    check=True,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL
                )
                played = True
                break
            except (subprocess.CalledProcessError, FileNotFoundError):
                continue

        if not played:
            print(f"⚠ No audio player found. Audio saved to: {temp_path}", file=sys.stderr)
            print(f"  You can play it manually with: afplay {temp_path}", file=sys.stderr)
        else:
            # Clean up temporary file after playback
            Path(temp_path).unlink(missing_ok=True)

    except Exception as e:
        print(f"✗ Failed to play audio: {e}", file=sys.stderr)
        Path(temp_path).unlink(missing_ok=True)


def main():
    """Main function"""
    if len(sys.argv) < 2:
        print("Usage: voicevox_speak.py <text> [speaker]", file=sys.stderr)
        print(f"\nAvailable speakers: {', '.join(SPEAKERS.keys())}", file=sys.stderr)
        sys.exit(1)

    text = sys.argv[1]

    # Parse speaker argument
    speaker_arg = sys.argv[2] if len(sys.argv) > 2 else "default"
    speaker_id = SPEAKERS.get(speaker_arg.lower(), SPEAKERS["default"])

    # Check if VoiceVox is running
    if not check_voicevox_running():
        sys.exit(1)

    print(f"🎤 Speaking: \"{text}\" (Speaker: {speaker_arg})", file=sys.stderr)

    try:
        # Generate speech
        audio_data = text_to_speech(text, speaker_id)

        # Play audio
        play_audio(audio_data)

        print("✓ Playback complete", file=sys.stderr)

    except Exception as e:
        print(f"✗ Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
