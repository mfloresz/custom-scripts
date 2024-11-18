#!/bin/bash

# Verificar dependencias
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "Se requiere yt-dlp pero no está instalado. Abandonando."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "Se requiere jq pero no está instalado. Abandonando."; exit 1; }
command -v kdialog >/dev/null 2>&1 || { echo >&2 "Se requiere kdialog pero no está instalado. Abandonando."; exit 1; }

url=$(kdialog --title "Descargar álbum de Youtube Music" --inputbox "Ingrese la url del álbum que desea descargar")

if [[ -z "$url" ]]; then
    kdialog --title "Error" --msgbox "No se ingresó ninguna URL. Abandonando."
    exit 1
fi
# Generar nombre aleatorio para el directorio temporal
temp_dir=$(mktemp -d /tmp/yt-album.XXXXXX)
mkdir -p "$temp_dir"

# Descargar álbum
yt-dlp --cookies-from-browser vivaldi:Default \
    --ignore-errors \
    --format bestaudio \
    --audio-quality 0 \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --add-metadata \
    --parse-metadata "playlist_index:%(track_number)s" \
    --output "$temp_dir/%(uploader)s/%(album)s/%(playlist_index)s. %(title)s.%(ext)s" \
    --yes-playlist "$url"

# Obtener información del álbum
json_output=$(yt-dlp --dump-json --playlist-items 1 "$url")
uploader=$(echo "$json_output" | jq -r '.uploader')
album=$(echo "$json_output" | jq -r '.album')

# Crear directorio para evitar errores
mkdir -p "$temp_dir/$uploader/$album"

# Descargar thumbnail
yt-dlp --skip-download \
    --write-thumbnail \
    --match-title "Album -" \
    --output "$temp_dir/$uploader/$album/cover.jpg" \
    --yes-playlist "$url"

# Mover carpetas de forma recursiva a $HOME/Descargas
mv "$temp_dir"/* "$HOME/Descargas"

# Limpiar el directorio temporal (si existe)
if [[ -d "$temp_dir" ]]; then
    rmdir "$temp_dir"
fi

if [[ $? -eq 0 ]]; then
    kdialog --title "Operación terminada" --passivepopup "Se ha descargado el álbum correctamente" 10
else
    kdialog --title "Error" --msgbox "Hubo un problema al descargar el álbum."
fi
