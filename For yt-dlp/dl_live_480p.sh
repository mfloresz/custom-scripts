#!/bin/bash

url=$(kdialog --title "Descargar video de Youtube (480p)" --inputbox "Ingrese la url del video que desea descargar  ")

yt-dlp --live-from-start -P "/home/misael/Descargas" -P "temp:/tmp/ytdlp-temp" -o "%(title)s.%(ext)s" -f "bestvideo[height<=480]+bestaudio/best[height<=480]" $url

rmdir /tmp/ytdlp-temp

kdialog --title "Operación terminada" --passivepopup \
    "Se ha descargado el video" 10
