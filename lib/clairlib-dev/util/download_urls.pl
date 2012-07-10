#!/usr/bin/perl
# script: download_urls.pl
# functionality: Downloads a set of URLs

use strict;
use warnings;

use Getopt::Std;
use vars qw/ %opt /;
use Clair::Utils::CorpusDownload;

sub usage;

my $opt_string = "b:c:i:";
getopts("$opt_string", \%opt) or usage();

my $corpus_name = "";
#my $corpus_name = "umich2";
if ($opt{"c"}) {
  $corpus_name = $opt{"c"};
} else {
  usage();
  exit;
}

my $url_file = "";
if ($opt{"i"}) {
  $url_file = $opt{"i"};
} else {
  usage();
  exit;
}

my $basedir = "produced";
if ($opt{"b"}) {
  $basedir = $opt{"b"};
}
my $gen_dir = "$basedir";

my $verbose = 0;

if ($verbose ) { print "Instantiating corpus $corpus_name in $gen_dir\n"; }
my $corpus = Clair::Utils::CorpusDownload->new(corpusname => "$corpus_name",
				    rootdir => "$gen_dir");

if ($verbose) { print "Reading URLs\n"; }
my $uref = $corpus->readUrlsFile($url_file);

if ($verbose) { print "Building corpus\n"; }
$corpus->buildCorpus(urlsref => $uref, cleanup => 0);

# write links file
#$corpus->write_links();

#
# Print out usage message
#
sub usage
{
  print "usage: $0 -c corpus_name -i url_file [-b base_dir]\n\n";
  print "  -i url_file\n";
  print "       Name of the file containing a list of URLs from which to build the network\n";
  print "  -c corpus_name\n";
  print "       Name of the corpus\n";
  print "  -b base_dir\n";
  print "       Base directory filename.  The corpus is generated here\n\n";

  print "example: $0 -c bulgaria -i data/bulgaria.10.urls -b /data0/projects/lexnets/pipeline/produced\n";

  exit;
}

