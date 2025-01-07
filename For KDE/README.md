# KDE Service Menu Scripts

A collection of useful service menu scripts for KDE Plasma desktop environment that add various file management and conversion capabilities to the right-click context menu.

## Features

### Image Tools
- **JPG Optimization**: Compress JPG images while maintaining reasonable quality
- **Format Conversion**:
  - Convert images to JPG (lossy compression)
  - Convert between JPG and JXL formats (lossless)
  - Convert images to AVIF format
  - Batch conversion support

### Video Tools
- **Format Conversion**:
  - Convert TS (Transport Stream) files to MP4
  - Convert MP4 to animated WEBP (max 1 min duration)

### Audio Tools
- Convert WEBM files to MP3 format

### Subtitle Tools
- Extract text from SRT subtitle files and copy to clipboard

### File Management
- **Move to Folder**: Create a new folder and move selected files into it
- **Filename Cleanup**:
  - Make filenames Windows-compatible
  - Remove invalid characters
  - Clean up excess spaces and underscores

## Installation

1. Copy the scripts to: `~/.local/share/kio/servicemenus/scripts/`
2. Copy the .desktop files to: `~/.local/share/kio/servicemenus/`
3. Ensure scripts have executable permissions: `chmod +x ~/.local/share/kio/servicemenus/scripts/*`

## Dependencies

- KDE Plasma desktop environment
- ffmpeg (for video/audio conversion)
- vips (for image processing)
- xclip (for clipboard operations)
- Python 3 (for subtitle processing)
- cjxl (for JXL conversion)

## Usage

After installation, the new options will appear in the right-click context menu under relevant submenus:
- Image Tools
- Video Tools
- Audio Tools
- Tools

Select file(s) and choose the desired operation from the context menu.

## Note

- Some operations are destructive (will replace original files)
- Backup important files before using conversion tools
- Check logs in /tmp/ for operation details
