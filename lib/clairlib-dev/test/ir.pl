#!/usr/local/bin/perl

# script: test_ir.pl
# functionality: Builds a corpus from some text files, then makes an IDF, a
# functionality: TF, and outputs some information from them

# To run this script, you need to have ALECACHE=/tmp (or to some other
# directory) set in your environment.

use warnings;
use strict;
use Clair::Utils::CorpusDownload;
use Clair::Utils::Idf;
use Clair::Utils::Tf;
use DB_File; # This is necessary if running on an NFS drive


my $in_dir = "$FindBin::Bin/input/ir";
my $out_dir = "$FindBin::Bin/produced/ir";
my $corpus_name = "ir_corpus";

# Read the *.txt files from the input directory, taking care to
# prepend the input directory before the filenames.
opendir INPUT, $in_dir or die "Couldn't open $in_dir: $!";
my @files = map { "$in_dir/$_" } grep { /\.txt$/ } readdir(INPUT);
closedir INPUT;

# Make this object so we can get the files into TREC format
my $corpus = Clair::Utils::CorpusDownload->new(
    corpusname => $corpus_name,
    rootdir => $out_dir,
);

# You have to do this because the rootdir and corpus
# parameters passed to the CorpusDownload constructor are ignored.
$corpus->{rootdir} = $out_dir;
$corpus->{corpus} = $corpus_name;

$corpus->buildCorpusFromFiles( filesref => \@files, cleanup => 0 );

# The order of the calls to buildIdf, build_docno_dbm, and buildTf are
# important. It can fail if they are called in a different order.

# Create the idf database file
$corpus->buildIdf( stemmed => 1 );
my $idf = Clair::Utils::Idf->new( rootdir => $out_dir, corpusname => $corpus_name,
    stemmed => 1 );

# Create the tf database file
$corpus->build_docno_dbm();
$corpus->buildTf( stemmed => 1 );
my $tf = Clair::Utils::Tf->new( rootdir => $out_dir, corpusname => $corpus_name,
    stemmed => 1 );

# Output some information involving term statistics.
print "nfiles=", scalar @files, "\n";
my @words = qw(the and);
foreach my $word (@words) {
    my $idf_score = $idf->getIdfForWord($word);
    my $tf_score = $tf->getFreq($word);
    my $n_docs = $tf->getNumDocsWithWord($word);
    print "word=$word, idf=$idf_score, tf=$tf_score, n_docs=$n_docs\n";
}

# Output some information involving phrase statistics.
my @phrase = qw(in the);
my $tf_score = $tf->getPhraseFreq(@phrase);
my $n_docs = $tf->getNumDocsWithPhrase(@phrase);
print "phrase=\"in the\", freq=$tf_score, n_docs=$n_docs\n";
