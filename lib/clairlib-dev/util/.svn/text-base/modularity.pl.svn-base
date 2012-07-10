#!/usr/bin/perl
# script: modularity.pl
# functionality: Calculate the modularity of a partitioning a graph

use strict;
use warnings;

use Getopt::Long;
use Clair::Network::Modularity;

sub usage;

my $net_file = "";
my $partitions_file = "";

my $res = GetOptions("graph=s" => \$net_file,
                     "partitions=s" => \$partitions_file);

if (!$res or ($net_file eq "") or (not defined $partitions_file) ) {
        usage();
        exit;
}

my $mod = new Clair::Network::Modularity();
print $mod->modularity($net_file,$partitions_file),"\n";

#
# Print out usage message
#
sub usage
{
        print "usage: $0 --graph file --paritions file\n\n";
        print "  --graph file\n";
        print "       Name of the file that contains the original graph in edgelist format\n";
        print "  --partitons file\n";
        print "       Name of the file that defines the partition of each node. Each line of the file should look like 'node partition'\n";

        print "\n";

        print "example: $0 --graph karate.el --partitons karate.partionins\n";

        exit;
}

