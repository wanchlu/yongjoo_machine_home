# script: test_idf.t
# functionality: Test TF and IDF functions drawing on a pre-downloaded corpus 

$ENV{ALECACHE} = "/tmp";
use strict;
use warnings;
use FindBin;
use DB_File;
use Test::More tests => 9;
use Clair::Config;

use_ok('Clair::Utils::Idf');
use_ok('Clair::Utils::Tf');
use_ok('Clair::Utils::CorpusDownload');

my $corpus_name = 'download_test';
my $word = 'abused';
my $s_word = 'abus';
my $base_dir = $FindBin::Bin;
my $root_dir = "$base_dir/input/idf";

my $corpusref = Clair::Utils::CorpusDownload->new(corpusname => $corpus_name,
                                    rootdir => $root_dir);
$corpusref->buildIdf(stemmed => 1);
$corpusref->buildIdf(stemmed => 0);
$corpusref->build_docno_dbm();
$corpusref->buildTf(stemmed => 1);
$corpusref->buildTf(stemmed => 0);

my %param_hash;
$param_hash{corpusname} = $corpus_name;
$param_hash{rootdir} = $root_dir;

# Compute the IDF (without stemming)
$param_hash{stemmed} = 0;
my $idfref = Clair::Utils::Idf->new(%param_hash);
my $result = $idfref->getIdfForWord($word);
cmp_ok( abs($result - 2.705), '<', 0.005, "getIdfForWord $word" );

$param_hash{stemmed} = 1;
$idfref = Clair::Utils::Idf->new(%param_hash);
$result = $idfref->getIdfForWord($s_word);
cmp_ok( abs($result - $DEFAULT_UNKNOWN_IDF), '<', 0.005, "getIdfForWord $s_word (stemmed)" );

$param_hash{stemmed} = 0;
my $tfref = Clair::Utils::Tf->new(%param_hash);
$result = $tfref->getNumDocsWithWord($word);
my $freq = $tfref->getFreq($word);
my @urls = $tfref->getDocs($word);
is($freq, 1, "tf $word");
is($result, 1, "num docs with $word");
is($urls[0], 
    "http://tangra.si.umich.edu/clair/testhtml/APW19981201.0005.txt.body.html",
    "urls[0]");
is(scalar @urls, 1, "number of urls");
