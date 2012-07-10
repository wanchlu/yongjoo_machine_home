# script: test_lexrank4.t
# functionality: Based on an interactive script, this test builds a sentence-
# functionality: based cluster, then a network, computes lexrank, and then
# functionality: runs MMR on it 

use strict;
use warnings;
use Test::More;
use Clair::Config;
use FindBin;
use Data::Dumper;

if (not defined $PRMAIN or not -e $PRMAIN) {
    plan( skip_all => "PRMAIN not defined in Clair::Config or doesn't exist" );
} else {
    plan( tests => 15 );
}

use_ok("Clair::Cluster");
use_ok("Clair::Document");
use_ok("Clair::Network");
use_ok("Clair::NetworkWrapper");
use_ok("Clair::Network::Centrality::LexRank");
use_ok("Clair::Network::Centrality::CPPLexRank");

my $docs_dir = "$FindBin::Bin/input/lexrank4";
my $file1 = "$docs_dir/file1.txt";
my $file2 = "$docs_dir/file2.txt";
my $bias = "$docs_dir/bias.txt";

# No similarity, no bias
my @results1 = run( files => [$file1, $file2] );
is(@results1, 7, "Uniform rank length");

my $ok = 1;
for (@results1) {
    my ($meta, $text, $score) = @$_;
    unless (within_delta($score, 1/7, 0.01)) {
        $ok = 0;
        last;
    }
}
ok($ok, "Uniform rank scores");

# Change the length
my @results2 = run( files => [$file1, $file2], s => 3 );
is(@results2, 3, "Changed length");

# Query-based
my @results3 = run( files => [$file1, $file2], q => $bias );
is(@results3, 7);
my @top_result = @{ shift @results3 };


is( $top_result[1], "mouse", "Favor the mouse");
cmp_ok( abs($top_result[2] - 0.52), "<", 0.01, "Mouse within delta");
$ok = 1;
for (@results3) {
    my ($meta, $text, $score) = @$_;
    unless(within_delta($score, 0.08, 0.01)) {
        $ok = 0;
        last;
    }
}
ok($ok, "Non-mice within delta");

# Order-based
my @results4 = run( files => [$file1, $file2], b => 1 );
is(@results4, 7);
my @expected4 = ( ["dog", 0.28],
                  ["monkey", 0.28],
                  ["hippo", 0.18],
                  ["mouse", 0.14],
                  ["whale", 0.10],
                  ["cat", 0.01],
                  ["spider", 0.01] );
$ok = 1;
foreach my $i (0 .. $#results4) {
    my ($meta, $text, $score) = @{ $results4[$i] };
    my ($text_e, $score_e) = @{ $expected4[$i] };
    unless ( $text eq $text_e && within_delta($score, $score_e, 0.01) ) {
        $ok = 0;
        last;
    }
}
ok($ok, "Order-based");

sub run {

    my %params = @_;
    my @files = @{ $params{files} };
    my $rbias = $params{b};
    my $qbias = $params{q};
    my $mmr = $params{m};
    my $size = $params{s};

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

    my %matrix = $sent_cluster->compute_cosine_matrix();
    my $network = $sent_cluster->create_network(
        cosine_matrix => \%matrix,
        include_zeros => 1
    );

    my $bet;

    # Run lexrank
    # TODO: in Clair::NetworkWrapper, allow for node-based biasing
    # TODO: in Clair::Network, fix compute_lexrank_from_bias_sents()

    if ($rbias) {
        $bet = Clair::Network::Centrality::LexRank->new($network);
        # Set the order bias
        set_order_bias($bet, @files);
    
        $bet->centrality();
    
    } elsif ($qbias) {

        # Wrap the network to use the CPP implementation of lexrank 
        $network = Clair::NetworkWrapper->new( 
            network => $network,
            prmain => $PRMAIN,
            clean => 1
        );

        # Read the bias files
        my @bias_sents = ();
        open BIAS, "< $qbias" or die "Couldn't read $qbias: $!";
        while (<BIAS>) {
            chomp;
            push @bias_sents, $_;
        }
        close BIAS;

        # Run query-based lexrank
        $bet = Clair::Network::Centrality::CPPLexRank->new($network);
        $bet->compute_lexrank_from_bias_sents(bias_sents => \@bias_sents);

    } else {

        # Wrap the network to use the CPP implementation of lexrank 
        $network = Clair::NetworkWrapper->new( 
            network => $network,
            prmain => $PRMAIN,
            clean => 1
        );

        # Run unbiased lexrank
        $bet = Clair::Network::Centrality::CPPLexRank->new($network);
        $bet->centrality();
    }


    # Run the MMR reranker if necessary

    if (defined $mmr) {
        $network->mmr_rerank_lexrank($mmr);
    }



    # Get the results and print them out

    my @results;
    my %scores = %{ get_scores($network) };
    my $counter = 0;
    foreach my $meta (sort { $scores{$b} cmp $scores{$a} } keys %scores) {
        my $text = $sent_cluster->get($meta)->get_text();
        push @results, [ $meta, $text, $scores{$meta} ];
        $counter++;
        if (defined $size and $counter >= $size) {
            last;
        }
    }

    return @results;

}

##################
# Some subroutines
##################

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

    my $centrality = shift;
    my @files = @_;

    # Print the bias file
    open TEMP, "> bias.temp" or die "Couldn't open temp file bias.temp: $!";
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

    $centrality->read_lexrank_bias("bias.temp");
    unlink("bias.temp") or warn "Couldn't remove bias.temp: $!";

}

sub within_delta {
    my $number1 = shift;
    my $number2 = shift;
    my $delta = shift;
    return abs($number1 - $number2) < $delta;
}
