#!/bin/bash

# INSTALL PACKAGES AND DEPENDENCIES--------------------------------------------------------
wget -P $HOME/.local/bin https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x $HOME/.local/bin/yt-dlp
python3 -m pip install -U gallery-dl


# FOR KDE SERVICE MENU---------------------------------------------------------------------
# Define las rutas
path_to_sf="$HOME/.local/share/kio/servicemenus/scripts"
path_to_df="$HOME/.local/share/kio/servicemenus"
path_to_sc="$HOME/.local/bin"
script_source="$(dirname "${BASH_SOURCE[0]}")"

# Crear el directorio de path_to si no existe
mkdir -p "$path_to_sf"
mkdir -p "$path_to_df"
mkdir -p "$path_to_sc"

# Copiar los archivos
# Desktop file
cp "$script_source/For KDE/ServiceMenu/tools.desktop" "$path_to_df/"
# Scripts
cp "$script_source/For KDE/ServiceMenu/scripts/move_to_folder.sh" "$path_to_sf/"
cp "$script_source/For KDE/ServiceMenu/scripts/ren_win.sh" "$path_to_sf/"
cp "$script_source/For KDE/ServiceMenu/scripts/ts_to_mp4.sh" "$path_to_sf/"

# Cambiar propietario y grupo al usuario actual
chown $USER:$USER "$path_to_sf/move_to_folder.sh"
chown $USER:$USER "$path_to_sf/ren_win.sh"
chown $USER:$USER "$path_to_sf/ts_to_mp4.sh"
chown $USER:$USER "$path_to_df/tools.desktop"

# Asignar permisos de ejecución al script
chmod +x "$path_to_sf/move_to_folder.sh"
chmod +x "$path_to_sf/ren_win.sh"
chmod +x "$path_to_sf/ts_to_mp4.sh"
chmod +x "$path_to_df/tools.desktop"

# FOR COMICS--------------------------------------------------------
cp "$script_source/For Comics/m_mpg.sh" "$path_to_sc/"
cp "$script_source/For Comics/convert-jpg-jpeg-png-to-webp.sh" "$path_to_sc/"
cp "$script_source/For Comics/convert_img.sh" "$path_to_sc/"

chown $USER:$USER "$path_to_sc/m_mpg.sh"
chown $USER:$USER "$path_to_sc/convert-jpg-jpeg-png-to-webp.sh"
chown $USER:$USER "$path_to_sc/convert_img.sh"

chmod +x "$path_to_sc/m_mpg.sh"
chmod +x "$path_to_sc/convert-jpg-jpeg-png-to-webp.sh"
chmod +x "$path_to_sc/convert_img.sh"

# Mensaje de éxito
kdialog --title "Instalación completa" --passivepopup "Los archivos han sido copiados correctamente" 10