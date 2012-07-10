#!/usr/local/bin/perl

# script: test_mead_summary.pl
# functionality: Tests MEAD's summarizer on a cluster of two documents,
# functionality: prints features for each sentence of the summary 

use strict;
use warnings;
use FindBin;
use Clair::Cluster;
use Clair::Config;
use Clair::Document;
use Clair::MEAD::Wrapper;
use Clair::MEAD::Summary;

my $out_dir = "$FindBin::Bin/produced/mead_summary";
my $docs = "$FindBin::Bin/input/mead_summary";

my $cluster = Clair::Cluster->new();
my $doc1 = Clair::Document->new( 
    file => "$docs/fed1.txt", 
    id => 1, 
    type => "text"
);
$cluster->insert(1, $doc1);
my $doc2 = Clair::Document->new( 
    file => "$docs/fed2.txt", 
    id => 2, 
    type => "text"
);
$cluster->insert(2, $doc2);

my $mead = Clair::MEAD::Wrapper->new(
    mead_home => $MEAD_HOME,
    cluster => $cluster,
    cluster_dir => $out_dir
);

my $summary = $mead->get_summary();

print "To string:\n";
print $summary->to_string() . "\n\n";

foreach my $i ( 1 .. $summary->size() ) {

    my %sent = $summary->get_sent($i);
    my %feats = $summary->get_features($i);
    my $str = join ",", map { "$_=$feats{$_}" } (keys %feats);

    print "$sent{text} ($sent{did}.$sent{sno}: $str)\n";

}
