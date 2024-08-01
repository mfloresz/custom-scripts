#!/bin/bash

# Función para mostrar el mensaje de advertencia en color amarillo y obtener la respuesta del usuario
ask_confirmation() {
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    echo -e "${YELLOW}Warning: This action will convert the images to WEBP format and delete the original files. If the images exceed the maximum number of pixels that the webp format supports, they will be ignored.${NC}"
    read -p "Do you want to continue? (y/n): " response
    case "$response" in
    [yY])
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

parent_folder="$PWD"
initial_size=$(du -sb "$parent_folder" | cut -f1)

# Mostrar mensaje de advertencia y obtener respuesta
if ask_confirmation; then
    #Realiza la conversión de todas las imágenes a Webp
    echo ""
    echo "Converting images..."
    for D in ./*; do
        if [ -d "$D" ]; then
            cd "$D"
            folder_name=$(basename "$D")
            echo "Converting images from $folder_name"
            sh $HOME/.local/bin/convert-jpg-jpeg-png-to-webp.sh >/dev/null 2>&1
            cd ..
        fi
    done
    final_size=$(du -sb "$parent_folder" | cut -f1)
    reduction_percentage=$(echo "scale=2; (($initial_size - $final_size) / $initial_size) * 100" | bc)
    size_difference_mb=$(echo "scale=2; ($initial_size - $final_size) / 1048576" | bc)
    echo "The folder has reduced its size by: $size_difference_mb MB ($reduction_percentage%)"
    

    echo ""
    echo "----------Conversion completed----------"
    echo ""

else
    echo ""
    echo "Operation cancelled."
    echo ""
fi
