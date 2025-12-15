#!/bin/bash

# --- Configuration ---
ADOC_EXTENSION=".adoc"
XML_EXTENSION=".xml"
MD_EXTENSION=".md"
PANDOC_FLAVOR="gfm" # GitHub Flavored Markdown
PANDOC_WRAP_OPTION="--wrap=none"

# --- Main Logic ---

echo "Starting AsciiDoc to Markdown conversion..."
echo "------------------------------------------"
echo "Processing files ending in '$ADOC_EXTENSION' in the current directory."

# Loop through all files that end with the specified AsciiDoc extension
for adoc_file in *$ADOC_EXTENSION; do

    # Check if a file with the extension was actually found (handles case where no files exist)
    if [ -f "$adoc_file" ]; then

        # 1. Determine base name and target file names
        # Removes the $ADOC_EXTENSION from the end of the filename
        base_name="${adoc_file%$ADOC_EXTENSION}"
        xml_file="${base_name}$XML_EXTENSION"
        md_file="${base_name}$MD_EXTENSION"

        echo -e "\nProcessing: **$adoc_file**"
        
        # --- Step 1: Asciidoctor Conversion (ADOC -> DocBook XML) ---
        echo "  [1/2] Converting to $xml_file (DocBook XML)..."
        if asciidoctor -b docbook "$adoc_file" -o "$xml_file"; then
            echo "  [SUCCESS] XML created."
            
            # --- Step 2: Pandoc Conversion (DocBook XML -> Markdown) ---
            echo "  [2/2] Converting to $md_file ($PANDOC_FLAVOR) with no wrapping..."
            if pandoc -f docbook -t "$PANDOC_FLAVOR" "$PANDOC_WRAP_OPTION" "$xml_file" -o "$md_file"; then
                echo "  [SUCCESS] Markdown created: **$md_file**"
                
                # --- Step 3: Cleanup (Optional but Recommended) ---
                echo "  [CLEANUP] Removing temporary file: $xml_file"
                rm "$xml_file"
            else
                echo "  [ERROR] Pandoc failed for $xml_file."
            fi
        else
            echo "  [ERROR] Asciidoctor failed for $adoc_file."
        fi

    fi
done

echo -e "\n------------------------------------------"
echo "Conversion complete."
