#!/bin/bash

# Script to fix layout issue in HTML files by adding missing closing div tag before Google Map section
# The issue is that there's a missing </div> tag to close the container div before the Google Map section

echo "Fixing layout issue in HTML files..."

# Function to fix a single file
fix_file() {
    local file="$1"
    echo "Processing: $file"
    
    # Check if the file has the Google Map section
    if grep -q "<!--Google map-->" "$file"; then
        # Check if the file already has the correct structure (4 closing divs before the new row)
        if grep -q "</div>.*</div>.*</div>.*</div>.*<div class=\"row gx-0\"><br>" "$file"; then
            echo "  File already has correct structure"
            return 0
        fi
        
        # Check if the file has the pattern that needs fixing (3 closing divs before the new row)
        if grep -q "</div>.*</div>.*</div>.*<div class=\"row gx-0\"><br>" "$file"; then
            # Add the missing closing div tag
            sed -i '' 's|</div>.*</div>.*</div>.*<div class="row gx-0"><br>|</div>\n      </div>\n        <div class="row gx-0"><br>|' "$file"
            echo "  Fixed layout issue"
            return 1
        else
            echo "  Could not find expected pattern"
            return 0
        fi
    else
        echo "  No Google Map section found"
        return 0
    fi
}

# Process all HTML files in the orthopaedics directories
total_files=0
fixed_files=0

for state in orthopaedics-NSW orthopaedics-QLD orthopaedics-VIC; do
    if [ -d "$state" ]; then
        echo "Processing $state directory..."
        for file in "$state"/*.html; do
            if [ -f "$file" ]; then
                ((total_files++))
                if fix_file "$file"; then
                    ((fixed_files++))
                fi
            fi
        done
    fi
done

echo ""
echo "Summary:"
echo "Total files processed: $total_files"
echo "Files fixed: $fixed_files"
echo "Files already correct: $((total_files - fixed_files))" 