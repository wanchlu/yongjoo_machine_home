#!/usr/bin/perl

use strict;
use warnings;

my @distributions = ("core", "ext");
my @subdirectories = ("t", "test", "util");


open HTML_FILE, "> testlist.html";
foreach my $dist (@distributions) {
  foreach my $subdir (@subdirectories) {
    generate_html(*HTML_FILE, $dist, $subdir);
  }
}
close HTML_FILE;


sub generate_html {
  my $htmlfile = shift;
  my $dist = shift;
  my $dir = shift;
  *HTML_FILE = $htmlfile;

  my @filelist = ();
  open FILELIST, "${dist}_${dir}_filelist.txt";
  while (<FILELIST>) {
    chomp;
    push @filelist, $_;
  }
  close FILELIST;

  # Output table of contents
  print HTML_FILE "<h3>Tests and/or scripts included in Clairlib-$dist, under $dir/*</h3>\n<ul>\n";
  foreach my $filename (@filelist) {
    # Get the full filepath so we can open the file.
    my $filepath = "../$dir/$filename";

    # The html server will fail if any file that contains .pl is requested; so these need renaming
    my $filename_page = $filename;
        if ($filename_page =~ /(.*)\.pl$/) {
      $filename_page = $1;
    }

    #copy file to appropriate place
    `cp $filepath /clair/html/clairlib/tests/$dir/$filename_page.txt`;

    my $filename_label = $filename;
    print HTML_FILE "<li><a href=\"http://belobog.si.umich.edu/clair/clairlib/tests/$dir/$filename_page.txt\">$filename_label</a>\n</li>";

    my $desc = "";
    my @contents = `cat $filepath`;
    foreach my $line (@contents) {
      if ($line =~ /#\W+functionality:(.*)/) {
        $desc .= $1;
      }
    }
    print HTML_FILE "<ul><li>$desc</li></ul>\n";
  }
  print HTML_FILE "</ul>";
}
