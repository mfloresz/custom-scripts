#!/bin/bash

# Crear un archivo temporal para los archivos no convertidos
temp_file=$(mktemp /tmp/error_conv.XXXXXX)

convert_file() {
    local archivo="$1"
    # Verifica si el archivo no es jpg o jpeg (case insensitive)
    if [[ ! "$archivo" =~ \.(jpg|jpeg|JPG|JPEG)$ ]]; then
        # Convierte el archivo a jpg con las opciones dadas
        vips copy "$archivo" "${archivo%.*}.jxl" --distance 0 --effort 7
        if [ $? -eq 0 ]; then
            if [ $2 -eq 0 ]; then
                rm "$archivo"
            fi
        else
            echo "- $(basename "$archivo")" >>"$temp_file"
            rm "${archivo%.*}.jxl"
        fi
    else
        echo "- $(basename "$archivo")" >>"$temp_file"
    fi
}
# Pregunta si desea eliminar las imágenes originales
if kdialog --yesno "¿Desea eliminar las imágenes originales?"; then
    delete_original=0
else
    delete_original=1
fi

for archivo in "$@"; do
    convert_file "$archivo" $delete_original
done

# Mensaje final de estado de la operación
kdialog --title "Estado de la operación" --passivepopup "La conversión de archivos ha terminado." 5

# Si hay archivos no convertidos, muestra un mensaje con kdialog
if [ -s "$temp_file" ]; then
    kdialog --title "Archivos no convertidos" --textbox "$temp_file" 500 250
    rm "$temp_file"
fi
