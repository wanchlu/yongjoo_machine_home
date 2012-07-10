#!/usr/local/bin/perl

# script: test_learn.pl
# functionality: Uses feature vectors in the svm_light format and calculates
# functionality: and saves perceptron parameters; needs features_traintest.pl

use strict;
use FindBin;
# use lib "$FindBin::Bin/../lib";
# use lib "$FindBin::Bin/lib"; # if you are outside of bin path.. just in case
use vars qw/$DEBUG/;

use Benchmark;
use Clair::Learn;
use Data::Dumper;
use File::Find;


$DEBUG = 0;
my %args;
my @train_files = (); # list of train files we will analyze
my @test_files = (); # list of test files we will analyze
my %container = (); # container for our file arrays.

my $results_root = "$FindBin::Bin/produced/features";
mkpath($results_root, 0, 0777) unless(-d $results_root);

my $output = "feature_vectors";
my $train = "$results_root/$output.train";
my $model = "$results_root/model";
my $eta = $args{eta};

unless(-f $train)
{
	print "The train file is required. Make sure features_traintest.pl has been run.\n";
	exit;
}

my $t0;
my $t1;

#
# Finding files
#
$t0 = new Benchmark;


my $lea = new Clair::Learn(DEBUG => $DEBUG, train => $train, model => $model);
my ($w0, $w) = $lea->learn("", $eta); # retrieves the coefficients


$t1 = new Benchmark;
my $timediff = timestr(timediff($t1, $t0));

$lea->debugmsg("learning (perceptron) convergence took: $timediff", 0);
$lea->debugmsg("intercept: $w0\n" . Dumper($w), 1);

# save the output
open M, "> $model" or $lea->errmsg("cannot open file '$model': $!", 1);
print M "intercept $w0\n";
while (my ($feature_id, $weight) = each %$w)
{
	print "id:weight $feature_id:$weight\n";
	print M "$feature_id $weight\n";
}
close M;
