#!/bin/bash

# Script to fix remaining layout issues in HTML files
# This script manually fixes files that need the missing closing div tag

echo "Fixing remaining layout issues..."

# List of files that need manual fixing (based on the previous script output)
files_to_fix=(
    "orthopaedics-QLD/Blog-orthopaedic-surgery-your-questions-answered.html"
    "orthopaedics-QLD/Bunions.html"
    "orthopaedics-QLD/Carpal-tunnel-syndrome.html"
    "orthopaedics-QLD/Contact-form.html"
    "orthopaedics-QLD/Elbow-Wrist-Hand-Conditions.html"
    "orthopaedics-QLD/Elbow-Wrist-Hand-Injuries.html"
    "orthopaedics-QLD/Foot-Ankle-Arthritis.html"
    "orthopaedics-QLD/Foot-Ankle-Conditions.html"
    "orthopaedics-QLD/Foot-Ankle-Injuries.html"
    "orthopaedics-QLD/Hip-Arthritis.html"
    "orthopaedics-QLD/Hip-Bursitis.html"
    "orthopaedics-QLD/Hip-Conditions.html"
    "orthopaedics-QLD/Hip-Injuries.html"
    "orthopaedics-QLD/Index.html"
    "orthopaedics-QLD/Knee-Arthritis.html"
    "orthopaedics-QLD/Knee-Conditions.html"
    "orthopaedics-QLD/Knee-Injuries.html"
    "orthopaedics-QLD/Neck-Back-Pain.html"
    "orthopaedics-QLD/Neck-Spine-Conditions.html"
    "orthopaedics-QLD/Shoulder-Arthritis.html"
    "orthopaedics-QLD/Shoulder-Conditions.html"
    "orthopaedics-QLD/Shoulder-Injuries.html"
    "orthopaedics-QLD/Spinal-Injuries.html"
)

# Function to fix a single file
fix_file() {
    local file="$1"
    echo "Fixing: $file"
    
    # Use sed to add the missing closing div tag
    # Look for the pattern: 3 closing divs followed by the new row div
    sed -i '' 's|</div>.*</div>.*</div>.*<div class="row gx-0"><br>|</div>\n      </div>\n        <div class="row gx-0"><br>|' "$file"
    
    if [ $? -eq 0 ]; then
        echo "  ✓ Fixed"
    else
        echo "  ✗ Failed"
    fi
}

# Fix all the files in the list
for file in "${files_to_fix[@]}"; do
    if [ -f "$file" ]; then
        fix_file "$file"
    else
        echo "File not found: $file"
    fi
done

echo "Done!" 