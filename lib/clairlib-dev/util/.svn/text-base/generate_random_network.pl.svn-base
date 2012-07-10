#!/usr/bin/perl
# script: generate_random_network.pl
# functionality: Generates a random network

use strict;
use warnings;

use Getopt::Long;
use Clair::Network::Generator::ErdosRenyi;
use Clair::Network::Reader::Edgelist;
use Clair::Network::Writer::Edgelist;

sub usage;

my $in_file = "";
my $delim = "[ \t]+";
my $out_file = "";
my $type = "";
my $verbose = 0;
my $undirected = 0;
my $n = 0;
my $m = 0;
my $p = 0;
my $stats = 1;
my $weights = 0;
my $res = GetOptions("input=s" => \$in_file,  "delim=s" => \$delim,
                     "output=s" => \$out_file, "type=s" => \$type,
                     "verbose" => \$verbose, "undirected" => \$undirected,
                     "n=i" => \$n, "m=i" => \$m, "p=f" => \$p,
                     "weights" => \$weights, "stats!" => \$stats);

my $directed = not $undirected;

if (!$res or ($type eq "")) {
  usage();
  exit;
}

my $in_net = 0;
if ($in_file ne "") {
  my $reader = Clair::Network::Reader::Edgelist->new();
  my $in_net = $reader->read_network($in_file,
                                     delim => $delim,
                                     directed => $directed);
  $n = $in_net->num_nodes();
  $m = $in_net->num_links();
}

my $parent_type = "";
my $subtype = "";
if ($type eq "erdos-renyi-gnm") {
  $parent_type = "erdos-renyi";
  $subtype = "gnm";
  if ($m == 0) {
    print "Need m argument for number of edges\n";
    usage();
  }
} elsif ($type eq "erdos-renyi-gnp") {
  $parent_type = "erdos-renyi";
  $subtype = "gnp";
  if ($p == 0) {
    print "Need p argument for probability of edge\n";
    usage();
  }
}

my $net = 0;
if ($parent_type eq "erdos-renyi") {
  my $generator = Clair::Network::Generator::ErdosRenyi->new(directed =>
                                                             $directed);
  if ($subtype eq "gnm") {
    $net = $generator->generate($n, $m, type => $subtype,
                                weights => $weights,
                                directed => $directed);
  } else {
    $net = $generator->generate($n, $p, type => $subtype,
                                weights => $weights,
                                directed => $directed);
  }
}

if ($out_file ne "") {
  my $export = Clair::Network::Writer::Edgelist->new();
  $export->write_network($net, $out_file, weights => $weights);
}
if ($stats) {
  $net->print_network_info();
}

sub usage {
  print "Usage $0 --output output_file --type type [--verbose]\n\n";
  print "  --input input_file\n";
  print "       Name of the input graph file\n";
  print "  --delim delimiter\n";
  print "          Vertices are delimited by delimter character\n";
  print "  --undirected,  -u\n";
  print "          Treat graph as an undirected graph\n";
  print "  --output output_file\n";
  print "       Name of the output graph file\n";
  print "  --type graph_type\n";
  print "       Type of random graph to generate, can be one of:\n";
  print "            erdos-renyi-gnm: Set number of edges\n";
  print "            erdos-renyi-gnp: Random edge w/ prob p\n";
  print "  -n number_nodes\n";
  print "       Number of nodes\n";
  print "  -m number_edges\n";
  print "       Number of edges\n";
  print "  -p edge_probability\n";
  print "       Probability of edge between two nodes\n";
  print "  --verbose\n";
  print "       Increase verbosity of debugging output\n";
  print "\n";
  die;
}

