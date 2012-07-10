#!/usr/local/bin/perl

# script: test_lsi.pl
# functionality: Constructs a latent semantic index from a corpus of
# functionality: baseball and hockey documents, then uses that index
# functionality: to map terms, queries, and documents to latent semantic
# functionality: space. The position vectors of documents in that space
# functionality: are then used to train and evaluate a SVM classifier
# functionality: using the Weka interface provided in Clair::Interface::Weka

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Clair::Algorithm::LSI;
use Clair::Document;
use Clair::Cluster;
use Clair::Interface::Weka;

use vars qw(@ISA @EXPORT);


my $basedir   = $FindBin::Bin;
my $input_dir = "$basedir/input/lsi";
my $gen_dir   = "$basedir/produced/lsi";


my $index;
# Extract features for training, then for testing
for my $round (("train", "test")) {
	if ($round eq "train") {
		print "\n---LSI TRAINING ROUND---";
	} elsif ($round eq "test") {
		print "\n---LSI TEST ROUND---";
	}
	# Create a cluster
	my $c = new Clair::Cluster;
	$c->set_id("sports");

	# Read every document from the the the training or test directory and insert it into the cluster
	# Convert from HTML to text, then stem as we do so
	while ( <$input_dir/$round/*> ) {
		my $file = $_;

		my $doc = new Clair::Document(file => $file, type => 'html', id => $file);
		$doc->set_class(extract_class($doc->get_html(), $file));  # Set the document's class label
		$doc->strip_html;
		$doc->stem;

		$c->insert($file, $doc);
	}

	# Get the number of documents belonging to each class occurring in the cluster
	my %classes = $c->classes();
	print "\nExtracting ", $c->count_elements(), " documents ($round):\n";
	print "    " . $classes{'baseball'} . " baseball documents\n";
	print "    " . $classes{'hockey'} . " hockey documents\n";

	if ($round eq "train") {
		# On training round, construct document-term matrix and compute SVD (computationally extremely intensive)
		print "\nConstructing document-term matrix and computing its singular value decomposition...\n";
		$index = new Clair::Algorithm::LSI(cluster => $c, type => "stem");
		$index->build_index();
		print "  Done.\n";
	} elsif ($round eq "test") {
		# On test round, road the previously saved index
		print "\nLoading latent semantic index from file $gen_dir/sports.lsi...\n";
		$index = new Clair::Algorithm::LSI(file => "$gen_dir/sports.lsi",
										   cluster => $c);
		print "  Done.\n";
	}

	# For each document in the cluster, compute the position vector of the document in latent space
	# using the singular value decomposition of the document-term matrix
	$c->compute_document_feature(name => "latent_coord",
								 feature => \&compute_latent_space_position_vect);
	# Write this feature (actually vector of features) to ARFF, prepending the specified header
	my $header = "%1. Title: Baseball / Hockey Corpus Dataset ($round)\n" .
				 "%2. Source: 20_newsgroups Corpus\n" .
				 "%      (a) Creator: Ken Lang\n" .
				 "%\n";
	write_ARFF($c, "$gen_dir/$round.arff", $header);
	print "Features written to $gen_dir/$round.arff\n";

	if ($round eq "train") {
		# Train a support vector machine (SVM) using 10-fold cross-validation
		print "Training support vector machine (SVM) with 10-fold cross-validation...\n";
		train_classifier(classifier => 'weka.classifiers.functions.SMO',
						 trainfile  => "$gen_dir/train.arff",
						 modelfile  => "$gen_dir/SMO.model",
						 logfile    => "$gen_dir/train-10fold-SMO.log");
		print "  Done.\n";
		print "    See $gen_dir/train-crossval-SMO.log for log of classifier output from training and 10-fold cross-validation\n";

		# Perform various operations on the LSI to illustrate the functionality it provides
		print "\nAssorted LSI Operations:\n";
		my @docids = sort keys %{$c->documents()};
		my $firstdoc = $c->documents()->{$docids[0]};
		# Find documents similar near in latent semantic space to the (arbitrarily) first document in the corpus
		print "\n1.  10 documents most similar to the first \"" . $firstdoc->get_class() . "\" document:\n";
		my %doc_dists = $index->rank_docs($firstdoc);
		@docids = sort {$doc_dists{$a} <=> $doc_dists{$b} } keys %doc_dists;
		for (my $i=0; $i < 10; $i++) {
			my $class = $c->get($docids[$i])->get_class();
			print "      $docids[$i]\tclass: $class\tdistance: $doc_dists{$docids[$i]}\n";
		}
		# Find documents far away from that document
		print "\n    10 documents least similar to the first \"" . $firstdoc->get_class() . "\" document:\n";
		@docids = sort {$doc_dists{$b} <=> $doc_dists{$a} } keys %doc_dists;
		for (my $i=0; $i < 10; $i++) {
			my $class = $c->get($docids[$i])->get_class();
			print "      $docids[$i]\tclass: $class\tdistance: $doc_dists{$docids[$i]}\n";
		}
		# Find terms near in latent semantic space to the term "hockey"
		print "\n2.  20 terms contextually most related to \"hockey\":\n";
		my %term_dists = $index->rank_terms("hockey");
		my @terms = sort {$term_dists{$a} <=> $term_dists{$b} } keys %term_dists;
		for (my $i=0; $i < 20; $i++) {
			print "        $terms[$i]      \tdistance: $term_dists{$terms[$i]}\n";
		}
		# Find terms near in latent semantic space to the term "playoff" (which denotes baseball)
		print "\n2.  20 terms contextually most related to \"playoff\":\n";
		%term_dists = $index->rank_terms("playoff");
		@terms = sort {$term_dists{$a} <=> $term_dists{$b} } keys %term_dists;
		for (my $i=0; $i < 20; $i++) {
			print "        $terms[$i]  \tdistance: $term_dists{$terms[$i]}\n";
		}

		# Order the following queries first by nearness in semantic space to the term "hockey",
		# then by nearness in semantic space to the term "playoff"
		my @queries = ("goalie stops puck",
					   "pitcher throws to catcher",
					   "extra innings",
					   "overtime");
		print "\n3.  Set of unordered queries:\n";
		print "        " . join("\n        ", @queries);
		print "\n    Ordered by contextual relationship to query \"hockey\":\n";
		my %query_dists = $index->rank_queries("hockey", @queries);
		my @ordered = sort {$query_dists{$a} <=> $query_dists{$b} } keys %query_dists;
		foreach my $query (@ordered) {
			print "        \"$query\"\t\t\tdistance: $query_dists{$query}\n";
		}
		print "    Ordered by contextual relationship to query \"playoff\":\n";
		%query_dists = $index->rank_queries("playoff", @queries);
		@ordered = sort {$query_dists{$a} <=> $query_dists{$b} } keys %query_dists;
		foreach my $query (@ordered) {
			print "        \"$query\"\t\t\tdistance: $query_dists{$query}\n";
		}

		# Save latent semantic index to file
		print "\nSaving latent semantic index to file $gen_dir/sports.lsi...\n";
		$index->save_to_file("$gen_dir/sports.lsi", savecluster => 0);
		print "  Done.\n";
	}
	elsif ($round eq "test") {
		# Test the classifier directly on the test set, outputting predictions for individual documents
		print "Testing SVM predictions...\n";
		my $test_log = test_classifier(classifier => 'weka.classifiers.functions.SMO',
									   modelfile => "$gen_dir/SMO.model",
								       testfile  => "$gen_dir/test.arff",
								       predfile  => "$gen_dir/test-SMO.pred",
								       logfile   => "$gen_dir/test-SMO.log");
		print "    See $gen_dir/test-SMO.log for log of classifier output from testing\n";
		print "    See $gen_dir/test-SMO.pred for log of classifier predictions from testing\n";
	}
}

# Delete the latent semantic index from disk (the file is quite large)
unlink "$gen_dir/sports.lsi";

print "\nHave a nice day!\n";



# ---AUXILIARY PROCEDURES---

# Extract a document's class
sub extract_class {
    my $html = shift;
    my $file = shift;

    my $label = $1 if ($html =~ m/<DOC GROUP="rec\.sport\.(\w+?)">/);
    die "extract_class - Class label not found in $file" if not defined $label;
    return $label;
}

# Compute a document's position in latent semantic space as that space is defined by the singular value
# decomposition (and dimensionality reduction of that decomposition) of the document-term matrix of the
# cluster
sub compute_latent_space_position_vect {
	my %params = @_;
	my $docref = $params{document};

	my $v = $index->doc_to_latent_space($docref);
	my @vect;
	foreach my $elem (list $v) {
		push @vect, $elem;
	}

	return \@vect;
}
