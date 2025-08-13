#!/usr/bin/env perl
use strict;
use warnings;
use File::Slurp qw(read_file write_file);

# Script to fix layout issue in remaining HTML files
# Handles different formatting patterns for the "Our Hospitals" section

print "Fixing layout issue in remaining HTML files...\n";

# Function to fix a single file
sub fix_file {
    my ($file) = @_;
    
    print "Processing: $file\n";
    
    my $content = read_file($file, binmode => ':utf8');
    my $original_content = $content;
    my $fixed = 0;
    
    # Pattern 1: Inline center tags (like in Hip-Arthritis.html)
    if ($content =~ s/(<center><h3>Our Hospitals<\/h3><\/center><center><p>Find out more about the orthopaedic services at our hospitals\.<\/p><\/center><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div>) <div class="row gx-0"><br>/$1\n            <\/div>\n          <\/div>\n        <\/div>\n        <div class="row gx-0"><br>/s) {
        $fixed = 1;
    }
    # Pattern 2: Multi-line center tags (like in Bunions.html and Blog file)
    elsif ($content =~ s/(<center>\s*<h3>Our Hospitals<\/h3>\s*<\/center>\s*<center>\s*<p>\s*Find out more about the orthopaedic services at our hospitals\.\s*<\/p>\s*<\/center><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div><div class="col-lg-3 d-flex flex-column"[^>]*>[^<]*<div style='clear:both'><\/div>[^<]*<a[^>]*>[^<]*<\/a><br><\/div>) <div class="row gx-0"><br>/$1\n            <\/div>\n          <\/div>\n        <\/div>\n        <div class="row gx-0"><br>/s) {
        $fixed = 1;
    }
    
    if ($fixed) {
        write_file($file, { binmode => ':utf8' }, $content);
        print "  ✓ Fixed: $file\n";
        return 1;
    } else {
        print "  - No changes needed: $file\n";
        return 0;
    }
}

# Get list of files that need fixing (exclude Index.html files which are already fixed)
my @qld_files = grep { /\.html$/ && !/Index\.html$/ } glob "orthopaedics-QLD/*.html";
my @nsw_files = grep { /\.html$/ && !/Index\.html$/ } glob "orthopaedics-NSW/*.html";
my @vic_files = grep { /\.html$/ && !/Index\.html$/ } glob "orthopaedics-VIC/*.html";

# Process QLD files
print "Processing QLD files...\n";
my $qld_count = 0;
for my $file (@qld_files) {
    $qld_count += fix_file($file);
}

# Process NSW files
print "Processing NSW files...\n";
my $nsw_count = 0;
for my $file (@nsw_files) {
    $nsw_count += fix_file($file);
}

# Process VIC files
print "Processing VIC files...\n";
my $vic_count = 0;
for my $file (@vic_files) {
    $vic_count += fix_file($file);
}

print "Layout fix completed!\n";
print "Files fixed: QLD=$qld_count, NSW=$nsw_count, VIC=$vic_count\n"; 