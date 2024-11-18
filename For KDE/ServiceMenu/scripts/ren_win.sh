#!/bin/bash

# Crear un archivo temporal para registrar los errores
temp_file=$(mktemp /tmp/error_conv.XXXXXX)

# Function to sanitize file names
sanitize() {
  echo "$1" | tr -d '<>:"/\\|?*;`'
}

# Rename files
for file in "$@"; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    sanitized_filename=$(sanitize "$filename")

    # Remove excess spaces
    new_filename=$(echo "$sanitized_filename" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]\+/ /g')

    # Remove excess underscores
    new_filename=$(echo "$new_filename" | sed 's/_\+/_/g')

    if [ "$filename" != "$new_filename" ]; then
      mv "$file" "$(dirname "$file")/$new_filename"
      
      # Comprobar si el renombramiento fue exitoso
      if [ $? -ne 0 ]; then
        echo "- $file no se pudo renombrar a $new_filename" >> "$temp_file"
      fi
    fi
  fi
done

# Mensaje final de estado de la operación
kdialog --title "Estado de la operación" --passivepopup "La conversión y gestión de archivos ha terminado." 5

# Si hay archivos no renombrados, muestra un mensaje con kdialog
if [ -s "$temp_file" ]; then
  kdialog --title "Archivos no renombrados" --textbox "$temp_file" 500 250
  rm "$temp_file"
fi
