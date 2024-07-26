#!/bin/bash
# Function to display the warning message in yellow color and get the user's response
ask_confirmation() {
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    #Warning Message
    echo -e "${YELLOW}Warning: The following action will perform the following operations.${NC}"
    echo -e "${YELLOW}- You will create the chapter covers taking into account the following considerations:${NC}"
    echo -e "${YELLOW}  - The chapter.webp file must exist${NC}"
    echo -e "${YELLOW}  - Numbering is in at the top${NC}"
    echo -e "${YELLOW}  - The color of the numbers is GRAY (Make sure that the number will be legible on the numbering globe).${NC}"
    echo -e "${YELLOW}- It will create the CBZ files and delete the original folders (Make sure that the folders are in the following format: Chapter ###)${NC}"
    #Pregunta
    read -p "¿Do you want to continue? (y/n): " response
    case "$response" in
    [yY])
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

# Operation in case of response andY
if ask_confirmation; then

    #Script to create the cover art and create the cbz files.
    read -p "¿In what number does the series start? " numini
    read -p "¿In what number does the series end? " numfin
    a=$numini
    echo ""
    echo "Creating covers..."
    for ((i = $numini; i <= $numfin; i++)); do
        number=$(printf "%03d" $i)
        find . -type d -name "Chapter ${number}*" -print0 | while read -d '' -r dir; do
            echo -ne "Creating cover for the chapter: $a\r" # Print the current directory
            magick chapter.webp -stroke 'rgba(0,0,0,0)' -strokewidth 3 -font "$HOME/.local/bin/OldLondon.ttf" -pointsize 150 -gravity center -fill 'rgba(245, 245, 245,1)' -annotate +0+740 "$a" "${dir}/000.webp"
        done
        let a=a+1
    done

    echo ""
    echo "Finished the creation of the cover pages, continuing with the creation of the CBZs..."

    # Convert folders to CBZ files within the range.
    for ((i = numini; i <= numfin; i++)); do
        number=$(printf "%03d" $i)
        folder_name="Chapter ${number}*"

        # Find folders that match the pattern.
        find . -maxdepth 1 -type d -name "$folder_name" -print0 | while IFS= read -r -d '' dir; do
            echo -ne "\rCreating CBZ from ${dir#./}\r"
            zip -r "${dir%/}.cbz" "$dir" >/dev/null
        done
    done

    echo ""
    echo "--------Operation finished.-----------"
    echo ""

    # Delete folders within the range.
    for ((i = numini; i <= numfin; i++)); do
        number=$(printf "%03d" $i)
        folder_name="Chapter ${number}*"

        # Find and delete folders that match the pattern.
        find . -maxdepth 1 -type d -name "$folder_name" -print0 | while IFS= read -r -d '' dir; do
            echo -ne "\rDeleting ${dir#./}\r"
            rm -r "$dir"
        done
    done

#If no
else
    echo ""
    echo "Operation cancelled."
    echo ""
fi
