#!/usr/bin/perl
# script: cos_to_histograms.pl
# functionality: Generates degree distribution histograms from
# functionality: degree distribution data

use strict;
use warnings;

use File::Spec;
use Getopt::Long;
use Clair::Network;

sub usage;

my $graph_file = "";
my $output_file = "";
my $start = 0.0;
my $end = 1.0;
my $inc = 0.01;
my $hists = 1;
my $verbose = 0;
#my $matlab_script = "/data0/projects/lr/plots/distplots.m";

my $res = GetOptions("input=s" => \$graph_file, "output=s" => \$output_file,
                     "start=f" => \$start, "end=f" => \$end,
                     "step=f" => \$inc,
                     "hists!" => \$hists, "verbose" => \$verbose);

if (!$res or ($graph_file eq "")) {
  usage();
  exit;
}

unless (-d "plots") {
  mkdir "plots" or die "Couldn't create plots directory: $!";
}

my ($vol, $dir, $hist_prefix) = File::Spec->splitpath($graph_file);
$hist_prefix =~ s/\.cos//;

if ($verbose) { print STDERR "Loading $graph_file\n"; }
my @edges = load_cos($graph_file);

my $max_degree = 0;

if ($hists) {
  for (my $i = $start; $i <= $end; $i += $inc) {
    # below is because of some strange rounding bug on the linux machines
    $i = sprintf("%.4f", $i);
    my $cutoff = sprintf("%.2f", $i);
    my @filtered = filter_cosine(\@edges, $cutoff);
    my @hist = link_degree(\@filtered);
    if (scalar(@hist) > $max_degree) {
      $max_degree = scalar(@hist);
    }
    write_hist("hists", $hist_prefix . "." . $cutoff . ".hist", \@hist);
  }
} else {
  if ($verbose) { print STDERR "Skipping writing histogram files\n"; }
}

write_plot("hists", $hist_prefix, $start, $end, $inc, $max_degree);


#
# Write the matlab plot for the cutoff files
#
sub write_plot {
  my $dir = shift;
  my $file = shift;
  my $start = shift;
  my $end = shift;
  my $inc = shift;
  my $max_degree = shift;

  my @hists = ();
  my @cutoffs = ();
  for (my $i = $end; $i > $start; $i -= $inc) {
    # below is because of some strange rounding bug on the linux machines
    $i = sprintf("%.4f", $i);
    my $cutoff = sprintf("%.2f", $i);
    push (@hists, $dir . "/" . $file . "." . $cutoff . ".hist");
    push (@cutoffs, $cutoff);
  }

  open(MYOUTFILE, ">$file-distplots.m");
  my $file_count = 0;
  my $color_index = 5;
  my $x = "";
  my $y = "";
  my $c = "";

  foreach my $hist (@hists) {
    chomp($hist);

    my $max_degree = 100;
    print MYOUTFILE "y$file_count = load('$hist'); \n";

    print MYOUTFILE "y$file_count = load('$hist'); \n";

    print MYOUTFILE "if length(y$file_count) < $max_degree \n";
    print MYOUTFILE "  y$file_count = [y$file_count zeros(1, $max_degree - size(y$file_count, 2))];\n";
    print MYOUTFILE "elseif length(y$file_count) > $max_degree\n";
    print MYOUTFILE "  y$file_count = y$file_count(1:$max_degree); \n";
    print MYOUTFILE "end \n";
    print MYOUTFILE "\n";

    $y = $y."y".$file_count."; ";
    $x = $x."1:1:length(y0); ";
    $c = $c."temp*$color_index;";
    $file_count++;
    $color_index = $color_index + 5;
  }
  print MYOUTFILE "Y = [ $y ]; \n";
  print MYOUTFILE "X = [ $x ]; \n";
  #hard coded to y0
  print MYOUTFILE "temp = ones(1,length(y0) ); \n";

  my $z = "";
  foreach $c (@cutoffs) {
    chomp($c);
    $z = $z."temp*".$c."; ";
  }

  print MYOUTFILE "C = [ $c ]; \n";
  print MYOUTFILE "Z = [ $z ]; \n \n"; # print MYOUTFILE "surf(Z,X,Y); \n";
  print MYOUTFILE "surf(Z,X,Y,C); \n"; # print MYOUTFILE "colormap hsv; \n";

  print MYOUTFILE "xlabel('Cosine similarity threshold');\n";
  print MYOUTFILE "ylabel('Vertex degree');\n";
  print MYOUTFILE "zlabel('Number of nodes');\n";

  print MYOUTFILE "view(-120,37.5); \n";

  my $save = $file . "_" . $start . "_" . $inc . "_" . $end;

  print MYOUTFILE "saveas(gcf,'plots/".$save.".jpg','jpg'); \n";
  print MYOUTFILE "saveas(gcf,'plots/".$save.".eps','eps'); \n";

  close(MYOUTFILE);
}

#
# Write histogram to file
#
sub write_hist {
  my $dir = shift;
  my $fn = shift;
  my $h = shift;
  my @hist = @{$h};

  unless (-d $dir) {
    mkdir $dir or die "Couldn't create $dir: $!";
  }

  open(OUTFILE, ">", $dir . "/" . $fn) or die "Couldn't open " . $dir . "/" .
    $fn, "\n";

  foreach my $deg (@hist) {
    print OUTFILE "$deg ";
  }
  print OUTFILE "\n";

  close OUTFILE;
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


sub link_degree {
  my $vert = shift;
  my @edges = @{$vert};

  my $pagecount = 0;
  my %ct = ();
  my %links = ();
  my %pageswith = ();

  my @hist = ();

  foreach my $e (@edges) {
    my ($from, $to) = @{$e};
    $ct{$from} = 1;
    $ct{$to} = 1;

    if (not exists $links{$to}) {
      $links{$to} = 0;
      $pagecount++;
    }

    if (not exists $links{$from}) {
      $links{$from} = 0;
      $pagecount++;
    }

    $links{$from}++;
  }

  my $total = scalar(keys %ct);

  foreach my $i2 (0..$total-1) {
    $pageswith{$i2} = 0;
  }

  foreach my $node (keys %links) {
    $pageswith{$links{$node}}++;
  }

  foreach my $linkcount (sort {$a <=> $b} keys %pageswith) {
    $hist[$linkcount] = $pageswith{$linkcount};
  }

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
