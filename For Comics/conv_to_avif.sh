#!/bin/bash

for i in *.jpg *.png *.jpeg; do
    # Verifica si el archivo existe (evita problemas con globs vacíos)
    if [ -f "$i" ]; then
        name=$(echo "$i" | cut -d'.' -f1)
        echo "Procesando: $i"
        if vips copy "$i" "${name}.avif"[Q=40]; then
            #echo "Conversión exitosa: ${name}.webp"
            #echo "Borrando archivo original: $i"
            rm "$i"
        else
            #echo "Error en la conversión de $i. El archivo original no se borrará."
            rm ${name}.webp

        fi
    fi
done
