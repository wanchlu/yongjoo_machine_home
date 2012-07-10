#!/usr/local/bin/perl

# script: test_classify.pl
# functionality: Classifies the test documents using the perceptron parameters
# functionality: calculated previously; requires that learn.pl has been run

use strict;
use FindBin;
# use lib "$FindBin::Bin/../lib";
# use lib "$FindBin::Bin/lib"; # if you are outside of bin path.. just in case
use vars qw/$DEBUG/;

use Benchmark;
use Clair::Classify;
use Data::Dumper;
use File::Find;

$DEBUG = 0;

my $results_root = "$FindBin::Bin/produced/features";
mkpath($results_root, 0, 0777) unless(-d $results_root);

my $output = "feature_vectors";
my $test = "$results_root/$output.test";
my $model = "$results_root/model";
my $output = "$results_root/classify.results";


unless(-f $test)
{
	print "The test file is required. Make sure learn.pl has been run.\n";
	exit;
}


my $t0;
my $t1;

#
# Finding files
#
$t0 = new Benchmark;

my $cla = new Clair::Classify(DEBUG => $DEBUG, test => $test, model => $model);

my ($result, $correct_count, $total_count) = $cla->classify();

my $percent = sprintf("%.4f", ( $correct_count / $total_count ) * 100 );
# print Dumper(\@return);
print "accuracy: ( $correct_count / $total_count ) * 100 = $percent\n";


$cla->debugmsg($result, 1);

# save the output
open M, "> $output" or $cla->errmsg("cannot open file '$output': $!", 1);
for my $aref (@$result)
{
	my $line = join " ", @$aref;
	print M "$line\n";
}
close M;


$t1 = new Benchmark;
my $timediff_find = timestr(timediff($t1, $t0));

