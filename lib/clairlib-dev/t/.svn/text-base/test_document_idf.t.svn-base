# script: test_document_idf.t
# functionality: Test the values assigned to various words in a generated IDF 

use strict;
use warnings;
use FindBin;
use Test::More tests => 13;


use_ok('Clair::Document');
use_ok('Clair::Cluster');

my $c = Clair::Cluster->new();

my $input_dir = "$FindBin::Bin/input/document_idf";
my $output_dir = "$FindBin::Bin/produced/document_idf";
$c->load_documents("$input_dir/*", type => 'html');
$c->strip_all_documents();
$c->stem_all_documents();

my $num_docs = $c->count_elements();
is($num_docs, 4, "correct num docs");

my %idf_hash = $c->build_idf("$output_dir/idf-dbm", type => 'text');

my $numerator = $num_docs + 1;

my $value = $idf_hash{'one'};
is($value, log( $numerator / 1.5 ), "one");

$value = $idf_hash{'and'};
is($value, log( $numerator / 2.5 ), "and");

$value = $idf_hash{'the'};
is($value, log( $numerator / 2.5 ), "the");

$value = $idf_hash{'The'};
is($value, log( $numerator / 4.5 ), "The");

$value = $idf_hash{'sales'};
is($value, log( $numerator / 1.5 ), "sales");

$value = $idf_hash{'rescuers'};
is($value, log( $numerator / 2.5 ), "rescuers");


%idf_hash = $c->build_idf("$output_dir/idf-dbm", type => 'stem');

$value = $idf_hash{'the'};
is($value, log( $numerator / 4.5 ), "the (stemmed)");

$value = $idf_hash{'sale'};
is($value, log( $numerator / 1.5 ), "sale (stemmed)");

$value = $idf_hash{'rescu'};
is($value, log( $numerator / 2.5 ), "rescu (stemmed)");

$value = $idf_hash{'The'};
is($value, undef, "'The' not defined");
