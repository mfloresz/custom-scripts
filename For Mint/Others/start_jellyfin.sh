#!/bin/bash

CONTAINER_NAME="jellyfin"

# Intenta iniciar el contenedor
if podman start "$CONTAINER_NAME"; then
    # Si el contenedor se inició correctamente
    zenity --notification --text="El contenedor '${CONTAINER_NAME}' se inició correctamente." --timeout=5
else
    # Si hubo un error al iniciar el contenedor
    zenity --notification --text="Error al iniciar el contenedor '${CONTAINER_NAME}'." --timeout=5
fi
