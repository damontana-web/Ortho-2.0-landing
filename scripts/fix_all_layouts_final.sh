#!/bin/bash

# Final script to fix layout issue in all HTML files
# Adds the missing closing div tag before the Google Map section
# Handles both single-line and multi-line patterns

echo "Fixing layout issue in all HTML files..."

# Function to fix files in a directory
fix_directory() {
    local dir="$1"
    echo "Processing directory: $dir"
    
    for file in "$dir"/*.html; do
        if [ -f "$file" ]; then
            echo "  Processing: $(basename "$file")"
            
            # Check if file has Google Map section
            if grep -q "<!--Google map-->" "$file"; then
                # Check if it already has the correct structure (4 closing divs before the new row)
                if grep -A 10 -B 10 "<!--Google map-->" "$file" | grep -q "</div>.*</div>.*</div>.*</div>.*<div class=\"row gx-0\"><br>"; then
                    echo "    Already has correct structure"
                else
                    # Create a temporary file
                    temp_file=$(mktemp)
                    
                    # Use awk to process the file and add the missing closing div
                    awk '
                    BEGIN { found_pattern = 0; }
                    {
                        # Look for the pattern: 3 closing divs followed by the new row div
                        if ($0 ~ /<\/div>.*<\/div>.*<\/div>.*<div class="row gx-0"><br>/) {
                            # Found the pattern, add the missing closing div
                            gsub(/<\/div>.*<\/div>.*<\/div>.*<div class="row gx-0"><br>/, "</div>\n      </div>\n        <div class=\"row gx-0\"><br>")
                            found_pattern = 1
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
                        echo "    Fixed layout issue"
                    else
                        # Clean up temp file
                        rm "$temp_file"
                        echo "    Could not find expected pattern"
                    fi
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