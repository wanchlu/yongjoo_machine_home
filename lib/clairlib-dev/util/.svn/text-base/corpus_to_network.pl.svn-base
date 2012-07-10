#!/usr/bin/perl
# script: corpus_to_network.pl
# functionality: Generates a hyperlink network from corpus HTML files

use strict;
use warnings;

use Getopt::Std;
use vars qw/ %opt /;
use Clair::Network;
use Clair::Network::Writer::Edgelist;
use Clair::Utils::TFIDFUtils;

sub usage;

my $opt_string = "c:b:o:";
getopts("$opt_string", \%opt) or usage();

my $corpus_name = "";
if ($opt{"c"}) {
  $corpus_name = $opt{"c"};
} else {
  usage();
  exit;
}

my $basedir = "produced";
if ($opt{"b"}) {
  $basedir = $opt{"b"};
}
my $gen_dir = "$basedir";

my $output_file = "";
if ($opt{"o"}) {
  $output_file = $opt{"o"};
#  open(OUTFILE, "> $output_file");
} else {
#  *OUTFILE = *STDOUT;
  usage();
  exit;
}

my $verbose = 0;


my $corpus_data_dir = "$gen_dir/corpus-data/$corpus_name";
my $linkfile = "$corpus_data_dir/$corpus_name.links";
my $doc_to_file = "$corpus_data_dir/" . $corpus_name . "-docid-to-file";
my $doc_to_url = "$corpus_data_dir/" . $corpus_name . "-docid-to-url";
my $compress_dbm = "$corpus_data_dir/" . $corpus_name . "-compress-docid";


if ($verbose) { print "Generating hyperlink network\n"; }
my $network = Clair::Network->new_hyperlink_network($linkfile,
						    docid_to_file_dbm =>
						    $doc_to_file,
						    compress_docid =>
						    $compress_dbm);

if ($output_file ne "") {
  write_links($network, $output_file, $doc_to_url);
}


#
# Like write_links in Clair::Network, but print the URL too
#
sub write_links
{
  my $self = shift;
  my $graph = $self->{graph};

  my $filename = shift;
  my $doc_to_url = shift;

  my %parameters = @_;
  my $skip_duplicates = 0;
  if (exists $parameters{skip_duplicates} &&
      $parameters{skip_duplicates} == 1) {
    $skip_duplicates = 1;
  }

  my $transpose = 0;
  if (exists $parameters{transpose} and $parameters{transpose} == 1) {
    $transpose = 1;
  }

  open(FILE, "> $filename") or die "Could not open file: $filename\n";

  my %seen_edges = ();

  # Open docid to URL database
  my %docid_to_url_dbm = ();
  dbmopen %docid_to_url_dbm, $doc_to_url, 0444 or die;

  foreach my $e ($graph->edges) {
    my $u;
    my $v;

    ($u, $v) = @$e;
    if ($u ne "EX") {
      $u = $docid_to_url_dbm{$u->get_id()};
    }
    if ($v ne "EX") {
      $v = $docid_to_url_dbm{$v->get_id()};
    }
    if ($transpose == 1) {
      my $temp = $u;
      $u = $v;
      $v = $temp;
    }

    if ($skip_duplicates  == 1 || not exists $seen_edges{"$u,$v"}) {
      print(FILE "$u $v\n");
      $seen_edges{"$u,$v"} = 1;
    }
  }

  dbmclose %docid_to_url_dbm;
  close(FILE);
}


#
# Print out usage message
#
sub usage
{
  print "usage: $0 -c corpus_name -o output_file [-b base_dir]\n\n";
  print "  -c corpus_name\n";
  print "       Name of the corpus\n";
  print "  -b base_dir\n";
  print "       Base directory filename.  The corpus is loaded from here\n";
  print "  -o output_file\n";
  print "       Name of file to write network to\n";
  print "\n";

  print "example: $0 -c bulgaria -o data/bulgaria.graph -b /data0/projects/lexnets/pipeline/produced\n";

  exit;
}

