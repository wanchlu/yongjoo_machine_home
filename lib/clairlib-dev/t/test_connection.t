# script: test_connection.t
# functionality: As part of Bio, test many basic functions of Connection,
# functionality: such as abstract retrieval, citation network analysis, etc.

use strict;
use warnings;
use Test::More tests => 11;
use FindBin;

use Clair::Bio::Connection;
use Clair::Network::Centrality::PageRank;

my $c = Clair::Bio::Connection->new();

my @ids = $c->get_ids();
ok( $#ids > 100, "Can get at least 100 ids (returned $#ids)" );

my @sents = $c->get_sentences("29019");
ok (@sents == 70, "Can get sentences");

my $title = $c->get_title("29100");
my $actual_title = "Delta-opioid receptor endocytosis in spinal cord after dermenkephalin activation";
ok ($title eq $actual_title, "Can get title");

@sents = $c->get_citing_sentences("1242180", "64497");
ok (@sents == 1, "Citation size");
my $sent = $sents[0];
ok ($sent->{parno} eq "30" && $sent->{rsnt} eq "7" && $sent->{sno} eq "168",
    "Citation sentence");

my @asents = $c->get_abstract_sentences("64497");
ok (@asents == 8, "Abstract sentences");

my $in = $c->get_degree_in("64497");
ok ($in == 1, "In degree");
my $out = $c->get_degree_out("64497");
ok ($out == 0, "Out degree");

# Test citation networks
my $hashref = {
    1242180 => { 64497 => 1, 126263 => 1 },
    545969 => { 126263 => 1, 400652 => 1 },
    400652 => { 400653 => 1 },
    400663 => { 400652 => 1 , 400653 => 1},
    400653 => { 400652 => 1 },
    524696 => { 400653 => 1 }
};
my $expected = new Clair::Network();
foreach my $from (keys %$hashref) {
    $expected->add_node($from) unless $expected->has_node($from);
    foreach my $to (keys %{ $hashref->{$from} }) {
        $expected->add_node($to) unless $expected->has_node($to);
        $expected->add_edge($from, $to);
        $expected->set_edge_attribute($from, $to, 'pagerank_transition', 1);
    }
}

my $n1 = $c->get_citation_network(1242180);

# Part of the same network, should be the same
my $n2 = $c->get_citation_network(64497, 524696);

is_deeply($n1, $expected, "citation network 1");
is_deeply($n2, $expected, "citation network 2");

# Test pagerank. 400653 should be highest ranked
my %scores = ();

my $cent = Clair::Network::Centrality::PageRank->new($n1);
$cent->centrality();

foreach my $id (keys %$hashref) {
    $scores{$id} = $n1->get_vertex_attribute($id, 'pagerank_value');
}

my $ok = 1;
my $score = $scores{400653};
foreach my $id (keys %scores) {
    if ($scores{$id} > $score) {
        $ok = 0;
        last;
    }
}
ok($ok, "Pagerank");
