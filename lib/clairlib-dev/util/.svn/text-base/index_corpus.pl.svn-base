#!/usr/bin/perl
# script: index_corpus.pl
# functionality: Builds the TF and IDF indices for a corpus 
# functionality: as well as several other support indices
#

use strict;
use warnings;

use File::Spec;
use Getopt::Long;

use Clair::Utils::CorpusDownload qw($verbose);
use Clair::Utils::Tf;
use Clair::Utils::Idf;

sub usage;

my $corpus_name = "";
my $base_dir = "produced";
my $input_dir = "";
my $docno_flag = 1;
my $tf_flag = 1;
my $idf_flag = 1;
my $links_flag = 1;
my $stats_flag = 1;
my $verbose = 0;
my $punc = 0;

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$base_dir,
		     "tf!" => \$tf_flag, "idf!" => \$idf_flag,
                     "links!" => \$links_flag, "stats!" => \$stats_flag,
                     "docno!" => \$docno_flag,
                     "verbose" => \$verbose,
                     "punc" => \$punc);

$Clair::Utils::CorpusDownload::verbose = $verbose;

if (!$res or ($corpus_name eq "") or ($base_dir eq "")) {
  usage();
  exit;
}

unless (-d $base_dir) {
  mkdir $base_dir or die "Couldn't create $base_dir: $!";
}


my $gen_dir = "$base_dir";

my $corpus_data_dir = "$gen_dir/corpus-data/$corpus_name";


if ($verbose ) { print "Instantiating corpus $corpus_name in $gen_dir\n"; }
my $corpus = Clair::Utils::CorpusDownload->new(corpusname => "$corpus_name",
                                               rootdir => "$gen_dir");

# index the corpus
print "Indexing the corpus\n";
if ($docno_flag) {
  $corpus->build_docno_dbm();
}

# Write links file
if ($links_flag) {
  if ($verbose) { print "Building hyperlink database\n"; }
  $corpus->write_links();
}

# Build tf-idf files
if ($idf_flag) {
  if ($verbose) { print "Building IDF database\n"; }
  $corpus->buildIdf(stemmed => 0, punc => $punc);
  $corpus->buildIdf(stemmed => 1, punc => $punc);
}
if ($tf_flag) {
  if ($verbose) { print "Building TF database\n"; }
  $corpus->buildTf(stemmed => 0);
  $corpus->buildTf(stemmed => 1);
}

# build document length dist and term counts
if ($stats_flag) {
  if ($verbose) { print "Building document length and term count databases\n";}
  $corpus->build_doc_len(stemmed => 0);
  $corpus->build_term_counts(stemmed => 0);
  $corpus->build_term_counts(stemmed => 1);
}

sub usage {
  print "Usage $0 --corpus corpus\n\n";
  print "  --corpus corpus\n";
  print "       Name of the corpus to index\n";
  print "  --base base_dir\n";
  print "       Base directory filename.  The corpus is located here\n";
  print " --docno, --no-docno\n";
  print "       Enable or disable building of docno database.  Enabled by default\n";
  print " --tf, --notf\n";
  print "       Enable or disable building of TF index.  Enabled by default\n";
  print " --idf, --noidf\n";
  print "       Enable or disable building of IDF index.  Enabled by default\n";
  print " --links, --nolinks\n";
  print "       Enable or disable building hyperlink database.  Enabled by default\n";
  print " --stats, --nostats\n";
  print "       Enable or disable building term counts and doc. len. dist.\n";
  print "       Enabled by default\n";
  print " --punc\n";
  print "       Include punctuation in IDF.  Disabled by default.\n";
  print "  --verbose\n";
  print "       Include verbose output\n";
  print "\n";

  die;
}
