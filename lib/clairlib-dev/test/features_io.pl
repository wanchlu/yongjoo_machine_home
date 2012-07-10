#!/usr/local/bin/perl

# script: features_io.pl
# functionality: Same as features.pl BUT, outputs the train data set as
# functionality: document and feature vectors in svm_light format, reads
# functionality: the svm_light formatted file and converts it to perl hash

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


# we can limit the number of document per class
my $fea2 = new Clair::Features(
	DEBUG => $DEBUG,
	document_limit => 100, ## NOTICE THIS FLAG ##
	mode => "train", # train data
	# features_file => "$results_root/.features_lookup"
);
$fea2->debugmsg("registering $files_count documents with 100 limit per class", 0);

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
		
	$fea2->register($gdoc);
	undef $gdoc; # memory conscious
}


my $top10 = $fea2->select(20);
$fea2->debugmsg("top 20 features with 100 docs:\n" . Dumper($top10), 0);

# you can also get the feature chi-squared values for binary classified documents.
$fea2->debugmsg("running \$fea2->chi_squared();", 0);

$fea2->{DEBUG} = 1; # to show more info
my $chisq_values = $fea2->chi_squared();
print Dumper($chisq_values);


# save the feature vectors in svm_light format
$fea2->output("$results_root/$output.train");
$fea2->debugmsg("feature vectors saved here: $results_root/$output.train", 0);

# feature and its associated id is saved here
# print Dumper($fea2->{features_map});

$fea2->debugmsg("retrieving feature vectors and converting to perl data structure", 0);
my $vectors = $fea2->input("$results_root/$output.train");
print Dumper($vectors);
