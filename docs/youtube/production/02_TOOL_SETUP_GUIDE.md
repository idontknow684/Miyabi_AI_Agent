# Tool Setup Guide - YouTube Production

**Last Updated**: 2025-11-07
**Platforms**: Windows 10/11, macOS
**Estimated Setup Time**: 4-6 hours

---

## Overview

This guide covers installation and configuration of all tools needed for YouTube video production:

1. **ゆっくりムービーメーカー4 (YMM4)** - Main editing software
2. **VOICEVOX** - Voice synthesis
3. **Adobe Photoshop/Canva** - Thumbnail design
4. **Supporting Tools** - Asset management, compression, etc.

---

## 1. ゆっくりムービーメーカー4 (YMM4)

### What is YMM4?

YMM4 is a free Japanese video editing software specifically designed for creating "Yukkuri" commentary videos with character avatars and auto-generated subtitles.

### System Requirements

**Minimum**:
- OS: Windows 7 or later (64-bit recommended)
- CPU: Intel Core i3 or equivalent
- RAM: 4GB
- GPU: DirectX 9 compatible
- Storage: 2GB free space

**Recommended**:
- OS: Windows 10/11 (64-bit)
- CPU: Intel Core i5 or better
- RAM: 8GB or more
- GPU: NVIDIA GeForce GTX 1050 or equivalent
- Storage: 10GB free space (for project files)

### Installation Steps

1. **Download YMM4**
   ```
   Official website: https://manjubox.net/ymm4/
   Download latest version (ymm4_setup.exe)
   ```

2. **Run Installer**
   - Double-click `ymm4_setup.exe`
   - Select installation language (Japanese)
   - Choose installation directory (default: C:\Program Files\YukkuriMovieMaker4)
   - Accept license agreement
   - Click Install

3. **Initial Setup**
   - Launch YMM4
   - Select project settings:
     - Video size: 1920x1080 (Full HD)
     - Frame rate: 60 fps
     - Audio: 48000 Hz stereo
   - Create new project folder for organization

4. **Install Character Voice Files**
   - YMM4 comes with default Yukkuri voices
   - For higher quality, integrate with VOICEVOX (see section 2)

### Basic Configuration

#### Video Settings
```
Resolution: 1920x1080 (1080p)
Frame Rate: 60 fps
Aspect Ratio: 16:9
Background Color: #FFFFFF (white) or custom
```

#### Audio Settings
```
Sample Rate: 48000 Hz
Channels: Stereo
Bit Depth: 24-bit
Master Volume: -3dB (headroom for mixing)
```

#### Project Organization
```
My Documents/YMM4/
├── Projects/
│   └── flickering_scenery/
│       ├── project.ymmp (YMM4 project file)
│       ├── audio/
│       ├── images/
│       ├── videos/
│       └── exports/
└── Assets/
    ├── characters/
    ├── effects/
    └── transitions/
```

### Essential Plugins

1. **AviUtl Bridge**
   - Allows exporting to AviUtl for advanced editing
   - Download: https://manjubox.net/ymm4/plugin/aviutl/

2. **Subtitle Enhancer**
   - Better subtitle styling options
   - Download: https://manjubox.net/ymm4/plugin/subtitle/

3. **Transition Pack**
   - Additional transition effects
   - Download: https://manjubox.net/ymm4/plugin/transitions/

### Keyboard Shortcuts (Essential)

```
Ctrl + S      : Save project
Ctrl + Z      : Undo
Ctrl + Y      : Redo
Space         : Play/Pause preview
Ctrl + E      : Export video
F5            : Refresh preview
Ctrl + D      : Duplicate selected item
Delete        : Delete selected item
Ctrl + C/V    : Copy/Paste
Arrow Keys    : Move timeline cursor
```

---

## 2. VOICEVOX

### What is VOICEVOX?

VOICEVOX is a free, open-source text-to-speech software with high-quality Japanese voices, perfect for Yukkuri-style videos.

### System Requirements

**Minimum**:
- OS: Windows 10 (64-bit), macOS 10.15+, Linux
- CPU: Intel Core i5 or equivalent
- RAM: 4GB
- Storage: 2GB free space

**Recommended**:
- OS: Windows 11 (64-bit) or macOS 12+
- CPU: Intel Core i7 or AMD Ryzen 5
- RAM: 8GB or more
- GPU: NVIDIA GPU with CUDA support (optional, for faster synthesis)
- Storage: 5GB free space

### Installation Steps (Windows)

1. **Download VOICEVOX**
   ```
   Official website: https://voicevox.hiroshiba.jp/
   Download: VOICEVOX-Windows-x64-[version].exe
   ```

2. **Install**
   - Run installer
   - Choose installation directory
   - Select voice libraries to install:
     - 四国めたん (Shikoku Metan) - Recommended
     - ずんだもん (Zundamon) - Recommended
     - 春日部つむぎ (Kasukabe Tsumugi)
     - 雨晴はう (Amehare Hau)

3. **Initial Configuration**
   - Launch VOICEVOX
   - Settings > Audio Settings:
     - Sample Rate: 48000 Hz (to match YMM4)
     - Output Format: WAV (16-bit or 24-bit)
   - Settings > Performance:
     - Enable GPU acceleration (if available)
     - Adjust synthesis speed

### VOICEVOX for YMM4 Integration

#### Method 1: Direct Integration (Recommended)

1. **Enable VOICEVOX in YMM4**
   - YMM4 > Settings > Voice
   - Select "VOICEVOX" as voice engine
   - Set VOICEVOX installation path
   - Test connection

2. **Character Voice Mapping**
   ```
   霊夢 (Reimu) → 四国めたん (Normal)
   魔理沙 (Marisa) → ずんだもん (Normal)
   ```

3. **Voice Parameters**
   - Speed: 1.0 (normal)
   - Pitch: 0.0 (default)
   - Intonation: 1.0 (default)
   - Volume: -3dB (headroom)

#### Method 2: Batch Audio Generation

1. **Prepare Script**
   - Export script from YMM4 or create text file
   - Format: One line per dialogue

2. **Generate Audio in VOICEVOX**
   - File > Import Text
   - Select character voice
   - Adjust parameters
   - Export as WAV files

3. **Import to YMM4**
   - YMM4 > Import Audio
   - Match audio files to timeline
   - Adjust timing as needed

### VOICEVOX Character Recommendations

**For Flickering Scenery Video**:

| Character | Voice | Personality | Use Case |
|-----------|-------|-------------|----------|
| 霊夢 (Reimu) | 四国めたん (Metan) - Normal | Calm, explanatory | Main narrator, technical explanations |
| 魔理沙 (Marisa) | ずんだもん (Zundamon) - Normal | Curious, questioning | Asking questions, reactions |
| Guest Expert | 春日部つむぎ (Tsumugi) - Serious | Professional, authoritative | Benchmark results, data |

### Audio Quality Settings

```
Format: WAV (uncompressed)
Sample Rate: 48000 Hz
Bit Depth: 24-bit
Channels: Mono (will be converted to stereo in YMM4)
Normalization: -3dB peak
Noise Reduction: Enabled
```

### Batch Processing Script (PowerShell)

```powershell
# voicevox_batch.ps1
# Generates audio for all lines in script

$scriptFile = "script.txt"
$outputDir = "audio_output"
$voicevoxPath = "C:\Program Files\VOICEVOX\VOICEVOX.exe"

# Read script lines
$lines = Get-Content $scriptFile

# Generate audio for each line
foreach ($line in $lines) {
    $index = $lines.IndexOf($line)
    $outputFile = "$outputDir\line_$index.wav"

    # Call VOICEVOX CLI (if available)
    & $voicevoxPath generate --text "$line" --output "$outputFile" --speaker 46
}

Write-Host "Audio generation complete!"
```

---

## 3. Thumbnail Design Tools

### Option A: Adobe Photoshop (Professional)

**System Requirements**:
- OS: Windows 10/11 (64-bit) or macOS 10.15+
- CPU: Intel Core i5 or equivalent
- RAM: 8GB minimum (16GB recommended)
- GPU: DirectX 12 or Metal compatible
- Storage: 4GB installation + 10GB workspace

**Installation**:
1. Download from Adobe Creative Cloud
2. Install Photoshop 2024
3. Activate with Adobe account
4. Install Japanese fonts (if needed)

**Photoshop Template Setup**:
```
File > New > Custom
Width: 1920 px
Height: 1080 px
Resolution: 72 ppi
Color Mode: RGB Color (8-bit)
Background: White
```

**Recommended Plugins**:
- Topaz Gigapixel AI (upscaling)
- Nik Collection (filters)
- Font Awesome (icons)

**Essential Fonts**:
```
Japanese:
- Noto Sans JP (Bold, Black)
- Source Han Sans (Heavy)
- 源暎ゴシック (Bold)

English:
- Montserrat (Bold, Black)
- Bebas Neue
- Impact
```

### Option B: Canva (Easy & Free)

**System Requirements**:
- Web browser (Chrome, Firefox, Safari)
- Internet connection
- Canva account (free or Pro)

**Setup**:
1. Visit https://www.canva.com/
2. Create account (free or Pro)
3. Select "Custom Size" template (1920x1080)

**Canva Pro Benefits** ($12.99/month):
- Remove background tool
- Brand kit (save colors, fonts)
- Premium stock photos
- Magic Resize
- Collaboration features

**Canva Thumbnail Template**:
1. Create new design (1920x1080)
2. Add background (solid color or image)
3. Add text layers:
   - Main title (100-150pt bold font)
   - Subtitle (40-60pt)
   - Call-to-action (30-40pt)
4. Add graphic elements:
   - Character images
   - Icons
   - Arrows/shapes
5. Export as PNG (high quality)

---

## 4. Supporting Tools

### A. Stock Image Sources

**Free**:
- Unsplash (https://unsplash.com/)
- Pexels (https://www.pexels.com/)
- Pixabay (https://pixabay.com/)
- いらすとや (https://www.irasutoya.com/) - Japanese illustrations

**Paid**:
- Shutterstock
- Adobe Stock
- iStock

### B. Icon Libraries

**Free**:
- Font Awesome (https://fontawesome.com/)
- Flaticon (https://www.flaticon.com/)
- Material Icons (https://fonts.google.com/icons)

**Paid**:
- The Noun Project
- IconScout

### C. Background Music (BGM)

**Free (Commercial Use)**:
- YouTube Audio Library
- Incompetech (https://incompetech.com/)
- Bensound (https://www.bensound.com/)
- DOVA-SYNDROME (https://dova-s.jp/) - Japanese

**Paid**:
- Epidemic Sound
- Artlist
- AudioJungle

### D. Sound Effects (SFX)

**Free**:
- Freesound (https://freesound.org/)
- Zapsplat (https://www.zapsplat.com/)
- 効果音ラボ (https://soundeffect-lab.info/) - Japanese

### E. Screen Recording (for demos)

**Windows**:
- OBS Studio (free, open-source)
- ShareX (free)
- Bandicam (paid)

**macOS**:
- QuickTime Player (built-in)
- OBS Studio (free)
- ScreenFlow (paid)

### F. Video Compression

**HandBrake** (free, cross-platform)
```
Settings for YouTube upload:
- Preset: "Production Max"
- Format: MP4
- Video Codec: H.264
- Quality: RF 20-22
- Frame Rate: Same as source (60fps)
- Audio Codec: AAC 320kbps
```

Download: https://handbrake.fr/

### G. Project Management

**Notion** (free tier available)
- Create production dashboard
- Track tasks and deadlines
- Store scripts and notes
- Collaborate with team

**Trello** (free tier available)
- Kanban board for workflow
- Task assignments
- Deadline tracking

---

## 5. YMM4 Advanced Configuration

### Character Setup

1. **Import Character Images**
   - YMM4 > Characters > Add New
   - Select character type: Yukkuri (霊夢, 魔理沙)
   - Import custom character sprites (if needed)

2. **Configure Character Expressions**
   ```
   霊夢 (Reimu):
   - Normal (通常)
   - Happy (笑顔)
   - Surprised (驚き)
   - Thinking (考え中)
   - Serious (真剣)

   魔理沙 (Marisa):
   - Normal (通常)
   - Excited (興奮)
   - Confused (困惑)
   - Confident (自信満々)
   - Explaining (解説中)
   ```

3. **Character Position & Size**
   - Reimu: Left side (X: 300, Y: 800)
   - Marisa: Right side (X: 1620, Y: 800)
   - Size: 80% of default

### Subtitle Styling

```
Font: Noto Sans JP Bold
Size: 48pt
Color: White (#FFFFFF)
Outline: Black (#000000) - 4px
Shadow: Yes (offset 2px, blur 4px)
Background: Semi-transparent black (#00000080)
Position: Bottom center
Animation: Fade in/out
```

### Timeline Organization

```
Track Layout (top to bottom):
1. Background (images/videos)
2. Diagrams/Charts
3. Character Layer 1 (Reimu)
4. Character Layer 2 (Marisa)
5. Subtitles
6. Transitions
7. BGM
8. SFX
9. Voiceover (Reimu)
10. Voiceover (Marisa)
```

### Export Settings (Final Video)

```
Format: MP4 (H.264)
Resolution: 1920x1080
Frame Rate: 60 fps
Bitrate: VBR (15-20 Mbps)
Audio: AAC 320kbps stereo
Quality: High (90-95%)
Hardware Acceleration: Enabled (if GPU supports)
```

---

## 6. Asset Library Setup

### Folder Structure

```
Assets/
├── audio/
│   ├── bgm/
│   │   ├── intro.mp3
│   │   ├── main.mp3
│   │   └── outro.mp3
│   ├── sfx/
│   │   ├── transition.wav
│   │   ├── pop.wav
│   │   └── whoosh.wav
│   └── voiceover/
│       ├── reimu/
│       └── marisa/
├── images/
│   ├── backgrounds/
│   ├── characters/
│   ├── diagrams/
│   └── logos/
├── videos/
│   ├── intros/
│   └── outros/
└── fonts/
    ├── NotoSansJP-Bold.otf
    └── Montserrat-Black.ttf
```

### Asset Naming Convention

```
Format: [type]_[description]_[number].[ext]

Examples:
bg_tech_01.jpg
char_reimu_happy.png
diagram_architecture_01.svg
sfx_transition_whoosh.wav
bgm_main_loop.mp3
```

### Asset Checklist

- [ ] Background images (10+)
- [ ] Character sprites (Reimu, Marisa with expressions)
- [ ] Technical diagrams (5+)
- [ ] Logos (GitHub, project logo)
- [ ] BGM tracks (intro, main, outro)
- [ ] SFX library (transitions, emphasize, etc.)
- [ ] Fonts (Japanese and English)
- [ ] Thumbnail templates (3 variations)

---

## 7. Workflow Integration

### Daily Workflow

1. **Morning Setup** (30 min)
   - Open YMM4 project
   - Check asset availability
   - Review today's tasks

2. **Production Work** (6-8 hours)
   - Follow production timeline
   - Save project every 30 minutes (Ctrl+S)
   - Export preview for review

3. **End of Day** (30 min)
   - Backup project files
   - Export work-in-progress
   - Update task tracker

### Backup Strategy

**Automated Backup** (using Windows Task Scheduler or macOS Automator):
```powershell
# backup_ymm4.ps1
$source = "C:\Users\[username]\Documents\YMM4\Projects\flickering_scenery"
$destination = "D:\Backups\YMM4\flickering_scenery_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item -Path $source -Destination $destination -Recurse
```

**Manual Backup**:
- Daily: Project file (.ymmp)
- Weekly: Full project folder
- Before major changes: Version snapshot

**Cloud Backup**:
- Google Drive
- Dropbox
- OneDrive

---

## 8. Performance Optimization

### YMM4 Performance Tips

1. **Proxy Editing**
   - Use lower resolution proxies for editing
   - Switch to full resolution for final export

2. **Cache Management**
   - Clear cache weekly: YMM4 > Settings > Clear Cache
   - Allocate at least 10GB for cache

3. **Hardware Acceleration**
   - Enable GPU acceleration in YMM4 settings
   - Update GPU drivers regularly

4. **Project Optimization**
   - Split long projects into segments
   - Pre-render complex effects
   - Use proxy files for large videos

### VOICEVOX Performance Tips

1. **GPU Acceleration**
   - Enable CUDA (NVIDIA) or DirectML (AMD)
   - Install latest GPU drivers

2. **Batch Processing**
   - Generate all audio at once
   - Use overnight processing for long scripts

3. **Cache Audio**
   - Save generated audio files
   - Reuse audio instead of regenerating

---

## 9. Troubleshooting

### Common YMM4 Issues

**Problem**: Video preview lags
**Solution**:
- Reduce preview quality
- Clear cache
- Close other applications
- Enable GPU acceleration

**Problem**: Audio sync issues
**Solution**:
- Check audio sample rate (should be 48000 Hz)
- Re-import audio files
- Adjust audio offset manually

**Problem**: Export fails
**Solution**:
- Check disk space
- Update YMM4 to latest version
- Try exporting in segments
- Disable hardware acceleration (if causing crashes)

### Common VOICEVOX Issues

**Problem**: Robotic voice quality
**Solution**:
- Adjust intonation settings
- Use different voice model
- Add pauses and punctuation
- Manually edit audio in Audacity

**Problem**: Slow synthesis
**Solution**:
- Enable GPU acceleration
- Close other applications
- Process in batches overnight

**Problem**: Installation errors
**Solution**:
- Run as administrator
- Check system requirements
- Download latest version
- Check antivirus settings

---

## 10. Quality Control Checklist

### Pre-Production
- [ ] All tools installed and tested
- [ ] Asset library organized
- [ ] Backup system configured
- [ ] Project folder structure created
- [ ] Character voices tested
- [ ] Export settings configured

### During Production
- [ ] Regular project saves (every 30 min)
- [ ] Preview playback smooth
- [ ] Audio levels consistent (-3dB headroom)
- [ ] Visual quality maintained
- [ ] Daily backups performed

### Pre-Export
- [ ] Full project review (watch entire video)
- [ ] Audio sync verified
- [ ] Subtitles accurate and timed
- [ ] No visual glitches
- [ ] Transitions smooth
- [ ] BGM/SFX balanced
- [ ] End screen configured
- [ ] Export settings verified

---

**Last Updated**: 2025-11-07
**Status**: Complete
**Owner**: Technical Lead
**Next Review**: After tool updates
