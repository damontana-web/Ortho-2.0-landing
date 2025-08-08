#!/usr/bin/env python3
"""
Script to fix layout issue in HTML files by adding missing closing div tag before Google Map section.
The issue is that there's a missing </div> tag to close the container div before the Google Map section.
"""

import os
import re
import glob

def fix_layout_issue(file_path):
    """
    Fix the layout issue in a single HTML file by adding the missing closing div tag.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the Google Map comment
        google_map_pattern = r'(<!--Google map-->)'
        match = re.search(google_map_pattern, content)
        
        if not match:
            print(f"No Google Map section found in {file_path}")
            return False
        
        google_map_pos = match.start()
        
        # Look for the pattern that indicates missing closing div
        # We need to find where the container div should be closed
        # The pattern should be: </div> (closes content list)
        #                         </div> (closes col-lg-12)
        #                         </div> (closes row gx-0)
        #                         <div class="row gx-0"><br> (next row starts)
        #                         <!--Google map-->
        
        # Look for the pattern before the Google Map comment
        before_google_map = content[:google_map_pos]
        
        # Find the last occurrence of the pattern that should be there
        # We're looking for the structure that ends with the hospital content
        # and then starts the Google Map section
        
        # The pattern we're looking for is:
        # </div> (closes the last hospital div)
        # </div> (closes content list)
        # </div> (closes col-lg-12)
        # </div> (closes row gx-0)
        # <div class="row gx-0"><br>
        # <!--Google map-->
        
        # But we're missing the closing div for the container
        
        # Let's look for the pattern that indicates the container div should be closed
        container_pattern = r'(\s*</div>\s*</div>\s*</div>\s*</div>\s*<div class="row gx-0"><br>\s*<!--Google map-->)'
        
        if re.search(container_pattern, content):
            print(f"File {file_path} already has the correct structure")
            return False
        
        # Look for the pattern that's missing the container closing div
        missing_container_pattern = r'(\s*</div>\s*</div>\s*</div>\s*<div class="row gx-0"><br>\s*<!--Google map-->)'
        
        match = re.search(missing_container_pattern, content)
        if match:
            # We found the pattern that's missing the container closing div
            # We need to add the missing </div> before the <div class="row gx-0"><br>
            
            # Find the position where we need to insert the closing div
            insert_pos = match.start() + match.group().find('<div class="row gx-0"><br>')
            
            # Insert the missing closing div
            new_content = content[:insert_pos] + '\n      </div>\n' + content[insert_pos:]
            
            # Write the fixed content back to the file
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            print(f"Fixed layout issue in {file_path}")
            return True
        else:
            print(f"Could not find the expected pattern in {file_path}")
            return False
            
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """
    Main function to process all HTML files in the orthopaedics directories.
    """
    # Get all HTML files in the orthopaedics directories
    html_files = []
    for state in ['orthopaedics-NSW', 'orthopaedics-QLD', 'orthopaedics-VIC']:
        if os.path.exists(state):
            html_files.extend(glob.glob(f"{state}/*.html"))
    
    print(f"Found {len(html_files)} HTML files to process")
    
    fixed_count = 0
    for file_path in html_files:
        if fix_layout_issue(file_path):
            fixed_count += 1
    
    print(f"\nFixed layout issue in {fixed_count} files out of {len(html_files)} total files")

if __name__ == "__main__":
    main() 