#!/usr/bin/perl
# script: classify.pl
# functionality: Classify a testing set using perceptron classifies.

use strict;
use warnings;

use Getopt::Long;

use Clair::Classify;

sub usage;

my $model_file = "";
my $test_features_file = "";
my $output="";
my $verbose=0;

my $res = GetOptions("model=s" => \$model_file,
                     "features_vectors=s" => \$test_features_file,
                     "output=s" => \$output,
                     "verbose!" => \$verbose);

if (!$res or ($model_file eq "") or ($test_features_file eq "") or($output eq "")) {
        usage();
        exit;
}
my $DEBUG=0;
my $cla = new Clair::Classify(DEBUG => $DEBUG, test => $test_features_file, model => $model_file);

my ($result, $correct_count, $total_count) = $cla->classify();

my $percent = sprintf("%.4f", ( $correct_count / $total_count ) * 100 );
# print Dumper(\@return);
print "accuracy: ( $correct_count / $total_count ) * 100 = $percent\n";


$cla->debugmsg($result, 1);

# save the output
open M, ">$output" or $cla->errmsg("cannot open file '$output': $!", 1);
for my $aref (@$result)
{
        my $line = join " ", @$aref;
        print M "$line\n";
}
close M;

#
# Print out usage message
#
sub usage
{
        print "usage: $0 --features_vectors file --model file --output file [--verbose]\n\n";
        print "  --test_features in_file\n";
        print "       Name of testing set features file. Each line of the file corresponds to a file and should take the following format (class feature:value...feature:value) \n";
        print "  --model file\n";
        print "       Name of resulting model file\n";
        print "  --output file\n";
        print "       The file the results will be written. It has the following format\n";
        print "       (docid   score   computed_class   correct_class   y|n) \n";
        print "  --verbose\n";

        print "\n";

        print "example: $0 --features_vectors test.features --model model --output results --verbose\n";

        exit;
}

