#!/bin/bash

# Cambia al directorio especificado en $1
cd "$1"

# Recorre todos los archivos .ts en el directorio y conviértelos a .mp4
for i in *.ts; do
    ffmpeg -i "$i" -c:v copy -c:a copy "${i%.ts}.mp4" && rm "$i"
done


kdialog --title "Estado de la operación" --passivepopup "La conversión de archivos ha terminado." 5
