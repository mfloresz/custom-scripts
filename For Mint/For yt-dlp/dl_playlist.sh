#!/bin/bash

# Solicitar URL al usuario usando zenity
url=$(zenity --entry \
    --title="Descargar playlist de YouTube" \
    --text="Ingrese la URL de la playlist que desea descargar:" \
    --width=400)

# Validar si se ingresó una URL
if [[ -z "$url" ]]; then
    zenity --error \
        --title="Error" \
        --text="No se ingresó ninguna URL. Operación cancelada." \
        --width=300
    exit 1
fi

# Crear directorio temporal
temp_dir=$(mktemp -d /tmp/yt-playlist.XXXXXX)
mkdir -p "$temp_dir"

# Configurar archivo de log
log_file="$HOME/.local/share/yt-playlist-downloader.log"

# Registrar inicio de descarga
echo "$(date '+%Y-%m-%d %H:%M:%S') - Iniciando descarga de playlist: $url" >> "$log_file"

# Ejecutar descarga
yt-dlp --windows-filenames \
    -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' \
    -o "$temp_dir/%(playlist)s/%(playlist_index)s. %(title)s.%(ext)s" \
    "$url"

# Mover archivos a Descargas
mv "$temp_dir"/* "$HOME/Descargas/" 2>/dev/null

# Registrar resultado en el log
echo "$(date '+%Y-%m-%d %H:%M:%S') - Operación de descarga finalizada" >> "$log_file"

# Limpiar directorio temporal
rm -rf "$temp_dir"

# Mostrar notificación de finalización
zenity --notification \
    --text="La playlist se ha descargado completamente"

exit 0
