#!/bin/bash

# Función para procesar una imagen
process_image() {
    local input_file="$1"

    # Verifica si el archivo existe
    if [ -f "$input_file" ]; then
        # Obtiene el nombre base sin extensión
        local name=$(basename "$input_file" | rev | cut -d'.' -f2- | rev)
        local dir=$(dirname "$input_file")

        echo "Procesando: $input_file"

        # Realiza la conversión a WebP
        if vips copy "$input_file" "${dir}/${name}.webp"[Q=70]; then
            echo "Conversión exitosa: ${dir}/${name}.webp"
            # Elimina el archivo original
            rm "$input_file"
            echo "Archivo original eliminado"
        else
            echo "Error en la conversión de $input_file"
            # Si hay error, elimina el archivo WebP si se creó
            rm -f "${dir}/${name}.webp"
        fi
    fi
}

# Procesa cada archivo pasado como argumento
for file in "$@"; do
    # Verifica que sea un archivo JPG o JPEG (case insensitive)
    if [[ $file =~ \.(jpg|jpeg)$ ]]; then
        process_image "$file"
    fi
done

# Notifica al usuario que el proceso ha terminado
kdialog --passivepopup "Conversión a WebP completada" 3
