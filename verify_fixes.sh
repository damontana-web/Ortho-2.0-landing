#!/bin/bash

# Verification script to check that all HTML files have the correct structure
# Should have 4 closing div tags before the Google Map section

echo "Verifying layout fixes..."

# Function to check a single file
check_file() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Check if file has Google Map section
    if grep -q "<!--Google map-->" "$file"; then
        # Check if it has the correct structure (4 closing divs before the new row)
        if grep -A 10 -B 10 "<!--Google map-->" "$file" | grep -q "</div>.*</div>.*</div>.*</div>.*<div class=\"row gx-0\"><br>"; then
            echo "  ✓ $filename - Correct structure"
            return 0
        else
            echo "  ✗ $filename - Still has layout issue"
            return 1
        fi
    else
        echo "  - $filename - No Google Map section"
        return 0
    fi
}

# Process all HTML files in the orthopaedics directories
total_files=0
correct_files=0
incorrect_files=0

for state in orthopaedics-NSW orthopaedics-QLD orthopaedics-VIC; do
    if [ -d "$state" ]; then
        echo "Checking $state directory..."
        for file in "$state"/*.html; do
            if [ -f "$file" ]; then
                ((total_files++))
                if check_file "$file"; then
                    ((correct_files++))
                else
                    ((incorrect_files++))
                fi
            fi
        done
    fi
done

echo ""
echo "Verification Summary:"
echo "Total files checked: $total_files"
echo "Files with correct structure: $correct_files"
echo "Files with layout issues: $incorrect_files"

if [ $incorrect_files -eq 0 ]; then
    echo "✓ All files have been fixed successfully!"
    exit 0
else
    echo "✗ Some files still need fixing."
    exit 1
fi 