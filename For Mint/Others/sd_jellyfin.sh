#!/bin/bash

podman stop --time 30 jellyfin

# Nombre del contenedor
CONTAINER_NAME="jellyfin"

# Modifica los comandos de kdialog por zenity
if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    # Contenedor está corriendo
    zenity --notification --text="El contenedor '${CONTAINER_NAME}' está corriendo"
else
    # Contenedor no está corriendo
    zenity --notification --text="El contenedor '${CONTAINER_NAME}' está detenido"
fi
