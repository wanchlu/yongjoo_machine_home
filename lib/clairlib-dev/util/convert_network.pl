#!/usr/bin/perl
# Convert graph between different formats

use strict;
use warnings;

use Getopt::Long;
use File::Spec;
use Clair::Network qw($verbose);
use Clair::Network::Reader::Edgelist;
use Clair::Network::Reader::GML;
use Clair::Network::Reader::Pajek;
use Clair::Network::Writer::Edgelist;
use Clair::Network::Writer::GraphML;
use Clair::Network::Writer::Pajek;
use Clair::Network::Writer::Graclus;

sub usage;

my $fname = "";
my $delim = "[ \t]+";
my $output_delim = " ";
my $input_format = "";
my $out_file = "";
my $output_format = "";
my $undirected = 0;
my $noduplicate = 0;
my $noIsoNodes = 0;

my $res = GetOptions("input=s" => \$fname, "undirected" => \$undirected,
                     "delim=s" => \$delim,
                     "delimout=s" => \$output_delim,
                     "input-format=s" => \$input_format,
                     "output-format=s" => \$output_format,
                     "output=s" => \$out_file,
                     "verbose" => \$verbose,
		     "no-duplicated-edges" => \$noduplicate,
		     "ignore-isolated-nodes" => \$noIsoNodes

		     );

#my $directed = not $undirected;
my $directed = 1 - $undirected;
$Clair::Network::verbose = $verbose;

if (!$res or ($fname eq "") or ($input_format eq "") or
    ($out_file eq "") or ($output_format eq "")) {
  usage();
}

my $vol;
my $dir;
my $prefix;
($vol, $dir, $prefix) = File::Spec->splitpath($fname);


# Read in file
my $net;
if ($input_format eq "edgelist") {
  if ($verbose) { print STDERR "Reading in edgelist file $fname\n"; }
  $prefix =~ s/\.graph//;
  my $reader = Clair::Network::Reader::Edgelist->new();

  $net = $reader->read_network($fname,
                               delim => $delim,
                               directed => $directed);
} elsif ($input_format eq "gml") {
  if ($verbose) { print STDERR "Reading in GML file $fname\n"; }
  my $reader = Clair::Network::Reader::GML->new();

  $net = $reader->read_network($fname, directed => $directed);
  if ($verbose) {
    print STDERR "Input network has " . $net->num_nodes() .
      " nodes and " . $net->get_edges() . " edges\n";
  }
} elsif ($input_format eq "pajek") {
  if ($verbose) { print STDERR "Reading in Pajek file $fname\n"; }
  my $reader = Clair::Network::Reader::Pajek->new();

  $net = $reader->read_network($fname, directed => $directed);
  if ($verbose) {
    print STDERR "Input network has " . $net->num_nodes() .
      " nodes and " . $net->get_edges() . " edges\n";
  }
} else {
  print STDERR "Unsupported input format $input_format\n";
  exit;
}

# Write file
my $writer = 0;
if ($output_format eq "edgelist") {
  if ($verbose) { print STDERR "Writing edgelist file $out_file\n"; }
  $writer = Clair::Network::Writer::Edgelist->new();
} elsif ($output_format eq "pajek") {
  if ($verbose) { print STDERR "Writing edgelist file $out_file\n"; }
  $writer = Clair::Network::Writer::Pajek->new();
  $writer->set_name("pajek");
} elsif ($output_format eq "graphml") {
  if ($verbose) { print STDERR "Writing edgelist file $out_file\n"; }
  $writer = Clair::Network::Writer::GraphML->new();
  $writer->set_name("graphml");
} elsif ($output_format eq "graclus") {
  my $writer = Clair::Network::Writer::Graclus->new();
  $writer->set_name("graclus");
  $writer->write_network($net, $out_file);
} else {
  print STDERR "Unsupported output format $output_format\n";
  exit;
}

$writer->write_network($net, $out_file, "no_duplicate" => $noduplicate);


#
# Print out usage message
#
sub usage
{
  print "usage: $0 [-e] [-d delimiter] -i file\n";
  print "or:    $0 [-f dotfile] < file\n";
  print "  --input file\n";
  print "          Input file in edge-edge format\n";
  print "  --input-format format\n";
  print "          Input file format: edgelist, gml, pajek\n";
  print "  --delim delimiter\n";
  print "          Vertices in input are delimited by delimiter character\n";
  print "  --output out_file\n";
  print "          If the network is modified (sampled, etc.) you can optionally write it\n";
  print "          out to another file\n";
  print "  --output-format format\n";
  print "          Output file format: edgelist, gml, pajek, graclus\n";
  print "  --undirected\n";
  print "          create an undirected graph, not specify this option means create a directed graph\n";
  print "  --no-duplicated-edges\n";
  print "          create an graph with unidirection edges\n";
  print "  --ignore-isolated-nodes\n";
  print "          ignore isolated nodes\n";
  print "\n";

  exit;
}
