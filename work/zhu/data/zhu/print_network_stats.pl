#!/usr/bin/perl
#
# script: print_network_stats.pl
# functionality: Prints various network statistics
#
use strict;
use warnings;

use Getopt::Long;
use File::Spec;
use Clair::Cluster;
use Clair::Network qw($verbose);
use Clair::Network::Centrality::Betweenness;
use Clair::Network::Centrality::Closeness;
use Clair::Network::Centrality::Degree;
use Clair::Network::Centrality::LexRank;
use Clair::Network::CFNetwork;
use Clair::Network::Sample::RandomEdge;
use Clair::Network::Sample::ForestFire;
use Clair::Network::Reader::Edgelist;
use Clair::Network::Writer::Edgelist;
use Clair::Network::Writer::GraphML;
use Clair::Network::Writer::Pajek;

sub usage;

my $delim = "[ \t]+";
my $sample_size = 0;
my $sample_type = "randomedge";
my $fname = "";
my $out_file = "";
my $pajek_file = "";
my $graphml_file = "";
my $extract = 0;
my $stem = 1;
my $undirected = 0;
my $wcc = 0;
my $scc = 0;
my $components = 0;
my $paths = 0;
my $triangles = 0;
my $assortativity = 0;
my $local_cc = 0;
my $all = 0;
my $output_delim = " ";
my $stats = 1;
my $degree_centrality = 0;
my $closeness_centrality = 0;
my $betweenness_centrality = 0;
my $lexrank_centrality = 0;
my $force = 0;
my $graph_class = "";
my $filebased = 0;
my $cf = 0;
my $multiedge = 0;
my $verbose = 0;

my $res = GetOptions("input=s" => \$fname, "delim=s" => \$delim,
                     "delimout=s" => \$output_delim,
                     "output:s" => \$out_file, "pajek:s" => \$pajek_file,
                     "graphml:s" => \$graphml_file,
                     "sample=i" => \$sample_size,
                     "sampletype=s" => \$sample_type,
                     "extract!" => \$extract,
                     "stem!" => \$stem, "undirected" => \$undirected,
                     "components" => \$components, "paths" => \$paths,
                     "wcc" => \$wcc, "scc" => \$scc,
                     "triangles" => \$triangles, "verbose!" => \$verbose,
                     "assortativity" => \$assortativity,
                     "localcc" => \$local_cc, "stats!" => \$stats,
                     "all" => \$all, "cf" => \$cf,
                     "betweenness-centrality" => \$betweenness_centrality,
                     "degree-centrality" => \$degree_centrality,
                     "closeness-centrality" => \$closeness_centrality,
                     "lexrank-centrality" => \$lexrank_centrality,
                     "force" => \$force,
                     "graph-class=s" => \$graph_class,
                     "filebased" => \$filebased,
                     "multiedge" => \$multiedge);

my $directed = not $undirected;
$Clair::Network::verbose = $verbose;

my $vol;
my $dir;
my $prefix;
($vol, $dir, $prefix) = File::Spec->splitpath($fname);
$prefix =~ s/\.graph//;
if ($all) {
  # Enable all options
  if ($directed) {
    $wcc = 1;
    $scc = 1;
  } else {
    $components = 1;
  }
  $triangles = 1;
  $paths = 1;
  $assortativity = 1;
  $local_cc = 1;
  $betweenness_centrality = 1;
  $degree_centrality = 1;
  $closeness_centrality = 1;
  $lexrank_centrality = 1;
}

if (!$res or ($fname eq "")) {
  usage();
}

my $fh;
my @hyp = ();

# make unbuffered
select STDOUT; $| = 1;

if ($verbose) {
  print "Reading in " . ($directed ? "directed" : "undirected") .
    " graph file\n";
}

my $reader = Clair::Network::Reader::Edgelist->new();
my $net;
my $graph;

if ($graph_class ne "") {
  eval("use $graph_class;");
  $graph = $graph_class->new(directed => $directed,
  														multiedge => $multiedge);
  $net = $reader->read_network($fname, graph => $graph,
                               delim => $delim,
                               directed => $directed,
                               filebased => $filebased,
                               multiedge => $multiedge);
} else {
  $net = $reader->read_network($fname,
                               delim => $delim,
                               directed => $directed,
                               filebased => $filebased,
                               edge_property => "lexrank_transition",
                               multiedge => $multiedge);
}


# Sample network if requested
if ($sample_size > 0) {
  if ($sample_type eq "randomedge") {
    if ($verbose) {
      print STDERR "Sampling $sample_size edges from network using random edge algorithm\n"; }
    my $sample = Clair::Network::Sample::RandomEdge->new($net);
    $net = $sample->sample($sample_size);
  } elsif ($sample_type eq "forestfire") {
    if ($verbose) {
      print STDERR "Sampling $sample_size nodes from network using Forest Fire algorithm\n"; }
    my $sample = Clair::Network::Sample::ForestFire->new($net);
    $net = $sample->sample($sample_size, 0.7);
  }
  elsif ($sample_type eq "randomnode")
   {
     if ($verbose) {
       print STDERR "Sampling $sample_size nodes from network usiná random node algorithm\n"; }
       my $sample = Clair::Network::Sample::RandomNode->new($net);
       $sample->number_of_nodes($sample_size);
       $net = $sample->sample();
   }

}

if ((($net->num_documents > 2000) or ($net->num_links > 4000000)) and
    (!$force) and (!$filebased)) {
  my $error_msg;
  $error_msg .= "Network is too large";
  if ($net->num_documents > 2000) {
    $error_msg .= " (" . $net->num_documents . " > 2000 nodes)";
  }
  if ($net->num_pairs > 4000000) {
    $error_msg .= " (" . $net->num_pairs . " > 4000000 edges)";
  }
  $error_msg .= ", please use sampling\n";
  die $error_msg;
}

# If graphviz dotfile is specified, dump network to that file
#if ($fname ne "") {
#  output_graphviz($net, $out_file);
#}

# If Pajek file is specified, dump network to that file
if ($pajek_file ne "") {
  my $export = Clair::Network::Writer::Pajek->new();
  $export->set_name("pajek");
  $export->write_network($net, "$pajek_file");
}

# If GraphML file is specified, dump network to that file
if ($graphml_file ne "") {
  my $export = Clair::Network::Writer::GraphML->new();
  $export->set_name($fname);
  $export->write_network($net, "$graphml_file");
}

if ($out_file ne "") {
  my $export = Clair::Network::Writer::Edgelist->new();
  $export->write_network($net, $out_file);
}

my $component_net;
if ($extract) {
  # Find the largest connected component
  if ($verbose) { print "Extracting largest connected component\n"; }
  print "Original network info:\n";
  print "  nodes: ", $net->num_nodes(), "\n";
  print "  edges: ", scalar($net->get_edges()), "\n";
  $component_net = $net->find_largest_component("weakly");
} else {
  $component_net = $net;
}

if ($stats) {
    $component_net->print_network_info(components => $components,
                                       wcc => $wcc, scc => $scc,
                                       paths => $paths,
                                       triangles => $triangles,
                                       assortativity => $assortativity,
                                       localcc => $local_cc,
                                       delim => $output_delim,
                                       verbose => $verbose);
}


# Get centrality measures
if ($degree_centrality) {
  my $degree = Clair::Network::Centrality::Degree->new($component_net);
  my $b = $degree->normalized_centrality();
  open(OUTFILE, "> $prefix.degree-centrality");
  foreach my $v (keys %{$b}) {
    print OUTFILE "$v$output_delim";
    printf OUTFILE '%.8f', $b->{$v};
    print OUTFILE "\n";
  }
  close OUTFILE;
}
if ($closeness_centrality) {
  my $closeness = Clair::Network::Centrality::Closeness->new($component_net);
  my $b = $closeness->normalized_centrality();
  open(OUTFILE, "> $prefix.closeness-centrality");
  foreach my $v (keys %{$b}) {
    print OUTFILE "$v$output_delim";
    printf OUTFILE '%.8f', $b->{$v};
    print OUTFILE "\n";
  }
  close OUTFILE;
}
if ($betweenness_centrality) {
  my $betweenness =
    Clair::Network::Centrality::Betweenness->new($component_net);
  my $b = $betweenness->normalized_centrality();
  open(OUTFILE, "> $prefix.betweenness-centrality");
  foreach my $v (keys %{$b}) {
    print OUTFILE "$v$output_delim";
    printf OUTFILE '%.8f', $b->{$v};
    print OUTFILE "\n";
  }
  close OUTFILE;
}

if ($lexrank_centrality) {
  # Set the cosine value to 1 on the diagonal
  foreach my $v ($component_net->get_vertices) {
    $component_net->set_vertex_attribute($v, "lexrank_transition", 1);
  }

  my $lexrank =
    Clair::Network::Centrality::LexRank->new($component_net);
  my $b = $lexrank->normalized_centrality();
  open(OUTFILE, "> $prefix.lexrank-centrality");
  foreach my $v (keys %{$b}) {
    print OUTFILE "$v$output_delim";
    printf OUTFILE '%.8f', $b->{$v};
    print OUTFILE "\n";
  }
  close OUTFILE;
}

# Community finding algorithms
# TODO: Add function to CFNetwork to import normal network and create
# labeled network
if ($cf) {
  my $gen_dir = "cf";
  my $cfn = new Clair::Network::CFNetwork(name => $prefix, unionfind => 1);

  # Copy network
  my $cnt = 1;
  my %node_hash = ();
  foreach my $v ($component_net->get_vertices) {
    $cfn->add_node($cnt, label => $v);
    $node_hash{$v} = $cnt;
    $cnt++;
  }
  foreach my $e ($component_net->get_edges) {
    my ($u, $v) = @$e;
    $cfn->add_edge($node_hash{$u}, $node_hash{$v});
  }

  if ($verbose) {
    print STDERR "checking, original # nodes: ", $component_net->num_nodes() . ", new: " .
      $cfn->num_nodes() . "\n";
    print STDERR "checking, original # nodes: ", $component_net->num_links() . ", new: " .
      $cfn->num_links() . "\n";
  }

  $cfn->communityFind(dirname => $gen_dir);
  $cfn->export2PajekProject(partition => 'best', dirname => $gen_dir);
}

#
# Print out usage message
#
sub usage
{
  print "usage: $0 [-e] [-d delimiter] -i file [-f dotfile]\n";
  print "or:    $0 [-f dotfile] < file\n";
  print "  --input file\n";
  print "          Input file in edge-edge format\n";
  print "  --delim delimiter\n";
  print "          Vertices in input are delimited by delimiter character\n";
  print "  --delimout output_delimiter\n";
  print "          Vertices in output are delimited by delimiter (can be printf format string)\n";
  print "  --force\n";
  print "          Ignore the 2000 nodes' limit";
  print "  --sample sample_size\n";
  print "          Calculate statistics for a sample of the network\n";
  print "          The sample_size parameter is interpreted differently for each\n";
  print "          sampling algorithm\n";
  print "  --sampletype sampletype\n";
  print "          Change the sampling algorithm, one of: randomnode, randomedge,\n";
  print "          forestfire\n";
  print "          randomnode: Pick sample_size nodes randomly from the original network\n";
  print "          randomedge: Pick sample_size edges randomly from the original network\n";
  print "          forestfire: Pick sample_size nodes randomly from the original network\n";
  print "                      using ForestFire sampling (see the tutorial for more\n";
  print "                      information)\n";
  print "          By default uses random edge sampling\n";
  print "  --output out_file\n";
  print "          If the network is modified (sampled, etc.) you can optionally write it\n";
  print "          out to another file\n";
  print "  --pajek pajek_file\n";
  print "          Write output in Pajek compatible format\n";
  print "  --extract,  -e\n";
  print "          Extract largest connected component before analyzing.\n";
  print "  --undirected,  -u\n";
  print "          Treat graph as an undirected graph, default is directed\n";
  print "  --scc\n";
  print "          Print strongly connected components\n";
  print "  --wcc\n";
  print "          Print weakly connected components\n";
  print "  --components\n";
  print "          Print components (for undirected graph)\n";
  print "  --paths,  -p\n";
  print "          Print shortest path matrix for all vertices\n";
  print "  --triangles,  -t\n";
  print "          Print all triangles in graph\n";
  print "  --assortativity,  -a\n";
  print "          Print the network assortativty coefficient\n";
  print "  --localcc,  -l\n";
  print "          Print the local clustering coefficient of each vertex\n";
  print "  --degree-centrality\n";
  print "          Print the degree centrality of each vertex\n";
  print "  --closeness-centrality\n";
  print "          Print the closeness centrality of each vertex\n";
  print "  --betweenness-centrality\n";
  print "          Print the betweenness centrality of each vertex\n";
  print "  --lexrank-centrality\n";
  print "          Print the LexRank centrality of each vertex\n";
  print "  --all\n";
  print "          Print all statistics for the network\n";
  print "  --self-loop";
  print "          Count the number of self loops in when calculating the harmonic mean geodesic distance using n*(n+1)/2 as numerator, default is using n*(n-1)/2\n";
  print "\n";
  print "example: $0 -i test.graph\n";
  print "\n";
  print "Example with sampling: $0 -i test.graph --sample 100 --sampletype randomnode\n\n";

  exit;
}
