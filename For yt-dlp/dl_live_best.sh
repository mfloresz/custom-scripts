#!/bin/bash

url=$(kdialog --title "Descargar video de Youtube" --inputbox "Ingrese la url del video que desea descargar  ")

yt-dlp --live-from-start -P "/home/misael/Descargas" -P "temp:/tmp/ytdlp-temp" -o "%(title)s.%(ext)s" $url

rmdir /tmp/ytdlp-temp

kdialog --title "Operación terminada" --passivepopup \
    "Se ha descargado el video" 10