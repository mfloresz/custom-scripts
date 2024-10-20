#!/bin/bash

# Verificar dependencias
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "Se requiere yt-dlp pero no está instalado. Abandonando."; exit 1; }
command -v kdialog >/dev/null 2>&1 || { echo >&2 "Se requiere kdialog pero no está instalado. Abandonando."; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo >&2 "Se requiere ffmpeg pero no está instalado. Abandonando."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "Se requiere jq pero no está instalado. Abandonando."; exit 1; }

# Solicitar URL al usuario
url=$(kdialog --title "Descargar canción de Youtube Music" --inputbox "Ingrese la url de la canción que desea descargar")

# Validar entrada del usuario
if [[ -z "$url" ]]; then
    kdialog --title "Error" --msgbox "No se ingresó ninguna URL. Abandonando."
    exit 1
fi

# Generar nombre aleatorio para el directorio temporal
random_suffix=$(printf "%04d" $((RANDOM % 10000)))
temp_dir="/tmp/ytdlp-ds-temp-$random_suffix"
mkdir -p "$temp_dir"

# Descargar canción
if yt-dlp --cookies-from-browser vivaldi:Default \
          --paths temp:"$temp_dir" \
          --ignore-errors \
          --format bestaudio \
          --extract-audio \
          --audio-format mp3 \
          --audio-quality 0 \
          --add-metadata \
          --output "$temp_dir/%(title)s.%(ext)s" \
          --yes-playlist "$url"; then

    # Obtener información del álbum
    json_output=$(yt-dlp --dump-json --playlist-items 1 "$url")
    uploader=$(echo "$json_output" | jq -r '.uploader')
    album=$(echo "$json_output" | jq -r '.album')

    # Descargar thumbnail
    yt-dlp --skip-download \
           --write-thumbnail \
           --output "$temp_dir/cover.jpg" \
           --yes-playlist "$url"

    # Procesar archivos descargados
    for mp3_file in "$temp_dir"/*.mp3; do
        if [ -f "$mp3_file" ]; then
            # Añadir la imagen al archivo MP3
            ffmpeg -i "$mp3_file" -i "$temp_dir/cover.jpg" -map 0:0 -map 1:0 -c copy -id3v2_version 3 \
                -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" \
                "${mp3_file%.mp3}_with_cover.mp3"

            # Reemplazar el archivo original con el nuevo que tiene la portada
            mv "${mp3_file%.mp3}_with_cover.mp3" "$mp3_file"

            # Mover el archivo a Descargas
            mv "$mp3_file" "${HOME}/Descargas/"
        fi
    done

    # Notificar éxito si la descarga fue exitosa
    kdialog --title "Operación terminada" --passivepopup "Se ha descargado la canción" 5
else
    # Notificar error en caso de fallo en la descarga
    kdialog --title "Error" --msgbox "Hubo un problema al descargar la canción."
fi

# Limpiar archivos temporales
rm -rf "$temp_dir"
