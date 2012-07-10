#!/usr/bin/perl
# script: summarize_document.pl
# functionality: Summarize a single document

use strict;
use warnings;

use Getopt::Long;

use Clair::Harmonic;
use Clair::Network::Reader::Edgelist;

sub usage;

my $output_file = "";
my $graph_file = "";
my $labels_file = "";
my $split_file = "";
my $method="relaxation";
my $rounds=10000;
my $verbose=0;

my $res = GetOptions("graph=s" => \$graph_file,
                     "output=s" => \$output_file,
                     "labels=s" => \$labels_file,
                     "split=s" => \$split_file,
                     "method=s" => \$method,
                     "rounds=i" => \$rounds,
                     "verbose!" => \$verbose);

if (!$res or $graph_file eq "" or $labels_file eq "" or $split_file eq "" or $output_file eq "") {
        usage();
        exit;
}

my $reader = new Clair::Network::Reader::Edgelist();
print "Reading in the network\n" if $verbose;
my $net = $reader->read_network($graph_file);
print "Reading in the labels\n" if $verbose;
my $harmonic = new Clair::Harmonic($net,$labels_file,$split_file);
print "Finding the labels using the $method method\n" if $verbose;
if($method eq "relaxation"){
           print "relaxation\n";
           $harmonic->relaxation($output_file);

}elsif($method eq "montecarlo"){
           $harmonic->MonteCarlo(rounds=>$rounds, output=>$output_file);
}

print "done\n" if $verbose;

#
# Print out usage message
#
sub usage
{
        print "usage: $0 --graph file --labels file --split file --output file [--method relaxation|montecarlo] \n\n";
        print "  --graph file\n";
        print "       Name of input graph file in edgelist format\n";
        print "  --output file\n";
        print "       Name of the output file\n";
        print "  --labels file\n";
        print "       Name of the file containing a list of node labels (node label)\n";
        print "  --split file\n";
        print "       Name of the file containing a list of the fixed nodes only\n";
        print "  --method relaxation|montecarlo\n";
        print "       The method used to find the unknown labels. This can take two values, relaxation(default) and montecarlo\n";
        print "  --verbose\n";
        print "       Preserve the order of the sentences in the summary as they were in the input\n";

        print "\n\n";

        exit;
}

