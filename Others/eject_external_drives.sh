#!/bin/bash

# Esta variable almacena la ruta de acceso a la unidad
ruta1="/dev/sdb"
ruta2="/dev/sdc"
# Desmonta el disco duro
udisksctl unmount -b /dev/sdb1
udisksctl unmount -b /dev/sdb2
udisksctl unmount -b /dev/sdc1
udisksctl unmount -b /dev/sdc2

# Apaga el disco duro
udisksctl power-off -b "$ruta1"
udisksctl power-off -b "$ruta2"

# Esta variable almacena la ruta de acceso a la unidad
#ruta1="/dev/sdb"
#ruta2="/dev/sdc"

# Desmonta el disco duro
#if udisksctl unmount -b /dev/sdb1 && \
#   udisksctl unmount -b /dev/sdb2 && \
#   udisksctl unmount -b /dev/sdc1 && \
#   udisksctl unmount -b /dev/sdc2; then
#    # Si todos los comandos de desmontar se ejecutaron correctamente, continuar con el apagado
#    if udisksctl power-off -b "$ruta1" && \
#       udisksctl power-off -b "$ruta2"; then
#        # Si todos los comandos se ejecutaron correctamente
        kdialog --title "Expulsión de discos duros" --passivepopup "Los discos duros se  apagaron." 5
#    else
#        # Si hubo un error al apagar los discos duros
#        kdialog --title "Estado del Script" --passivepopup "Error al apagar los discos duros." 5
#    fi
#else
#    # Si hubo un error al desmontar los discos duros
#    kdialog --title "Estado del Script" --passivepopup "Error al desmontar los discos duros." 5
#fi
