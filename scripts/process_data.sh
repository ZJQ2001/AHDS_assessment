#!/bin/bash

# Directory containing the downloaded data
input_dir="raw"
output_dir="clean"

# Output file path
processed_file="$output_dir/processed_data.tsv"

# Ensure the output directory exists
mkdir -p "$output_dir"

# Write the header to the output file
echo -e "PMID\tYear\tTitle" > "$processed_file"

# Debugging: List files in the input directory
echo "Looking for XML files in $input_dir:" >&2
ls "$input_dir"/*.xml >&2 || echo "No XML files found in $input_dir" >&2

# Debugging: Print found files
echo "Found files to process:" >&2
for file in "$input_dir"/article-*.xml; do
    echo "$file" >&2
done

# Iterate over all XML files in the input directory
for file in "$input_dir"/article-*.xml; do
    if [[ -f "$file" ]]; then
        echo "Processing file: $file" >&2

        # Read the entire XML file content into a variable
        xml_content=$(<"$file")

        # Extract PMID
        pmid=$(echo "$xml_content" | sed -n 's/.*<PMID Version="1">\([^<]*\).*/\1/p')

        # Extract Year
        year=$(echo "$xml_content" | sed -n 's/.*<PubDate>.*<Year>\([^<]*\).*/\1/p')

        # Extract Title and remove any tags within the title
        title=$(echo "$xml_content" | sed -n 's/.*<ArticleTitle>\(.*\)<\/ArticleTitle>.*/\1/p' | sed 's/<[^>]*>//g')

        # Append to output if all fields exist
        if [[ -n "$pmid" && -n "$year" && -n "$title" ]]; then
            echo -e "$pmid\t$year\t$title" >> "$processed_file"
        else
            echo "Skipped incomplete data in $file" >&2
        fi
    else
        echo "No matching XML files found in $input_dir" >&2
    fi
done

echo "Data processing is complete and has been saved to $processed_file"
