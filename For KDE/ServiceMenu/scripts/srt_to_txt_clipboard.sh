#!/bin/bash

# Crear directorio temporal
temp_dir=$(mktemp -d /tmp/srt-conv.XXXXXX)

# Copiar el script Python necesario al directorio temporal
cp "$HOME/.local/share/kio/servicemenus/scripts/srt2text.py" "$temp_dir/"
cd "$temp_dir"

# Procesar cada archivo seleccionado
for archivo in "$@"; do
    # Verificar que el archivo existe y es un .srt
    if [ ! -f "$archivo" ] || [[ ! "$archivo" =~ \.srt$ ]]; then
        kdialog --error "El archivo $archivo no es válido o no existe"
        continue
    fi

    # Obtener el nombre base del archivo
    nombre_base=$(basename "$archivo")

    # Copiar el archivo SRT al directorio temporal
    cp "$archivo" "$temp_dir/"

    # Convertir el archivo srt a texto
    python3 srt2text.py -s "$nombre_base" -o "${nombre_base%.srt}.txt" -i

    # Leer el contenido del archivo y copiarlo al portapapeles
    if [ -f "${nombre_base%.srt}.txt" ]; then
        xclip -selection clipboard < "${nombre_base%.srt}.txt"
        kdialog --title "Éxito" --passivepopup "Texto copiado al portapapeles" 3
    else
        kdialog --error "Error al procesar $nombre_base"
    fi
done

# Limpiar
cd - > /dev/null
rm -rf "$temp_dir"
