#!/usr/local/bin/perl
# script: cos_to_networks.pl
# functionality: Generate series of networks by incrementing through cosine cutoffs
#

use strict;
use warnings;
use Getopt::Long;
use File::Spec;
use Clair::Network qw($verbose);
use Clair::Network::Writer::Edgelist;

sub usage;

my $cos_file = "";
my $start = 0.0;
my $end = 1.0;
my $inc = 0.01;
my $graph_dir = "";

my $res = GetOptions("input=s" => \$cos_file, "output=s" => \$graph_dir,
		     "start=f" => \$start, "end=f" => \$end,
		     "step=f" => \$inc);

if ($cos_file eq "") {
  usage();
  exit;
}

my ($vol, $dir, $prefix) = File::Spec->splitpath($cos_file);
$prefix =~ s/\.cos//;
if ($graph_dir eq "") {
  $graph_dir = "graphs/$prefix";
}

unless (-d $graph_dir) {
  `mkdir -p $graph_dir`;
  unless (-d $graph_dir) { die "Couldn't make directory $graph_dir: $!\n"; }
}

my @edges = load_cos($cos_file);

my $test_net = new Clair::Network();
my $net = $test_net->create_cosine_network(\@edges);

for (my $i = $start; $i <= $end; $i += $inc) {
  # below is because of some strange rounding bug on the linux machines
  $i = sprintf("%.4f", $i);
  my $cutoff = sprintf("%.2f", $i);
  my $cos_net = $net->create_network_from_cosines($cutoff);

  my $export = Clair::Network::Writer::Edgelist->new();
  $export->write_network($cos_net,
                         $graph_dir . "/" . $prefix . "-" . $cutoff . ".net");
}

#
# Load cosine file
#
sub load_cos {
  my $file = shift;

  my @edges = ();

  open(INFILE, $file) or die "Couldn't open $file\n";

  while (<INFILE>) {
    chomp;
    my @array = split(/ /, $_);
    push @edges, \@array;
  }

  close INFILE;

  return @edges;
}

#
# Print out usage message
#
sub usage
{
  print "usage: $0 --input input_file [--output output_directory] [--start start] [--end end] [--step step]\n\n";
  print "  --input input_file\n";
  print "       Name of the input graph file\n";
  print "  --output output_directory\n";
  print "       Name of output directory.  The default is graphs/input_file_prefix\n";
  print "  --start start\n";
  print "       Cutoff value to start at\n";
  print "  --end end\n";
  print "       Cutoff value to end at\n";
  print "  --step step\n";
  print "       Size of step between cutoff points\n";
  print "\n";

  print "example: $0 --input data/bulgaria.cos --output networks\n";

  exit;
}
