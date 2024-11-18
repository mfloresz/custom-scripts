#!/bin/bash

podman stop --time 30 jellyfin

# Nombre del contenedor
CONTAINER_NAME="jellyfin"

# Verifica si el contenedor está corriendo
if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    # Contenedor está corriendo
    kdialog --title "Estado del Contenedor" --passivepopup "El contenedor '${CONTAINER_NAME}' está corriendo." 5
else
    # Contenedor no está corriendo
    kdialog --title "Estado del Contenedor" --passivepopup "El contenedor '${CONTAINER_NAME}' está detenido." 5
fi
