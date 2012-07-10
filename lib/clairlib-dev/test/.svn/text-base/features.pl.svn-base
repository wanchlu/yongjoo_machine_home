#!/usr/local/bin/perl

# script: test_features.pl
# functionality: Reads docs from input/features/train, calculates chi-squared
# functionality: values for all extracted features, shows ways to retrieve
# functionality: those features

use strict;
use FindBin;
# use lib "$FindBin::Bin/../lib";
# use lib "$FindBin::Bin/lib"; # if you are outside of bin path.. just in case
use vars qw/$DEBUG/;

use Clair::Features;
use Clair::GenericDoc;
use Data::Dumper;
use File::Find;
use File::Path;

# globals
$DEBUG = 0;
my %args;
my @train_files = (); # list of train files we will analyze
my @test_files = (); # list of test files we will analyze
my %container = (); # container for our file arrays.
my $results_root = "$FindBin::Bin/produced/features";

mkpath($results_root, 0, 0777) unless(-d $results_root);

my $n = $args{n} || 0;
my $train_root = "$FindBin::Bin/input/features/train";
my $test_root = "$FindBin::Bin/input/features/test";
my $output = "test_output";
my $feature_opt = $args{feature} if($args{feature});
my $filter = $args{filter} || '.*';


my $t0;
my $t1;

#
# Finding files
#
sub wanted_train
{
  return if( ! -f $File::Find::name );
  push @train_files, $File::Find::name;
}
find(\&wanted_train, ( $train_root ));
@train_files = grep { -f $_ && /$filter/ } @train_files;


#
# Processing documents
#
my $files = \@train_files;
my $files_count = scalar @train_files;

my $fea = new Clair::Features(
	DEBUG => $DEBUG,
	document_limit => $n,
	mode => "train", # train data
	# features_file => "$results_root/.features_lookup"
);


$fea->debugmsg("registering $files_count documents", 0);
# register each document into the Clair::Features object
for my $f (@$files)
{
	my $gdoc = new Clair::GenericDoc(
		DEBUG => $DEBUG,
		content => $f,
		stem => 1,
		lowercase => 1,
		use_parser_module => "sports" # the test data is formatted in pseudo xml.
	);
		
	$fea->register($gdoc);
	undef $gdoc; # memory conscious
}

# print Dumper($fea->{features_global}); exit;

my $all = $fea->select();
$fea->debugmsg("feature counts: " . scalar @$all, 0);

my $top10 = $fea->select(10);
$fea->debugmsg("top 10 features:\n" . Dumper($top10), 0);

my $top50 = $fea->select(50);
$fea->debugmsg("top 50 features:\n" . Dumper($top50), 0);

# you can also get the feature chi-squared values for binary classified documents.
$fea->debugmsg("running \$fea2->chi_squared();", 0);
$fea->{DEBUG} = 1; # to show more info
my $chisq_values = $fea->chi_squared();
print Dumper($chisq_values);

# save the classified data into a file in the svm_light format.
$fea->output("$results_root/$output.train");

$fea->debugmsg("feature vectors saved here: $results_root/$output.train", 0);

# print Dumper($fea->{features_global});
# print Dumper($fea->{feature_scores});

