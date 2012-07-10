#!/usr/local/bin/perl

# script: test_stem.pl
# functionality: Tests the Clair::Utils::Stem stemmer

use strict;
use warnings;
use FindBin;
use Clair::Utils::Stem;

my $stemmer = new Clair::Utils::Stem;
my $file = "$FindBin::Bin/input/stem/1.txt";

open FILE, $file or die "Couldn't open $file: $!";
while (<FILE>) {
   chomp $_;
   {
      /^([^a-zA-Z]*)(.*)/ ;
      print $1;
      $_ = $2;
      unless ( /^([a-zA-Z]+)(.*)/ ) { last; }
      my $word = lc $1; # turn to lower case before calling:
      $_ = $2;
      $word = $stemmer->stem($word);
      print $word;
      redo;
   }
   print "\n";
}
close FILE;
