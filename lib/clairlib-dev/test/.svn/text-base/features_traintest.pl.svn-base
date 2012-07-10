#!/usr/local/bin/perl

# script: test_features_traintest.pl
# functionality: Builds the feature vector for training and testing datasets,
# functionality: and is a prerequisite for learn.pl and classify.pl

use strict;
use FindBin;
# use lib "$FindBin::Bin/../lib";
# use lib "$FindBin::Bin/lib"; # if you are outside of bin path.. just in case
use vars qw/$DEBUG/;

use Benchmark;
use Clair::Features;
use Clair::GenericDoc;
use Data::Dumper;
use File::Find;
use File::Path;

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
my $output = "feature_vectors";
my $feature_opt = $args{feature} if($args{feature});
my $filter = $args{filter} || '.*';


my $t0;
my $t1;

#
# Finding files
#
$t0 = new Benchmark;


sub wanted_train
{
  return if( ! -f $File::Find::name );
  push @train_files, $File::Find::name;
}
find(\&wanted_train, ( $train_root ));
@train_files = grep { -f $_ && /$filter/ } @train_files;


sub wanted_test
{
  return if( ! -f $File::Find::name );
  push @test_files, $File::Find::name;
}
find(\&wanted_test, ( $test_root ));
@test_files = grep { -f $_ && /$filter/ } @test_files;


$t1 = new Benchmark;
my $timediff_find = timestr(timediff($t1, $t0));



#
# Processing documents
#
$t0 = new Benchmark;

$container{train} = \@train_files;
$container{test} = \@test_files;

# train the data first and then test
# this illustrates how you first use the train data to produce the feature vectors
# and then use the test data to build the feature vectors with matching id's.

for my $dataset (qw/train test/)
{
	my $files = $container{$dataset};
	
	my $fea = new Clair::Features(
		DEBUG => $DEBUG,
		features_file => "$results_root/feature_lookup_map",
		# document_limit => $n,
		mode => $dataset,
		# features_file => "$results_root/.features_lookup"
	);
	$fea->debugmsg("building $dataset feature vectors", 0);

	for my $f (@$files)
	{
		my $gdoc = new Clair::GenericDoc(
			DEBUG => $DEBUG,
			content => $f,
			stem => 1,
			use_parser_module => "sports"
		);
		
		$fea->register($gdoc);
		undef $gdoc;
	}

	# you need to run $fea->select() in order to retain the feature id's across the datasets.
	$fea->debugmsg("ordering features and saving the map for $dataset", 0) if($dataset eq "train");
	$fea->select();
	# $fea->input("$output.$dataset");
	$fea->debugmsg("saving $dataset feature vectors: $results_root/$output.$dataset", 0);
	$fea->output("$results_root/$output.$dataset");
}


$t1 = new Benchmark;
my $timediff_prep = timestr(timediff($t1, $t0));

