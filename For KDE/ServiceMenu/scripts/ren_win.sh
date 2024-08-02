#!/bin/bash

# Función para eliminar caracteres especiales y reemplazar espacios por guiones bajos
sanitize() {
  #echo "$1" | tr ' ' '_' | tr -cd '[:alnum:]_.-'
  echo "$1" | tr ' ' '_' | tr -d '<>:"/\\|?*'

}

# Directorio a procesar
DIRECTORIO="$1"

# Renombrar archivos eliminando caracteres especiales y reemplazando espacios por guiones bajos
for archivo in "$DIRECTORIO"/*; do
  if [ -f "$archivo" ]; then
    nombre=$(basename "$archivo")
    nuevo_nombre=$(sanitize "$nombre")
    if [ "$nombre" != "$nuevo_nombre" ]; then
      mv "$archivo" "$DIRECTORIO/$nuevo_nombre"
    fi
  fi
done

# Eliminar espacios al principio y al final del nombre del archivo (antes de la extensión)
for archivo in "$DIRECTORIO"/*; do
  if [ -f "$archivo" ]; then
    dir=$(dirname "$archivo")
    nombre=$(basename "$archivo")
    extension="${nombre##*.}"
    nombre_sin_extension="${nombre%.*}"

    # Eliminar espacios extra, espacios al principio y al final del nombre sin extensión
    nombre_limpio=$(echo "$nombre_sin_extension" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]\+/ /g')

    # Eliminar exceso de guiones bajos
    nombre_limpio=$(echo "$nombre_limpio" | sed 's/_\+/_/g')

    # Reconstruir el nombre del archivo con la extensión
    nuevo_nombre="${nombre_limpio}.${extension}"

    if [ "$nombre" != "$nuevo_nombre" ]; then
      mv "$archivo" "$dir/$nuevo_nombre"
    fi
  fi
done
