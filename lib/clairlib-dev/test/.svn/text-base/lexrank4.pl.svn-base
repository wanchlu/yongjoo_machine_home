#!/usr/local/bin/perl

# script: test_lexrank4.pl
# functionality: Based on an interactive script, this test builds a sentence-
# functionality: based cluster, then a network, computes lexrank, and then
# functionality: runs MMR on it 

use strict;
use warnings;
use FindBin;
use Clair::Config qw( $PRMAIN );
use Clair::Cluster;
use Clair::Document;
use Clair::Network;
use Clair::Network::Centrality::LexRank;
use Clair::Network::Centrality::CPPLexRank;
use Clair::NetworkWrapper;
use File::Spec;
use Getopt::Long;

# This script has been converted from an interactive example script. To
# use it interactively, uncomment the GetOptions part.

# This script is used to run various forms of lexrank with optional MMR 
# reranking.
#
# Each input file must be in the format of one unique meta-data tag and one 
# sentence per line, separated with a tab.
#
# To run an unbiased lexrank on a list of files (uses C++ lexrank):
#     ./lexrank.pl -i myid file1 file2 ... fileN
#
# To run a biased lexrank on a list of files, where each sentence is given
# a boost proportional to its distance from the top of the document (uses
# Perl lexrank):
#     ./lexrank.pl -i myid -b file1 file2 ... fileN
#
# To run a biased lexrank from a file containing query sentences, one per line
# (uses C++ lexrank):
#     ./lexrank.pl -i myid -q bias.txt file1 file2 ... fileN
#
# To use MMR reranking:
#     ./lexrank.pl -i myid -m 0.75
#
# To use generation probabilities instead of cosine similarity:
#     ./lexrank.pl -g
#
# Author: Tony Fader (afader@umich.edu)


# Get command line arguments

my (@files, $id, $rbias, $qbias, $mmr, $size, $clean, $genprob);

my $input_dir = "$FindBin::Bin/input/lexrank4";
opendir INPUT, $input_dir or die "Couldn't open $input_dir: $!";
@files = ("$input_dir/combine1.txt");
closedir INPUT;

$id = "test";
$qbias = "$input_dir/bias.10.1.txt";
$mmr = 0.75;
$genprob = 1;
$clean = 0;

#GetOptions(
#    "i=s" => \$id,
#    "q=s" => \$qbias,
#    "b"   => \$rbias,
#    "g"   => \$genprob,
#    "m=f" => \$mmr,
#    "s=i" => \$size,
#    "c"   => \$clean
#);
# @files = @ARGV;

#if (@files <= 0 || !defined $id) {
#    print_usage();
#    exit(1);
#} elsif ($rbias && $qbias) {
#    print "Both -b and -q specified\n";
#    exit(1);
#}



# Make a temporary directory to work in to prevent collisions between multiple
# runs
my $out_dir = "$FindBin::Bin/produced/lexrank4/$id";
if (!-e $out_dir) {
    mkdir($out_dir, 0755) or die "Couldn't create directory $id: $!";
    chdir($out_dir) or die "Couldn't chdir to $id: $!";
} elsif (-d $out_dir) {
    chdir($out_dir) or die "Couldn't chdir to $id: $!";
} else {
    die "Unable to create or use directory $id";
}



# Create a sentence cluster from the file list

my @lines = combine_lines(@files);
my $sent_cluster = Clair::Cluster->new();
for (@lines) {
    my @tokens = split /\t/;
    die "Malformed line: $_" unless @tokens == 2;
    my ($meta, $text) = @tokens;
    my $doc = Clair::Document->new(
        string => $text,
        type => "text",
        id => $meta
    );
    $doc->stem();
    $sent_cluster->insert($meta, $doc);
}



# Create a network from the sentence cluster

my $network;

if ($genprob) {
    my %matrix = $sent_cluster->compute_genprob_matrix();
    $network = $sent_cluster->create_genprob_network(
        genprob_matrix => \%matrix,
        include_zeros => 1
    );
} else {
    my %matrix = $sent_cluster->compute_cosine_matrix();
    $network = $sent_cluster->create_network(
        cosine_matrix => \%matrix,
        include_zeros => 1
    );
}




# Run lexrank
my $cent;
if ($rbias) {
  $cent = Clair::Network::Centrality::LexRank->new($network);

    # Set the order bias
    set_order_bias($network, @files);

    $cent->centrality();

} elsif ($qbias) {

    # Wrap the network to use the CPP implementation of lexrank 
    $network = Clair::NetworkWrapper->new( 
        network => $network,
        prmain => $PRMAIN,
        clean => 1
    );

    # Read the bias files
    my @bias_sents = ();
    open BIAS, $qbias or die "Couldn't read $qbias: $!";
    while (<BIAS>) {
        chomp;
        push @bias_sents, $_;
    }
    close BIAS;

    # Run query-based lexrank
    $cent = Clair::Network::Centrality::CPPLexRank->new($network);
    $cent->compute_lexrank_from_bias_sents(bias_sents => \@bias_sents);
} else {

    # Wrap the network to use the CPP implementation of lexrank 
    $network = Clair::NetworkWrapper->new( 
        network => $network,
        prmain => $PRMAIN,
        clean => 1
    );

    # Run unbiased lexrank
    $cent = Clair::Network::Centrality::CPPLexRank->new($network);
    $cent->centrality();
}


# Run the MMR reranker if necessary

if (defined $mmr) {
    $network->mmr_rerank_lexrank($mmr);
}



# Get the results and print them out

my %scores = %{ get_scores($network) };
my $counter = 0;
foreach my $meta (sort { $scores{$b} cmp $scores{$a} } keys %scores) {
    my $text = $sent_cluster->get($meta)->get_text();
    print "$meta\t$text\t$scores{$meta}\n";
    $counter++;
    if (defined $size and $counter >= $size) {
        last;
    }
}



# Done

exit(0);


##################
# Some subroutines
##################

sub print_usage {
    print "usage: $0 -i id [options] file1 [file2 ... ]\n" .
          "Options: \n" .
          "  -m value, parameter in [0,1]\n" .
          "  -s size\n" .
          "  -q bias_file,  query-based biased lexrank\n" .
          "  -b, rank-based biased lexrank\n" .
          "  -c, cleanup directory when done\n" .
          "Only one of -q and -b may be specified.\n";
}

sub combine_lines {
    my @files = @_;
    my @lines = ();
    foreach my $file (@files) {
        open FILE, "< $file" or die "Couldn't open $file: $!";
        while(<FILE>) {
            chomp;
            push @lines, $_;
        }
        close FILE;
    }
    return @lines;
}

sub get_scores {
    my $network = shift;
    my $graph = $network->{graph};
    my @verts = $graph->vertices();
    my %scores = ();
    foreach my $vert (@verts) {
        $scores{$vert} = $graph->get_vertex_attribute($vert, "lexrank_value");
    }
    return \%scores;
}

# Given a list of files each containing a list of sents, makes a bias file 
# where each sentence is weighted according to its relative position in the
# file. 
sub set_order_bias {

    my $network = shift;
    my @files = @_;

    # Print the bias file
    open TEMP, "> $out_dir/bias.temp" or die "Couldn't open temp file bias.temp: $!";
    foreach my $file (@files) {
        my @metas;
        open FILE, "< $file" or die "Couldn't open $file for read: $!";
        while (<FILE>) {
            my ($meta, $text) = split /\t/, $_;
            push @metas, $meta;
        }
        close FILE;

        my $denom = $#metas;
        if ($denom < 0) {
            warn "No sentences in $file";
            next;
        } elsif ($denom == 0) {
            print TEMP "$metas[0] 1\n";
        } else {
            foreach my $i (0 .. $denom) {
                my $weight = ($denom - $i) / $denom;
                print TEMP "$metas[$i] $weight\n";
            }
        }

    }
    close TEMP;

    $network->read_lexrank_bias("$out_dir/bias.temp");
    if ($clean) {
        unlink("bias.temp") or warn "Couldn't remove bias.temp: $!";
    }

}
