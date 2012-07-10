# script: test_pagerank.t
# functionality: Creates a small cluster and runs pagerank, confirming
# functionality: the pagerank distribution

use strict;
use warnings;
use FindBin;

use Test::More tests => 8;

use_ok('Clair::Network');
use_ok('Clair::Network::Centrality::PageRank');
use_ok('Clair::Cluster');
use_ok('Clair::Document');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/pagerank";
my $file_input_dir = "$FindBin::Bin/input/pagerank";
my $file_exp_dir = "$FindBin::Bin/expected/pagerank";

my $c = new Clair::Cluster();
my $doc1 = new Clair::Document(id => 1, type => 'text',
    string => 'This is document 1');
my $doc2 = new Clair::Document(id => 2, type => 'text',
    string => 'This is document 2');
my $doc3 = new Clair::Document(id => 3, type => 'text',
    string => 'This is document 3');
my $doc4 = new Clair::Document(id => 4, type => 'text',
    string => 'This is document 4');
$c->insert(1, $doc1);
$c->insert(2, $doc2);
$c->insert(3, $doc3);
$c->insert(4, $doc4);

is($c->count_elements, 4, "count_elements");

my $n = $c->create_hyperlink_network_from_file("$file_input_dir/link.txt");
$n->save_hyperlink_edges_to_file("$file_gen_dir/hyperlinks.txt");
ok(compare_proper_files("hyperlinks.txt"), "save_hyperlink_edges_to_file" );

my $cent = Clair::Network::Centrality::PageRank->new($n);

$cent->centrality();

$cent->save("$file_gen_dir/pagerank_values.txt");
ok(compare_proper_files("pagerank_values.txt"),
    "save_current_pagerank_distribution");

# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
  my $filename = shift;

  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

