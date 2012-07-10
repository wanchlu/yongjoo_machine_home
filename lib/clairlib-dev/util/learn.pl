#!/usr/bin/perl
# script: learn.pl
# functionality: Train a model using perceptron

use strict;
use warnings;

use Getopt::Long;

use Clair::Learn;

sub usage;

my $model_file = "";
my $train_features_file = "";
my $verbose=0;
my $eta=0.5;

my $res = GetOptions("model=s" => \$model_file,
                     "features_vectors=s" => \$train_features_file,
                     "eta=f" =>\$eta,
                     "verbose!" => \$verbose);

if (!$res or ($model_file eq "") or ($train_features_file eq "")) {
        usage();
        exit;
}

if ($eta <= 0 or $eta > 1){
     print STDERR "eta should be  0 < eta <= 1\n";
     exit;
}

my $DEBUG = 0;


my $lea = new Clair::Learn(DEBUG => $DEBUG, train => $train_features_file, model => $model_file);
my ($w0, $w) = $lea->learn("", $eta); # retrieves the coefficients

      # save the output
open M, ">$model_file" or $lea->errmsg("cannot open file '$model_file': $!", 1);
print M "intercept $w0\n";
while (my ($feature_id, $weight) = each %$w)
{
        print "id:weight $feature_id:$weight\n";
        print M "$feature_id $weight\n";
}
close M;



#
# Print out usage message
#
sub usage
{
        print "usage: $0 --features_vectors file --model file [--eta float] [--verbose]\n\n";
        print "  --features_vectors in_file\n";
        print "       Name of taining set features file. Each line of the file corresponds to a file and should take the following format (class feature:value...feature:value) \n";
        print "  --model file\n";
        print "       Name of resulting model file\n";
        print "  --eta float\n";
        print "       Learning rate (0 < eta <= 1) \n";
        print "  --verbose\n";

        print "\n";

        print "example: $0 --features_vectors train.features --model model --eta 0.75 --verbose\n";

        exit;
}

