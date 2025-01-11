#!/bin/bash

# Verificar dependencias
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "Se requiere yt-dlp pero no está instalado. Abandonando."; exit 1; }
command -v zenity >/dev/null 2>&1 || { echo >&2 "Se requiere zenity pero no está instalado. Abandonando."; exit 1; }

# Solicitar URL al usuario
url=$(zenity --entry \
             --title="Descargar video de Youtube (480p)" \
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
temp_dir=$(mktemp -d /tmp/yt-stream-480p.XXXXXX)
mkdir -p "$temp_dir"

# Descargar el video con calidad máxima de 480p
yt-dlp --live-from-start \
       --windows-filenames \
       -P "$HOME/Descargas" \
       -P "temp:$temp_dir" \
       -o "%(title)s.%(ext)s" \
       -f "bestvideo[height<=480]+bestaudio/best[height<=480]" \
       "$url"

# Notificar que la descarga ha terminado
zenity --notification \
       --text="Se ha descargado el video"

# Limpiar el directorio temporal (si existe)
if [[ -d "$temp_dir" ]]; then
    rmdir "$temp_dir"
fi
