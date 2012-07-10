#!/usr/local/bin/perl

# script: test_corpusdownload_hyperlink.pl
# functionality: Downloads a corpus and creates a network based on the
# functionality: hyperlinks between the webpages

use strict;
use warnings;
# -------------------------------------------------------------------
#   This is a sample driver for the TF/IDF CLAIR library modules
# -------------------------------------------------------------------

# -------------------------------------------------------------------
#  * Use CorpusDownload.pm to download and build a new corpus, or
#      to build a TF or IDF.
#  * Use Idf (Tf) to use an already-built Idf (Tf)
# -------------------------------------------------------------------
use DB_File;
use FindBin;
use Clair::Utils::CorpusDownload;
use Clair::Utils::Idf;
use Clair::Utils::Tf;
use Clair::Network;
use Clair::Network::Centrality::PageRank;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/corpusdownload_hyperlink";

my $gen_dir = "$basedir/produced/corpusdownload_hyperlink";
unless (-d $gen_dir) {
    mkdir $gen_dir or die "Couldn't mkdir $gen_dir: $!";
}
unless (-d "$gen_dir/corpora") {
    mkdir "$gen_dir/corpora" or die "Couldn't mkdir $gen_dir/corpora: $!";
}

# -------------------------------------------------------------------
#  This is the constructor.  It simply stores the directory
#  and name of the corpus.  It must be called prior to
#  any other routine.
# -------------------------------------------------------------------
my $corpus_name = "test-hyper";
my $corpusref = Clair::Utils::CorpusDownload->new(corpusname => $corpus_name,
                rootdir => $gen_dir);

# -------------------------------------------------------------------
#  Here's how to build a corpus.  An array @urls needs to be
#  built somehow.  (Here, we read the URLs from a file
#  $corpusname.urls.)  Then, the corpus will be built in
#  the directory $rootdir/$corpusname
# -------------------------------------------------------------------
my $uref = $corpusref->readUrlsFile("$input_dir/t.urls");
$corpusref->buildIdf(stemmed => 0, rootdir => $gen_dir );
$corpusref->buildIdf(stemmed => 1, rootdir => $gen_dir );
$corpusref->buildCorpus(urlsref => $uref, rootdir => $gen_dir );
$corpusref->build_docno_dbm( rootdir => $gen_dir );

# -------------------------------------------------------------------
# Compute the file listing the links
# -------------------------------------------------------------------
$corpusref->write_links( rootdir => $gen_dir );

# -------------------------------------------------------------------
# Create the network based on the links
# -------------------------------------------------------------------
my $linkfile = "$gen_dir/corpus-data/$corpus_name/$corpus_name.links";
my $doc_to_file = "$gen_dir/corpus-data/$corpus_name/$corpus_name-docid-to-file";
my $compress_dbm = "$gen_dir/corpus-data/$corpus_name/$corpus_name-compress-docid";

my $network = Clair::Network->new_hyperlink_network($linkfile, docid_to_file_dbm => $doc_to_file, compress_docid => $compress_dbm);
my $networkEX = Clair::Network->new_hyperlink_network($linkfile, ignore_EX => 0, docid_to_file_dbm => $doc_to_file, compress_docid => $compress_dbm);

# -------------------------------------------------------------------
# Create the network based on the links
# -------------------------------------------------------------------
print "Diameter without EX: ", $network->diameter(max => 1), "\n";
print "Avg diameter without EX: ", $network->diameter(avg => 1), "\n";

print "Diameter with EX: ", $networkEX->diameter(max => 1), "\n";
print "Avg diameter with EX: ", $networkEX->diameter(avg => 1), "\n";


my $cent = Clair::Network::Centrality::LexRank->new($network);

$network->centrality();

print "Pagerank results:\n";
$network->print_current_distribution();

$cent = Clair::Network::Centrality::LexRank->new($network);

$cent->centrality();
print "Pagerank results with EX:\n";
$cent->print_current_distribution();

