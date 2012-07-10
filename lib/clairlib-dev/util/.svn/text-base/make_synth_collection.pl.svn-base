#!/usr/bin/perl
# script: make_synth_collection.pl
# functionality: Makes a synthetic document set based on a pre-existing corpus
#

use strict;
use warnings;

use File::Spec;
use Getopt::Long;

use Clair::Config;
use Clair::Document;
use Clair::Utils::CorpusDownload;
use Clair::SyntheticCollection;
use Clair::RandomDistribution::Gaussian;
use Clair::RandomDistribution::LogNormal;
use Clair::RandomDistribution::Poisson;
use Clair::RandomDistribution::RandomDistributionFromWeights;
use Clair::RandomDistribution::Zipfian;

sub usage;

my $corpus_name = "";
my $output_name = "";
my $output_dir = "";
my $base_dir = "produced";
my $term_policy = "";
my $doclen_policy = "";
my $n_gram = 1;
my $filetype = "html";
my $num_docs = 0;
my $verbose = 0;

# Distribution parameters
my $term_alpha = 0.0;
my $term_mean = 0.0;
my $term_variance = 0.0;
my $term_std_dev = 0.0;
my $term_lambda = 0.0;
my $term_weights_file = "";

my $doclen_alpha = 0.0;
my $doclen_mean = 0.0;
my $doclen_variance = 0.0;
my $doclen_std_dev = 0.0;
my $doclen_lambda = 0.0;

my $k = 0;
my $n = 0;

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$base_dir,
                     "size=i" => \$num_docs,
                     "term-policy=s" => \$term_policy,
                     "doclen-policy=s" => \$doclen_policy,
                     "output=s" => \$output_name,
                     "directory=s" => \$output_dir, "verbose!" => \$verbose,
		     "ngram=i" => \$n_gram,
                     "filetype=s" => \$filetype,
                     "term-alpha:f" => \$term_alpha,
                     "term-mean:f" => \$term_mean,
                     "term-variance:f" => \$term_variance,
                     "term-std_dev:f" => \$term_std_dev,
                     "term-lambda:f" => \$term_lambda,
                     "term-weights_file=s" => \$term_weights_file,
                     "doclen-alpha:f" => \$doclen_alpha,
                     "doclen-mean:f" => \$doclen_mean,
                     "doclen-variance:f" => \$doclen_variance,
                     "doclen-std_dev:f" => \$doclen_std_dev,
                     "doclen-lambda:f" => \$doclen_lambda,
                     "k:i" => \$k, "doc-size:i" => \$n);

if (!$res or ($num_docs == 0) or
    (($corpus_name eq "") and ($doclen_policy ne "constant")) or
    ($output_name eq "") or ($output_dir eq "") or ($term_policy eq "" && $n_gram == 1) or
    ($doclen_policy eq "") or ($filetype eq "" && $n_gram > 1)) {
  usage ();
  exit;
}

my $gen_dir = "$base_dir";

my $corpus_data_dir = "$gen_dir/corpus-data/$corpus_name";

my %doclen = ();
my %tc = ();
if ($doclen_policy ne "constant") {
  my $corpus = Clair::Utils::CorpusDownload->new(corpusname => "$corpus_name",
                                                 rootdir => "$gen_dir");

  # index the corpus
  my $pwd = `pwd`;
  chomp $pwd;

  # Get the document length distribution
  %doclen = $corpus->get_doc_len_dist();
  # Get term counts
  %tc = $corpus->get_term_counts();

  chdir $pwd;
} else {
  # Constant document length
  for (my $i = 0; $i < $num_docs; $i++) {
     $doclen{$i} = $n;
  }
}

my @doclen_weights = ();
my @lengths = ();
my @term_weights = ();
my @terms = ();

my $num_terms;
if ($k) {
  for (my $i = 0; $i <= $k; $i++) {
    # Convert to alpha
    my @ascii = unpack("C*", "$i");
    foreach my $c (@ascii) {
      $c += 49;
    }

    my $out = pack("C*", @ascii);
    push @terms, $out;
  }
  $num_terms = $k;
} else {
  $num_terms = scalar(keys %tc);
}

# Get document length weights
if ($doclen_policy ne "constant") {
  foreach my $j (sort {$doclen{$a} <=> $doclen{$b}} keys %doclen) {
    push @doclen_weights, $doclen{$j};
    if ($doclen_policy eq "mirror") {
      # Include the length of every document in the lengths parameter
      # If we're mirroring the document distribution
      for (my $m = 0; $m < $doclen{$j}; $m++) {
        push @lengths, $j;
      }
    } else {
      push @lengths, $j;
    }

  }
}

# Get term weights
foreach my $temp_term (sort {$tc{$b} <=> $tc{$a}} keys %tc) {
    push @term_weights, $tc{$temp_term};
    push @terms, $temp_term;
}

# Print term counts of the original corpus into a file
`mkdir $output_dir`;
open (SOURCETC, ">$output_dir/source_tc.txt") or
    die "Could not create file $output_dir/source_tc.txt\n";
for (my $t = 0; $t <= $#terms ; $t++) {
    print SOURCETC $terms[$t] . " " . $term_weights[$t] . "\n";
}
close (SOURCETC);

# If user specified weights, use that file instead of term counts
my @manual_term_weights = ();
if($term_policy eq "manualweights"){
    if($term_weights_file eq ""){
        usage();
    }
    open (WEIGHTFILE, "$term_weights_file") or die ("Can't open $term_weights_file.\n");
    my $line = "";
    while(<WEIGHTFILE>){
        $line = $_;
        chomp($line);
        $line =~ /(.+)\s+(\d+)/;
        $tc{$1} = $2;
    }
    close (WEIGHTFILE);
    # Get term weights
    @terms = ();
    foreach my $temp_term (sort {$tc{$b} <=> $tc{$a}} keys %tc) {
        push @manual_term_weights, $tc{$temp_term};
        push @terms, $temp_term;
    }
    unless (scalar(@manual_term_weights) == scalar (@term_weights)){
       die ("Number of terms doesn't match number of term weights.\n");
    }
}

my $a;
my $b;

if ($verbose) { print "Reading in term distribution...\n"; }

# The random distribution modules want the first element in the weights arrays to be meaningless
     print "$term_policy\n";
  print "test\n";
if ($term_policy eq "randomdistributionfromweights") {
    print "test2\n";

  unshift @term_weights, 0;

  $a = Clair::RandomDistribution::RandomDistributionFromWeights->new(weights
                                                                     => \@term_weights);
} elsif ($term_policy eq "manualweights"){
 unshift @manual_term_weights, 0;

 $a = Clair::RandomDistribution::RandomDistributionFromWeights->new(weights
                                                                     => \@manual_term_weights);
} elsif ($term_policy eq "gaussian") {
  $a = Clair::RandomDistribution::Gaussian->new(mean => $term_mean,
                                                variance => $term_variance,
                                                dist_size => $num_terms);
} elsif ($term_policy eq "lognormal") {
  $a = Clair::RandomDistribution::LogNormal->new(mean => $term_mean,
                                                 std_dev => $term_std_dev,
                                                 dist_size => $num_terms);
} elsif ($term_policy eq "poisson") {
  $a = Clair::RandomDistribution::Poisson->new(lambda => $term_lambda,
                                               dist_size => $num_terms);
} elsif ($term_policy eq "zipfian") {
    print "test2\n";
  $a = Clair::RandomDistribution::Zipfian->new(alpha => $term_alpha,
                                               dist_size => $num_terms);
}

if ($verbose) { print "Reading in document length distribution...\n"; }

if ($doclen_policy eq "randomdistributionfromweights") {
  unshift @doclen_weights, 0;

  $b = Clair::RandomDistribution::RandomDistributionFromWeights->new(weights =>
                                                                     \@doclen_weights);
} elsif ($doclen_policy eq "gaussian") {
  $b = Clair::RandomDistribution::Gaussian->new(mean => $doclen_mean,
                                                variance => $doclen_variance,
                                                dist_size => $num_docs);
} elsif ($doclen_policy eq "lognormal") {
  $b = Clair::RandomDistribution::LogNormal->new(mean => $doclen_mean,
                                                 std_dev => $doclen_std_dev,
                                                 dist_size => $num_docs);
} elsif ($doclen_policy eq "poisson") {
  $b = Clair::RandomDistribution::Poisson->new(lambda => $doclen_lambda,
                                               dist_size => $num_docs);
} elsif ($doclen_policy eq "zipfian") {
  $b = Clair::RandomDistribution::Zipfian->new(alpha => $doclen_alpha,
                                               dist_size => $num_docs);
}

# Ngram code

my @ngrams = ();
if($n_gram > 1) {
    if($n_gram > 4) {
	die "--ngram $n_gram needs to be between 1 and 4, inclusive";
    }

    print "Starting to process n-grams, filetype is \"$filetype\"\n" if($verbose);

    # First, we get all source files into one tempfile

    print "Consolidating source files...\n" if($verbose);
    my $input_file = "$corpus_name\_temp\.$filetype";
    `cat $gen_dir/download/$corpus_name/*/* > $input_file`;

    print "Getting sentences...\n" if($verbose);
    my $doc = new Clair::Document(file => "$input_file", type => "$filetype");
    my @sentences = $doc->get_sentences;

    # Print it out in the format we want into a temporary file
    print "Formatting sentences...\n" if($verbose);
    my $temp_filename = $input_file . "\_formatted-sentences";
    open(OUTPUT, ">" . "$temp_filename") or die "Can't open $temp_filename\n";
    print OUTPUT "<START> ";
    my $temp_string = "";
    for(my $i = 0; $i < scalar(@sentences); $i++){
	$temp_string = $sentences[$i];
	$temp_string =~ s/\s+/ /g;
	unless ($i == scalar(@sentences) - 1){ print OUTPUT "$temp_string <S>\n"; }
	else { print OUTPUT "$temp_string <END>\n"; }
    }
    close OUTPUT;

    # CMU-LM wants its input in UNIX format
    `dos2unix $temp_filename`;
    `chmod 0664 $temp_filename`;
    @sentences = undef; #conserve memory

    print "Calling text2wngram...\n\n" if($verbose);

    # Use CMU-LM to generate bigrams
    my $ngrams_file = $input_file . '.w' . $n_gram . 'gram';
    `cat $temp_filename | text2wngram -n $n_gram -temp /tmp > $ngrams_file`;

    `rm $temp_filename`;
    `rm $input_file`;
    $doc = undef;

    # Now, we load $ngrams_file to and array and pass it to Clair::SyntheticCollection
    print "Reading n-grams list to an array...\n" if($verbose);
    open (INPUT, "$ngrams_file");
    @ngrams = <INPUT>;
    close INPUT;

    `rm $ngrams_file`;
}


if ($verbose) { print "\nCreating collection\n"; }
my $col;
if ($doclen_policy eq "constant") {
  # All documents have the same length
    if($n_gram == 1) {
	$col = Clair::SyntheticCollection->new(name => $output_name,
					       base => $output_dir,
					       mode => "create_new",
					       term_map => \@terms,
					       term_dist => $a,
					       doc_length => $n,
					       size => $num_docs);
    }
    else {
	$col = Clair::SyntheticCollection->new(name => $output_name,
					       base => $output_dir,
					       mode => "create_new",
					       n_gram => $n_gram,
					       ngram_map => \@ngrams,
					       doc_length => $n,
					       size => $num_docs);
    }
} elsif ($doclen_policy eq "mirror") {
  # Mirror the lengths of the existing corpus
    if($n_gram == 1) {
	$col = Clair::SyntheticCollection->new(name => $output_name,
					       base => $output_dir,
					       mode => "create_new",
					       term_map => \@terms,
					       term_dist => $a,
					       doclen_dist => $b,
					       doclen_map => \@lengths,
					       mirror_doclen => 1,
					       size => $num_docs);
    }
    else {
	$col = Clair::SyntheticCollection->new(name => $output_name,
					       base => $output_dir,
					       mode => "create_new",
					       n_gram => $n_gram,
					       ngram_map => \@ngrams,
					       doclen_dist => $b,
					       doclen_map => \@lengths,
					       mirror_doclen => 1,
					       size => $num_docs);
    }
} else {
  # Use some random distribution of document lengths
    if($n_gram == 1) {
	$col = Clair::SyntheticCollection->new(name => $output_name,
					       base => $output_dir,
					       mode => "create_new",
					       term_map => \@terms,
					       term_dist => $a,
					       doclen_dist => $b,
					       doclen_map => \@lengths,
					       size => $num_docs);
    }
    else {
	$col = Clair::SyntheticCollection->new(name => $output_name,
					       base => $output_dir,
					       mode => "create_new",
					       n_gram => $n_gram,
					       ngram_map => \@ngrams,
					       doclen_dist => $b,
					       doclen_map => \@lengths,
					       size => $num_docs);
    }
}

if ($verbose) { print "Generating documents\n"; }
$col->create_documents();

#
# Print out usage message
#
sub usage
{
  print "$0\n";
  print "Generate a synthetic corpus\n";
  print "\n";
  print "usage: $0 -c corpus_name [-b base_dir]\n\n";
  print "  --output, -o name\n";
  print "       Name of the generated collection\n";
  print "  --directory output directory\n";
  print "       Directory to output generated collection in\n";
  print "  --corpus, -c corpus_name\n";
  print "       Name of the source corpus\n";
  print "  --base, -b base_dir\n";
  print "       Base directory filename.  The corpus is loaded from here\n";
  print "  --ngram {1, 2, 3, 4}\n";
  print "       N-gram size, if terms are to be generated using n-grams extracted from source files. Default is 1.\n";
  print "       (Note: --term-policy arguments will be ignored if --ngram is greater than 1, and\n";
  print "        RandomDistributionFromWeights will be used as ngram-policy.)\n";
  print "  --filetype {text, html, stem}\n";
  print "       File-type of source files. Only required if --ngram is greater than 1. This is necessary to extract n-grams from the source corpus.\n";
  print "  --term-policy, -t policy\n";
  print "       Term distribution: {gaussian, lognormal, poisson, zipfian, randomdistributionfromweights, manualweights}\n";
  print "  --doclen-policy\n";
  print "       Document length distribution: {gaussian, lognormal, poisson, zipfian, randomdistributionfromweights, constant, mirror}\n";
  print "  --size, -s number_of_documents\n";
  print "       Number of documents to generate\n";
  print "  --verbose,-v\n";
  print "       Increase debugging verbosity\n";
  print "\n";
  print " The following arguments are required by the specified policies:\n";
  print "Option and value    Policy               Argument Type\n";
  print "alpha               zipfian              positive float\n";
  print "mean                gaussian,lognormal   positive float\n";
  print "variance            gaussian             positive float\n";
  print "std_dev             lognormal            positive float\n";
  print "lambda              poisson              positive float\n";
  print "weights_file        manualweights        string\n";
  print "k                   constant             integer\n";
  print "   vocabulary size\n";
  print "doc-size            constant             integer\n";
  print "   number of terms in each document\n";
  print "\n";
  print "Example: $0 --output SynthCorpus --directory synth_out --corpus chemical --base produced --size 20 --term-policy zipfian --term-alpha 1 --doclen-policy mirror --verbose\n";

  exit;
}
