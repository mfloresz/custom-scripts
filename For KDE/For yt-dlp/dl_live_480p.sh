#!/bin/bash

# Verificar dependencias
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "Se requiere yt-dlp pero no está instalado. Abandonando."; exit 1; }
command -v kdialog >/dev/null 2>&1 || { echo >&2 "Se requiere kdialog pero no está instalado. Abandonando."; exit 1; }

# Solicitar URL al usuario
url=$(kdialog --title "Descargar video de Youtube (480p)" --inputbox "Ingrese la url del video que desea descargar")

# Validar entrada del usuario
if [[ -z "$url" ]]; then
    kdialog --title "Error" --msgbox "No se ingresó ninguna URL. Abandonando."
    exit 1
fi

# Generar nombre aleatorio para el directorio temporal
random_suffix=$(printf "%04d" $((RANDOM % 10000)))
temp_dir="/tmp/ytdlp-stream-$random_suffix"
mkdir -p "$temp_dir"

# Descargar el video con calidad máxima de 480p
if yt-dlp --live-from-start --windows-filenames -P "$HOME/Descargas" -P "temp:$temp_dir" \
           -o "%(title)s.%(ext)s" \
           -f "bestvideo[height<=480]+bestaudio/best[height<=480]" \
           "$url"; then
    # Notificar éxito si la descarga fue exitosa
    kdialog --title "Operación terminada" --passivepopup "Se ha descargado el video" 10
else
    # Notificar error en caso de fallo en la descarga
    kdialog --title "Error" --msgbox "Hubo un problema al descargar el video."
fi

# Limpiar el directorio temporal (si existe)
if [[ -d "$temp_dir" ]]; then
    rmdir "$temp_dir"
fi
