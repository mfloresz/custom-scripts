#!/bin/bash


# Crear un archivo temporal para los archivos no convertidos
temp_file=$(mktemp /tmp/error_conv.XXXXXX)
# Pregunta si desea eliminar las imágenes originales
kdialog --yesno "¿Desea eliminar las imágenes originales?"


if [ $? -eq 0 ]; then
    for archivo in "$@"; do
        # Verifica que el archivo tenga la extensión .jpg o .jpeg
        if [[ "$archivo" == *.jpg || "$archivo" == *.jpeg ]]; then
            # Convierte el archivo con las opciones dadas
            gm convert "$archivo" -quality 70 -define jpeg:mozjpeg=true "${archivo%.*}_opt.jpg"
            # Elimina la imagen original y renombra la optimizada
            rm "$archivo"
            mv "${archivo%.*}_opt.jpg" "${archivo%.*}.jpg"
        else
            # Añade el nombre del archivo a la lista de no convertidos
            echo "- $(basename "$archivo")" >> "$temp_file"
        fi
    done
else
    for archivo in "$@"; do
        # Verifica que el archivo tenga la extensión .jpg o .jpeg
        if [[ "$archivo" == *.jpg || "$archivo" == *.jpeg ]]; then
            # Convierte el archivo con las opciones dadas
            convert "$archivo" -quality 70 -define jpeg:mozjpeg=true "${archivo%.*}_opt.jpg"

        else
            # Añade el nombre del archivo a la lista de no convertidos
            echo "- $(basename "$archivo")" >> "$temp_file"
        fi

    done
fi

# Mensaje final de estado de la operación
kdialog --title "Estado de la operación" --passivepopup "La conversión y gestión de archivos ha terminado." 5

# Si hay archivos no convertidos, muestra un mensaje con kdialog
if [ -s "$temp_file" ]; then
    kdialog --title "Archivos no convertidos" --textbox "$temp_file" 500 250
    rm "$temp_file"
fi