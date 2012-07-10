#!/usr/local/bin/perl
# script: list_to_lexrank.pl
# functionality: uses file containing a list of sentences and thier cosines
#  and calculates its lexrank 

use warnings;
use FindBin;
use Getopt::Long;
use Clair::Network;
use Clair::Network::Centrality::LexRank;

$listfile = "";
$cosfile = "";
$corpus = "";

my $res = GetOptions("corpus=s" => \$corpus, "list=s" => \$listfile, "cos=s" => \$cosfile);

if ( ! $listfile || ! $cosfile || ! $corpus) {
  usage();
  exit;
}

$distfile = "./$corpus.dist";

open LIST, $listfile or die "Can't open $listfile\n";

my $n = new Clair::Network();

$i = 0;
while (<LIST>) {
	chomp;
  $n->add_node($i, text => '$_');
  $i++;
}

if( ! -f $distfile ) {
  open DIST, ">$distfile" or die "Can't open distribution file $distfile: $!\n";
  
  $dist = 1/$i;

  for($j = 0, $j <= $i, $j++) {
    print DIST "$j $dist";
  }
}

my $cent = Clair::Network::Centrality::LexRank->new($n);

if( -f $cosfile ) {
  $cent->read_lexrank_probabilities_from_file("$cosfile");
}else{
  die "Can't read from cosine file $cosfile: $!\n";
}

$cent->read_lexrank_initial_distribution("$distfile");

$cent->centrality(jump => 0.5);

$cent->save("$corpus.lexrank");

sub usage {
  print "usage: $0 --corpus corpus --list list_file --cos cos_file\n\n";
  print "  --corpus corpus\n";
  print "       Name of the corpus\n";
  print "  --list list_file\n";
  print "       File with list of data, one data point per line\n";
  print "  --cos cos_file\n";
  print "       Cosine graph file\n";
  print "\n";

  die;
}

