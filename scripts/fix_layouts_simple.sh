#!/bin/bash

# Simple script to fix layout issue in all HTML files
# Adds three closing </div> tags before the Google Map section

echo "Fixing layout issue in all HTML files..."

# Function to fix files in a directory
fix_directory() {
    local dir="$1"
    local state="$2"
    
    echo "Processing $state files..."
    
    # Find all HTML files in the directory
    for file in "$dir"/*.html; do
        if [ -f "$file" ]; then
            echo "Processing: $file"
            
            # Create a backup
            cp "$file" "$file.backup"
            
            # Use sed to add the three closing div tags
            # This matches the pattern where the last hospital link ends and adds the closing tags
            sed -i '' 's/\(<div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='\''clear:both'\''><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div>\) <div class="row gx-0"><br>/\1\n            <\/div>\n          <\/div>\n        <\/div>\n        <div class="row gx-0"><br>/' "$file"
            
            # Check if the file was modified
            if ! cmp -s "$file" "$file.backup"; then
                echo "  ✓ Fixed: $file"
                rm "$file.backup"
            else
                echo "  - No changes needed: $file"
                rm "$file.backup"
            fi
        fi
    done
}

# Fix QLD files
fix_directory "orthopaedics-QLD" "QLD"

# Fix NSW files  
fix_directory "orthopaedics-NSW" "NSW"

# Fix VIC files
fix_directory "orthopaedics-VIC" "VIC"

echo "Layout fix completed!" 