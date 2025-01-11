#!/bin/bash

for i in *.jpg *.png *.jpeg *.webp; do
    # Verifica si el archivo existe
    if [ -f "$i" ]; then
        name=$(echo "$i" | cut -d'.' -f1)
        echo "Procesando: $i"
        if cwebp -q 75 -mt "$i" -o "${name}_optimized.webp"; then
            #echo "Conversión exitosa: ${name}_optimized.webp"
            #echo "Borrando archivo original: $i"
            rm "$i"
        else
            #echo "Error en la conversión de $i. El archivo original no se borrará."
            rm "${name}_optimized.webp"
        fi
    fi
done
