#!/bin/bash

# Verificar dependencias
command -v yt-dlp >/dev/null 2>&1 || { echo >&2 "Se requiere yt-dlp pero no está instalado. Abandonando."; exit 1; }
command -v kdialog >/dev/null 2>&1 || { echo >&2 "Se requiere kdialog pero no está instalado. Abandonando."; exit 1; }

# Solicitar URL al usuario
url=$(kdialog --title "Descargar canción de Youtube Music" --inputbox "Ingrese la url de la canción que desea descargar")

# Validar entrada del usuario
if [[ -z "$url" ]]; then
    kdialog --title "Error" --msgbox "No se ingresó ninguna URL. Abandonando."
    exit 1
fi

# Descargar canción
if yt-dlp --cookies-from-browser vivaldi:Default \
           --ignore-errors \
           --format bestaudio \
           --audio-quality 0 \
           --add-metadata \
           --output "${HOME}/Descargas/%(title)s.%(ext)s" \
           --yes-playlist "$url"; then
    # Notificar éxito si la descarga fue exitosa
    kdialog --title "Operación terminada" --passivepopup "Se ha descargado la canción" 5
else
    # Notificar error en caso de fallo en la descarga
    kdialog --title "Error" --msgbox "Hubo un problema al descargar la canción."
fi