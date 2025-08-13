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
    
    # Check if file contains "Our Hospitals" section
    if ($content =~ /Our Hospitals/) {
        # QLD pattern - replace the specific pattern
        if ($content =~ s/(<center><h3>Our Hospitals<\/h3><\/center><center><p>Find out more about the orthopaedic services at our hospitals\.<\/p><\/center><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div>) <div class="row gx-0"><br>/$1\n            <\/div>\n          <\/div>\n        <\/div>\n        <div class="row gx-0"><br>/s) {
            write_file($file, { binmode => ':utf8' }, $content);
            print "  ✓ Fixed QLD pattern: $file\n";
            return 1;
        }
        # NSW pattern - similar but with NSW hospitals
        elsif ($content =~ s/(<center><h3>Our Hospitals<\/h3><\/center><center><p>Find out more about the orthopaedic services at our hospitals\.<\/p><\/center><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br>[^<]*<a[^>]*>[^<]*<\/a><br><\/div>) <div class="row gx-0"><br>/$1\n            <\/div>\n          <\/div>\n        <\/div>\n        <div class="row gx-0"><br>/s) {
            write_file($file, { binmode => ':utf8' }, $content);
            print "  ✓ Fixed NSW pattern: $file\n";
            return 1;
        }
        # VIC pattern - with VIC hospitals
        elsif ($content =~ s/(<center>\s*<h3>Our Hospitals<\/h3>\s*<\/center>\s*<center>\s*<p>Find out more about the orthopaedic services at our hospitals\.<\/p>\s*<\/center><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div>) <div class="row gx-0"><br>/$1\n            <\/div>\n          <\/div>\n        <\/div>\n        <div class="row gx-0"><br>/s) {
            write_file($file, { binmode => ':utf8' }, $content);
            print "  ✓ Fixed VIC pattern: $file\n";
            return 1;
        }
        else {
            print "  - Pattern not matched: $file\n";
            return 0;
        }
    } else {
        print "  - No 'Our Hospitals' section found: $file\n";
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