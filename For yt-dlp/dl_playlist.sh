#!/bin/bash

# Solicitar URL al usuario
url=$(kdialog --title "Descargar playlist de youtube" --inputbox "Ingrese la url de la playlist que desea descargar")

# Validar entrada del usuario
if [[ -z "$url" ]]; then
    kdialog --title "Error" --msgbox "No se ingresó ninguna URL. Abandonando."
    exit 1
fi

# Generar nombre aleatorio para el directorio temporal
temp_dir=$(mktemp -d /tmp/yt-playlist.XXXXXX)
mkdir -p "$temp_dir"
log_file="/tmp/yt-playlist-downloader.log"
# Agregar la fecha y hora al log
echo "$(date '+%Y-%m-%d %H:%M:%S') - Iniciando descarga de playlist: $url" >> "$log_file"

# Descargar playlist con yt-dlp
if yt-dlp --windows-filenames -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' -o "$temp_dir/%(playlist)s/%(playlist_index)s. %(title)s.%(ext)s" "$url"; then
    # Mover contenido recursivamente a Descargas
    mv "$temp_dir"/* "$HOME/Descargas/"
    # Notificar éxito si la descarga fue exitosa
    kdialog --title "Operación terminada" --passivepopup "Se ha descargado la playlist" 5
else
    # Notificar error en caso de fallo en la descarga
    kdialog --title "Error" --msgbox "Hubo un problema al descargar la playlist."
fi
# Registrar estado de la operación
if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Descarga completada exitosamente" >> "$log_file"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error durante la descarga" >> "$log_file"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Código de error: $?" >> "$log_file"
fi
# Modificar el formato de descarga a mp4
# Limpiar archivos temporales
rm -rf "$temp_dir"
# Configurar ubicación del archivo de log
log_file="$HOME/.local/share/yt-playlist-downloader.log"
