# script: test_compare_idf.t
# functionality: Compare results of Clair::Util idf calculations with
# functionality: those performed by the build_idf script 


# This is used to compare the results of the idf calculations in Clair::Util
# to the ones performed by the build_idf script
# Input should be a single file that has already been stemmed
use strict;
use warnings;
use FindBin;
use Test::More tests => 7;

use_ok('Clair::Util');
use_ok('Clair::Cluster');
use_ok('Clair::Document');

my $file_exp_dir = "$FindBin::Bin/expected/compare_idf";
my $file_gen_dir = "$FindBin::Bin/produced/compare_idf";
my $root_dir = $FindBin::Bin;

# Create cluster
my %documents = ();
my $c = Clair::Cluster->new(documents => \%documents);

# Read input file
my $input_file = "$FindBin::Bin/input/compare_idf/test.txt";

my $text = "";

# Create each document, stem it, and insert it into the cluster
# Add the stemmed text to the $text variable
my $doc = Clair::Document->new(type => 'text', file => $input_file, 
    id => $input_file);
$c->insert(document => $doc, id => $input_file);
$text .= $doc->{text} . " ";

# Take off the last newline like the other build_idf does (for comparison)
$text = substr($text, 0, length($text) - 1);

# Change directory so dbm files are created in the docs directory
chdir $file_gen_dir or die "Couldn't chdir to $file_gen_dir: $!";

Clair::Util::build_idf_by_line($text, "dbm2");

my %idf = Clair::Util::read_idf("dbm2");
my $l;
my $r;
my $ct = 0;

is( $idf{'This'}, log(6/1.5), 'idf{This}' );
is( $idf{'on'}, log(6/2.5), 'idf{on}' );
is( $idf{'not'}, log(6/1.5), 'idf{not}' );
is( $idf{'one'}, log(6/3.5), 'idf{one}' );
