#!/usr/bin/perl
# script: crawl_url.pl
# functionality: Crawls from a starting URL, returning a list of URLs
# Output to stdout, or a file

use strict;
use warnings;

use Getopt::Long;
use Clair::Utils::CorpusDownload;
use Clair::Utils::Idf;
use Clair::Utils::Tf;

sub usage;


my $url = "";
my $output_file = "";
my $test = "";
my $verbose = 0;

my $res = GetOptions("url=s" => \$url, "output=s" => \$output_file,
		     "test=s" => \$test, "verbose!" => \$verbose);

if ($url eq "") {
  usage();
  exit;
}

if ($output_file ne "") {
  open(OUTFILE, "> $output_file");
} else {
  *OUTFILE = *STDOUT;
}

# make unbuffered
select STDOUT; $| = 1;
select OUTFILE; $| = 1;

my $corpusref = Clair::Utils::CorpusDownload->new();

if ($verbose) { print "Crawling $url\n"; }
my $uref = 0;
if ($test ne "") {
  $uref = $corpusref->poach($url, error_file => "errors.txt",
			    test => $test);
} else {
  $uref = $corpusref->poach($url, error_file => "errors.txt");
}

foreach my $url (@{$uref}) {
  print OUTFILE $url, "\n";
}

close OUTFILE;
#unlink("seen_url", "urls_list");
#
# Print out usage message
#
sub usage
{
  print "usage: $0 -c corpus_name -u url [-b base_dir] [-o output_file]\n\n";
  print "  --url url\n";
  print "       URL to start the crawl from\n";
  print "  --output output filename\n";
  print "       File to store the URLs in.  If not specified, print them to STDOUT\n";
  print "  --test test regular expression\n";
  print "       Regular expression to test URLs\n";
  print "\n";

  print "example: $0 -c kzoo -b /data0/projects/lexnets/pipeline/produced -u http://www.kzoo.edu/ -o data/kzoo.urls\n";

  exit;
}

