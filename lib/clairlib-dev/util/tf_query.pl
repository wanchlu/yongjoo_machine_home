#!/usr/local/bin/perl
# script: tf_query.pl
# functionality: Looks up tf values for terms in a corpus
#
# Based on test/test_lookupTFIDF.pl in clairlib

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use Clair::Config;
use Clair::Utils::Tf;
use Clair::Utils::CorpusDownload;

sub usage;

my $corpus_name ="";
my $query = "";
my $stemmed = 0;
my $all = 1;
my $basedir = "";
my $verbose = '';
my @phrase = ();

my $vars = GetOptions("corpus=s" => \$corpus_name,
                     "query=s" => \$query,
                     "basedir=s" => \$basedir,
                     "all" => \$all,
                     "stemmed" => \$stemmed,
                     "verbose" => \$verbose);

if( $corpus_name eq "" ) {
  usage();
  exit;
}

if( $query ne "" ){
	$all = 0;
}

$Clair::Utils::Tf::verbose = $verbose;

if ( $basedir eq "" ) {
	$basedir = "produced";
}
my $gen_dir = "$basedir";

if ($verbose) { print "Loading tf for $corpus_name in $gen_dir\n"; };
my $tf = Clair::Utils::Tf->new(rootdir => "$gen_dir",
                               corpusname => $corpus_name,
                               stemmed => $stemmed);

if( $all ){

	# Use Clair::Utils::CorpusDownload::get_term_counts()
	my $cd = Clair::Utils::CorpusDownload->new(rootdir => "$gen_dir",
                                             corpusname => $corpus_name);
	my %tfs = $cd->get_term_counts(stemmed => $stemmed);
	if( keys(%tfs) == 0 ){
		print "No term counts found.  Perhaps you need to run index_corpus.pl?\n";
	}else{
		foreach my $key (sort keys %tfs) {
			my $freq = $tf->getFreq($key);
    	my $res = $tf->getNumDocsWithWord($key);
			print "$key $freq $res\n";
		}
	}

}else{

  @phrase = split / /, $query;

	my $urls = $tf->getDocsWithPhrase(@phrase);

	if ($verbose) {
		my $res = $tf->getNumDocsWithPhrase(@phrase);
		my $freq = $tf->getPhraseFreq(@phrase);

		print "TF($query) = $freq total in $res docs\n"; 
		print "Documents with \"$query\"\n";
	}

	foreach my $url (keys %{$urls})  {
#		my ($url_freq, $match_hash) = $tf->getPhraseFreqInDocument(\@phrase, url => $url);
#		print "  $url: $url_freq\n";
		my $positions = $urls->{$url};
		my $freq = scalar(keys %$positions);
		print "  $url: $freq\n";
	}
}
sub usage
{
	print "$0: Run TF queries\n";
	print "usage: $0 -c corpus_name -q query [-b base_dir]\n\n";
	print "  --basedir base_dir\n";
	print "       Base directory filename.  The corpus is generated here\n";
	print "  --corpus corpus_name\n";
	print "       Name of the corpus\n";
	print "  --query query\n";
	print "       Term or phrase to query. Enclose phrases in quotes\n";
	print "  --stemmed\n";
	print "       If set, uses stemmed terms.  Default is unstemmed.\n";
	print "  --all\n";
	print "       Prints frequency for all terms(format: term frequency documents)\n";
	print "\n";

	print "example: $0 -c kzoo -q Michigan -b /data0/projects/lexnets/pipeline/produced\n";

	exit;
}

