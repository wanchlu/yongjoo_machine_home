# script: test_network.t
# functionality: Test basic Network functionality, such as node/edge addition
# functionality: and removal, path generation, statistics, matlab graphics
# functionality: generation, etc. 

use strict;
use warnings;
use FindBin;
use Test::More tests => 64;

use_ok('Clair::Network');
use_ok('Clair::Network::Writer::Pajek');
use_ok('Clair::Network::Writer::Edgelist');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/network";
my $file_doc_dir = "$FindBin::Bin/input/network";
my $file_exp_dir = "$FindBin::Bin/expected/network";

my $g1 = Clair::Network->new();
$g1->add_node(1, text => "Random sentence");
$g1->add_node(2, text => "unique");
$g1->add_node(3, text => "mark hodges");
$g1->add_node(4, text => "mark liffiton");
$g1->add_node(5, text => "dragomir radev");
$g1->add_node(6, text => "mike dagitses");

$g1->add_edge(1, 2);
$g1->add_edge(1, 3);
$g1->add_edge(2, 4);
$g1->add_edge(4, 5);
$g1->add_edge(5, 6);
$g1->add_edge(4, 6);

#is($g1->diameter(filename => "$file_gen_dir/graph.diameter"), 3, "diameter");
#ok(compare_sorted_proper_files("graph.diameter"), "diameter files");

is($g1->diameter(), 3, "diameter"); 

is($g1->diameter(), 3, "diameter"); 
$g1->remove_edge(4, 6);
is($g1->diameter(), 4, "diameter"); 

$g1->add_node(7, text => "");
$g1->add_edge(1, 7);
$g1->add_edge(7, 6);

my @path = $g1->find_path(1, 6);
my $path_length = @path;
is($path_length, 3, "find_path");

$g1->set_node_weight(7, 20);
is($g1->get_node_weight(7), 20, "get_node_weight");

$g1->remove_node(7);

@path = $g1->find_path(1, 6);
$path_length = @path;
is($path_length, 5, "find_path");

# Test Pajek writing and reading
my $export = Clair::Network::Writer::Pajek->new();
$export->set_name('test_graph');
$export->write_network($g1, "$file_gen_dir/graph.pajek");

my $reader = Clair::Network::Reader::Pajek->new();
my $pajek_net = $reader->read_network("$file_gen_dir/graph.pajek");
ok($pajek_net->{graph} eq $g1->{graph}, "Pajek reading and writing");

is($g1->num_documents(), 6, "num_documents");
is($g1->num_pairs(), 15, "num_pairs");
is($g1->num_links(), 5, "num_links");
my $graph = $g1->{graph};

$g1->add_node('EX8', text => 'an external node');
$g1->add_edge('EX8', 4);
$g1->add_edge(5, 'EX8');

is($g1->num_links(), 5, "num_links");
is($g1->num_links(external => 1), 2, "num_links external => 1");

my %deg_hist = $g1->compute_in_link_histogram();
is($deg_hist{1}, 5, "compute_in_link_histogram");

%deg_hist = $g1->compute_out_link_histogram();
is($deg_hist{1}, 3, "compute_out_link_histogram");

my $avg_deg = $g1->avg_total_degree();
is($avg_deg, 2, "avg_total_degree");

%deg_hist = $g1->compute_total_link_histogram();
is($deg_hist{1}, 2, "compute_total_link_histogram");

my $retString = $g1->power_law_out_link_distribution();
like($retString, qr/y = 3 x\^-0\.5849\d+/, "power_law_out_link_distribution");

$retString = $g1->power_law_in_link_distribution();
like($retString, qr/y = 5 x\^-2\.3219\d+/, "power_law_in_link_distribution");

$retString = $g1->power_law_total_link_distribution();
like($retString, qr/y = 2\.204\d+ x\^0\.0629\d+/, 
    "power_law_total_link_distribution");

is($g1->diameter(), 4, "diameter");
is($g1->diameter(undirected => 1), 5, "diameter undirected");

my $diameter = $g1->diameter(avg => 1);
cmp_ok(abs($diameter - 2.055), "<", 0.005, "diameter avg");
 
$diameter = $g1->diameter(avg => 1, undirected => 1);
cmp_ok(abs($diameter - 2.285), "<", 0.005, "diameter undirected avg");

# Test average shortest path
my $asp = $g1->average_shortest_path();
cmp_ok(abs($asp - 1.535), '<', 0.005, "average_shortest_path");

# Test Newman's power law exponent formula
my @npl = $g1->newman_power_law_exponent(\%deg_hist, 1);
cmp_ok(abs($npl[0] - 2.635), '<', 0.005, "newman_power_law_exponent");

# Test finding largest component
my $largest_component = $g1->find_largest_component("weakly");
is($largest_component->num_nodes(), 7, "find_largest_component");

$export = Clair::Network::Writer::Edgelist->new();
$export->write_network($g1, "$file_gen_dir/graph.links");
ok(compare_sorted_proper_files("graph.links"), "write_links");

$g1->write_nodes("$file_gen_dir/graph.nodes");
ok(compare_sorted_proper_files("graph.nodes"), "write_nodes");

my $wscc = $g1->Watts_Strogatz_clus_coeff;
cmp_ok(abs($wscc - 0.235), '<', 0.005, "Watts_Strogatz_clus_coeff");

my $newman_cc = $g1->newman_clustering_coefficient();
cmp_ok($newman_cc, "=", 0.375, "newman_clustering_coefficient");

my @triangles = $g1->get_triangles();
cmp_ok($triangles[0][0], "eq", "4-5-EX8", "get_triangles");

my $spl = $g1->get_shortest_path_length("1", "4");
cmp_ok($spl, "=", 2, "shortest_path_length");

my %dist = $g1->get_shortest_paths_lengths("1");
cmp_ok($dist{5}, "=", 3, "shortest_paths_lengths");

$g1->write_db("$file_gen_dir/graph.db");
ok(-e "$file_gen_dir/graph.db", "write_db");

$g1->write_db("$file_gen_dir/xpose.db", transpose => 1);
ok(-e "$file_gen_dir/xpose.db", "write_db transpose");

$g1->find_scc("$file_gen_dir/graph.db", "$file_gen_dir/xpose.db", 
    "$file_gen_dir/graph-scc-db.fin");
ok(compare_sorted_proper_files("graph-scc-db.fin"), "find_scc");

$g1->get_scc("$file_gen_dir/graph-scc-db.fin", "$file_doc_dir/link_map", 
    "$file_gen_dir/graph.scc");
ok(compare_sorted_proper_files("graph.scc"), "get_scc");

my %in_hist = $g1->compute_in_link_histogram();
$g1->write_link_matlab(\%in_hist, "$file_gen_dir/graph_in.m", 'graph');
ok(compare_proper_files("graph_in.m"), "write_link_matlab");

$g1->write_link_dist(\%in_hist, "$file_gen_dir/graph-inLinks");
ok(compare_sorted_proper_files("graph-inLinks"), "write_link_dist");

my %cos = ();
$cos{1} = ();
$cos{1}{2} = .1;
$cos{1}{3} = .3;
$cos{1}{4} = .6;
$cos{2} = ();
$cos{2}{1} = .1;
$cos{2}{3} = .4;
$cos{2}{4} = .1;
$cos{3} = ();
$cos{3}{1} = .3;
$cos{3}{2} = .4;
$cos{3}{4} = .2;
$cos{4} = ();
$cos{4}{1} = .6;
$cos{4}{2} = .1;
$cos{4}{3} = .2;

my ($la, $nla) = $g1->average_cosines(\%cos);
cmp_ok(abs($la - 0.1665), "<", 0.0005, "average_cosines la");
cmp_ok(abs($nla - 0.3225), "<", 0.0005, "average_cosines nla");

my ($lb_ref, $nlb_ref) = $g1->cosine_histograms(\%cos);
my @lb = @$lb_ref;
my @nlb = @$nlb_ref;
is($lb[10], 2, "cosine_histograms lb");
is($nlb[10], 2, "cosine_histograms nlb");

$g1->write_histogram_matlab($lb_ref, $nlb_ref, "$file_gen_dir/graph", 
    "test_network");
ok(compare_sorted_proper_files("graph_linked_hist.m"), "write_histogram_matlab");
ok(compare_sorted_proper_files("graph_linked_cumulative.m"), "write_histogram_matlab");
ok (compare_sorted_proper_files("graph_not_linked_hist.m"), "write_histogram_matlab");

my $hist_as_string = $g1->get_histogram_as_string($lb_ref, $nlb_ref);
open (HIST_FILE, "> $file_gen_dir/graph.hist")  
    or die "Couldn't open $file_gen_dir/graph.hist: $!";
print HIST_FILE $hist_as_string;
close(HIST_FILE);
ok(compare_sorted_proper_files("graph.hist"), "get_histogram_as_string");

$g1->create_cosine_dat_files('graph', \%cos, directory => "$file_gen_dir");
ok(compare_sorted_proper_files("graph-point-one-all.dat"), 
    "create_cosine_dat_files graph-point-one-all.dat");
ok(compare_sorted_proper_files("graph-all-cosine"), "... graph-all-cosine.dat");
ok(compare_sorted_proper_files("graph-0-1.dat"), "... graph-0-1.dat");
ok(compare_sorted_proper_files("graph-0-2.dat"), "... graph-0-2.dat");
ok(compare_sorted_proper_files("graph-0-3.dat"), "... graph-0-3.dat");
ok(compare_sorted_proper_files("graph-0-4.dat"), "... graph-0-4.dat");
ok(compare_sorted_proper_files("graph-0-5.dat"), "... graph-0-5.dat");
ok(compare_sorted_proper_files("graph-0-6.dat"), "... graph-0-6.dat");
ok(compare_sorted_proper_files("graph-0-7.dat"), "... graph-0-7.dat");
ok(compare_sorted_proper_files("graph-0-8.dat"), "... graph-0-8.dat");
ok(compare_sorted_proper_files("graph-0-9.dat"), "... graph-0-9.dat");
ok(compare_sorted_proper_files("graph-0.dat"), "... graph-0.dat");

my $network = Clair::Network->new();
open DEBUG, "$file_exp_dir/debug.graph";
while (<DEBUG>) {
    chomp;
    my ($from, $to) = split / /, $_;
    $network->add_edge($from, $to);
}
close DEBUG;
is($network->avg_in_degree(), $network->avg_out_degree(), "avg deg on graph");

# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
	my $filename = shift;
	return Clair::Util::compare_files("$file_exp_dir/$filename", 
        "$file_gen_dir/$filename");
}

sub compare_sorted_proper_files {
	my $filename = shift;
	return Clair::Util::compare_sorted_files("$file_exp_dir/$filename", 
        "$file_gen_dir/$filename");
}
