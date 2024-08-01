#!/bin/bash

# Verifica si hay argumentos
if [ $# -eq 0 ]; then
    kdialog --error "No se seleccionaron archivos o carpetas."
    exit 1
fi

# Pregunta el nombre de la nueva carpeta
folder_name=$(kdialog --title "Ingrese el nombre de la carpeta" --inputbox "Cuidado: Si no seleccionó ningún archivo o carpeta,\nel resultado será que moverá la carpeta actual\nun nivel arriba dentro de la carpeta que especifique aquí." "Nueva Carpeta")

# Si el nombre está vacío, muestra un error y sale
if [ -z "$folder_name" ]; then
    kdialog --error "No se proporcionó un nombre de carpeta válido."
    exit 1
fi

# Crea la nueva carpeta
mkdir -p "$folder_name"

# Mueve los archivos y carpetas seleccionados a la nueva carpeta
for filename_foldername in "$@"; do
    mv "$filename_foldername" "$folder_name/"
done

# Muestra un mensaje de éxito
kdialog --title "Carpeta '$folder_name' creada" --passivepopup "Los archivos y carpetas han sido movidos a la nueva carpeta" 10
