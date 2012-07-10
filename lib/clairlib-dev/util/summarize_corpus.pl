#!/usr/bin/perl
# script: summarize_corpus.pl
# functionality: Summarize a corpus

use strict;
use warnings;

use Getopt::Long;

use Clair::Document;
use Clair::SentenceFeatures qw(:all);
use Clair::Corpus;
use Clair::Cluster;

sub usage;

my $output_file = "";
my $corpus_name = "";
my $base="produced/";
my $size=10;
my $type="text";
my $verbose=0;
my $length;
my $centroid;
my $position;
my $sim_with_first;
my $preserve_order=0;

my $res = GetOptions("corpus=s" => \$corpus_name,
                     "base=s" => \$base,
                     "output=s" => \$output_file,
                     "max_sentences=i" => \$size,
                     "length=f" => \$length,
                     "centroid=f" => \$centroid,
                     "position=f" => \$position,
                     "sim_with_first=f" => \$sim_with_first,
                     "type=s"=> \$type,
                     "preserve_order!"=> \$preserve_order,
                     "verbose!" => \$verbose);

if (!$res or ($corpus_name eq "") or (not defined $length &&
    not defined $centroid && not defined $position &&
    not defined $sim_with_first)) {
        usage();
        exit;
}

my $corpus =  new Clair::Corpus(rootdir => $base, corpusname => $corpus_name);
my $cluster = new Clair::Cluster();
$cluster->load_corpus($corpus);
$cluster->strip_all_documents();

my %features=();
my %weights=();

if(defined $length){
   $length=1 unless $length ne "";
   $features{"length"}=\&length_feature;
   $weights{"length"}=$length;
}

if(defined $position){
   $position=1 unless $position ne "";
   $features{"position"}=\&position_feature;
   $weights{"position"}=$position;
}

if(defined $centroid){
   $centroid=1 unless $centroid ne "";
   $features{"centroid"}=\&centroid_feature;
   $weights{"centroid"}=$centroid;
}

if(defined $sim_with_first){
   $sim_with_first=1 unless $sim_with_first ne "";
   $features{"simwithfirst"}=\&sim_with_first_feature;
   $weights{"simwithfirst"}=$sim_with_first;
}

print "Computing Sentences Features\n" if $verbose;
$cluster->compute_sentence_features(%features);
print "Normalizing Sentence Features\n" if $verbose;
$cluster->normalize_sentence_features(keys %features);
# Score the sentences using the weights
print "Scoring Sentences\n" if $verbose;
$cluster->score_sentences( weights => \%weights );
print "Getting Summary Setences\n" if $verbose;

#my $docs = $cluster->documents();
#foreach my $doc (values %$docs){
#        print $doc->get_html(),"\n";
#}

my @summary = $cluster->get_summary(size => $size, preserve_order => $preserve_order);

if($output_file ne ""){
    open OUT, ">$output_file" or die "cann't open file $!";
}

foreach my $sent (@summary) {
    if($output_file ne ""){
        print OUT "$sent->{text} ";
    }else{
        print "$sent->{text} ";
    }
}
close OUT;
print "\n" if ($output_file eq "");
print "Done\n" if $verbose;


#
# Print out usage message
#
sub usage
{
        print "usage: $0 --corpus corpus_name [--base base_directory --output out_file --length weight --position weight --centroid weight --sim_with_first weight --max_sentences size --type text|html --preserve_order]\n\n";
        print "  --corpus corpus_name\n";
        print "       Name of the input corpus\n";
        print "  --base base_directory\n";
        print "       Base directory of the corpus\n";
        print "  --output file\n";
        print "       Name of output file where the summary will be written. If not specified, the result will be printed on the screen\n";
        print "  --length weight\n";
        print "       Consider the sentence length when computing the sentence features. The value is the weight of the lenght feature when scoring the sentences\n";
        print "  --position weight\n";
        print "       Consider the sentence position when computing the sentence features. The value is the weight of the position feature when scoring the sentences\n";
        print "  --sim_with_first weight\n";
        print "       Consider the similarity of the sentence with the first sentence when computing the sentences features. The value is the weight of the similarity feature when scoring the sentences\n";
        print "  --centroid weight\n";
        print "       Consider the sentence centroid when computing the sentence features. The value is the weight of the centroid feature when scoring the sentence\n";
        print "  --type text|html\n";
        print "       The type of the input file\n";
        print "  --max_sentences weight\n";
        print "       The maximum number of sentences in the summary\n";
        print "  --presever_order\n";
        print "       Preserve the order of the sentences in the summary as they were in the input\n";
        print "  --verbose\n";

        print "\n";

        print "example: $0 --corpus Gulf --base produced --type text --output summary.txt --length 0.7 --position 0.8 --max_sentences 5\n";

        exit;
}

