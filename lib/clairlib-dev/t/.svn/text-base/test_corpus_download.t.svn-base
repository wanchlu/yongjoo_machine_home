# script: test_corpus_download.t
# functionality: Test CorpusDownload, downloading a corpus and checking the
# functionality: produced TF and IDF against expected results 

$ENV{ALECACHE} = "/tmp";
use strict;
use warnings;
use FindBin;
use Test::More tests => 11;

use_ok('Clair::Utils::CorpusDownload');
use_ok('Clair::Util');

my $base_dir = $FindBin::Bin;
my $input_dir = "$base_dir/input/corpus_download";
my $root_dir = "$base_dir/produced/corpus_download";

my $corpus_name = "download_test";
my $corpusref = Clair::Utils::CorpusDownload->new(corpusname => $corpus_name,
    rootdir => $root_dir);

# Make sure we read in the correct number of URLs
my $uref = $corpusref->readUrlsFile("$base_dir/input/corpus_download/t.urls");
is(scalar @$uref, 6, "Number of url refs");

# Build the corpus
$corpusref->buildCorpus(urlsref => $uref);

# Now check to make sure the correct files have been downloaded
foreach my $url (@$uref) {
    my $remote_path = $url;
    $remote_path =~ s{^http://}{}g;
    if ($remote_path =~ m{/([^/]+)$}) {
        my $file_name = $1;
        ok( cd_compare("download/$corpus_name/$remote_path", $file_name), 
            "downloaded $file_name" );
    } else {
        fail("Bad URL: $url, check input dir $input_dir");
    }
}

$corpusref->buildIdf(stemmed => 1);
$corpusref->buildIdf(stemmed => 0);
$corpusref->build_docno_dbm();
$corpusref->buildTf(stemmed => 1);
$corpusref->buildTf(stemmed => 0);

ok( cd_compare("corpus-data/$corpus_name-tf/a/ab/abused.tf", "abused.tf"),
    "abused.tf" );
ok( cd_compare("corpus-data/$corpus_name-tf-s/a/ab/abus.tf", "abus.tf"),
    "abus.tf" );

sub cd_compare {
    my ($file1, $file2) = @_;
    return Clair::Util::compare_files(
        "$base_dir/produced/corpus_download/$file1",
        "$base_dir/expected/corpus_download/$file2"
    );
}
