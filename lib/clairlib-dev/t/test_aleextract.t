# script: test_aleextract.t
# functionality: Using ALE, extract a corpus in a DB and perform several
# functionality: searches on it 

use warnings;
use strict;
use Clair::Config qw($ALE_PORT $ALE_DB_USER $ALE_DB_PASS);
use FindBin;
use Test::More;

if (not defined $ALE_PORT or not -e $ALE_PORT) {
    plan(skip_all => "ALE_PORT not defined in Clair::Config or doesn't exist");
} else {
    plan(tests => 10);
}

use_ok("Clair::ALE::Extract");
use_ok("Clair::ALE::Search");
use Clair::Utils::ALE qw(%ALE_ENV);

# Set up the ALE environment
my $doc_dir = "$FindBin::Bin/input/ale";
$ENV{MYSQL_UNIX_PORT} = $ALE_PORT;
$ALE_ENV{ALESPACE} = "test_extract";
$ALE_ENV{ALECACHE} = $doc_dir;
if (defined $ALE_DB_USER) {
    $ALE_ENV{ALE_DB_USER} = $ALE_DB_USER;
}
if (defined $ALE_DB_PASS) {
    $ALE_ENV{ALE_DB_PASS} = $ALE_DB_PASS;
}

# Extract the links
my $e = Clair::ALE::Extract->new();
my @files = glob("$doc_dir/tangra.si.umich.edu/clair/testhtml/*.html");
$e->extract( drop_tables => 1, files => \@files );

# TEST 1 - total pages
my $search = Clair::ALE::Search->new(
    limit => 200,
);
is(count_results($search), 107, "Total links indexed");

# TEST 2 - just from index.html
$search = Clair::ALE::Search->new(
    limit => 100,
    source_url => "http://tangra.si.umich.edu/clair/testhtml"
);
is(count_results($search), 3, "From index.html");

# TEST 3 - just to google
$search = Clair::ALE::Search->new(
    limit => 100,
    dest_url => "http://www.google.com"
);
is(count_results($search), 1, "To google.com");

# TEST 4 - "search the web"
$search = Clair::ALE::Search->new(
    limit => 100,
    link1_text => "Search the web"
);
is(count_results($search), 1, "With text \"Search the web\"");

# TEST 5,6 - "search the web" urls
$search = Clair::ALE::Search->new(
    limit => 100,
    link1_text => "Search the web"
);
my $conn = $search->queryresult();
my $link = $conn->{links}->[0];
is($link->{from}->{url}, 
    "http://tangra.si.umich.edu/clair/testhtml", "link from");
is($link->{to}->{url}, "http://www.google.com", "link to");

# Clean up
$e->drop_tables();

# TEST 7,8 - from CorpusDownload style corpus 
$e = Clair::ALE::Extract->new();
my $old_space = $ALE_ENV{ALESPACE};
$e->extract(
    corpusname => "myCorpus",
    rootdir => "$FindBin::Bin/input/ale/corpus"
);
is($ALE_ENV{ALESPACE}, $old_space, "extract doesn't change ALESPACE");
$ALE_ENV{ALESPACE} = "myCorpus";
$search = Clair::ALE::Search->new();
is(count_results($search), 5, "Total links");
#$e->drop_tables();


# Helper
sub count_results {
    my $search = shift;
    my $total = 0;
    $total++ while $search->queryresult();
    return $total;
}
