#!/usr/bin/perl
# script: corpus_to_lexical_network.pl
# functionality: Generates a lexical network for a corpus
# In the lexical network, each node is a word, and an edge exists between
# two words if they occur in the same sentences.  Multiple occurences are
# weighted more.
#

use strict;
use warnings;

use Getopt::Long;

use Clair::Cluster;
use Clair::Network::Writer::Edgelist;
#mjschal was here, removing references to Essence.  This doesn't appear to be used:
#use Essence::IDF;

sub usage;

my $corpus_name = "";
my $basedir = "produced";
my $output_file = "";
my $sample_size = 0;
my $verbose = 0;
my $stem = 1;

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$basedir,
		     "output:s" => \$output_file,
		     "stem!" => \$stem, "verbose!" => \$verbose);

if (!$res or ($corpus_name eq "") or ($basedir eq "")) {
  usage();
  exit;
}

my $gen_dir = "$basedir";

my $corpus_data_dir = "$gen_dir/corpus-data/$corpus_name";
my $doc_to_file = "$corpus_data_dir/" . $corpus_name . "-docid-to-file";

if ($verbose) { print "Loading corpus into cluster\n"; }
my $cluster = new Clair::Cluster;
$cluster->load_corpus($corpus_name, docid_to_file_dbm => $doc_to_file);

if ($verbose) { print "Stripping cluster\n"; }
$cluster->strip_all_documents;
if ($verbose) { print "Stemming cluster\n"; }
if ($stem) {
  $cluster->stem_all_documents;
}

if ($verbose) { print "Creating network\n"; }
my $network = $cluster->create_lexical_network();

if ($output_file ne "") {
  my $export = Clair::Network::Writer::Edgelist->new();
  $export->write_network($network, $output_file, weights => 1);
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
  print "  --stem or --no-stem\n";
  print "       Use the stemmed or unstemmed version of the corpus to generate the network\n";

  print "\n";

  print "example: $0 -c bulgaria -o bulgaria.graph -b produced\n";

  exit;
}
