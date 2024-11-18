#!/bin/bash
set -e

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display the warning message and get the user's response
ask_confirmation() {
    echo -e "${YELLOW}Warning: The following action will perform several operations.${NC}"
    echo -e "${YELLOW}Ensure that the image 'chapter.webp' exists.${NC}"
    echo -e "${YELLOW}Check the color and position of the text.${NC}"
    echo -e "${YELLOW}Take into account how many digits the series is (#,##,###,####).${NC}"
    echo -e "${YELLOW}Please take into account chapters #.5 (only), if there are any intermediates, make sure they comply with this format, otherwise they will be ignored.${NC}"
    read -p "¿Do you want to continue? (y/n): " response
    [[ $response =~ ^[yY]$ ]]
}

# Function to get text position and color
get_text_options() {
    local position color digits
    echo "Choose text position: (1) Upper (2) Middle (3) Lower"
    read -p "Enter choice: " position
    echo "Choose text color: (1) White (2) Gray"
    read -p "Enter choice: " color
    echo "Choose number of digits (1-4):"
    read -p "Enter choice: " digits
    case "$position" in
        1) pos_offset="-880" ;;
        2) pos_offset="-30" ;;
        3) pos_offset="+740" ;;
    esac
    case "$color" in
        1) text_color="rgba(245, 245, 245,1)" ;;
        2) text_color="rgba(128, 128, 128,1)" ;;
    esac
    printf "%s\n%s\n%s\n" "$pos_offset" "$text_color" "$digits"
}

# Function to process images and create CBZ files
process_chapter() {
    local i=$1
    local chapter=$(printf "%0${digits}d" $i)
    local dir="Chapter $chapter"
    if [[ -d "$dir" ]]; then
        printf "Working on Chapter %s\n" "$chapter"
        local text=$i
        [[ ${i%.*} != $i ]] && text="$i.5"
        convert chapter.webp -stroke 'rgba(0,0,0,0)' -strokewidth 3 -font "$HOME/.local/bin/OldLondon.ttf" \
        -pointsize 150 -gravity center -fill "$text_color" -annotate +0"$pos_offset" "$text" "${dir}/000.webp"
        zip -r "${dir}.cbz" "$dir" > /dev/null && rm -rf "$dir" || echo "Failed to create CBZ for $dir. Directory not deleted."
    else
        echo "Directory $dir does not exist. Skipping."
    fi
}

# Main script
if ask_confirmation; then
    read -p "Enter starting number: " start
    read -p "Enter ending number: " end
    mapfile -t text_options < <(get_text_options)
    pos_offset=${text_options[0]}
    text_color=${text_options[1]}
    digits=${text_options[2]}
    for ((i=start; i<=end; i++)); do
        process_chapter "$i"
        half_chapter=$(printf "%0${digits}d.5" $i)
        [[ -d "Chapter $half_chapter" ]] && process_chapter "$half_chapter"
    done
fi
