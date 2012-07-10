#!/usr/bin/perl
#
# script: network_growth.pl
# functionality: Generates graphs for queries in web search engine
# functionality: query logs and measures network statistics
# 
# The network edges are updated every time new word (in the ranked word list) 
# is included in measuring the similarities of queries.
# Based on code by Xiaodong Shi
#

use strict;
use warnings;

use File::Path;
use Getopt::Long;
use Clair::Network;
use Clair::Corpus;
use Clair::Cluster;

sub usage;

#my $word_freqs = "sorted_word_freqs_from_50000q.stat";
my $in_file = "sorted_word_freqs_from_1000q.stat";
my $stat_file = "net.stat";
my $delim = "\t\t";
my $sample_size = 1000;
my $corpus_name = "";
my $basedir = "produced";
my $min_freq = 2;
my $verbose = 0;

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$basedir,
                     "wordfreqs=s" => \$in_file, "delim=s" => \$delim,
                     "sample=i" => \$sample_size, "t=s" => \$stat_file,
		     "minfreq=i" => \$min_freq, "verbose" => \$verbose);

if ($corpus_name eq "") {
  usage();
}

my $corpus = Clair::Corpus->new(corpusname => "$corpus_name",
                                rootdir => "$basedir");

if ($verbose) { print "Loading corpus into cluster\n"; }
my $cluster = new Clair::Cluster;
$cluster->load_corpus($corpus);

#
# 1. Read the corpus file to get the document content
#

my @queries = ();
my %query_hash = ();
my $line_num = 0;

my $docs = $cluster->documents();
foreach my $did (keys %{$docs}) {
  my $doc = $docs->{$did};
  $doc->strip_html();
  my @sents = $doc->get_sentences();
  foreach my $line (@sents) {
    chomp $line;
    # $line = lc($line);
    $line_num++;
    $queries[$line_num-1] = $line;

    if (not defined $query_hash{$line}) {
      $query_hash{$line} = 1;
    } else {
      $query_hash{$line} = $query_hash{$line} + 1;
    }
  }
}

#
# 2. Read the words and their ranked frequencies from input file.
#

my %freq = $corpus->get_term_counts();

print "Reading finished!\n";
print "Reversing the order of sorted words ...\n";

# Reverse the order of words
my @words = sort { $freq{$a} cmp $freq{$b} } keys %freq;
my %word_rank_hash = ();
my @r_words = ();
my $size = scalar(keys %freq);

for (my $i = 0; $i < $size; $i++) {
  $r_words[$i] = $words[$size - 1 - $i];

  if (exists $word_rank_hash{$r_words[$i]}) {
  } else { 
    $word_rank_hash{$r_words[$i]} = $i + 1;
  }
}

print "Total ", $size, " words. Order reversed!\n";
print "Size of word_rank_hash table: ", scalar(keys %word_rank_hash), "\n";

#
# 3. Take one word each time and build the graph
# 

my $network = Clair::Network->new();
#my $out_file = "$corpus_name.edges";
#if (!(-d $out_file)) {
#  mkpath ($out_file, 1, 0777);
#}
my $out_file = "$corpus_name.wordmodel.nodes";

open (FOUT, ">$out_file") or die "Could not open output file $out_file: $!\n";
print "Writing network nodes to output file $out_file ...\n";

my @qs = keys %query_hash;
foreach (my $i = 0; $i < scalar(@qs); $i++) {
  # add queries to the graph
  $network->add_node($i + 1, $qs[$i]);
  print FOUT (($i+1) .  "\t" . $qs[$i] . "\n");
}

close FOUT;

print "Num. Nodes written: ", $network->num_nodes(), "\n";

# Output network edges into file
#$out_file = $out_dir . "/" . $corpus_name . "/graph";  
#if (!(-d $out_file)) {
#  mkpath ($out_file, 1, 0777);
#}
#$out_file = $out_file . "/edges";
$out_file = "$corpus_name.wordmodel.edges";
open (FOUT, ">$out_file") or die "Could not open output file $out_file: $!\n";
print "Writing network edges to output file $out_file ...\n";

# Output the network statistics into file
#my $net_stat_file = $out_dir . "/" . $corpus_name . "/stats"; 
#if (!(-d $net_stat_file)) {
#  mkpath ($net_stat_file, 1, 0777);
#}
#$net_stat_file = $net_stat_file . "/net.stat";
my $net_stat_file = "$corpus_name.wordmodel.stats";
open (STAT, ">$net_stat_file") or die "Could not open network stats file $net_stat_file: $!\n"; 

print STAT "threshold nodes edges diameter lcc avg_short_path watts_strogatz_cc newman_cc in_link_power in_link_power_rsquared in_link_pscore in_link_power_newman in_link_power_newman_error out_link_power out_link_power_rsquared out_link_pscore out_link_power_newman out_link_power_newman_error total_link_power total_link_power_rsquared total_link_pscore total_link_power_newman total_link_power_newman_error avg_degree\n";

# loop through all distinct queries and add one word at a time; 
# determine if two queries share a common word ranked higher than the added
# word;
for (my $n = 0; $n < $size; $n++) {
  # only if the word appears in more than 1 query, we can measure whether two
  # queries share that same word
  if ((defined $freq{$r_words[$n]}) and ($freq{$r_words[$n]} >= $min_freq)) {
	
  # if there is one of the four conditions, then run the iteration: 
  #    1. the next word has a different frequency from the current one
  #    2. the current word is the first one with frequency equal to min_freq
  #    3. the current word is the first word in the ranked list and its frequency is greater than min_freq (evaluated in the above statement).
  #    4. the current word is the k*50-th in the ranked list. 

  if ((($n < $size - 1) && ($freq{$r_words[$n+1]} ne $freq{$r_words[$n]}))
      || (($n > 0) && ($freq{$r_words[$n - 1]} < $min_freq))
      || ($n % 50 eq 0)) {
    for (my $x = 0; $x < scalar(@qs) - 1; $x++) {
      for (my $y = $x + 1; $y < scalar(@qs); $y++) {
        if (!($network->has_edge($x + 1, $y + 1))) {
          my $k = 0;
          # split the document into word tokens
          my @x_tokens = split(/ /, $qs[$x]);
          my @y_tokens = split(/ /, $qs[$y]);
			
			
          foreach my $x_token (@x_tokens) {
                    
            if ((defined $word_rank_hash{$x_token}) and
                ($word_rank_hash{$x_token} <= $n + 1)) {
              foreach my $y_token (@y_tokens) {
                if ($x_token eq $y_token) {
                  # for simplicity, we don't count the num of
                  # cooccurances of words in them, so we use binary
                  # values instead.
                  $k++;
                  last;
                }
              }
            }
          }

          if ($k > 0) {
            $network->add_edge($x + 1, $y + 1); 
            print FOUT (($x+1) . "\t" . ($y+1) . "\t" . ($n+1) . "\n"); 
            $network->set_edge_weight($x + 1, $y + 1, 1); 
          }
        }
      }
    }

    print $n + 1 . "\tNum. Edges: " . ($network->num_links()) . "\n";

    my $stat_string = "";
    if ($network->num_links() eq 0) {
      $stat_string = $network->num_nodes() . " " . $network->num_links() . " ";
      $stat_string = $stat_string .
        "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n";
    } else {
      $stat_string = $network->get_network_info_as_string();
    }

    # write network statistics to the file
    print STAT ($n + 1) . " " . $stat_string . "\n";
  }
}
}

close FOUT;
close STAT;


#
# prompt the user about the correct usage of this script
#
sub usage {
  print "usage: $0 --corpus corpus_name [-f query_log_file] [-i sorted_words_input_file]";
  print "[-s sample_size] [-m min_word_frequency] [-t net_stat_file]\n";
  print "  --corpus, -c corpus_name\n";
  print "          Name of corpus to load\n";
  print "  --sample, -s sample_size\n";
  print "          Calculate statistics for a sample of the network\n";
  print "          By default uses random edge sampling\n";
  print "  --minword, -m min_word_frequency\n";
  print "  -t net_stat_file\n";
  print "\n";
  print "example: $0 -c aol-10000 -f 100000.q ";
  print "-i sorted_word_freqs_from_100000q.stat ";
  print "-s 10000 -m 2 -t aol-10000-query-net.stat\n";
  exit;
}
