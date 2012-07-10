#!/usr/local/bin/perl

# script: test_wordcount.pl
# functionality: Using Cluster and Document, counts the words in each file
# functionality: of a directory 

use strict;
use warnings;
use Clair::Cluster;
use Clair::Document;
use FindBin;

my $input_dir = "$FindBin::Bin/input/wordcount";

my $cluster = Clair::Cluster->new();
$cluster->load_documents("$input_dir/*.txt", type => "text", filename_id => 1 );
my $docs = $cluster->documents();
print "did\t#words\n";
foreach my $did (keys %$docs) {
    my $doc = $docs->{$did};
    my $words = $doc->count_words();
    print "$did\t$words\n";
}
