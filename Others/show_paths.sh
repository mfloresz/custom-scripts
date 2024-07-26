#!/bin/bash

# Verifica si hay argumentos
if [ $# -eq 0 ]; then
    kdialog --error "No se seleccionaron archivos o carpetas."
    exit 1
fi

# Construye la lista de rutas
rutas=""
for archivo in "$@"; do
    rutas+="$archivo\n"
done

# Muestra las rutas en un cuadro de diálogo
kdialog --msgbox "Archivos y carpetas seleccionados:\n$rutas"