#!/bin/bash

# Esta variable almacena la ruta de acceso a la unidad
ruta1="/dev/sdb"
ruta2="/dev/sdc"

# Función para desmontar y apagar un disco
desmontar_y_apagar() {
        local ruta="$1"

        # Verificar si el disco está montado
        if mount | grep "$ruta" >/dev/null; then
                echo "Desmontando $ruta..."
                udisksctl unmount -b "${ruta}1"
                udisksctl unmount -b "${ruta}2"
        else
                echo "$ruta no está montado."
        fi

        # Apagar el disco duro
        echo "Apagando $ruta..."
        udisksctl power-off -b "$ruta"
}

# Desmontar y apagar los discos
desmontar_y_apagar "$ruta1"
desmontar_y_apagar "$ruta2"

kdialog --title "Expulsión de discos duros" --passivepopup "Los discos duros se  apagaron." 5