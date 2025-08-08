#!/usr/bin/env perl
use strict;
use warnings;
use File::Slurp qw(read_file write_file);

# Usage: perl scripts/replace_hospitals.pl <state_dir> <block_file>
my ($state_dir, $block_file) = @ARGV;
if (!defined $state_dir || !defined $block_file) {
  die "Usage: $0 <state_dir> <block_file>\n";
}

my $block = read_file($block_file, binmode => ':utf8');

opendir(my $dh, $state_dir) or die "Cannot open dir $state_dir: $!";
my @files = grep { /\.html$/ && -f "$state_dir/$_" } readdir($dh);
closedir $dh;

my $updated = 0;
FILE:
for my $file (@files) {
  my $path = "$state_dir/$file";
  my $content = read_file($path, binmode => ':utf8');
  my $orig = $content;

  # Find the Our Hospitals header (with or without center wrappers)
  my ($start_idx, $after_header_idx);
  if ($content =~ m{<h3>\s*Our\s+Hospitals\s*</h3>}i) {
    $start_idx = $-[0];
    $after_header_idx = $+[0];
  } else {
    next FILE;
  }

  # If a centered intro paragraph follows, advance past it to keep it
  # Match like </center><center> ... </center> after header optionally wrapped in </center>
  my $tail = substr($content, $after_header_idx);
  if ($tail =~ m{\A\s*</center>\s*<center>.*?</center>}is) {
    $after_header_idx += $+[0];
  }

  # Locate the end boundary: start of map row or Google map marker
  my @end_markers = (
    '<div class="row gx-0"',
    '<!--Google map-->',
    'id="map-container-google-1"',
  );
  my $end_idx = length($content);
  for my $m (@end_markers) {
    my $pos = index($content, $m, $after_header_idx);
    if ($pos != -1 && $pos < $end_idx) {
      $end_idx = $pos;
    }
  }

  # If no marker found, skip file
  next FILE if $end_idx == length($content);

  # Build new content
  my $new_content = substr($content, 0, $after_header_idx) . $block . substr($content, $end_idx);

  if ($new_content ne $content) {
    write_file($path, { binmode => ':utf8' }, $new_content);
    $updated++;
    print "Updated: $path\n";
  }
}

print "Done. Updated $updated files in $state_dir.\n"; 