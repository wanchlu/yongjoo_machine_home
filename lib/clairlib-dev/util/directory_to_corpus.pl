#!/usr/bin/perl
#
# script: directory_to_corpus.pl
# functionality: Generates a clairlib Corpus from a directory of documents
#

use strict;
use warnings;

use File::Spec;
use Getopt::Long;
use Clair::Utils::CorpusDownload;

sub usage;

my $corpus_name = "";
my $base_dir = "produced";
my $input_dir = "";
my $in_file = "";
my $type = "text";
my $verbose = 0;
my $safe = 0;
my $skipDownload = 0;

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$base_dir,
		     "directory=s" => \$input_dir, "input=s" => \$in_file,
		     "type=s" => \$type, "verbose" => \$verbose, "skipDownload" => \$skipDownload);

if (!$res or ($corpus_name eq "")) {
  usage();
  exit;
}

unless (-d $base_dir) {
  mkdir $base_dir or die "Couldn't create $base_dir: $!";
}


my $gen_dir = "$base_dir";

my $corpus_data_dir = "$gen_dir/corpus-data/$corpus_name";

if ($skipDownload)  { 
  $safe = 1;
  print "Skipping download.\n";
}

if ($verbose ) { print "Instantiating corpus $corpus_name in $gen_dir\n"; }

my $corpus = Clair::Utils::CorpusDownload->new(corpusname => "$corpus_name",
				    rootdir => "$gen_dir");

if ($input_dir ne "") {
  $corpus->build_corpus_from_directory(dir => $input_dir, cleanup => 0,
				       safe => $safe, relative => 1, skipCopy => $skipDownload);
} elsif ($in_file ne "") {
  my @files = ($in_file);
  $corpus->buildCorpusFromFiles(filesref => \@files, cleanup => 0, safe => $safe, skipCopy => $skipDownload);
} else {
  usage();
  exit;
}

sub usage {
  print "Usage $0 --corpus corpus [--input input_file | --directory input_dir]\n\n";
  print "  --corpus corpus\n";
  print "       Name of the corpus to index\n";
  print "  --base base_dir\n";
  print "       Base directory filename.  The corpus is generated here\n";
  print "  --directory input_dir\n";
  print "       Directory containing files to insert into the corpus\n";
  print "  --input input_file\n";
  print "       File containing filenames of input documents\n";
  print "  --type document_type\n";
  print "       Document type, one of: text, html, stem\n";
  print "  --skipDownload\n";
  print "       Skips copying files into the $base_dir/download folder\n";
  print "  --verbose\n";
  print "       Include verbose output\n";
  print "\n";

  die;
}
