#!/bin/bash

CONTAINER_NAME="jellyfin"

# Intenta iniciar el contenedor
if podman start "$CONTAINER_NAME"; then
    # Si el contenedor se inició correctamente
    kdialog --title "Estado del Contenedor" --passivepopup "El contenedor '${CONTAINER_NAME}' se inició correctamente." 5
else
    # Si hubo un error al iniciar el contenedor
    kdialog --title "Estado del Contenedor" --passivepopup "Error al iniciar el contenedor '${CONTAINER_NAME}'." 5
fi
