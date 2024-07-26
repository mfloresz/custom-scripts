#!/bin/bash

# INSTALL PACKAGES AND DEPENDENCIES--------------------------------------------------------
wget -P $HOME/.local/bin https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x $HOME/.local/bin/yt-dlp
python3 -m pip install -U gallery-dl

# CREATE PATHS-----------------------------------------------------------------------------
path_to_sf="$HOME/.local/share/kio/servicemenus/scripts"
path_to_df="$HOME/.local/share/kio/servicemenus"
path_to_sc="$HOME/.local/bin"
script_source="$(dirname "${BASH_SOURCE[0]}")"

mkdir -p "$path_to_sf"
mkdir -p "$path_to_df"
mkdir -p "$path_to_sc"

# FOR KDE SERVICE MENU---------------------------------------------------------------------
cp "$script_source/For KDE/ServiceMenu/tools.desktop" "$path_to_df/"
cp "$script_source/For KDE/ServiceMenu/scripts/move_to_folder.sh" "$path_to_sf/"
cp "$script_source/For KDE/ServiceMenu/scripts/ren_win.sh" "$path_to_sf/"
cp "$script_source/For KDE/ServiceMenu/scripts/ts_to_mp4.sh" "$path_to_sf/"

chown $USER:$USER "$path_to_sf/move_to_folder.sh"
chown $USER:$USER "$path_to_sf/ren_win.sh"
chown $USER:$USER "$path_to_sf/ts_to_mp4.sh"
chown $USER:$USER "$path_to_df/tools.desktop"

chmod +x "$path_to_sf/move_to_folder.sh"
chmod +x "$path_to_sf/ren_win.sh"
chmod +x "$path_to_sf/ts_to_mp4.sh"
chmod +x "$path_to_df/tools.desktop"

# FOR COMICS-------------------------------------------------------------------------------
cp "$script_source/For Comics/files/OldLondon.ttf" "$path_to_sc/" 
cp "$script_source/For Comics/m_upw.sh" "$path_to_sc/"
cp "$script_source/For Comics/m_mpw.sh" "$path_to_sc/"
cp "$script_source/For Comics/m_lpw.sh" "$path_to_sc/"
cp "$script_source/For Comics/m_upg.sh" "$path_to_sc/"
cp "$script_source/For Comics/m_mpg.sh" "$path_to_sc/"
cp "$script_source/For Comics/m_lpg.sh" "$path_to_sc/"
cp "$script_source/For Comics/convert-jpg-jpeg-png-to-webp.sh" "$path_to_sc/"
cp "$script_source/For Comics/convert_img.sh" "$path_to_sc/"

chown $USER:$USER "$path_to_sc/m_upw.sh"
chown $USER:$USER "$path_to_sc/m_mpw.sh"
chown $USER:$USER "$path_to_sc/m_lpw.sh"
chown $USER:$USER "$path_to_sc/m_upg.sh"
chown $USER:$USER "$path_to_sc/m_mpg.sh"
chown $USER:$USER "$path_to_sc/m_lpg.sh"
chown $USER:$USER "$path_to_sc/convert-jpg-jpeg-png-to-webp.sh"
chown $USER:$USER "$path_to_sc/convert_img.sh"

chmod +x "$path_to_sc/m_upw.sh"
chmod +x "$path_to_sc/m_mpw.sh"
chmod +x "$path_to_sc/m_lpw.sh"
chmod +x "$path_to_sc/m_upg.sh"
chmod +x "$path_to_sc/m_mpg.sh"
chmod +x "$path_to_sc/m_lpg.sh"
chmod +x "$path_to_sc/convert-jpg-jpeg-png-to-webp.sh"
chmod +x "$path_to_sc/convert_img.sh"

# FOR YT-DLP-------------------------------------------------------------------------------
cp "$script_source/For yt-dlp/dl_album.sh" "$path_to_sc/" 
cp "$script_source/For yt-dlp/dl_live_480p.sh" "$path_to_sc/"
cp "$script_source/For yt-dlp/dl_live_best.sh" "$path_to_sc/"

chown $USER:$USER "$path_to_sc/dl_album.sh"
chown $USER:$USER "$path_to_sc/dl_live_480p.sh"
chown $USER:$USER "$path_to_sc/dl_live_best.sh"

chmod +x "$path_to_sc/dl_album.sh"
chmod +x "$path_to_sc/dl_live_480p.sh"
chmod +x "$path_to_sc/dl_live_best.sh"

# OTHER SCRIPTS----------------------------------------------------------------------------
cp "$script_source/Others/start_jellyfin.sh" "$path_to_sc/" 
cp "$script_source/Others/sd_jellyfin.sh" "$path_to_sc/"
cp "$script_source/Others/eject_external_drives.sh" "$path_to_sc/"

chown $USER:$USER "$path_to_sc/start_jellyfin.sh"
chown $USER:$USER "$path_to_sc/sd_jellyfin.sh"
chown $USER:$USER "$path_to_sc/eject_external_drives.sh"

chmod +x "$path_to_sc/start_jellyfin.sh"
chmod +x "$path_to_sc/sd_jellyfin.sh"
chmod +x "$path_to_sc/eject_external_drives.sh"

# MESSAGE SCRIPTS INSTALLED----------------------------------------------------------------
kdialog --title "Instalación completa" --passivepopup "Los archivos han sido copiados correctamente" 10