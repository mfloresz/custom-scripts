#!/bin/bash

temp_file=$(mktemp /tmp/error_conv.XXXXXX)

# Convierte los archivos .ts seleccionados en el directorio y los convierte a .mp4
for archivo in "$@"; do
  ffmpeg -i "$archivo" -q:a 0 -map_metadata 0 -vn "${archivo%.webm}.mp3"
  if [ $? -ne 0 ]; then
    echo "- $(basename "$archivo")" >>"$temp_file"
    continue
  fi
  rm -f "$archivo"
done

# Mensaje final de estado de la operación
kdialog --title "Estado de la operación" --passivepopup "La conversión y gestión de archivos ha terminado." 5

# Si hay archivos no convertidos, muestra un mensaje con kdialog
if [ -s "$temp_file" ]; then
    kdialog --title "Archivos no convertidos" --textbox "$temp_file" 500 250
    rm "$temp_file"
fi
