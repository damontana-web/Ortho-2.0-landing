#!/bin/bash

# Improved script to fix layout issue in HTML files by adding missing closing div tag before Google Map section
# The issue is that there's a missing </div> tag to close the container div before the Google Map section

echo "Fixing layout issue in HTML files..."

# Function to fix a single file
fix_file() {
    local file="$1"
    echo "Processing: $file"
    
    # Check if the file has the Google Map section
    if grep -q "<!--Google map-->" "$file"; then
        # Check if the file already has the correct structure (4 closing divs before the new row)
        if grep -A 10 -B 10 "<!--Google map-->" "$file" | grep -q "</div>.*</div>.*</div>.*</div>.*<div class=\"row gx-0\"><br>"; then
            echo "  File already has correct structure"
            return 0
        fi
        
        # Use sed to find and replace the pattern
        # We're looking for the pattern where we have 3 closing divs followed by the new row div
        # and we need to add a 4th closing div before the new row div
        
        # Create a temporary file
        temp_file=$(mktemp)
        
        # Use awk to process the file line by line and add the missing closing div
        awk '
        BEGIN { found_pattern = 0; added_div = 0; }
        {
            # Look for the pattern: 3 closing divs followed by the new row div
            if ($0 ~ /<\/div>.*<\/div>.*<\/div>.*<div class="row gx-0"><br>/) {
                # Found the pattern, add the missing closing div
                gsub(/<\/div>.*<\/div>.*<\/div>.*<div class="row gx-0"><br>/, "</div>\n      </div>\n        <div class=\"row gx-0\"><br>")
                found_pattern = 1
                added_div = 1
            }
            print $0
        }
        END {
            if (found_pattern) {
                exit 0
            } else {
                exit 1
            }
        }
        ' "$file" > "$temp_file"
        
        if [ $? -eq 0 ]; then
            # Replace the original file with the fixed version
            mv "$temp_file" "$file"
            echo "  Fixed layout issue"
            return 1
        else
            # Clean up temp file
            rm "$temp_file"
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