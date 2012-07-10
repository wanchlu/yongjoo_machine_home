# script: test_kernighanlin.t
# funcationality: Test KernighanLin algorithm on Karate data

use Clair::Network::KernighanLin;
use Clair::Network::Reader::GML;
use FindBin;
use Test::More tests => 5;

use_ok('Clair::Network::KernighanLin');
use_ok('Clair::Network::Reader::GML');

my $base_dir = $FindBin::Bin;
my $fileName = "$base_dir/input/network/karate.gml";
my $reader = Clair::Network::Reader::GML->new();
my $net = $reader->read_network($fileName);

my $KL = new Clair::Network::KernighanLin($net);

$graphPartition = $KL->generatePartition(4);

is($$graphPartition{1},1, "Check the partition of node 1");
is($$graphPartition{2},1, "Check the partition of node 2");
is($$graphPartition{3},1, "Check the partition of node 3");


