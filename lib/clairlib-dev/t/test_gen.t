# script: test_gen.t
# functionality: Test some statistical computations using Clair::Gen 

use strict;
use warnings;
use FindBin;
use Test::More tests=> 9;

use_ok('Clair::Gen');

my $file_input_dir = "$FindBin::Bin/input/gen";

my $g = new Clair::Gen;
$g->read_from_file("$file_input_dir/j.dist");
my $n = $g->count;

is($n, 8, "count");

my @expected_dist = (7, 4, 1, 0, 0, 0, 0, 3);
my @observed = $g->distribution;
is_deeply(\@observed, \@expected_dist, "distribution");

my ($c_hat, $alpha_hat) = $g->plEstimate(\@observed);
cmp_ok( abs($c_hat - 4.7265), '<', 0.0005, "plEstimate c_hat" );
cmp_ok( abs($alpha_hat + 0.465), '<', 0.005, "plEstimate alpha_hat" );

my @expected = $g->genPL($c_hat, $alpha_hat, $n);
my ($df, $pv) = $g->compareChiSquare(\@observed, \@expected, 2);
is($df, 5, "compareChiSquare df");
cmp_ok( abs($pv - 0.0895), '<', 0.0005, "compareChiSquare pv" );

# lambda = 8, nsamples = 20
my $lambda = 8;
my $n_samples = 20;
my @samples = $g->genPois($lambda, $n_samples);

is(scalar @samples, $n_samples, "genPois number of samples");
my $all_pos = 1;
for (@samples) {
    last and $all_pos = 0 if $_ <= 0;
}
ok($all_pos, "genPois positive samples");

