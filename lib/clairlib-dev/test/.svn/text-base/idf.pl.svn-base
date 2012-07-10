#!/usr/local/bin/perl

# script: test_idf.pl
# functionality: Creates a cluster from some input files, then builds an idf
# functionality: from the lines of the documents 

use strict;
use warnings;
use FindBin;
use Clair::Util;
use Clair::Cluster;
use Clair::Document;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/idf";
my $gen_dir = "$basedir/produced/idf";

# Create cluster
my %documents = ();
my $c = Clair::Cluster->new(documents => \%documents);

my $text = "";
# Create each document, stem it, and insert it into the cluster
# Add the stemmed text to the $text variable
while ( <$input_dir/*> )
{
  my $file = $_;

  my $dl = Clair::Document->new(type => 'text', file => $file, id => $file);

  $c->insert(document => $dl, id => $file);

  # Get the number of lines in the text (because the stemmed version loses them)
  my @lines = split("\n", $dl->{text});

  $dl->stem_keep_newlines();

  $text .= $dl->{stem} . " ";

  # print "Document: $dl->{stem}\n";
}

$text = substr($text, 0, length($text) - 1);

Clair::Util::build_idf_by_line($text, "$gen_dir/dbm2");

my %idf = Clair::Util::read_idf("$gen_dir/dbm2");
my $l;
my $r;
my $ct = 0;

while (($l, $r) = each %idf) {
  $ct++;
  print "$ct\t$l\t*$r*\n";
}

