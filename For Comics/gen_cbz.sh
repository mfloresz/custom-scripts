#!/bin/bash

# Function to display the warning message and get the user's response
ask_confirmation() {
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    echo -e "${YELLOW}Warning: The following action will perform several operations.${NC}"
    echo -e "${YELLOW}Ensure that the image 'chapter.webp' exists.${NC}"
    echo -e "${YELLOW}Check the color and position of the text.${NC}"
    echo -e "${YELLOW}Take into account how many digits the series is (#,##,###,####).${NC}"
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

# Function to get text position and color
get_text_options() {
    echo "Choose text position: (1) Upper (2) Middle (3) Lower"
    read -p "Enter choice: " position
    echo "Choose text color: (1) White (2) Gray"
    read -p "Enter choice: " color
    echo "Choose number of digits (1-4):"
    read -p "Enter choice: " digits
}

# Main script
if ask_confirmation; then
    read -p "Enter starting number: " start
    read -p "Enter ending number: " end

    # Get text options
    get_text_options

    # Set position and color
    case "$position" in
        1) pos_offset="-880" ;;
        2) pos_offset="-30" ;;
        3) pos_offset="+740" ;;
    esac

    case "$color" in
        1) text_color="rgba(245, 245, 245,1)" ;;
        2) text_color="rgba(128, 128, 128,1)" ;;
    esac

    # Initialize the starting number
    a=$start

    # Loop to process images
    for ((i=start; i<=end; i++)); do
        b=$(printf "%0${digits}d" $i)
        dir="Chapter $b"

        # Check if directory exists
        if [ -d "$dir" ]; then
            # Modify command based on user input
            echo "Working on Chapter $a"
            magick chapter.webp -stroke 'rgba(0,0,0,0)' -strokewidth 3 -font "$HOME/.local/bin/OldLondon.ttf" \
            -pointsize 150 -gravity center -fill "$text_color" -annotate +0"$pos_offset" "$a" "${dir}/000.webp"
            
            # Optional: Create CBZ file and remove original directory
            zip -r "${dir}.cbz" "$dir" > /dev/null
            rm -rf "$dir"
        else
            echo "Directory $dir does not exist. Skipping."
        fi

        # Increment the number
        let a=a+1
    done
fi
