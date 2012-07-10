# script: test_network.t
# functionality: Test basic Network functionality, such as node/edge addition
# functionality: and removal, path generation, statistics, matlab graphics
# functionality: generation, etc.

use strict;
use warnings;
use FindBin;
use Test::More tests => 5;

use_ok('Clair::Network');
use_ok('Clair::Network::Reader::GML');

my $file_doc_dir = "$FindBin::Bin/input/network_reader";

my $reader = Clair::Network::Reader::GML->new();
my $net = $reader->read_network($file_doc_dir . "/test.gml");

ok($net->has_edge("1", "2"), "edge 1-2 exists");
ok($net->has_edge("2", "3"), "edge 2-3 exists");
ok($net->has_edge("3", "1"), "edge 3-1 exists");
