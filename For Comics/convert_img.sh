#!/bin/bash

# Función para mostrar el mensaje de advertencia en color amarillo y obtener la respuesta del usuario
ask_confirmation() {
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    echo -e "${YELLOW}}Advertencia: Esta acción convertirá las imágenes a formato WEBP y eliminará los archivos originales. Asegúrese de que no haya imágenes con una altura mayor a lo que permite Webp.${NC}"
    read -p "¿Deseas continuar? (y/n): " response
    case "$response" in
        [yY])
        return 0 ;;
        *)
        return 1 ;;
    esac
}

# Mostrar mensaje de advertencia y obtener respuesta
if ask_confirmation; then
    #Realiza la conversión de todas las imágenes a Webp
    echo ""
    echo "Convirtiendo imágenes..."
    for D in ./*; do
        if [ -d "$D" ]; then
            cd "$D"
            folder_name=$(basename "$D")
            echo "Convirtiendo imágenes del $folder_name"
            sh $HOME/.local/bin/convert-jpg-jpeg-png-to-webp.sh >/dev/null 2>&1
            cd ..
        fi
    done
    echo ""
    echo "----------Conversión terminada----------"
    echo ""
    
else
    echo ""
    echo "Operación cancelada."
    echo ""
fi
