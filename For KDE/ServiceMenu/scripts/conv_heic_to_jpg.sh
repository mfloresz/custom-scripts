#!/bin/bash

for archivo in "$@"; do
    # Verifica que el archivo tenga la extensión .jpg o .jpeg
    if [[ "$archivo" == *.jpg || "$archivo" == *.jpeg ]]; then
        # Convierte el archivo con las opciones dadas
       convert "$archivo" -quality 70 -define jpeg:mozjpeg=true "${archivo%.*}.jpg"
    fi
done


kdialog --title "Estado de la operación" --passivepopup "La conversión de archivos ha terminado." 5
