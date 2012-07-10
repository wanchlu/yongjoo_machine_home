#!/usr/bin/perl -w
# script: link_synthetic_collection.pl
# functionality: Links a collection using a certain network generator
# Usage: $0
#         -n <name_of_new_corpus>
#         -c <input_collection>
#         -l <link_policy>, any of: {radev, menczer, erdos, watts}
#
# The following arguments are required by the specified policies:
#
# Option and value                Policies                Argument Type
#  -p <link_probability>        erdos, watts                positive float [0,1]
#  -k <k-parameter>                watts                        positive integer
#  -w <term_weight_file>        radev                        path to term weight file
#  -s <sigmoid_steepness>        radev, menczer                positive float
#  -t <sigmoid_threshold>        radev, menczer                positive float
#  -r <probability_reserve>        radev                         positive float
use strict;

use Getopt::Long;

use Clair::SyntheticCollection;
use Clair::LinkPolicy::WattsStrogatz;
use Clair::LinkPolicy::ErdosRenyi;
use Clair::LinkPolicy::MenczerMacro;
use Clair::LinkPolicy::RadevMicro;

# Default error
sub usage {
  die "
Usage: $0
         -n <name_of_new_corpus>
         -b <base_directory_of_new_corpus>
         -c <name_of_input_synthetic_collection>
         -d <base_directory_of_input_collection>
         -l <link_policy>, any of: {radev, menczer, erdos, watts}

 The following arguments are required by the specified policies:

 Option and value                Policies                Argument Type
  -p <link_probability>                erdos, watts                positive float [0,1]
  -k <num_neighbors>                watts                        positive integer
  -w <term_weight_file>                radev                        term weight file
  -s <sigmoid_steepness>        radev, menczer                positive float
  -t <sigmoid_threshold>        radev, menczer                positive float
  -r <probability_reserve>        radev                         positive float\n\n";
}

my $corpus_name = "";
my $base_dir = "produced";
my $new_dir = "";
my $new_name = "";
my $link_policy = "";
my $num_neighbors = -1;
my $link_prob = -1;
my $term_weight_file = "";
my $sigmoid_steepness = -1;
my $sigmoid_threshold = -1;
my $prob_reserve = -1;
my $verbose = -1;

my $res = GetOptions("corpus=s" => \$corpus_name, "directory=s" => \$base_dir,
                     "name=s" => \$new_name, "base=s" => \$new_dir,
                     "k=i" => \$num_neighbors,
                     "link=s" => \$link_policy,
                     "probability=f" => \$link_prob,
                     "weight=s" => \$term_weight_file,
                     "steepness=f" => \$sigmoid_steepness,
                     "threshold=f" => \$sigmoid_threshold,
                     "reserve=f" => \$prob_reserve,
                     "verbose" => \$verbose);

# We need at least -n, -c, -l
unless (($corpus_name ne "") && ($new_name ne "") &&
        ($link_policy ne "")) { usage(); }

# Make sure we can open the existing collection.
# (should croak here if collection does not exist)
my $synthdox = Clair::SyntheticCollection->new (name => $corpus_name,
                                                base => $base_dir,
                                                mode => "read_only");

my $new_corpus;

# Verify additional args and create the appropriate corpus.
if ($link_policy eq "radev") {
  # verify args
  unless (($term_weight_file ne "") && ($sigmoid_steepness ne -1) &&
          ($sigmoid_threshold ne -1) && ($prob_reserve ne -1)) { usage() }

  # create corpus
  $new_corpus = Clair::LinkPolicy::RadevMicro->new(base_collection =>
                                                   $synthdox,
                                                   base_dir => $new_dir);
  $new_corpus->create_corpus(corpus_name       => $new_name,
                             term_weights      => $term_weight_file,
                             sigmoid_steepness => $sigmoid_steepness,
                             sigmoid_threshold => $sigmoid_threshold,
                             prob_reserve      => $prob_reserve);

} elsif ($link_policy eq "menczer") {
  # verify args
  unless (($sigmoid_steepness ne -1) && ($sigmoid_threshold ne -1)) { usage() }

  # create corpus
  $new_corpus = Clair::LinkPolicy::MenczerMacro->new(base_collection =>
                                                     $synthdox,
                                                     base_dir => $new_dir);
  $new_corpus->create_corpus(corpus_name       => $new_name,
                             sigmoid_steepness => $sigmoid_steepness,
                             sigmoid_threshold => $sigmoid_threshold);

} elsif ($link_policy eq "erdos") {
  # verify args
  unless ($link_prob ne -1) { usage() }

  # create corpus
  $new_corpus = Clair::LinkPolicy::ErdosRenyi->new(base_collection =>
                                                   $synthdox,
                                                   base_dir => $new_dir);
  $new_corpus->create_corpus(corpus_name => $new_name,
                             link_prob   => $link_prob);

} elsif ($link_policy eq "watts") {
  # verify args
  unless (($link_prob ne -1) && ($num_neighbors ne -1)) { usage() }

  # create corpus
  $new_corpus = Clair::LinkPolicy::WattsStrogatz->new(base_collection =>
                                                      $synthdox,
                                                      base_dir => $new_dir);
  $new_corpus->create_corpus(corpus_name   => $new_name,
                             link_prob     => $link_prob,
                             num_neighbors => $num_neighbors);
} else { usage(); }
