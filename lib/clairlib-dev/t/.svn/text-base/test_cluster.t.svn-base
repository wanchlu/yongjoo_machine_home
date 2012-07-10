# script: test_cluster.t
# functionality: Test many basic functions of the Cluster class, including
# functionality: Document insertion, Network generation, and more. 

use strict;
use warnings;
use FindBin;
use Test::More tests => 29;
use Clair::Config;

use_ok('Clair::Document');
use_ok('Clair::Cluster');
use_ok('Clair::Network');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/cluster";
my $file_doc_dir = "$FindBin::Bin/input/cluster";
my $file_exp_dir = "$FindBin::Bin/expected/cluster";

my $c1 = Clair::Cluster->new();
my $d1 = Clair::Document->new( id => 1, type => "text",
    string => 'This is the text for document 1.' );
$d1->stem();
$c1->insert(1, $d1);
is($c1->count_elements(), 1, "count_elements");

my $d2 = Clair::Document->new( id => 2, string => 'Text for document 2.', 
    type => 'text');
$d2->stem();
$c1->insert(2, $d2);
is($c1->count_elements, 2, "count_elements");

my $get_d2 = $c1->get(2);
is($get_d2, $d2, "get");
is($c1->count_elements, 2, "count_elements");

my $d3 = Clair::Document->new( id => 3, type => "text",
    string => 'This is the third of the documents.' );
$d3->stem();
$c1->insert(3, $d3);
is($c1->count_elements, 3, "count_elements");

my $n = $c1->create_sentence_based_network();
isa_ok($n, "Clair::Network", "create_sentence_based_network");
is($n->num_nodes(), 3, "Network::num_nodes");
is($n->num_links(), 4, "Network::num_links");

my %cos_hash_stem_assumed       = $c1->compute_cosine_matrix();
my %largest_cosine_stem_assumed = $c1->get_largest_cosine();
my $val = $cos_hash_stem_assumed{1}{2};
cmp_ok(abs($val - 0.4645), '<', 0.0005, "compute_cosine_matrix");

my %cos_hash_stem_specified = $c1->compute_cosine_matrix(text_type => 'stem');
my %largest_cosine_stem_specified = $c1->get_largest_cosine();
$val = $cos_hash_stem_specified{2}{3};
cmp_ok(abs($val - 0.1445), '<', 0.0005, "compute_cosine_matrix 2");

is($largest_cosine_stem_assumed{'value'}, 
    $largest_cosine_stem_specified{'value'}, "get_largest_cosine");


my %cos_hash_text       = $c1->compute_cosine_matrix(text_type => 'text');
my %largest_cosine_text = $c1->get_largest_cosine();
$val = $cos_hash_text{1}{3};
cmp_ok(abs($val - 0.0215), '<', 0.0005, "compute_cosine_matrix unstemmed");

$c1->write_cos("$file_gen_dir/text.cos");
ok(compare_proper_files('text.cos'), "write_cos");

$c1->write_cos("$file_gen_dir/stem.cos", 
    cosine_matrix => \%cos_hash_stem_assumed);
ok(compare_proper_files('stem.cos'), "write_cos unstemmed");

$c1->write_cos("$file_gen_dir/stem_zeros.cos", 
    cosine_matrix => \%cos_hash_stem_specified, write_zeros => 1);
ok(compare_proper_files('stem_zeros.cos'), "write_cos stemmed zeros");


# Test the compute_lexrank method

$d1 = Clair::Document->new(string => "foo bar", type => "text", id => 1);
$d2 = Clair::Document->new(string => "bar baz", type => "text", id => 2);
$d3 = Clair::Document->new(string => "qux",     type => "text", id => 3);
my $c = Clair::Cluster->new();
$c->insert(1, $d1);
$c->insert(2, $d2);
$c->insert(3, $d3);
my %scores = $c->compute_lexrank();
is(scalar keys %scores, 3, "compute_lexrank number of scores");
ok($scores{3} <= $scores{2}, "compute_lexrank scores 1");
ok($scores{3} <= $scores{1}, "compute_lexrank scores 2");
cmp_ok(abs($scores{1} - $scores{2}), '<', 0.1, "compute_lexrank scores");


# Test the get_unique_words method

$d1 = Clair::Document->new(string => "Cat dogs bears", type => "text", id => 1);
$d2 = Clair::Document->new(string => "cat Bear", type => "text", id => 2);
$c = Clair::Cluster->new();
$c->insert(1, $d1);
$c->insert(2, $d2);
my @words = $c->get_unique_words();
ok(eq_set(\@words, ["cat", "dog", "bear"]), "get unique words");


# Test the genprob functionality

SKIP: {

    if (not defined $GENPROB or not -e $GENPROB) {
        skip("because \$GENPROB not defined in Clair::Config or doesn't exist",
            5);
    }

    $d1 = Clair::Document->new(string => "cat dogs bear", type => "text", 
        id => 1);
    $d2 = Clair::Document->new(string => "dog cat dog", type => "text", 
        id => 2);
    $d3 = Clair::Document->new(string => "bear bear", type => "text", 
        id => 3);
    $c = Clair::Cluster->new();
    $c->insert(1, $d1);
    $c->insert(2, $d2);
    $c->insert(3, $d3);
    my %genprob = $c->compute_genprob_matrix();
    foreach (keys %genprob) {
        is($genprob{$_}->{$_}, 0, "0 diag");
    }
    cmp_ok(abs($genprob{1}->{2} - 0.3271924516), '<', 0.01, "genprob 1");
    cmp_ok(abs($genprob{1}->{3} - 0.3275189910), '<', 0.01, "genprob 2");
}

# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
	my $filename = shift;
	return Clair::Util::compare_files("$file_exp_dir/$filename", 
        "$file_gen_dir/$filename");
}
