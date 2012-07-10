# script: test_network_adamic.t
# functionality: Test the function of adamic/adar value in a network.

use Test::More tests=>4; 
use Clair::Network::AdamicAdar;
use_ok(Clair::Network::AdamicAdar);
use FindBin;

my $corpus = "$FindBin::Bin/input/adamic_adar";

$aa = new Clair::Network::AdamicAdar();
$result = $aa->readCorpus($corpus);

is ($result->{"C.txt"}->{"E.txt"}, 1.53157416118645, "test the Adamic Adar value between C and E");
is ($result->{"A.txt"}->{"B.txt"}, 1.34268245500409, "test the Adamic Adar value between A and B");
is ($result->{"A.txt"}->{"C.txt"}, 1.34268245500409, "test the Adamic Adar value between A and C");

