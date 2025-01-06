#!/bin/bash

# Recibir el directorio de trabajo como primer argumento
work_dir="$1"

# Cambiar al directorio de trabajo
cd "$work_dir"

parent_folder="$PWD"
initial_size=$(du -sb "$parent_folder" | cut -f1)

# Ya no es necesario preguntar por confirmación ya que se maneja desde la GUI
echo "Starting image conversion..."
echo ""

#Realiza la conversión de todas las imágenes a Webp
echo "Converting images..."
for D in ./*; do
    if [ -d "$D" ]; then
        cd "$D"
        folder_name=$(basename "$D")
        echo "Converting images from $folder_name"
        sh $HOME/.local/bin/conv_to_webp.sh >/dev/null 2>&1
        cd ..
    fi
done

final_size=$(du -sb "$parent_folder" | cut -f1)
reduction_percentage=$(echo "scale=2; (($initial_size - $final_size) / $initial_size) * 100" | bc)
size_difference_mb=$(echo "scale=2; ($initial_size - $final_size) / 1048576" | bc)
echo "The folder has reduced its size by: $size_difference_mb MB ($reduction_percentage%)"

echo ""
echo "----------Conversion completed----------"
echo ""
