#!/bin/bash

# Function to display the warning message and get the user's response
ask_confirmation() {
    echo -e "Warning: The following action will perform several operations."
    echo -e "Ensure that the image 'chapter.webp' exists."
    echo -e "Check the color and position of the text."
    echo -e "Take into account how many digits the series is (#,##,###,####)."
    echo -e "Please take into account chapters #.5 (only), if there are any intermediates, make sure they comply with this format, otherwise they will be ignored."
    read -r -p "¿Do you want to continue? (y/n): " response
    [[ $response =~ ^[Yy]$ ]]
}

# Function to get text position and color
get_text_options() {
    local position color digits
    echo "Choose text position: (1) Upper (2) Middle (3) Lower"
    read -r -p "Enter choice: " position
    echo "Choose text color: (1) White (2) Gray"
    read -r -p "Enter choice: " color
    echo "Choose number of digits (1-4):"
    read -r -p "Enter choice: " digits
    echo "$position $color $digits"
}

# Function to process a chapter
process_chapter() {
    #local chapter=$1 pos_offset text_color digits
    #pos_offset=$2
    #text_color=$3
    #digits=$4
    local p_chapter=$1
    local p_pos_offset=$2
    local p_text_color=$3
    local p_digits=$4
    chapter_dir=$(printf "Chapter %0${digits}d" $p_chapter)

    if [[ -d "$chapter_dir" ]]; then
        printf "Working on Chapter %s\n" "$p_chapter"
        convert chapter.webp -stroke 'rgba(0,0,0,0)' -strokewidth 3 -font "$HOME/.local/bin/OldLondon.ttf" \
            -pointsize 150 -gravity center -fill "$p_text_color" -annotate +0"$p_pos_offset" "$p_chapter" "${chapter_dir}/000.webp"

        zip -r "${chapter_dir}.cbz" "$chapter_dir" >/dev/null && rm -rf "$chapter_dir" || echo "Failed to create CBZ for $chapter_dir. Directory not deleted."
    elif [[ $p_chapter != *.5 ]]; then
        printf "Chapter %s does not exist. Skipping.\n" "$p_chapter"
    fi
}

# Main script
if ask_confirmation; then
    read -r -p "Enter starting number: " start
    read -r -p "Enter ending number: " end

    # Get text options
    IFS=' ' read -r position color digits <<<$(get_text_options)

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

    # Loop to process images
    for ((i = start; i <= end; i++)); do
        process_chapter $i $pos_offset $text_color $digits
        process_chapter "${i}.5" $pos_offset $text_color $digits
    done
fi
