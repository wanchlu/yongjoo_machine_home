# script: test_girvanNewman
# functionality: Test GirvanNewman algorithm on Karate data

use Clair::Network::GirvanNewman;
use Clair::Network::Reader::GML;
use FindBin;
use Test::More tests => 5;

use_ok('Clair::Network::GirvanNewman');
use_ok('Clair::Network::Reader::GML');

my $base_dir = $FindBin::Bin;
my $fileName = "$base_dir/input/network/karate.gml";
my $reader = Clair::Network::Reader::GML->new();
my $net = $reader->read_network($fileName);

my $GN = new Clair::Network::GirvanNewman($net);
$graphPartition = $GN->partition();

my $str1 = $$graphPartition{1};
my $str2 = $$graphPartition{2};
my $str3 = $$graphPartition{3};

is(substr($str1, 2, 1), 0, "Check the partition of node 1");
is(substr($str2, 2, 1), 0, "Check the partition of node 2");
is(substr($str3, 2, 1), 1, "Check the partition of node 3");
