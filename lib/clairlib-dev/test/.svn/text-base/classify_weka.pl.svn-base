#!/usr/local/bin/perl

# script: test_classify_weka.pl
# functionality: Extracts bag-of-words features from each document
# functionality: in a training corpus of baseball and hockey documents,
# functionality: then trains and evaluates a Weka decision tree classifier,
# functionality: saving its output to files

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Clair::Document;
use Clair::Cluster;
use Clair::Interface::Weka;;

my $basedir   = $FindBin::Bin;
my $input_dir = "$basedir/input/classify";
my $gen_dir   = "$basedir/produced/classify";



# ---FEATURE EXTRACTION PHASE---
	print "\n---FEATURE EXTRACTION PHASE---";

	# Extract features for training, then for testing
	for my $round (("train", "test")) {
		# Create a cluster
		my $c = new Clair::Cluster;
		$c->set_id("sports");

		# Read every document from the the the training or test directory and insert it into the cluster
		# Convert from HTML to text, then stem as we do so
		while ( <$input_dir/$round/*> ) {
			my $file = $_;

			my $doc = new Clair::Document(type => 'html', file => $file, id => $file);
			$doc->set_class(extract_class($doc->get_html(), $file));  # Set the document's class label
			$doc->strip_html;
			$doc->stem;

			$c->insert($file, $doc);
		}
		# Compute the bag-of-words feature (which actually constitutes a vector) for each document in the cluster
		$c->compute_document_feature(name => "vect", feature => \&compute_bag_of_words_vect);

		# Get the number of documents belonging to each class occurring in the cluster
		my %classes = $c->classes();
		print "\nExtracting ", $c->count_elements(), " documents to $round:\n";
		print "    " . $classes{'baseball'} . " baseball documents\n";
		print "    " . $classes{'hockey'} . " hockey documents\n";

		# Write features to ARFF, prepending the specified header
		my $header = "%1. Title: Baseball / Hockey Corpus Dataset ($round)\n" .
					 "%2. Source: 20_newsgroups Corpus\n" .
					 "%      (a) Creator: Ken Lang\n" .
					 "%\n";
		write_ARFF($c, "$gen_dir/$round.arff", $header);
		print "Features written to $gen_dir/$round.arff\n";
	}


# ---TRAINING PHASE---
	print "\n---TRAINING PHASE---\n";

	# Train a J48 decision tree classifier using 10-fold cross-validation
	print "Training J48 decision tree classifier with 10-fold cross-validation...\n";
	train_classifier(classifier => 'weka.classifiers.trees.J48',
					 trainfile  => "$gen_dir/train.arff",
					 modelfile  => "$gen_dir/J48.model",
					 logfile    => "$gen_dir/train-10fold-J48.log");
	print "    See $gen_dir/train-crossval-J48.log for log of classifier output from training and 10-fold cross-validation\n";

	# Train a J48 decision tree classifier using cross-validation on the test set
	print "Training J48 decision tree classifier with cross-validation on test set...\n";
	my ($train_10fold_log, $train_test_log) = train_classifier(classifier => 'weka.classifiers.trees.J48',
															   trainfile  => "$gen_dir/train.arff",
															   modelfile  => "$gen_dir/J48.model",
															   testfile   => "$gen_dir/test.arff",
															   logfile    => "$gen_dir/train-test-J48.log");
	print "    See $gen_dir/train-crossval-J48.log for log of classifier output from training and cross-validation on $gen_dir/test.arff\n";


# ---TESTING PHASE---
	print "\n---TESTING PHASE---\n";
	print "Testing classifier predictions...\n";
	# Test the classifier directly on the test set, outputting predictions for individual documents
	my $test_log = test_classifier(classifier => 'weka.classifiers.trees.J48',
								   modelfile => "$gen_dir/J48.model",
								   testfile  => "$gen_dir/test.arff",
								   predfile  => "$gen_dir/test-J48.pred",
								   logfile   => "$gen_dir/test-J48.log");
	print "    See $gen_dir/test-J48.log for log of classifier output from testing\n";
	print "    See $gen_dir/test-J48.pred for log of classifier predictions from testing\n";


# ---DONE---
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


# Compute the bag-of words feature from 10 pre-selected features (these features were culled earlier
# from the entire set of stemmed terms occurring in the corpus using chi square feature selection)
sub compute_bag_of_words_vect {
	my %params = @_;
	my $docref = $params{document};

	my %tf = $docref->tf(type => "stem");
	my %vect;
	$vect{'hockei'} = $tf{'hockei'}   || 0;
	$vect{'nhl'} = $tf{'nhl'}         || 0;
	$vect{'playoff'} = $tf{'playoff'} || 0;
	$vect{'pitch'} = $tf{'pitch'}     || 0;
	$vect{'basebal'} = $tf{'basebal'} || 0;
	$vect{'goal'} = $tf{'goal'}       || 0;
	$vect{'cup'} = $tf{'cup'}         || 0;
	$vect{'ca'} = $tf{'ca'}           || 0;
	$vect{'bat'} = $tf{'bat'}         || 0;
	$vect{'pitcher'} = $tf{'pitcher'} || 0;

	return \%vect;
}
