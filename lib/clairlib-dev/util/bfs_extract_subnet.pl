#!/usr/local/bin/perl

#
# Read a network from a Clairlib Network file (in edgelist format), 
# and extract the subgraph centered around a specified node.
# The node is represented in the same form as appearing in the edgelist
# file. For example, if it is a query network, then the center node
# should be be specified as queries. 
# 
# Author: Xiaodong Shi
# Date: 11-09-2007
#


use lib "/data0/projects/clairlib-dev/lib";
use lib "/data0/projects/clairlib-dev/util";
use lib "../lib";

use strict;
use warnings;

use Clair::Network;
use Clair::Network::Reader::Edgelist;
use Getopt::Long;
use Clair::Network::Subnet;


####################################
##         Start of Script        ##
####################################


my ($input_file, $output_file, $center_node, $depth, $directed, $delim);
my ($weighted, $threshold, $sel_query_file, $out_net_format);

# get the parameters from command line
GetOptions("input=s" => \$input_file,
	   "outformat:s" => \$out_net_format, 
	   "output:s" => \$output_file, 
	   "center=s" => \$center_node, 
	   "depth=i" => \$depth, 
	   "directed:i" => \$directed, 
	   "weighted:i" => \$weighted, 
	   "delim:s" => \$delim, 
	   "threshold=f" => \$threshold, 
	   "selected:s" => \$sel_query_file);


# default output network format
unless (defined $out_net_format) {
    # clairlib edgelist network format
    $out_net_format = "clairlib";
}

# default output file path 
unless (defined $output_file) {  
    $output_file = "./nets/sub_query_network.net"; 
} 

# directed network or undirected
unless (defined $directed) {
    # default is undirected network
    $directed = 0;
}

# edge-weighted network?
unless (defined $weighted) {
    # default is weighted
    $weighted = 1;
}

# default delimiter of edge list
unless (defined $delim) {
    # default is tab
    $delim = "\t";
}

# if a pre-selected list of nodes is defined, use that list of nodes and extract
# the edges from the network to construct the subgraph
my %sel_query_hash = ();
my $presel_query = 0;
if ((defined $sel_query_file) and ($sel_query_file ne 0)) { 
    printf "\tPre-selected Query: " . $sel_query_file . "\n"; 
    $presel_query = 1;
    open SEL_QUERY, "<$sel_query_file " or die "Could not open pre-selected query input file: $!\n";
    while (<SEL_QUERY>) {
	my $line = $_;
	chomp $line;
	$sel_query_hash{$line} = 1;
    }
    close SEL_QUERY;
}


# print parameter settings
print "Parameters: \n"; 
print "\tInput Net Format : clairlib\n"; 
print "\tOutput Net Format: " . $out_net_format . "\n"; 
print "\tInput Net File:    " . $input_file . "\n"; 
print "\tCenter Node:       " . $center_node . "\n"; 
print "\tDirected:          " . $directed . "\n"; 
print "\tWeighted:          " . $weighted . "\n"; 
print "\tDelim:             " . $delim . "\n";
print "\tMax. Depth:        " . $depth . "\n"; 
print "\tThreshold:         " . $threshold . "\n";
print "\tOutput File:       " . $output_file . "\n"; 



#Load the network from the input file
print "Loading network from input file $input_file ... ";
my $reader = Clair::Network::Reader::Edgelist->new();
my $network = $reader->read_network($input_file, 
				 directed => $directed, 
				 weights => $weighted, 
				 property => "weight", 
				 edge_property => "weight", 
				 delim => $delim);
print "finished!\n";


my $extractor = Clair::Network::Subnet->new($network);
my $subnet = $extractor->BFS_extract_from($center_node, 
					  depth => $depth, 
					  directed => $directed, 
					  threshold => $threshold);


printf "Subgraph statistics: \n";
printf "\tNum. nodes: " . $subnet->num_nodes() . "\n";
printf "\tNum. edges: " . $subnet->num_links() . "\n"; 


# export the extracted subgraph to output file
printf "Export $out_net_format network to output file $output_file ... ";
my $export;
if ($out_net_format eq "pajek") {
    #Export the Pajek-format file
    $export = Clair::Network::Writer::Pajek->new(); 
    $export->set_name("sub_query_network"); 
    $export->write_network($subnet, $output_file);
}
else {
    #Export the clairlib network file
    $export = Clair::Network::Writer::Edgelist->new();
    $export->write_network($subnet, $output_file, delim => $delim, weights => $weighted);
}
printf "completed!\n";



#
# Print out usage message
#
sub usage
{
    print "usage: $0 -input file -center node -depth m [-outformat format] [-output file] ";
    print "[-directed d] [-weighted w] [-delim delimiter] [-threshold t] [-selected file]\n";
    print "or:    $0 [-f dotfile] < file\n";
    print "  --input file\n";
    print "          Input network file in edge-edge format\n";
    print "  --center node\n"; 
    print "          The center node from which BFS starts\n";
    print "  --depth m\n"; 
    print "          Maximum depth allowed for BFS to reach\n";
    print "  --delim delimiter\n";
    print "          Vertices are delimited by delimter character\n";
    print "  --outformat format\n";
    print "          The format of the network to export, either clairlib or pajek\n";
    print "  --output out_file\n";
    print "          The network file to which the extracted subgraph is exported\n";
    print "  --directed d\n";
    print "          Treat graph as an directed graph or not\n";
    print "  --weighted w\n";
    print "          Treat graph as edge-weighted graph or not\n";
    print "  --threshold t\n";
    print "          Extract only edges (and connected nodes) whose weight is above threshold\n";
    print "  --selected file\n";
    print "          The file containing predefined queries that should be included in the subgrahp\n";
    print "\n";
    print "example: $0 -input ./lex_nets/query_network.graph -outformat clairlib -center ford -directed 0 ";
    print "-weighted 1 delim '\t' -depth 2 -threshold 0.2 -output ./lex_nets/subgraph_test.graph\n";
 
    exit;
}
