#!/usr/local/bin/perl

# script: test_summary.pl
# functionality: Test the cluster summarization ability using various features 

use strict;
use warnings;
use Clair::Document;
use Clair::Cluster;
use Clair::SentenceFeatures qw(:all);
use FindBin;

# Load some documents
my @docs = glob("$FindBin::Bin/input/summary/*");
my $cluster = Clair::Cluster->new();
$cluster->load_file_list_array(\@docs, type => "text", filename_id => 1);

# Create a list of features and assign them uniform weights
my %features = (
    'length' => \&length_feature,
    'position' => \&position_feature,
    'simwithfirst' => \&sim_with_first_feature,
    'centroid' => \&centroid_feature
);
my %weights = map { $_ => 1 } keys %features;

# Compute the features and scale them to [0,1]
$cluster->compute_sentence_features(%features);
$cluster->normalize_sentence_features(keys %features);

# Score the sentences using the weights
$cluster->score_sentences( weights => \%weights );

# Get a ten sentence summary
my @summary = $cluster->get_summary( size => 10 );

foreach my $sent (@summary) {
    my $features = $sent->{features};
    my $score = $sent->{score};
    $sent->{did} =~ /([^\/]+\.txt)/;
    my $did = $1;
    my $sno = $sent->{'index'} + 1;
    print "[$did,$sno,$score]\t$sent->{text}\n";
    foreach my $fname (keys %$features) {
        print "\t$fname $features->{$fname}\n";
    }
}
