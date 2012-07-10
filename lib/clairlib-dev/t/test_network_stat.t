# script: test_network_stat.t
# functionality: Generates a network, then computes and displays a large          
# functionality: number of network statistics 

use strict;
use warnings;
use FindBin;

use Test::More tests => 43;

use_ok('Clair::Network');
use_ok('Clair::Network::Writer::Edgelist');
use_ok('Clair::Cluster');
use_ok('Clair::Document');
use_ok('Clair::Util');

my $old_prefix = "a";
my $threshold = ".20";

my $file_gen_dir = "$FindBin::Bin/produced/network_stat";
my $file_input_dir = "$FindBin::Bin/input/network_stat";
my $file_exp_dir = "$FindBin::Bin/expected/network_stat";
my $prefix = "$file_gen_dir/$old_prefix";

# Create cluster
my $cluster = Clair::Cluster->new();
my @files = ();
my @doc_ids = ();

clear_stats_file();

# Open txt file and read in each line, putting it into the cluster as
# a separate document
open (TXT, "< $file_input_dir/$old_prefix.txt") || die("Could not open $file_input_dir/$old_prefix.txt.");

my $doc_count = 0;

while (<TXT>)
{
	$doc_count++;
	my $doc = Clair::Document->new(type => 'text', string => "$_",
	                                  id => "$doc_count");
	$cluster->insert($doc_count, $doc);

#	print "$doc_count:\t$_\n";
}

my %cos = $cluster->compute_cosine_matrix(text_type => 'text');

$cluster->write_cos("$prefix.all.cos", cosine_matrix => \%cos);

cmp_ok( abs($cos{5}{13} - 0.05605), "<", 0.00005, "cos");
cmp_ok( abs($cos{19}{26} - 0.07495), "<", 0.00005, "cos 2");


# Do binary cosine w/ cutoff of 0.2
my %bin_matrix = $cluster->compute_binary_cosine($threshold);
cmp_ok( abs($bin_matrix{13}{29} - 0.2215), "<", 0.00005, "bin matrix");
is($bin_matrix{19}{26}, 0, "bin matrix cutoff"); 


# Create networks
my $network = $cluster->create_network(cosine_matrix => \%cos, 
    include_zeros => 1);
my $networkThreshold = $cluster->create_network(cosine_matrix => \%bin_matrix);

# Creating .links files
my $export = Clair::Network::Writer::Edgelist->new();
$export->write_network($network, "$prefix.all.links");
$export->write_network($networkThreshold, "$prefix.links");
ok($network->has_edge(13, 3), "has_edge(13,3)");

ok($networkThreshold->has_edge(7, 12), "has_edge(7,12)");
ok(not ($networkThreshold->has_edge(2, 20)), "not has_edge(2,20)");

$network->write_nodes("$prefix.nodes");
ok(compare_proper_files("$old_prefix.nodes"), "write_notes");
ok($network->has_node(5), "has_node(5)");
ok($network->has_node(13), "has_node(13)");
is($network->has_node(33), '', "not has_node(33)");

is($network->num_documents, 32, "num_documents");
is($networkThreshold->num_documents, 21, "num_documents thresh");

is($network->num_pairs, 496, "num_pairs");
is($networkThreshold->num_pairs, 210, "num_paris thresh");

is($networkThreshold->num_links(external => 1), 0, "num_links thresh ext");
is($networkThreshold->num_links(internal => 1), 84, "num_links thresh int");
is($networkThreshold->num_links(internal => 1, unique => 1), 84, 
    "num_links thresh int uniq");

$networkThreshold->write_db("$prefix.db");
ok(-e "$prefix.db");

$networkThreshold->write_db("$prefix-xpose.db", transpose => 1);
ok(-e "$prefix-xpose.db");

#print $networkThreshold->num_nodes(), "\n";
#print $networkThreshold->num_links(), "\n";
is($networkThreshold->avg_in_degree, 4, "avg_in_degree");
is($networkThreshold->avg_out_degree, 4, "avg_out_degree");
is($networkThreshold->avg_total_degree, 8, "avg_total_degree");

my $dist = $networkThreshold->power_law_out_link_distribution;
ok ($dist =~ /y = 4\.217.* x\^-0\.167/);

$dist = $networkThreshold->power_law_in_link_distribution;
ok ($dist =~ /y = 4\.217.* x\^-0\.167/);

$dist = $networkThreshold->power_law_total_link_distribution;
ok ($dist =~ /y = 4\.737.* x\^-0\.167/);

my $wscc = $networkThreshold->Watts_Strogatz_clus_coeff(filename => "$prefix.cc.out");
ok ($wscc >  0.442 and $wscc < 0.443);

my $diam = $networkThreshold->diameter(avg => 1, filename => "$prefix.asp.directed.out", directed => 1);
ok ($diam > 2.144 and $diam < 2.145);

$diam = $networkThreshold->diameter(avg => 1, filename => "$prefix.asp.undirected.out", undirected => 1);
ok ($diam > 2.144 and $diam < 2.145);

$diam = $networkThreshold->diameter(max => 1, filename => "$prefix.directed.diameter.out", directed => 1);
ok ($diam == 4);

$diam = $networkThreshold->diameter(max => 1, filename => "$prefix.undirected.diameter.out", undirected => 1);
ok ($diam == 4);

my ($link_avg_cos, $nl_avg_cos) = $networkThreshold->average_cosines(\%cos);
ok ($link_avg_cos > 0.309 and $link_avg_cos < 0.310);
ok ($nl_avg_cos > 0.02098 and $nl_avg_cos < 0.02099);

my ($link_hist, $nolink_hist) = $networkThreshold->cosine_histograms(\%cos);
my @lh = @$link_hist;
ok ($lh[29] == 6);
ok ($lh[36] == 2);

my @nlh = @$nolink_hist;
ok ($nlh[14] == 8);
ok ($nlh[8] == 10);

$networkThreshold->create_cosine_dat_files($old_prefix, \%cos, directory => $file_gen_dir);

my $dat_stats = $networkThreshold->get_dat_stats("$prefix", "$prefix.links", "$prefix.all.cos");
ok ($dat_stats =~ "cosine.*992.*\nnumber.*1692\nratio.*: 0.193.*\nratio.*: 0.0212.*\nratio.*: 0.0189.*\naverage.*0.05");

# Copied from gg.pl:

#
# Statistics Methods
#
sub clear_stats_file {
	unlink "$prefix.stats";
}

sub print_stat {
  my $name = shift;
	my $value = shift;
	my $date = `date`;
	chomp($date);
	open (STATS, ">>$prefix.stats");
	print STATS $name,": $value\n";
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
#	print `grep "^$name" $prefix.stats`;
}

sub not_exists_stat {
	my $name = shift;
	my $st = `grep "^$name" $prefix.stats`;
	return ($st =~ /^\s*$/);
}

# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
  my $filename = shift;

  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

