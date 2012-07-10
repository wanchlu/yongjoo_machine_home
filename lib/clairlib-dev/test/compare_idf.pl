#!/usr/local/bin/perl

# script: test_compare_idf.pl
# functionality: Compares results of Clair::Util idf calculations with
# functionality: those performed by the build_idf script 

# This is used to compare the results of the idf calculations in Clair::Util
# to the ones performed by the build_idf script
# Input should be a single file that has already been stemmed
use strict;
use warnings;
use FindBin;
use Clair::Util;
use Clair::Cluster;
use Clair::Document;
use DB_File;

# This file has been stemmed.
my $input_file = "$FindBin::Bin/input/compare_idf/speech.txt";
my $output_dir = "$FindBin::Bin/produced/compare_idf";

# Create cluster
my %documents = ();
my $c = Clair::Cluster->new(documents => \%documents);



# Create each document, stem it, and insert it into the cluster
# Add the stemmed text to the $text variable
my $doc = Clair::Document->new(type => 'text', file => $input_file, id => $input_file);
$c->insert(document => $doc, id => $input_file);
my $text .= $doc->get_text() . " ";

# Take off the last newline like the other build_idf does (for comparison)
$text = substr($text, 0, length($text) - 1);

# Make the produced directory unless it exists
unless (-d $output_dir) {
    mkdir $output_dir or die "Couldn't create $output_dir: $!";
}

Clair::Util::build_idf_by_line($text, "$output_dir/dbm2");

my %idf = Clair::Util::read_idf("$output_dir/dbm2");
my $l;
my $r;
my $ct = 0;

while (($l, $r) = each %idf) {
  $ct++;
  print "$ct\t$l\t*$r*\n";
}
