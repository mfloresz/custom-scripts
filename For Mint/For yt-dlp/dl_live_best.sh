#!/bin/bash

# Verificar dependencias
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "Se requiere yt-dlp pero no está instalado. Abandonando."; exit 1; }
command -v zenity >/dev/null 2>&1 || { echo >&2 "Se requiere zenity pero no está instalado. Abandonando."; exit 1; }

# Solicitar URL al usuario
url=$(zenity --entry \
             --title="Descargar video de Youtube" \
             --text="Ingrese la url del video que desea descargar" \
             --width=400)

# Validar entrada del usuario
if [[ -z "$url" ]]; then
    zenity --error \
           --title="Error" \
           --text="No se ingresó ninguna URL. Abandonando." \
           --width=300
    exit 1
fi

# Generar nombre aleatorio para el directorio temporal
temp_dir=$(mktemp -d /tmp/yt-stream.XXXXXX)
mkdir -p "$temp_dir"

# Descargar el video
yt-dlp --live-from-start \
       --windows-filenames \
       -P "$HOME/Descargas" \
       -P "temp:$temp_dir" \
       -o "%(title)s.%(ext)s" \
       "$url"

# Notificar finalización
zenity --notification \
       --text="Se ha descargado el video"

# Limpiar el directorio temporal
if [[ -d "$temp_dir" ]]; then
    rmdir "$temp_dir"
fi
