# Personal Scripts Collection

A personal collection of scripts and tweaks for Linux (mainly KDE Plasma) that I use in my daily workflow. This is a hobby project, so it may contain errors or non-optimal ways of performing certain tasks.

## 🚀 Main Features

### 📚 Comic Scripts
- GUI for processing comics and converting them to CBZ
- Automatic WebP format conversion
- Numbered cover generation
- Image optimization
- Chapter management

### 🎵 yt-dlp Scripts
- YouTube Music album downloads
- Single song downloads with metadata
- Playlist downloads
- Live stream downloads
- Scripts for different video qualities

### 🖥️ KDE Service Menus
- Image optimization
- Format conversion
- Subtitle tools
- File management
- Video and audio conversion

### 🛠️ Other Utility Scripts
- External drive management
- CPU control
- Container management (Jellyfin)
- ONLYOFFICE themes
- Update scripts

## ⚙️ Requirements

- KDE Plasma
- Python 3.x
- yt-dlp
- ffmpeg
- ImageMagick
- PyQt5
- pyvips

## 📦 Installation

```bash
git clone [repository-url]
cd [repository-name]
chmod +x install.sh
./install.sh
```

## ⚠️ Important Note

This is a personal project that I'm sharing in case it might be useful to others, but:
- I'm not a professional developer
- Scripts are adapted to my specific needs
- There might be more efficient ways to achieve the same results
- Some scripts may need adjustments to work on other systems

## 📁 Project Structure

```
.
├── For Comics/          # Comic processing scripts and GUI
├── For KDE/            # KDE service menu integration
├── For yt-dlp/         # YouTube download scripts
├── Others/             # Miscellaneous utility scripts
└── install.sh          # Installation script
```

## 🤝 Contributing

Suggestions and improvements are welcome, but please keep in mind that this is a hobby, personal project.

## 🔧 Configuration

Most scripts can be configured by editing their source files. Look for commented sections at the beginning of each script for customizable parameters.

## 📝 Usage Examples

### Comic Processing
```bash
./gen_cbz_gui.py
```

### YouTube Downloads
```bash
./dl_album.sh [YouTube Music album URL]
./dl_song.sh [YouTube Music song URL]
```

### KDE Service Menus
Access through right-click context menu in Dolphin file manager.

## 🐛 Known Issues

- Some scripts might need path adjustments depending on your system
- Font dependencies might need manual installation
- KDE service menus might need cache refresh after installation

## 📄 License

This project is free to use. Feel free to use and modify it as you see fit.

## 🙏 Acknowledgments

- KDE Community
- yt-dlp developers
- All developers of the tools used in these scripts

## 📧 Contact

Feel free to open an issue if you find any bugs or have suggestions for improvements.

---

**Note**: This is a hobby project created for personal use. While I strive to make it useful and functional, it may not follow best practices or professional standards.
