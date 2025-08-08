#!/usr/bin/env perl
use strict;
use warnings;
use File::Slurp qw(read_file write_file);

# Script to fix layout issue in all HTML files across QLD, NSW, and VIC folders
# Adds three closing </div> tags before the Google Map section

print "Fixing layout issue in all HTML files...\n";

# Function to fix a single file
sub fix_file {
    my ($file) = @_;
    
    print "Processing: $file\n";
    
    my $content = read_file($file, binmode => ':utf8');
    my $original_content = $content;
    
    # Pattern to match the end of hospital links section and add closing divs
    # This matches the pattern where the last hospital link ends and Google Map section begins
    if ($content =~ s/(<div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div>) <div class="row gx-0"><br>/$1\n            <\/div>\n          <\/div>\n        <\/div>\n        <div class="row gx-0"><br>/s) {
        write_file($file, { binmode => ':utf8' }, $content);
        print "  ✓ Fixed: $file\n";
        return 1;
    } else {
        print "  - No changes needed: $file\n";
        return 0;
    }
}

# Process all HTML files in QLD folder
print "Processing QLD files...\n";
my $qld_count = 0;
for my $file (glob "orthopaedics-QLD/*.html") {
    if (-f $file) {
        $qld_count += fix_file($file);
    }
}

# Process all HTML files in NSW folder
print "Processing NSW files...\n";
my $nsw_count = 0;
for my $file (glob "orthopaedics-NSW/*.html") {
    if (-f $file) {
        $nsw_count += fix_file($file);
    }
}

# Process all HTML files in VIC folder
print "Processing VIC files...\n";
my $vic_count = 0;
for my $file (glob "orthopaedics-VIC/*.html") {
    if (-f $file) {
        $vic_count += fix_file($file);
    }
}

print "Layout fix completed!\n";
print "Files fixed: QLD=$qld_count, NSW=$nsw_count, VIC=$vic_count\n"; 