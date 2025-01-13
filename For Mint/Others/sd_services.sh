#!/bin/bash

# Obtener todos los contenedores en ejecución
RUNNING_CONTAINERS=$(podman ps --format "{{.Names}}")

if [ -z "$RUNNING_CONTAINERS" ]; then
    zenity --notification --text="No hay contenedores en ejecución"
    exit 0
fi

# Detener cada contenedor con un tiempo de espera de 30 segundos
for CONTAINER in $RUNNING_CONTAINERS; do
    podman stop --time 30 "$CONTAINER"

    # Verificar si el contenedor se detuvo correctamente
    if ! podman ps --format "{{.Names}}" | grep -q "^${CONTAINER}$"; then
        zenity --notification --text="El contenedor '$CONTAINER' se ha detenido correctamente"
    else
        zenity --notification --text="Error al detener el contenedor '$CONTAINER'"
    fi
done

# Verificación final
if [ -z "$(podman ps --format '{{.Names}}')" ]; then
    zenity --notification --text="Todos los contenedores han sido detenidos"
else
    zenity --notification --text="Algunos contenedores no pudieron ser detenidos"
fi
