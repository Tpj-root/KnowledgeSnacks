#!/bin/bash

# Function to read a file, extract topic names, create folders, and download PDFs
download_pdfs() {
    local file="$1"  # File containing topic names and URLs
    local topic=""   # Variable to store the current topic

    # Read the file line by line
    while IFS= read -r line; do
        # Skip topics that contain "_Study_online"
        if [[ "$line" =~ ^\`\`\`([a-zA-Z0-9_-]+)_Study_online$ ]]; then
            topic=""  # Reset topic so URLs under it are ignored
            continue
        fi
        
        # Check if the line starts with triple backticks followed by a topic name ending in "_Download"
        if [[ "$line" =~ ^\`\`\`([a-zA-Z0-9_-]+)_Download$ ]]; then
            topic="${BASH_REMATCH[1]}"  # Extract the topic name before "_Download"
            mkdir -p "$topic"  # Create a directory with the topic name if it doesn't exist
            continue  # Move to the next line
        fi
        
        # Check if the line is a URL (starting with http or https)
        if [[ "$line" =~ ^https?:// ]]; then
            if [[ -n "$topic" ]]; then  # Ensure a topic folder is set before downloading
                wget -P "$topic" "$line"  # Download the file into the respective folder
            else
                echo "Warning: No topic found for URL $line"
            fi
        fi
    done < "$file"  # Read from the specified file
}

# Run the function with the provided file
download_pdfs "README.md"
