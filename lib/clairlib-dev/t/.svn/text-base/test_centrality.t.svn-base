#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use Test::More tests => 299;
#use Clair::GraphWrapper::Boost;

use_ok('Clair::Network::Reader::Edgelist');
use_ok('Clair::Network::Centrality::Betweenness');
use_ok('Clair::Network::Centrality::Closeness');
use_ok('Clair::Network::Centrality::Degree');
use_ok('Clair::Network::Centrality::LexRank');
use_ok('Clair::Util');

my $file_doc_dir = "$FindBin::Bin/input/centrality";
my $circle = "circle.graph";
my $line = "line.graph";
my $star = "star.graph";
my $complex = "complex.graph";
my $directed_fn = "directed.graph";
my $lexrank_fn = "lexrank2.cos";

my $reader = Clair::Network::Reader::Edgelist->new();
#my $circle_graph = new Clair::GraphWrapper::Boost();
#my $circle_net = $reader->read_network($file_doc_dir . "/" . $circle, filebased => 0, undirected => 1, graph => $circle_graph);
my $circle_net = $reader->read_network($file_doc_dir . "/" . $circle, filebased => 0, undirected => 1);
is($circle_net->num_nodes, 9, "Loading circle network");

my $line_net = $reader->read_network($file_doc_dir . "/" . $line, filebased => 0, undirected => 1);
is($line_net->num_nodes, 7, "Loading line network");

my $star_net = $reader->read_network($file_doc_dir . "/" . $star, filebased => 0, undirected => 1);
is($star_net->num_nodes(), 8, "Loading star network");

my $complex_net = $reader->read_network($file_doc_dir . "/" . $complex, filebased => 0, undirected => 1);
is($complex_net->num_nodes(), 13, "Loading complex network");

my $directed_net = $reader->read_network($file_doc_dir . "/" . $directed_fn, filebased => 0);
is($directed_net->num_nodes(), 5, "Loading directed network");

my $undirected_net = $reader->read_network($file_doc_dir . "/" . $directed_fn,
                                           undirected => 1, filebased => 0);
is($undirected_net->num_nodes(), 5, "Loading undirected network");

my $lexrank_net = $reader->read_network($file_doc_dir . "/" . $lexrank_fn,
                                        undirected => 1, filebased => 0,
                                        edge_property => "lexrank_transition");
is($undirected_net->num_nodes(), 5, "Loading lexrank network");


# test degree centrality
my $degree = Clair::Network::Centrality::Degree->new($circle_net);
my $b = $degree->centrality();
is($b->{"n1"}, 2, "degree centrality ring n1 == 2");
is($b->{"n2"}, 2, "degree centrality ring n2 == 2");
is($b->{"n3"}, 2, "degree centrality ring n3 == 2");
is($b->{"n4"}, 2, "degree centrality ring n4 == 2");
is($b->{"n5"}, 2, "degree centrality ring n5 == 2");
is($b->{"n6"}, 2, "degree centrality ring n6 == 2");
is($b->{"n7"}, 2, "degree centrality ring n7 == 2");
is($b->{"n8"}, 2, "degree centrality ring n8 == 2");
is($b->{"n9"}, 2, "degree centrality ring n9 == 2");
my $nb = $degree->normalized_centrality();
is($nb->{"n1"}, 0.25, "degree centrality normalized ring n1 == 0.25");
is($nb->{"n2"}, 0.25, "degree centrality normalized ring n2 == 0.25");
is($nb->{"n3"}, 0.25, "degree centrality normalized ring n3 == 0.25");
is($nb->{"n4"}, 0.25, "degree centrality normalized ring n4 == 0.25");
is($nb->{"n5"}, 0.25, "degree centrality normalized ring n5 == 0.25");
is($nb->{"n6"}, 0.25, "degree centrality normalized ring n6 == 0.25");
is($nb->{"n7"}, 0.25, "degree centrality normalized ring n7 == 0.25");
is($nb->{"n8"}, 0.25, "degree centrality normalized ring n8 == 0.25");
is($nb->{"n9"}, 0.25, "degree centrality normalized ring n9 == 0.25");

$degree = Clair::Network::Centrality::Degree->new($line_net);
$b = $degree->centrality();
is($b->{"n1"}, 2, "degree centrality line n1 == 2");
is($b->{"n2"}, 2, "degree centrality line n2 == 2");
is($b->{"n3"}, 2, "degree centrality line n3 == 2");
is($b->{"n4"}, 2, "degree centrality line n4 == 2");
is($b->{"n5"}, 2, "degree centrality line n5 == 2");
is($b->{"n6"}, 1, "degree centrality line n6 == 2");
is($b->{"n7"}, 1, "degree centrality line n7 == 2");
$nb = $degree->normalized_centrality();
is($nb->{"n1"}, 1/3, "degree centrality normalized line n1 == " . 1/3);
is($nb->{"n2"}, 1/3, "degree centrality normalized line n2 == " . 1/3);
is($nb->{"n3"}, 1/3, "degree centrality normalized line n3 == " . 1/3);
is($nb->{"n4"}, 1/3, "degree centrality normalized line n4 == " . 1/3);
is($nb->{"n5"}, 1/3, "degree centrality normalized line n5 == " . 1/3);
is($nb->{"n6"}, 1/6, "degree centrality normalized line n6 == " . 1/6);
is($nb->{"n7"}, 1/6, "degree centrality normalized line n7 == " . 1/6);

$degree = Clair::Network::Centrality::Degree->new($star_net);
$b = $degree->centrality();
is($b->{"n1"}, 7, "degree centrality star n1 == 7");
is($b->{"n2"}, 1, "degree centrality star n2 == 1");
is($b->{"n3"}, 1, "degree centrality star n3 == 1");
is($b->{"n4"}, 1, "degree centrality star n4 == 1");
is($b->{"n5"}, 1, "degree centrality star n5 == 1");
is($b->{"n6"}, 1, "degree centrality star n6 == 1");
is($b->{"n7"}, 1, "degree centrality star n7 == 1");
is($b->{"n8"}, 1, "degree centrality star n8 == 1");
$nb = $degree->normalized_centrality();
is($nb->{"n1"}, 1, "degree centrality normalized star n1 == " . 1);
is($nb->{"n2"}, 1/7, "degree centrality normalized star n2 == " . 1/7);
is($nb->{"n3"}, 1/7, "degree centrality normalized star n3 == " . 1/7);
is($nb->{"n4"}, 1/7, "degree centrality normalized star n4 == " . 1/7);
is($nb->{"n5"}, 1/7, "degree centrality normalized star n5 == " . 1/7);
is($nb->{"n6"}, 1/7, "degree centrality normalized star n6 == " . 1/7);
is($nb->{"n7"}, 1/7, "degree centrality normalized star n7 == " . 1/7);
is($nb->{"n8"}, 1/7, "degree centrality normalized star n8 == " . 1/7);

$degree = Clair::Network::Centrality::Degree->new($complex_net);
$b = $degree->centrality();
is($b->{"n1"}, 3, "degree centrality complex n1 == 3");
is($b->{"n2"}, 3, "degree centrality complex n2 == 3");
is($b->{"n3"}, 3, "degree centrality complex n3 == 3");
is($b->{"n4"}, 3, "degree centrality complex n4 == 3");
is($b->{"n5"}, 3, "degree centrality complex n5 == 3");
is($b->{"n6"}, 3, "degree centrality complex n6 == 3");
is($b->{"n7"}, 2, "degree centrality complex n7 == 2");
is($b->{"n8"}, 3, "degree centrality complex n8 == 3");
is($b->{"n9"}, 3, "degree centrality complex n9 == 3");
is($b->{"n10"}, 2, "degree centrality complex n10 == 2");
is($b->{"n11"}, 3, "degree centrality complex n11 == 3");
is($b->{"n12"}, 3, "degree centrality complex n12 == 3");
is($b->{"n13"}, 2, "degree centrality complex n13 == 2");
$nb = $degree->normalized_centrality();
is($nb->{"n1"}, .25, "degree centrality normalized complex n1 == .25");
is($nb->{"n2"}, .25, "degree centrality normalized complex n2 == .25");
is($nb->{"n3"}, .25, "degree centrality normalized complex n3 == .25");
is($nb->{"n4"}, .25, "degree centrality normalized complex n4 == .25");
is($nb->{"n5"}, .25, "degree centrality normalized complex n5 == .25");
is($nb->{"n6"}, .25, "degree centrality normalized complex n6 == .25");
is($nb->{"n7"}, 2/12, "degree centrality normalized complex n7 == " . 2 / 12);
is($nb->{"n8"}, .25, "degree centrality normalized complex n8 == .25");
is($nb->{"n9"}, .25, "degree centrality normalized complex n9 == .25");
is($nb->{"n10"}, 2/12, "degree centrality normalized complex n10 == " . 2/12);
is($nb->{"n11"}, .25, "degree centrality normalized complex n11 == .25");
is($nb->{"n12"}, .25, "degree centrality normalized complex n12 == .25");
is($nb->{"n13"}, 2/12, "degree centrality normalized complex n13 == " . 2/12);

$degree = Clair::Network::Centrality::Degree->new($directed_net);
$b = $degree->centrality();
is($b->{"n1"}, 1, "degree centrality directed n1 == 1");
is($b->{"n2"}, 1, "degree centrality directed n2 == 2");
is($b->{"n3"}, 1, "degree centrality directed n3 == 2");
is($b->{"n4"}, 1.5, "degree centrality directed n4 == 1.5");
is($b->{"n5"}, 0.5, "degree centrality directed n5 == 0.5");
$nb = $degree->normalized_centrality();
is($nb->{"n1"}, 0.25, "degree centrality normalized directed n1 == " . 0.25);
is($nb->{"n2"}, 0.25, "degree centrality normalized directed n2 == " . 0.25);
is($nb->{"n3"}, 0.25, "degree centrality normalized directed n3 == " . 0.25);
is($nb->{"n4"}, 0.375, "degree centrality normalized directed n4 == " . 0.375);
is($nb->{"n5"}, 0.125, "degree centrality normalized directed n5 == " . 0.125);

$degree = Clair::Network::Centrality::Degree->new($undirected_net);
$b = $degree->centrality();
is($b->{"n1"}, 2, "degree centrality unundirected n1 == 2");
is($b->{"n2"}, 2, "degree centrality undirected n2 == 2");
is($b->{"n3"}, 2, "degree centrality undirected n3 == 2");
is($b->{"n4"}, 3, "degree centrality undirected n4 == 3");
is($b->{"n5"}, 1, "degree centrality undirected n5 == 1");
$nb = $degree->normalized_centrality();
is($nb->{"n1"}, 0.5, "degree centrality normalized undirected n1 == " . 0.5);
is($nb->{"n2"}, 0.5, "degree centrality normalized undirected n2 == " . 0.5);
is($nb->{"n3"}, 0.5, "degree centrality normalized undirected n3 == " . 0.5);
is($nb->{"n4"}, 0.75, "degree centrality normalized undirected n4 == " . 0.75);
is($nb->{"n5"}, 0.25, "degree centrality normalized undirected n5 == " . 0.25);


# Test closeness centrality
my $closeness = Clair::Network::Centrality::Closeness->new($circle_net);
$b = $closeness->centrality();
is($b->{"n1"}, 0.05, "closeness centrality ring n1 == 0.05");
is($b->{"n2"}, 0.05, "closeness centrality ring n2 == 0.05");
is($b->{"n3"}, 0.05, "closeness centrality ring n3 == 0.05");
is($b->{"n4"}, 0.05, "closeness centrality ring n4 == 0.05");
is($b->{"n5"}, 0.05, "closeness centrality ring n5 == 0.05");
is($b->{"n6"}, 0.05, "closeness centrality ring n6 == 0.05");
is($b->{"n7"}, 0.05, "closeness centrality ring n7 == 0.05");
is($b->{"n8"}, 0.05, "closeness centrality ring n8 == 0.05");
is($b->{"n9"}, 0.05, "closeness centrality ring n9 == 0.05");
$nb = $closeness->normalized_centrality();
is($nb->{"n1"}, 0.4, "closeness centrality normalized ring n1 == 0.4");
is($nb->{"n2"}, 0.4, "closeness centrality normalized ring n2 == 0.4");
is($nb->{"n3"}, 0.4, "closeness centrality normalized ring n3 == 0.4");
is($nb->{"n4"}, 0.4, "closeness centrality normalized ring n4 == 0.4");
is($nb->{"n5"}, 0.4, "closeness centrality normalized ring n5 == 0.4");
is($nb->{"n6"}, 0.4, "closeness centrality normalized ring n6 == 0.4");
is($nb->{"n7"}, 0.4, "closeness centrality normalized ring n7 == 0.4");
is($nb->{"n8"}, 0.4, "closeness centrality normalized ring n8 == 0.4");
is($nb->{"n9"}, 0.4, "closeness centrality normalized ring n9 == 0.4");

$closeness = Clair::Network::Centrality::Closeness->new($line_net);
$b = $closeness->centrality();
is($b->{"n1"}, 1/12, "closeness centrality line n1 == " . 1/12);
is($b->{"n2"}, 1/13, "closeness centrality line n2 == " . 1/13);
is($b->{"n3"}, 1/13, "closeness centrality line n3 == " . 1/13);
is($b->{"n4"}, 1/16, "closeness centrality line n4 == " . 1/16);
is($b->{"n5"}, 1/16, "closeness centrality line n5 == " . 1/16);
is($b->{"n6"}, 1/21, "closeness centrality line n6 == " . 1/21);
is($b->{"n7"}, 1/21, "closeness centrality line n7 == " . 1/21);
$nb = $closeness->normalized_centrality();
is($nb->{"n1"}, 6/12, "closeness centrality normalized line n1 == " . 6/12);
is($nb->{"n2"}, 6/13, "closeness centrality normalized line n2 == " . 6/13);
is($nb->{"n3"}, 6/13, "closeness centrality normalized line n3 == " . 6/13);
is($nb->{"n4"}, 6/16, "closeness centrality normalized line n4 == " . 6/16);
is($nb->{"n5"}, 6/16, "closeness centrality normalized line n5 == " . 6/16);
is($nb->{"n6"}, 6/21, "closeness centrality normalized line n6 == " . 6/21);
is($nb->{"n7"}, 6/21, "closeness centrality normalized line n7 == " . 6/21);

$closeness = Clair::Network::Centrality::Closeness->new($star_net);
$b = $closeness->centrality();
is($b->{"n1"}, 1/7, "closeness centrality star n1 == " . 1/7);
is($b->{"n2"}, 1/13, "closeness centrality star n2 == 1" . 1/13);
is($b->{"n3"}, 1/13, "closeness centrality star n3 == 1" . 1/13);
is($b->{"n4"}, 1/13, "closeness centrality star n4 == 1" . 1/13);
is($b->{"n5"}, 1/13, "closeness centrality star n5 == 1" . 1/13);
is($b->{"n6"}, 1/13, "closeness centrality star n6 == 1" . 1/13);
is($b->{"n7"}, 1/13, "closeness centrality star n7 == 1" . 1/13);
is($b->{"n8"}, 1/13, "closeness centrality star n8 == 1" . 1/13);
$nb = $closeness->normalized_centrality();
is($nb->{"n1"}, 1, "closeness centrality normalized star n1 == " . 1);
is($nb->{"n2"}, 1/13 * 7, "closeness centrality normalized star n2 == " . 1/13 * 7);
is($nb->{"n3"}, 1/13 * 7, "closeness centrality normalized star n3 == " . 1/13 * 7);
is($nb->{"n4"}, 1/13 * 7, "closeness centrality normalized star n4 == " . 1/13 * 7);
is($nb->{"n5"}, 1/13 * 7, "closeness centrality normalized star n5 == " . 1/13 * 7);
is($nb->{"n6"}, 1/13 * 7, "closeness centrality normalized star n6 == " . 1/13 * 7);
is($nb->{"n7"}, 1/13 * 7, "closeness centrality normalized star n7 == " . 1/13 * 7);
is($nb->{"n8"}, 1/13 * 7, "closeness centrality normalized star n8 == " . 1/13 * 7);

$closeness = Clair::Network::Centrality::Closeness->new($complex_net);
$b = $closeness->centrality();
is($b->{"n1"}, 1/24, "closeness centrality complex n1 == " . 1/24);
is($b->{"n2"}, 1/29, "closeness centrality complex n2 == " . 1/29);
is($b->{"n3"}, 1/29, "closeness centrality complex n3 == " . 1/29);
is($b->{"n4"}, 1/29, "closeness centrality complex n4 == " . 1/29);
is($b->{"n5"}, 1/37, "closeness centrality complex n5 == " . 1 / 37);
is($b->{"n6"}, 1/37, "closeness centrality complex n6 == " . 1 / 37);
is($b->{"n7"}, 1/47, "closeness centrality complex n7 == " . 1 / 47);
is($b->{"n8"}, 1/37, "closeness centrality complex n8 == " . 1 / 37);
is($b->{"n9"}, 1/37, "closeness centrality complex n9 == " . 1 / 37);
is($b->{"n10"}, 1/47, "closeness centrality complex n10 == " . 1 / 47);
is($b->{"n11"}, 1/37, "closeness centrality complex n11 == " . 1 / 37);
is($b->{"n12"}, 1/37, "closeness centrality complex n12 == " . 1 / 37);
is($b->{"n13"}, 1/47, "closeness centrality complex n13 == " . 1 / 47);
$nb = $closeness->normalized_centrality();
is($nb->{"n1"}, 1/24 * 12,
   "closeness centrality normalized complex n1 == " . 1 / 24 * 12);
is($nb->{"n2"}, 1/29 * 12,
   "closeness centrality normalized complex n2 == " . 1/29 * 12);
is($nb->{"n3"}, 1/29 * 12,
   "closeness centrality normalized complex n3 == " . 1 / 29 * 12);
is($nb->{"n4"}, 1/29 * 12,
   "closeness centrality normalized complex n4 == " . 1 / 29 * 12);
is($nb->{"n5"}, 1/37 * 12,
   "closeness centrality normalized complex n5 == " . 1 / 37 * 12);
is($nb->{"n6"}, 1/37 * 12,
   "closeness centrality normalized complex n6 == " . 1 / 37 * 12);
is($nb->{"n7"}, 1/47 * 12,
   "closeness centrality normalized complex n7 == " . 1 / 47 * 12);
is($nb->{"n8"}, 1/37 * 12,
   "closeness centrality normalized complex n8 == " . 1 / 37 * 12);
is($nb->{"n9"}, 1/37 * 12,
   "closeness centrality normalized complex n9 == " . 1 / 37 * 12);
is($nb->{"n10"}, 1/47 * 12,
   "closeness centrality normalized complex n10 == " . 1 / 47 * 12);
is($nb->{"n11"}, 1/37 * 12,
   "closeness centrality normalized complex n11 == " . 1 / 37 * 12);
is($nb->{"n12"}, 1/37 * 12,
   "closeness centrality normalized complex n12 == " . 1 / 37 * 12);
is($nb->{"n13"}, 1/47 * 12,
   "closeness centrality normalized complex n13 == " . 1 / 47 * 12);

$closeness = Clair::Network::Centrality::Closeness->new($directed_net);
$b = $closeness->centrality();
is($b->{"n1"}, 1 / 7, "closeness centrality directed n1 == " . 1 / 7);
is($b->{"n2"}, 1 / 3, "closeness centrality directed n2 == " . 1 / 3);
is($b->{"n3"}, 1 / 3, "closeness centrality directed n3 == " . 1 / 3);
is($b->{"n4"}, 1, "closeness centrality directed n4 == " . 1);
is($b->{"n5"}, 0, "closeness centrality directed n5 == " . 0);
$nb = $closeness->normalized_centrality();
is($nb->{"n1"}, 4 / 7,
   "closeness centrality normalized directed n1 == " . 4 / 7);
is($nb->{"n2"}, 4 / 6,
   "closeness centrality normalized directed n2 == " . 4 / 6);
is($nb->{"n3"}, 4 / 6,
   "closeness centrality normalized directed n3 == " . 4 / 6);
is($nb->{"n4"}, 1,
   "closeness centrality normalized directed n4 == " . 1);
is($nb->{"n5"}, 0,
   "closeness centrality normalized directed n5 == " . 0);

$closeness = Clair::Network::Centrality::Closeness->new($undirected_net);
$b = $closeness->centrality();
is($b->{"n1"}, 1 / 7, "closeness centrality undirected n1 == " . 1 / 7);
is($b->{"n2"}, 1 / 6, "closeness centrality undirected n2 == " . 1 / 6);
is($b->{"n3"}, 1 / 6, "closeness centrality undirected n3 == " . 1 / 6);
is($b->{"n4"}, 1 / 5, "closeness centrality undirected n4 == " . 1 / 5);
is($b->{"n5"}, 1 / 8, "closeness centrality undirected n5 == " . 1 / 8);
$nb = $closeness->normalized_centrality();
is($nb->{"n1"}, 4 / 7,
   "closeness centrality normalized undirected n1 == " . 4 / 7);
is($nb->{"n2"}, 4 / 6,
   "closeness centrality normalized undirected n2 == " . 4 / 6);
is($nb->{"n3"}, 4 / 6,
   "closeness centrality normalized undirected n3 == " . 4 / 6);
is($nb->{"n4"}, 4 / 5,
   "closeness centrality normalized undirected n4 == " . 4 / 5);
is($nb->{"n5"}, 4 / 8,
   "closeness centrality normalized undirected n5 == " . 4 / 8);


# Test betweenness centrality
my $betweenness = Clair::Network::Centrality::Betweenness->new($circle_net);
$b = $betweenness->centrality();
is($b->{"n1"}, 12, "betweenness centrality ring n1 == 12");
is($b->{"n2"}, 12, "betweenness centrality ring n2 == 12");
is($b->{"n3"}, 12, "betweenness centrality ring n3 == 12");
is($b->{"n4"}, 12, "betweenness centrality ring n4 == 12");
is($b->{"n5"}, 12, "betweenness centrality ring n5 == 12");
is($b->{"n6"}, 12, "betweenness centrality ring n6 == 12");
is($b->{"n7"}, 12, "betweenness centrality ring n7 == 12");
is($b->{"n8"}, 12, "betweenness centrality ring n8 == 12");
is($b->{"n9"}, 12, "betweenness centrality ring n9 == 12");
$nb = $betweenness->normalized_centrality();
is($nb->{"n1"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n1 == " . 12 / (8 * 7));
is($nb->{"n2"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n2 == " . 12 / (8 * 7));
is($nb->{"n3"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n3 == " . 12 / (8 * 7));
is($nb->{"n4"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n4 == " . 12 / (8 * 7));
is($nb->{"n5"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n5 == " . 12 / (8 * 7));
is($nb->{"n6"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n6 == " . 12 / (8 * 7));
is($nb->{"n7"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n7 == " . 12 / (8 * 7));
is($nb->{"n8"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n8 == " . 12 / (8 * 7));
is($nb->{"n9"}, 12 / (8 * 7),
   "betweenness centrality normalized ring n9 == " . 12 / (8 * 7));

$betweenness = Clair::Network::Centrality::Betweenness->new($line_net);
$b = $betweenness->centrality();
is($b->{"n1"}, 18, "betweenness centrality line n1 == " . 18);
is($b->{"n2"}, 16, "betweenness centrality line n2 == " . 16);
is($b->{"n3"}, 16, "betweenness centrality line n3 == " . 16);
is($b->{"n4"}, 10, "betweenness centrality line n4 == " . 10);
is($b->{"n5"}, 10, "betweenness centrality line n5 == " . 10);
is($b->{"n6"}, 0, "betweenness centrality line n6 == " . 0);
is($b->{"n7"}, 0, "betweenness centrality line n7 == " . 0);
$nb = $betweenness->normalized_centrality();
is($nb->{"n1"}, 18/(6*5),
   "betweenness centrality normalized line n1 == " . 18/(6*5));
is($nb->{"n2"}, 16/(6*5),
   "betweenness centrality normalized line n2 == " . 16/(6*5));
is($nb->{"n3"}, 16/(6*5),
   "betweenness centrality normalized line n3 == " . 16/(6*5));
is($nb->{"n4"}, 10/(6*5),
   "betweenness centrality normalized line n4 == " . 10/(6*5));
is($nb->{"n5"}, 10/(6*5),
   "betweenness centrality normalized line n5 == " . 10/(6*5));
is($nb->{"n6"}, 0,
   "betweenness centrality normalized line n6 == " . 0);
is($nb->{"n7"}, 0,
   "betweenness centrality normalized line n7 == " . 0);

$betweenness = Clair::Network::Centrality::Betweenness->new($star_net);
$b = $betweenness->centrality();
is($b->{"n1"}, 42, "betweenness centrality star n1 == " . 42);
is($b->{"n2"}, 0, "betweenness centrality star n2 == 1" . 0);
is($b->{"n3"}, 0, "betweenness centrality star n3 == 1" . 0);
is($b->{"n4"}, 0, "betweenness centrality star n4 == 1" . 0);
is($b->{"n5"}, 0, "betweenness centrality star n5 == 1" . 0);
is($b->{"n6"}, 0, "betweenness centrality star n6 == 1" . 0);
is($b->{"n7"}, 0, "betweenness centrality star n7 == 1" . 0);
is($b->{"n8"}, 0, "betweenness centrality star n8 == 1" . 0);
$nb = $betweenness->normalized_centrality();
is($nb->{"n1"}, 1, "betweenness centrality normalized star n1 == " . 1);
is($nb->{"n2"}, 0, "betweenness centrality normalized star n2 == " . 0);
is($nb->{"n3"}, 0, "betweenness centrality normalized star n3 == " . 0);
is($nb->{"n4"}, 0, "betweenness centrality normalized star n4 == " . 0);
is($nb->{"n5"}, 0, "betweenness centrality normalized star n5 == " . 0);
is($nb->{"n6"}, 0, "betweenness centrality normalized star n6 == " . 0);
is($nb->{"n7"}, 0, "betweenness centrality normalized star n7 == " . 0);
is($nb->{"n8"}, 0, "betweenness centrality normalized star n8 == " . 0);

$betweenness = Clair::Network::Centrality::Betweenness->new($complex_net);
$b = $betweenness->centrality();
is($b->{"n1"}, 96, "betweenness centrality complex n1 == " . 96);
is($b->{"n2"}, 54, "betweenness centrality complex n2 == " . 54);
is($b->{"n3"}, 54, "betweenness centrality complex n3 == " . 54);
is($b->{"n4"}, 54, "betweenness centrality complex n4 == " . 54);
is($b->{"n5"}, 10, "betweenness centrality complex n5 == " . 10);
is($b->{"n6"}, 10, "betweenness centrality complex n6 == " . 10);
is($b->{"n7"}, 0, "betweenness centrality complex n7 == " . 0);
is($b->{"n8"}, 10, "betweenness centrality complex n8 == " . 10);
is($b->{"n9"}, 10, "betweenness centrality complex n9 == " . 10);
is($b->{"n10"}, 0, "betweenness centrality complex n10 == " . 0);
is($b->{"n11"}, 10, "betweenness centrality complex n11 == " . 10);
is($b->{"n12"}, 10, "betweenness centrality complex n12 == " . 10);
is($b->{"n13"}, 0, "betweenness centrality complex n13 == " . 0);
$nb = $betweenness->normalized_centrality();
is($nb->{"n1"}, 96 / (11 * 12),
   "betweenness centrality normalized complex n1 == " . 96 / (11 * 12));
is($nb->{"n2"}, 54 / (11 * 12),
   "betweenness centrality normalized complex n2 == " . 54 / (11 * 12));
is($nb->{"n3"}, 54 / (11 * 12),
   "betweenness centrality normalized complex n3 == " . 54 / (11 * 12));
is($nb->{"n4"}, 54 / (11 * 12),
   "betweenness centrality normalized complex n4 == " . 54 / (11 * 12));
is($nb->{"n5"}, 10 / (11 * 12),
   "betweenness centrality normalized complex n5 == " . 10 / (11 * 12));
is($nb->{"n6"}, 10 / (11 * 12),
   "betweenness centrality normalized complex n6 == " . 10 / (11 * 12));
is($nb->{"n7"}, 0,
   "betweenness centrality normalized complex n7 == " . 0);
is($nb->{"n8"}, 10 / (11 * 12),
   "betweenness centrality normalized complex n8 == " . 10 / (11 * 12));
is($nb->{"n9"}, 10 / (11 * 12),
   "betweenness centrality normalized complex n9 == " . 10 / (11 * 12));
is($nb->{"n10"}, 0,
   "betweenness centrality normalized complex n10 == " . 0);
is($nb->{"n11"}, 10 / (11 * 12),
   "betweenness centrality normalized complex n11 == " . 10 / (11 * 12));
is($nb->{"n12"}, 10 / (11 * 12),
   "betweenness centrality normalized complex n12 == " . 10 / (11 * 12));
is($nb->{"n13"}, 0,
   "betweenness centrality normalized complex n13 == " . 0);

$betweenness = Clair::Network::Centrality::Betweenness->new($directed_net);
$b = $betweenness->centrality();
is($b->{"n1"}, 0, "betweenness centrality directed n1 == " . 0);
is($b->{"n2"}, 1, "betweenness centrality directed n2 == " . 1);
is($b->{"n3"}, 1, "betweenness centrality directed n3 == " . 1);
is($b->{"n4"}, 3, "betweenness centrality directed n4 == " . 3);
is($b->{"n5"}, 0, "betweenness centrality directed n5 == " . 0);
$nb = $betweenness->normalized_centrality();
is($nb->{"n1"}, 0,
   "betweenness centrality normalized directed n1 == " . 0);
is($nb->{"n2"}, 1 / 12,
   "betweenness centrality normalized directed n2 == " . 1 / 12);
is($nb->{"n3"}, 1 / 12,
   "betweenness centrality normalized directed n3 == " . 1 / 12);
is($nb->{"n4"}, 1 / 4,
   "betweenness centrality normalized directed n4 == " . 1 / 4);
is($nb->{"n5"}, 0,
   "betweenness centrality normalized directed n5 == " . 0);

$betweenness = Clair::Network::Centrality::Betweenness->new($undirected_net);
$b = $betweenness->centrality();
is($b->{"n1"}, 1, "betweenness centrality undirected n1 == " . 1);
is($b->{"n2"}, 2, "betweenness centrality undirected n2 == " . 2);
is($b->{"n3"}, 2, "betweenness centrality undirected n3 == " . 2);
is($b->{"n4"}, 7, "betweenness centrality undirected n4 == " . 7);
is($b->{"n5"}, 0, "betweenness centrality undirected n5 == " . 0);
$nb = $betweenness->normalized_centrality();
is($nb->{"n1"}, 1 / 12,
   "betweenness centrality normalized undirected n1 == " . 1 / 12);
is($nb->{"n2"}, 1 / 6,
   "betweenness centrality normalized undirected n2 == " . 1 / 6);
is($nb->{"n3"}, 1 / 6,
   "betweenness centrality normalized undirected n3 == " . 1 / 6);
is($nb->{"n4"}, 7 / 12,
   "betweenness centrality normalized undirected n4 == " . 7 / 12);
is($nb->{"n5"}, 0,
   "betweenness centrality normalized undirected n5 == " . 0);

$betweenness = Clair::Network::Centrality::LexRank->new($lexrank_net);
$b = $betweenness->centrality();

ok(Clair::Util::within_delta($b->{"0"}, 0.2968, 0.0001),
   "LexRank centrality undirected 0 == " . 0.2968);
ok(Clair::Util::within_delta($b->{"1"}, 0.1169, 0.0001),
   "LexRank centrality undirected 1 == " . 0.1169);
ok(Clair::Util::within_delta($b->{"2"}, 0.2936, 0.0001),
   "LexRank centrality undirected 2 == " . 0.2936);
ok(Clair::Util::within_delta($b->{"3"}, 0.2926, 0.0001),
   "LexRank centrality undirected 3 == " . 0.2926);

