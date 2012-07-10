#!/usr/local/bin/perl

# script: test_networkstat.pl
# functionality: Generates a network, then computes and displays a large
# functionality: number of network statistics 

use strict;
use warnings;
use DB_File;
use FindBin;

use Clair::Network;
use Clair::Network::Writer::Edgelist;
use Clair::Network::Writer::Pajek;
use Clair::Cluster;
use Clair::Document;

my $basedir = $FindBin::Bin;
my $input_dir = "input/networkstat";
my $output_dir = "produced/networkstat";

my $old_prefix = "a";
my $threshold = 0.20;

my $prefix = "$output_dir/$old_prefix";

print "prefix: $prefix\n";
print "threshold: $threshold\n";

# Create cluster
my %documents = ();
my $cluster = Clair::Cluster->new(documents => \%documents);
my @files = ();
my @doc_ids = ();

# Open txt file and read in each line, putting it into the cluster as
# a separate document
open (TXT, "<$input_dir/$old_prefix.txt") || die("Could not open $input_dir/$old_prefix.txt.");

my $doc_count = 0;

while (<TXT>)
{
	$doc_count++;
	my $doc = Clair::Document->new(type => 'text', string => "$_",
	                                  id => "$doc_count");
	$cluster->insert($doc_count, $doc);

	print "$doc_count:\t$_\n";
}

my %cos = $cluster->compute_cosine_matrix(text_type => 'text');

## CREATE A.ALL.COS FILE
$cluster->write_cos("$prefix.all.cos", cosine_matrix => \%cos);

# Uncomment to display the cosine matrix:
# foreach my $i (1..$doc_count)
# {
# 	foreach my $j (1..$doc_count)
# 	{
# 		if ($j < $i)
# 		{
# 			print "$j $i $cos{$j}{$i}\n";
# 			print "$i $j $cos{$i}{$j}\n";
# 		}
# 	}
# }


# Do binary cosine w/ cutoff of 0.15
my %bin_matrix = $cluster->compute_binary_cosine($threshold);


## CREATE A.15.COS FILE
$cluster->write_cos("$prefix$threshold.cos", cosine_matrix => \%bin_matrix, write_zeros => 0);

# Create networks
my $network = $cluster->create_network(cosine_matrix => \%cos, include_zeros => 1);
my $networkThreshold = $cluster->create_network(cosine_matrix => \%bin_matrix);

# Creating .links files
my $export = Clair::Network::Writer::Edgelist->new();
$export->write_network($network, "$prefix.all.links");
$export->write_network($networkThreshold, "$prefix.links");
$network->write_nodes("$prefix.nodes");
$export->write_network($networkThreshold, "$prefix.linksuniq",
                       skip_duplicates => 1);

### check if the stats file exists
if (not -e "$prefix.stats") {
	print STDERR "creating the .stats file\n";
	`echo statistic: [date] value > $prefix.stats`;
}

my $n1 = $network->num_documents;
my $n2 = $networkThreshold->num_documents;
print_stat("documents", "$n1 vs. $n2");

$n1 = $network->num_pairs;
$n2 = $networkThreshold->num_pairs;
print_stat("pairs", "$n1 vs. $n2");
display_stat("documents");
display_stat("pairs");

my $ext_links = $networkThreshold->num_links(external => 1);
my $int_links = $networkThreshold->num_links(internal => 1);
my $int_links_nm = $networkThreshold->num_links(internal => 1, unique => 1);

print_stat("Number of external links (includes links with multiplicities)", $ext_links);
display_stat("Number of external links");

print_stat("Number of internal links (includes links with multiplicities)", $int_links);
display_stat("Number of internal links (includes links with multiplicities)");

if ($ext_links != 0) {
	print_stat("Ratio of internal to external links", $ext_links/$int_links);
	display_stat("Ratio of internal to external links");
}

print_stat("Number of internal links (no multiplicities allowed)", $int_links_nm);
display_stat("Number of internal links (no multiplicities allowed)");

$networkThreshold->write_db("$prefix.db");
print "PRINTING DB\n";
$networkThreshold->print_db("$prefix.db");
$networkThreshold->write_db("$prefix-xpose.db", transpose => 1);
print "PRINTING TRANSPOSED DB\n";
$networkThreshold->print_db("$prefix-xpose.db");
$networkThreshold->find_scc("$prefix.db", "$prefix-xpose.db", "$prefix-scc-db.fin", verbose => 1);
$networkThreshold->get_scc("$prefix-scc-db.fin", "$prefix.link_map", "$prefix.scc");
$export->write_network($networkThreshold, "$prefix-xpose.link",
                       transpose => 1);

print_stat("Average in-degree", "average degree " . $networkThreshold->avg_in_degree);
display_stat("Average in-degree");
my %in_hist = $networkThreshold->compute_in_link_histogram();
$networkThreshold->write_link_matlab(\%in_hist, $prefix . "_in.m", "$old_prefix-in");
$networkThreshold->write_link_dist(\%in_hist, "$prefix-inLinks");

print_stat("Average out-degree", "average degree " . $networkThreshold->avg_out_degree);
display_stat("Average out-degree");
my %out_hist = $networkThreshold->compute_out_link_histogram();
$networkThreshold->write_link_matlab(\%out_hist, $prefix . "_out.m", "$old_prefix-out");
$networkThreshold->write_link_dist(\%out_hist, "$prefix-outLinks");

print_stat("Average total-degree", "average degree " . $networkThreshold->avg_total_degree);
display_stat("Average total-degree");
my %tot_hist = $networkThreshold->compute_total_link_histogram();
$networkThreshold->write_link_matlab(\%tot_hist, $prefix . "_total.m", "$old_prefix-total");
$networkThreshold->write_link_dist(\%tot_hist, "$prefix-totalLinks");

print_stat("Power Law, out-link distribution", $networkThreshold->power_law_out_link_distribution);
display_stat("Power Law, out-link distribution");

print_stat("Power Law, in-link distribution", $networkThreshold->power_law_in_link_distribution);
display_stat("Power Law, in-link distribution");

print_stat("Power Law, total-link distribution", $networkThreshold->power_law_total_link_distribution);
display_stat("Power Law, total-link distribution");

my $wscc = $networkThreshold->Watts_Strogatz_clus_coeff(filename => "$prefix.cc.out");
print_stat("Watts-Strogatz clustering coefficient", $wscc);
display_stat("Watts-Strogatz clustering coefficient");

my $newman_cc = $networkThreshold->newman_clustering_coefficient();
print_stat("Newman clustering coefficient", $newman_cc);
display_stat("Newman clustering coefficient");

my @triangles = $networkThreshold->get_triangles();
print_stat("Network triangles", @triangles);
display_stat("Network triangles");

my $spl = $networkThreshold->get_shortest_path_length("1", "12");
print_stat("Shortest path between node 1 and node 12", $spl);
display_stat("Shortest path between node 1 and node 12");

my %dist = $networkThreshold->get_shortest_paths_lengths("1");
print_stat("Shortest paths between node 1 and reachable nodes", %dist);
display_stat("Shortest paths between node 1 and reachable nodes");


print_stat("Average shortest path",
	   $networkThreshold->average_shortest_path());
display_stat("Average shortest path");

print_stat("Average directed shortest path", $networkThreshold->diameter(avg => 1, filename => "$prefix.asp.directed.out", directed => 1) );
display_stat("Average directed shortest path");

print_stat("Average undirected shortest path", $networkThreshold->diameter(avg => 1, filename => "$prefix.asp.undirected.out", undirected => 1) );
display_stat("Average undirected shortest path");

print_stat("Maximum directed shortest path", $networkThreshold->diameter(max => 1, filename => "$prefix.diameter.out", directed => 1) );
display_stat("Maximum directed shortest path");

print_stat("Maximum undirected shortest path", $networkThreshold->diameter(max => 1, filename => "$prefix.diameter.out", undirected => 1) );
display_stat("Maximum undirected shortest path");

write_to_stat("------ COSINE STATISTICS -----------\n");

my ($link_avg_cos, $nl_avg_cos) = $networkThreshold->average_cosines(\%cos);

print_stat("linked average cosine", $link_avg_cos);
display_stat("linked average cosine");

print_stat("not linked average cosine", $nl_avg_cos);
display_stat("not linked average cosine");

my ($link_hist, $nolink_hist) = $networkThreshold->cosine_histograms(\%cos);
$networkThreshold->write_histogram_matlab($link_hist, $nolink_hist, $prefix, $prefix);
my $hist_string = $networkThreshold->get_histogram_as_string($link_hist, $nolink_hist);
write_to_stat($hist_string);
print $hist_string;

print "$prefix\n";

$networkThreshold->create_cosine_dat_files($old_prefix, \%cos, directory => "produced/networkstat");

print "2\n";

my $dat_stats = $networkThreshold->get_dat_stats("$prefix", "$prefix.links", "$prefix.all.cos");

#produced/networkstat/a/produced/networkstat/a-point-one-all.dat

print "3\n";

write_to_stat($dat_stats);
print $dat_stats;

print "4\n";

$export = Clair::Network::Writer::Pajek->new();
$export->set_name($prefix);
$export->write_network($networkThreshold, "$prefix.net");

#
# Statistics Methods
#
sub print_stat {
  my $name = shift;
	my $value = shift;
	my $date = `date`;
	chomp($date);
	open (STATS, ">>$prefix.stats");
	print STATS $name,": [$date] $value\n";
	close STATS;
}

sub write_to_stat {
	my $text = shift;
	open (STATS, ">>$prefix.stats");
	print STATS $text;
	close STATS;
}

sub get_stat {
	my $name = shift;
	my $line = `grep "^$name" $prefix.stats`;
	chomp($line);
	my @columns = split (" ", $line);
	return $columns[$#columns];
}

sub display_stat {
	my $name = shift;
	print `grep "^$name" $prefix.stats`;
}

sub not_exists_stat {
	my $name = shift;
	my $st = `grep "^$name" $prefix.stats`;
	return ($st =~ /^\s*$/);
}

