#!/usr/bin/perl
# script: estimate_network_parameters.pl
# functionality: Estimate network parameters using Newman method outlined in
# functionality: Random graphs with arbitrary degree sequences
#

use strict;
use warnings;

use Clair::Utils::Polynomial;
use Data::Dumper;
use File::Spec;
use Getopt::Long;

my $graph_file = "";
my $output_file = "";
my $start = 0.0;
my $end = 1.0;
my $inc = 0.01;
my $hists = 1;
my $verbose = 0;

my $res = GetOptions("input=s" => \$graph_file, "output=s" => \$output_file,
                     "start=f" => \$start, "end=f" => \$end,
                     "step=f" => \$inc,
                     "hists!" => \$hists, "verbose" => \$verbose);

if (!$res or ($graph_file eq "")) {
  usage();
  exit;
}

my ($vol, $dir, $hist_prefix) = File::Spec->splitpath($graph_file);
$hist_prefix =~ s/\.cos//;

if ($verbose) { print STDERR "Loading $graph_file\n"; }
my @edges = load_cos($graph_file);

my $max_degree = 0;

my @a = ();

if ($hists) {
  for (my $i = $start; $i <= $end; $i += $inc) {
    # below is because of some strange rounding bug on the linux machines
    $i = sprintf("%.4f", $i);
    my $cutoff = sprintf("%.2f", $i);
    my @filtered = filter_cosine(\@edges, $cutoff);
    my @hist = link_degree(\@filtered);
    my $num_nodes = 0;

    foreach my $h (@hist) {
      $num_nodes += $h;
    }

    if (scalar(@hist) > $max_degree) {
      $max_degree = scalar(@hist);
    }
#    print Dumper(@hist);
    my @rev = reverse(@hist);
    my $poly = new Clair::Utils::Polynomial(\@rev);
    my $G0 = $poly->div($num_nodes);
    my $G0deriv = $G0->deriv();
    my $G0deriv2 = $G0deriv->deriv();

    # z = average degree
    my $z = $G0deriv->eval_poly(1);
    my $z2 = $G0deriv2->eval_poly(1);
    my $G1 = $G0deriv->div($z);

#    print "poly: $poly\n";
#    print "deriv: $deriv\n";
    my $l;
    if (($z > 0) && ($z2 > 0)) {
#      print "z: $z, z2: $z2, num_nodes: $num_nodes\n";
      my $denom = log($z2 / $z);
      if ($denom > 0) {
        $l = (log($num_nodes / $z) / $denom) + 1;
      } else {
        $l = 0;
      }
    } else {
      $l = 0;
    }
    #print "$cutoff haverage shortest path estimate: $l\n";
    print "$l\n";
    #print "histogram for $cutoff\n";
    #print Dumper(@hist);
  }
} else {
  if ($verbose) { print STDERR "Skipping writing histogram files\n"; }
}


@a = (3, 0, 5, 4);

my $poly = Clair::Utils::Polynomial->new(\@a);

my $e = $poly->eval_poly(2);
my @c = $poly->deriv();

#print Dumper($e);
#print Dumper(@c);


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


=head2 link_degree

Warning, this function assumes the cosine file has entries for both
A -> B and B -> A.  For example:

A B 0.2
B A 0.2
A C 0.3
C A 0.3

In other words, for a collection of n documents, there are
n(n - 1) NOT (n(n - 1)) / 2 lines.

=cut

sub link_degree {
  my $vert = shift;
  my @edges = @{$vert};

  my %ct = ();
  my %links = ();

  my @hist = ();

  foreach my $e (@edges) {
    my ($from, $to) = @{$e};
    $ct{$from} = 1;
    $ct{$to} = 1;

    if (not exists $links{$to}) {
      $links{$to} = 0;
    }

    if (not exists $links{$from}) {
      $links{$from} = 0;
    }

    $links{$from}++;
  }

  my $total = scalar(keys %ct);

  foreach my $i2 (0..$total-1) {
    $hist[$i2] = 0;
  }

  foreach my $node (keys %links) {
    $hist[$links{$node}]++;
  }

#  foreach my $linkcount (sort {$a <=> $b} keys %pageswith) {
#    $hist[$linkcount] = $pageswith{$linkcount};
#  }

  return @hist;
}

#
# filter cosine file by cutoff
#
sub filter_cosine {
  my $cref = shift;
  my @cos = @{$cref};
  my $cutoff = shift;

  my @edges = ();

  foreach my $e (@cos) {
    my @links = @{$e};
    my ($l, $r, $c) = @links;
    if ($c >= $cutoff) {
      push @edges, \@links;
    }
  }

  return @edges;
}

#
# Print out usage message
#
sub usage
{
  print "usage: $0 --input input_file [--output output_file] [--start start] [--end end] [--step step]\n\n";
  print "  --input input_file\n";
  print "       Name of the input graph file\n";
  print "  --output output_file\n";
  print "       Name of plot output file\n";
  print "  --start start\n";
  print "       Cutoff value to start at\n";
  print "  --end end\n";
  print "       Cutoff value to end at\n";
  print "  --step step\n";
  print "       Size of step between cutoff points\n";
  print "\n";

  print "example: $0 --input data/bulgaria.cos --output data/bulgaria.m\n";

  exit;
}
