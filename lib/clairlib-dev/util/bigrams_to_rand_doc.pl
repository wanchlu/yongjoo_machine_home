#!/usr/local/bin/perl

# script: test_random_walk.pl
# functionality: Creates a network, assigns initial probabilities and tests
# functionality: taking single steps and calculating stationary distribution

use strict;
use warnings;

use Clair::Network;
use Clair::Network::Reader::Edgelist;
use Clair::RandomWalk;

use Getopt::Long;

my $input_file="";
my $size;
my $output_file = "synth";
my $delim="<s>";

my $res = GetOptions("input=s" => \$input_file,"output=s"=>\$output_file, "size=i" => \$size, "delim=s" => \$delim);

if (!$res or $input_file eq "") {
    usage();
    exit;
}

if ($size<1){
     print STDERR "Size should be > 1\n";
     exit;
}
my $reader = new Clair::Network::Reader::Edgelist();
my $n = $reader->read_network($input_file);
my $rn = new Clair::RandomWalk($n);
$rn->load_transition_probabilities_from_file($input_file);

my $sents=0;
open OUT,">$output_file" or die "Can't open file $!";
my $current_node;
while(1){
     $current_node =  $rn->walk_one_random_step();
     if($current_node ne $delim){
          print OUT "$current_node ";
     }else{
             $sents++;
             print OUT "\n";
     }
     last if($sents>=$size);
}
close OUT;

# Print usage message
sub usage
{
    print "$0\n";
    print "Generate a random document from bigrams by performing a random walk on the corresponding graph\n";
    print "\n";
    print "Usage: $0 --input file --output file --size int [--delim string] \n\n";
    print "  --input \n";
    print "      Name of the input bigrams file (word1 word2 freq.).\n";
    print "  --output \n";
    print "      Name of the output synthetic file.\n";
    print "  --size \n";
    print "      The number of sentences in the resulting synthetic document.\n";
    print "  --delim \n";
    print "      The sentence delimeter (default <s>).\n";
    print "\n";
    print "Example: $0 --input 11sent.bigrams --output 11sent.synth --size 5 --delim <S>\n";

    exit;
}
