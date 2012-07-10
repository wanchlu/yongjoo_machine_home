#!/usr/bin/perl
# script: cos_to_stats.pl
# functionality: Generates a table of network statistics for networks by
# functionality: incrementing through cosine cutoffs
#

use strict;
use warnings;
use Getopt::Long;
use File::Spec;
use Clair::Network qw($verbose);
use Clair::Network::Sample::ForestFire;
use Clair::Network::Sample::RandomEdge;
use Clair::Network::Sample::RandomNode;
use Clair::Network::Reader::Edgelist;
use Clair::Network::Writer::Edgelist;
use Clair::Network::Writer::GraphML;
use Math::BigFloat lib => 'GMP';
use Math::BigInt lib => 'GMP';

sub usage;

my $delim = "[ \t]+";
my $output_delim = " ";
my $cos_file = "";
my $graphml = 0;
my $threshold;
my $start = 0.0;
my $end = 1.0;
my $inc = 0.01;
my $sample_size = 0;
my $sample_type = "randomnode";
my $out_file = "";
my $graphs = 0;
my $all = 0;
my $stats = 1;
my $single = 0;
my $verbose = 0;
my $summary  = 0;
my $reverse = 0;
my @props = ();

my $res = GetOptions("input=s" => \$cos_file, "output=s" => \$out_file,
                     "delimout=s" => \$output_delim,
                     "graphml" => \$graphml,
                     "threshold=f" => \$threshold, "delim=s" => \$delim,
                     "start=f" => \$start, "end=f" => \$end,
                     "step=f" => \$inc, "graphs:s" => \$graphs,
                     "sample=i" => \$sample_size, "single" => \$single,
                     "sampletype=s" => \$sample_type,
                     "all" => \$all, "stats!" => \$stats,
                     "summary" => \$summary, "properties:s" => \@props,
                     "reverse" => \$reverse, "verbose" => \$verbose);

$Clair::Network::verbose = $verbose;

if ($graphs eq "") {
  # Use default directory graphs if graphs enabled
  $graphs = "graphs";
}

if ($graphs) {
  unless (-d $graphs) {
    mkdir $graphs or die "Couldn't create $graphs: $!";
  }
}

if (!$res or ($cos_file eq "")) {
  usage();
  exit;
}

my $dir;
my $vol;
my $prefix;
my $file;

($vol, $dir, $prefix) = File::Spec->splitpath($cos_file);
$prefix =~ s/\.cos//;
if ($out_file ne "") {
  ($vol, $dir, $file) = File::Spec->splitpath($out_file);
  if ($dir ne "") {
    unless (-d $dir) {
      mkdir $dir or die "Couldn't create $dir: $!";
    }
  }

  open(OUTFILE, "> $out_file");
  *STDOUT = *OUTFILE;
  select OUTFILE; $| = 1;
}

# make unbuffered
select STDOUT; $| = 1;
select STDERR; $| = 1;
select STDOUT;


# Print only summary statistics if enabled
if ($summary) {
  open(FIN, $cos_file) or die "Couldn't open $cos_file: $!\n";
  my %seen = ();
  my $n = Math::BigInt->new(0);
  my $mean = Math::BigFloat->new(0);
  my $sum = Math::BigFloat->new(0);
  my $sum_sqr = Math::BigFloat->new(0);
  my $var = Math::BigFloat->new(0);
  my $s = 0;
  my $delta;


  my %mat = ();
  while (<FIN>) {
    chomp;
    my @edge = split(/$delim/);
    my ($u, $v, $w) = @edge;

    if ((!exists $mat{$u}{$v}) and (!exists $mat{$v}{$u})) {
      $mat{$u}{$v} = 1;
      $mat{$v}{$u} = 1;
      $sum += Math::BigFloat->new($w);
      $sum_sqr +=  $w * $w;
      $n++;
    }
  }
  close FIN;

  $mean = $sum / $n;
  $var = ($sum_sqr - $sum * $mean)/($n - 1);
  print "Sample Mean:     " . $mean->ffround(-4) . "\n";
  print "Sample Variance: " . $var->ffround(-4) . "\n";
  print "Sample Std. Dev: " . Math::BigFloat->new(sqrt($var))->ffround(-4) .
    "\n";
  exit;
}


my $net;
# Sample network if requested
if ($sample_size > 0) {
  if ($verbose) { print STDERR "Reading in $cos_file\n"; }
  my $reader = new Clair::Network::Reader::Edgelist;
  $net = $reader->read_network($cos_file, undirected => 1, delim => $delim);

  if ($sample_type eq "randomedge") {
    if ($verbose) {
      print STDERR "Sampling $sample_size edges from network using random edge algorithm\n"; }
    my $sample = Clair::Network::Sample::RandomEdge->new($net);
    $net = $sample->sample($sample_size);
  } elsif ($sample_type eq "forestfire") {
    if ($verbose) {
      print STDERR "Sampling $sample_size nodes from network using Forest Fire algorithm\n"; }
    my $sample = Clair::Network::Sample::ForestFire->new($net);
    $net = $sample->sample($sample_size, 0.7);
  } elsif ($sample_type eq "randomnode") {
    if ($verbose) {
      print STDERR "Sampling $sample_size nodes from network using Random Node algorithm\n";
    }
    my $sample = Clair::Network::Sample::RandomNode->new($net);
    $sample->number_of_nodes($sample_size);
    $net = $sample->sample();
  }
} else {
  if ($graphs) {
    # no sampling, just write the graph files
    for (my $i = $start; $i <= $end; $i += $inc) {
      # below is because of some strange rounding bug on the linux machines
      $i = sprintf("%.4f", $i);
      my $cutoff = sprintf("%.2f", $i);
      if ($verbose) {
        print STDERR "Writing graph file for cutoff $cutoff\n";
      };
      open FOUT, ">$graphs/$prefix-$cutoff.graph";

      open(FIN, $cos_file) or die "Couldn't open $cos_file: $!\n";
      while (<FIN>) {
        chomp;
        my @edge = split(/$delim/);

        my ($u, $v, $w) = @edge;
        if (($reverse and ($w <= $cutoff)) or
            (not $reverse and ($w >= $cutoff))) {
          print FOUT "$u$output_delim$v$output_delim$w\n";
        }
      }
      close FIN;
      close FOUT;
    }
  }
}

if ($stats) {
  if ($verbose) { print STDERR "Reading in $cos_file\n"; }
  my $reader = new Clair::Network::Reader::Edgelist;
  $net = $reader->read_network($cos_file, undirected => 1,
                               unionfind => 1, delim => $delim);
  if (scalar(@props) == 0) {
    if ($net->{directed}) {
      @props = ("threshold","nodes","edges","diameter","lcc","strongly_connected_components","avg_short_path",
                "ferrer_avg_short_path","watts_strogatz_cc","hmgd", "full_avsp",
                "in_link_power","in_link_power_rsquared","in_link_pscore",
                "in_link_power_newman","in_link_power_newman_error",
                "out_link_power","out_link_power_rsquared","out_link_pscore",
                "out_link_power_newman","out_link_power_newman_error",
                "total_link_power","total_link_power_rsquared",
                "total_link_pscore","total_link_power_newman",
                "total_link_power_newman_error","avg_degree");
    } else {
      @props = ("threshold","nodes","edges","diameter","lcc","strongly_connected_components","avg_short_path",
                "ferrer_avg_short_path","watts_strogatz_cc","hmgd","full_avsp",
                "total_link_power","total_link_power_rsquared",
                "total_link_pscore","total_link_power_newman",
                "total_link_power_newman_error","avg_degree");
    }
  } else {
    @props = split(/,/,join(',', @props));
  }
  if ($single and $threshold) {
    # Run for already generated graph
    print_network($net, $threshold, \@props);
  } elsif ($threshold) {
    # Run for just a single cutoff
    run_cutoff($net, $threshold, \@props);
  } else {
    # Run for all cutoffs
    my $header = join(" ", @props);
    print "$header\n";
    for (my $i = $start; $i <= $end; $i += $inc) {
      # below is because of some strange rounding bug on the linux machines
      $i = sprintf("%.4f", $i);
      my $cutoff = sprintf("%.2f", $i);

      run_cutoff($net, $cutoff, \@props);
    }
  }
}

sub array_to_graphml {
  my $fn = shift;
  my $ed = shift;
  my @edges = @{$ed};

  open(GRAPH, "> $fn") or die "Couldn't open file: $fn\n";

  print GRAPH <<EOH
<?xml version="1.0" encoding="UTF-8"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns
                      http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
EOH
;

  print GRAPH "<key id=\"d1\" for=\"edge\" attr.name=\"weight\" attr.type=\"double\"/>\n";
  print GRAPH "  <graph id=\"graph\" edgedefault=\"undirected\">\n";

  my %nodes = ();
  foreach my $e (@edges) {
    my ($u, $v, $w) = @{$e};
    $nodes{$u} = 1;
    $nodes{$v} = 1;
  }

  foreach my $v (keys %nodes) {
    print GRAPH "    <node id=\"" . $v . "\"/>\n";
  }

  foreach my $e (@edges) {
    my ($u, $v, $w) = @{$e};
    print GRAPH "    <edge source=\"" . $u . "\" target=\"" . $v . "\">\n";
    print GRAPH "      <data key=\"d1\">" . $w . "</data>\n";
    print GRAPH "    </edge>\n";
  }

  print GRAPH "  </graph>\n";
  print GRAPH "</graphml>\n";

  close(GRAPH);
}



sub run_cutoff {
  my $net = shift;
  my $cutoff = shift;
  my $p = shift;

  if ($verbose) { print STDERR "Creating network for cutoff $cutoff\n"; }
  my $cos_net = $net->create_network_from_cosines($cutoff,
                                                  reverse => $reverse);

  print_network($cos_net, $cutoff, $p);
  if ($all) {
    # Dump out additional data
    # triangles
    open(FOUT, ">$dir/$prefix-$cutoff.triangles") or die "Couldn't open $dir/$prefix.triangles: $!\n";
    my ($triangles, $triangle_cnt, $triple_cnt) = $net->get_triangles();
    foreach my $triangle (@{$triangles}) {
      print FOUT $triangle, "\n";
    }
    close FOUT;
    # average shortest path matrix
    open(FOUT, ">$dir/$prefix-$cutoff.asp") or die "Couldn't open $dir/$prefix.asp: $!\n";
    # save stdout and redirect it to the file
    *SAVED = *STDOUT;
    *STDOUT = *FOUT;
    $cos_net->print_asp_matrix();
    # restore stdout
    *STDOUT = *SAVED;
    close FOUT;
  }

#  print "total_size out: ", total_size($cos_net), "\n";

  if ($graphs) {
    write_network($cos_net, $cutoff);
  }
}

sub print_network {
  my $net = shift;
  my $cutoff = shift;
  my $p = shift;
  my @props = @{$p};

  my @zeros = map { 0 } @props;
  if ($net->num_nodes > 0) {
    if ($verbose) { print STDERR "Getting network info for cutoff $cutoff\n"; }
    my $str = $net->get_network_info_as_string($p, reverse => $reverse);
    print "$cutoff " . $str . "\n";
  } else {
    print "$cutoff ";
    print join(" ", @zeros[0 .. $#zeros-1]) . "\n";
  }
}

sub write_network {
  my $cos_net = shift;
  my $cutoff = shift;

  my $export = Clair::Network::Writer::Edgelist->new();
  $export->write_network($cos_net,
                         "$graphs/$prefix-$cutoff.graph", weights => 1);

  if ($graphml) {
    my $ge = Clair::Network::Writer::GraphML->new();
    $ge->write_network($cos_net,
                       "$graphs/$prefix-$cutoff.graphml", weights => 1);
  }

  if ($all) {
    # Dump out additional data
    # triangles
    open(FOUT, ">$dir/$prefix-$cutoff.triangles") or die "Couldn't open $dir/$prefix.triangles: $!\n";
    my ($triangles, $triangle_cnt, $triple_cnt) = $net->get_triangles();
    foreach my $triangle (@{$triangles}) {
      print FOUT $triangle, "\n";
    }
    close FOUT;
    # average shortest path matrix
    open(FOUT, ">$dir/$prefix-$cutoff.asp") or die "Couldn't open $dir/$prefix.asp: $!\n";
    # save stdout and redirect it to the file
    *SAVED = *STDOUT;
    *STDOUT = *FOUT;
    $cos_net->print_asp_matrix();
    # restore stdout
    *STDOUT = *SAVED;
    close FOUT;
  }
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
  print "       Name of output file.  Dumps the stats to this file\n";
  print "  --start start\n";
  print "       Cutoff value to start at\n";
  print "  --end end\n";
  print "       Cutoff value to end at\n";
  print "  --step step\n";
  print "       Size of step between cutoff points\n";
  print "  --sample sample_size\n";
  print "       Sample from the network\n";
  print "  --sampletype sample_algorithm\n";
  print "       Sampling algorithm to use, can be: randomnode, randomedge, forestfire\n";
  print "  --graphs [directory]\n";
  print "       If set, output a graph file for each cutoff in the specified
directory (defaults to graphs)\n";
  print "  --single\n";
  print "       Generate line for a single threshold.  Must also specify threshold\n";
  print "  --threshold threshold\n";
  print "       Generate network for single threshold and print stats for it.\n";
  print "  --properties propertylist\n";
  print "       Specify which network properties to print.  Separate values with a comma.\n";
  print "       Example:  --properties threshold,nodes,edges,avg_short_path,cc\n";
  print "  --stats, --nostats\n";
  print "       Enable or disable printing of actual statistics\n";
  print "       For example, specify --nostats and --graphs to just output\n";
  print "       cosine graphs for later processing\n";
  print "  --reverse\n";
  print "       Compute stats for edges less than or equal threshold instead of greater than or equal to threshold\n";
  print "\n";

  print "example: $0 --input data/bulgaria.cos --output networks\n";

  exit;
}
