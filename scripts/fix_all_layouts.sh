#!/bin/bash

# Simple script to fix layout issue in all HTML files
# Adds the missing closing div tag before the Google Map section

echo "Fixing layout issue in all HTML files..."

# Function to fix files in a directory
fix_directory() {
    local dir="$1"
    echo "Processing directory: $dir"
    
    # Use sed to add the missing closing div tag
    # Look for the pattern: 3 closing divs followed by the new row div
    # and add a 4th closing div before the new row div
    
    for file in "$dir"/*.html; do
        if [ -f "$file" ]; then
            echo "  Processing: $(basename "$file")"
            
            # Check if file has Google Map section
            if grep -q "<!--Google map-->" "$file"; then
                # Check if it already has the correct structure
                if grep -A 5 -B 5 "<!--Google map-->" "$file" | grep -q "</div>.*</div>.*</div>.*</div>.*<div class=\"row gx-0\"><br>"; then
                    echo "    Already has correct structure"
                else
                    # Fix the file by adding the missing closing div
                    sed -i '' 's|</div>.*</div>.*</div>.*<div class="row gx-0"><br>|</div>\n      </div>\n        <div class="row gx-0"><br>|' "$file"
                    echo "    Fixed layout issue"
                fi
            else
                echo "    No Google Map section found"
            fi
        fi
    done
}

# Process all three directories
for state in orthopaedics-NSW orthopaedics-QLD orthopaedics-VIC; do
    if [ -d "$state" ]; then
        fix_directory "$state"
    fi
done

echo "Done!" 