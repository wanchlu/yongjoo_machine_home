# script: test_hyperlink.t
# functionality: Test the ability to generate a hyperlink-based network from
# functionality: a small document cluster 

use strict;
use warnings;
use FindBin;
use Test::More tests => 7;

use_ok('Clair::Network');
use_ok('Clair::Cluster');
use_ok('Clair::Document');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/hyperlink";
my $file_input_dir = "$FindBin::Bin/input/hyperlink";
my $file_exp_dir = "$FindBin::Bin/expected/hyperlink";

my $c = new Clair::Cluster();
my $d1 = new Clair::Document(id => 1, type => 'text', string => 'Document 1');
$c->insert(1, $d1);
my $d2 = new Clair::Document(id => 2, type => 'text', string => 'Document 2');
$c->insert(2, $d2);
my $d3 = new Clair::Document(id => 3, type => 'text', string => 'Document 3');
$c->insert(3, $d3);
my $d4 = new Clair::Document(id => 4, type => 'text', string => 'Document 4');
$c->insert(4, $d4);

is($c->count_elements, 4, "count_elements");

my $n = $c->create_hyperlink_network_from_file("$file_input_dir/hyperlinks");

# Original edges
$n->save_hyperlink_edges_to_file("$file_gen_dir/hyperlink1");
ok( compare_proper_files("hyperlink1"), "save_hyperlink_edges_to_file" );

my $n2 = $n->create_subset_network_from_file("$file_input_dir/subset");
$n2->save_hyperlink_edges_to_file("$file_gen_dir/hyperlink2");
ok(compare_proper_files("hyperlink2"), "create_subset_network_from_file" );

sub compare_proper_files {
  my $filename = shift;
  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

