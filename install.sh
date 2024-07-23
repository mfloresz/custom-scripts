#!/bin/bash

# Define las rutas
path_to_s="$HOME/.local/share/kio/servicemenus/scripts"
path_to_d="$HOME/.local/share/kio/servicemenus"
script_source="$(dirname "${BASH_SOURCE[0]}")"

# Crear el directorio de path_to si no existe
mkdir -p "$path_to_s"
mkdir -p "$path_to_d"

# Copiar los archivos
# Desktop file
cp "$script_source/For KDE/ServiceMenu/tools.desktop" "$path_to_d/"
# Scripts
cp "$script_source/For KDE/ServiceMenu/scripts/move_to_folder.sh" "$path_to_s/"
cp "$script_source/For KDE/ServiceMenu/scripts/ren_win.sh" "$path_to_s/"
cp "$script_source/For KDE/ServiceMenu/scripts/ts_to_mp4.sh" "$path_to_s/"

# Cambiar propietario y grupo al usuario actual
chown $USER:$USER "$path_to_s/move_to_folder.sh"
chown $USER:$USER "$path_to_s/ren_win.sh"
chown $USER:$USER "$path_to_s/ts_to_mp4.sh"

# Asignar permisos de ejecución al script
chmod +x "$path_to_s/move_to_folder.sh"
chmod +x "$path_to_s/ren_win.sh"
chmod +x "$path_to_s/ts_to_mp4.sh"

# Mensaje de éxito
echo "Archivos instalados y permisos configurados correctamente en $path_to"
kdialog --title "Instalación completa" --passivepopup "Los archivos han sido copiados correctamente" 10