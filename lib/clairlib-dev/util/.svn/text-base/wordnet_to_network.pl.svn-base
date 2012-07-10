#!/usr/bin/perl
#
# script: wordnet_to_network.pl
# functionality: Generates a synonym network from WordNet
#

use strict;
use warnings;

use WordNet::QueryData;
use Getopt::Long;

sub usage;

my $out_file = "";
my $verbose = 0;
my $res = GetOptions("output=s" => \$out_file, "verbose" => \$verbose);

if (!$res or ($out_file eq "")) {
  usage();
  exit;
}

open(OUTFILE, ">$out_file") or die "Couldn't open $out_file: $!\n";

my $wn = WordNet::QueryData->new;

#my %wn_hash = ();

my @words = $wn->listAllWords("noun");

foreach my $word (@words) {
  foreach my $sense ($wn->querySense($word . "#n")) {
    foreach my $syn ($wn->querySense($sense, "syns")) {
      $syn =~ s/([a-zA-Z]*).*/$1/;
      if ($syn ne "") {
	print OUTFILE "$word $syn\n";
      }
    }
  }
}

close OUTFILE;

sub usage {
  print "Usage $0 --output output_file [--verbose]\n\n";
  print "  --output output_file\n";
  print "       Name of the output graph file\n";
  print "  --verbose\n";
  print "       Increase verbosity of debugging output\n";
  print "\n";
  die;
}

