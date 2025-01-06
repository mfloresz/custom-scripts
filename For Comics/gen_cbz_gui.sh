# Get arguments
start=$1
end=$2
position=$3
color=$4
digits=$5

# Validate arguments
if [ -z "$start" ] || [ -z "$end" ] || [ -z "$position" ] || [ -z "$color" ] || [ -z "$digits" ]; then
    echo "Error: Missing arguments"
    echo "Usage: $0 start_number end_number position color digits"
    exit 1
fi

# Set position and color based on arguments
case "$position" in
    1) pos_offset="-880" ;;
    2) pos_offset="-30" ;;
    3) pos_offset="+740" ;;
    *) echo "Invalid position"; exit 1 ;;
esac

case "$color" in
    1) text_color="rgba(245, 245, 245,1)" ;;
    2) text_color="rgba(128, 128, 128,1)" ;;
    *) echo "Invalid color"; exit 1 ;;
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

        # Create CBZ file and remove original directory
        zip -r "${dir}.cbz" "$dir" > /dev/null
        if [ -f "${dir}.cbz" ]; then
            rm -rf "$dir"
        else
            echo "Failed to create CBZ for $dir. Directory not deleted."
            echo ""
        fi
    else
        echo "Directory $dir does not exist. Skipping."
        echo ""
    fi

    # Automatically check for half chapters
    half_dir="Chapter ${b}.5"
    if [ -d "$half_dir" ]; then
        echo "Working on $half_dir"
        magick chapter.webp -stroke 'rgba(0,0,0,0)' -strokewidth 3 -font "$HOME/.local/bin/OldLondon.ttf" \
            -pointsize 150 -gravity center -fill "$text_color" -annotate +0"$pos_offset" "${a}.5" "${half_dir}/000.webp"

        zip -r "${half_dir}.cbz" "$half_dir" > /dev/null
        if [ -f "${half_dir}.cbz" ]; then
            rm -rf "$half_dir"
            echo ""
        else
            echo "Failed to create CBZ for $half_dir. Directory not deleted."
            echo ""
        fi
    fi

    # Increment the number
    let a=a+1
done
