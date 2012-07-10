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
use Clair::Network::Reader::GraphML;
use Clair::Network::Spectral;
use Clair::Network::GirvanNewman;
use Clair::Network::KernighanLin;

sub usage;

my $fname = "";
my $delim = "[ \t]+";
my $format = "edgelist";
my $method = "fiedler";
my $N = 2;
my $verbose = 0;
my $help=0;

my $res = GetOptions("graph=s" => \$fname,
                     "delim=s" => \$delim,
                     "format=s" => \$format,
                     "method=s" => \$method,
                     "N=i" => \$N,
                     "help!" => \$help,
                     "verbose!" => \$verbose
                     );

$Clair::Network::verbose = $verbose;

if (!$res or $help or ($fname eq "") or $N<2) {
  usage();
}

my $vol;
my $dir;
my $prefix;
($vol, $dir, $prefix) = File::Spec->splitpath($fname);


# Read in file
my $net;
if ($format eq "edgelist") {
  if ($verbose) { print STDERR "Reading in edgelist file $fname\n\n"; }
  $prefix =~ s/\.graph//;
  my $reader = Clair::Network::Reader::Edgelist->new();

  $net = $reader->read_network($fname,
                               delim => $delim);
  if ($verbose) {
    print STDERR "Input network has " . $net->num_nodes() .
      " nodes and " . $net->get_edges() . " edges\n\n";
  }
} elsif ($format eq "gml") {
  if ($verbose) { print STDERR "Reading in GML file $fname\n\n"; }
  my $reader = Clair::Network::Reader::GML->new();

  $net = $reader->read_network($fname);
  if ($verbose) {
    print STDERR "Input network has " . $net->num_nodes() .
      " nodes and " . $net->get_edges() . " edges\n\n";
  }
} elsif ($format eq "pajek") {
  if ($verbose) { print STDERR "Reading in Pajek file $fname\n\n"; }
  my $reader = Clair::Network::Reader::Pajek->new();

  $net = $reader->read_network($fname);
  if ($verbose) {
    print STDERR "Input network has " . $net->num_nodes() .
      " nodes and " . $net->get_edges() . " edges\n\n";
  }
} elsif ($format eq "graphml") {
  if ($verbose) { print STDERR "Reading in GraphML file $fname\n\n"; }
  my $reader = Clair::Network::Reader::GraphML->new();
  $net = $reader->read_network($fname);
  if ($verbose) {
    print STDERR "Input network has " . $net->num_nodes() .
      " nodes and " . $net->get_edges() . " edges\n\n";
  }
}else{
  print STDERR "Unsupported input format $format\n\n";
  exit;
}

if($method eq "fiedler"){
           my $Spectral=new Clair::Network::Spectral($net,"gap");
           print "Splitting Value = ",$Spectral->get_splitting_value(),"\n\n" if $verbose;
           my ($a,$b)=$Spectral->get_partitions();
           my @f=@{$Spectral->get_fiedler_vector()};
           if($verbose){
                  print "Fiedler Vector: [";
                  foreach my $v (@f){
                         printf "%1.4f  ",$v;
                  }
                  print "]\n\n";
           }
           my @parta = @$a;
           my @partb = @$b;
           print "Partition 1: \n";
           foreach my $n (sort @parta){
                  print "  $n\n";
           }
           print "\n";

           print "Partition 2: \n";
           foreach my $n (sort @partb){
                    print "  $n\n";
           }
           print "\n";

}elsif($method eq "girvan-newman"){
           my $GN = new Clair::Network::GirvanNewman($net);
           my $gf = $GN->partition();
           my %graphPartition = %$gf;
           my @nodes = $net->get_vertices();
           my @partitions =();
           foreach my $i (0...$N-1){
                   $partitions[$i]=();
           }

           print "\n====The Dendrogram====\n\n" if($verbose);

           foreach my $n (@nodes){
                    my $str = $graphPartition{$n};
                    printf "%4s => %s\n",$n,$str if $verbose;
                    my @p = split(/\|/, $str);
                    push @{$partitions[$p[$N-1]]},$n;
           }
           print "\n----------------------\n\n" if($verbose);
           foreach my $p (1...$#partitions+1){
                    print "Partition $p: \n";
                    my @part = @{$partitions[$p-1]};
                    @part=sort(@part);
                    foreach my $node (@part){
                            print "\t$node\n";
                    }
           }

}elsif($method eq "krenighan-lin"){
          my $KL = new Clair::Network::KernighanLin($net);
          my $graphPartition = $KL->generatePartition();
          my @partitions =();
          foreach my $n (keys %$graphPartition){
                 push @{$partitions[$$graphPartition{$n}]}, $n;
          }
          foreach my $p (1...$#partitions+1){
                    print "Partition $p: \n";
                    my @part = @{$partitions[$p-1]};
                    @part=sort(@part);
                    foreach my $node (@part){
                            print "\t$node\n";
                    }
          }
}else{
  print STDERR "Unsupported partitioning method\n";
  exit;
}



#
# Print out usage message
#
sub usage
{
  print "\nusage: $0 --graph file [--format edgelist|gml|graphml|pajek][--delim string][--N integer][--method fiedler|krenighan-lin|girvan-newman][--verbose] \n";
  print "  --graph file\n";
  print "          Input graph file\n";
  print "  --format edgelist|gml|graphml|pajek\n";
  print "          Input file format\n";
  print "  --delim delimiter\n";
  print "          Vertices in input are delimited by delimiter character (applies to edgelist format\n";
  print "  --method fiedler|krenighan-lin|girvan-newman\n";
  print "          The algorithm used to partition the graph\n";
  print "  --N\n";
  print "          The desired number of partitions (for Girvan-Newman)\n";
  print "  --verbose\n";
  print "          Print more information and show the intermediate results\n";
  print "\n";

  exit;
}
