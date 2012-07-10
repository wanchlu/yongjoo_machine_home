# script: test_alesearch.t
# functionality: From a small set of documents, build an ALE DB and do some
# functionality: searches 

use warnings;
use strict;
use Clair::Config;
use FindBin;
use Test::More;

if (not defined $ALE_PORT or not -e $ALE_PORT) {
    plan(skip_all => "ALE_PORT not defined in Clair::Config or doesn't exist");
} else {
    plan(tests => 7);
}

use_ok("Clair::ALE::Extract");
use_ok("Clair::ALE::Search");
use Clair::Utils::ALE qw(%ALE_ENV);

# Set up the ALE environment
my $doc_dir = "$FindBin::Bin/input/ale";
$ENV{MYSQL_UNIX_PORT} = $ALE_PORT;
$ALE_ENV{ALESPACE} = "test_search";
$ALE_ENV{ALECACHE} = $doc_dir;
if (defined $ALE_DB_USER) {
    $ALE_ENV{ALE_DB_USER} = $ALE_DB_USER;
}
if (defined $ALE_DB_PASS) {
    $ALE_ENV{ALE_DB_PASS} = $ALE_DB_PASS;
}


my $extract = Clair::ALE::Extract->new();
my @files = glob("$doc_dir/foo.com/*.html");
$extract->extract(files => \@files);

# TEST 1 - total links
my $search = Clair::ALE::Search->new();
is(count_results($search), 5, "Total links");

# TEST 2 - links to self
$search  = Clair::ALE::Search->new(link1_word => "self");
is(count_results($search), 2, "Self links");

# TEST 3 - limit the results
$search = Clair::ALE::Search->new(limit => 1);
is(count_results($search), 1, "limit results");

# TEST 4 - case shouldn't matter
$search = Clair::ALE::Search->new(link1_word => "self");
my $search2 = Clair::ALE::Search->new(link1_word => "SeLF");
is(count_results($search), count_results($search2), "case");

# TEST 5 - mulltilink testing
$search = Clair::ALE::Search->new( link2_word => "web", link1_word => "self" );
is(count_results($search), 1, "multilink search");

# Clean up
$extract->drop_tables();

sub count_results {
    my $search = shift;
    my $total = 0;
    $total++ while $search->queryresult();
    return $total;
}
