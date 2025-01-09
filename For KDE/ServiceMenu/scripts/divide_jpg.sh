#!/bin/bash

# Función para obtener la extensión del archivo
get_extension() {
    filename=$1
    echo "${filename##*.}"
}

# Función para obtener el nombre base del archivo sin extensión
get_basename() {
    filename=$1
    echo "${filename%.*}"
}

# Para cada archivo pasado como argumento
for img in "$@"; do
    # Verificar que el archivo existe
    if [ ! -f "$img" ]; then
        kdialog --error "El archivo $img no existe"
        continue
    fi

    # Obtener solo el nombre del archivo sin la ruta
    filename=$(basename "$img")

    # Obtener altura de la imagen usando vips
    height=$(vipsheader -f height "$img")
    # Obtener ancho de la imagen
    width=$(vipsheader -f width "$img")

    # Mostrar diálogo para obtener número de divisiones
    parts=$(kdialog --title "Dividir imagen" \
                    --inputbox "La imagen $filename tiene una altura de $height píxeles.\n¿En cuántas partes quieres dividirla?" "2")

    # Si el usuario canceló el diálogo, continuar con la siguiente imagen
    if [ $? -ne 0 ]; then
        continue
    fi

    # Verificar que el número es válido
    if ! [[ "$parts" =~ ^[0-9]+$ ]] || [ "$parts" -lt 2 ]; then
        kdialog --error "Por favor, ingresa un número válido mayor o igual a 2"
        continue
    fi

    # Calcular la altura de cada parte
    part_height=$(( height / parts ))

    # Obtener extensión y nombre base
    ext=$(get_extension "$img")
    base=$(get_basename "$img")

    # Dividir la imagen
    success=true
    for ((i=0; i<parts; i++)); do
        # Calcular posición Y de inicio para el recorte
        y_pos=$(( i * part_height ))

        # Para la última parte, ajustar la altura para incluir los píxeles restantes
        if [ $i -eq $((parts-1)) ]; then
            part_height=$(( height - y_pos ))
        fi

        # Crear nombre del archivo de salida con número de parte
        output_file="${base}-$(printf "%02d" $((i+1))).${ext}"

        # Extraer la parte de la imagen
        if ! vips extract_area "$img" "$output_file" 0 $y_pos $width $part_height; then
            kdialog --error "Error al dividir la imagen $filename en la parte $((i+1))"
            success=false
            break
        fi
    done

    # Si todo fue exitoso, eliminar el archivo original
    if [ "$success" = true ]; then
        rm "$img"
        #kdialog --msgbox "La imagen $img ha sido dividida exitosamente en $parts partes"
    fi
done
