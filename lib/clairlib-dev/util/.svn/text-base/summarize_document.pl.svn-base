#!/usr/bin/perl
# script: summarize_document.pl
# functionality: Summarize a single document

use strict;
use warnings;

use Getopt::Long;

use Clair::Document;
use Clair::SentenceFeatures qw(:all);
use Data::Dumper;

sub usage;

my $output_file = "";
my $input_file = "";
my $size=10;
my $type="text";
my $verbose=0;
my $length;
my $centroid;
my $position;
my $sim_with_first;
my $preserve_order=0;

my $res = GetOptions("input=s" => \$input_file,
                     "output=s" => \$output_file,
                     "max_sentences=i" => \$size,
                     "length=f" => \$length,
                     "centroid=f" => \$centroid,
                     "position=f" => \$position,
                     "sim_with_first=f" => \$sim_with_first,
                     "type=s"=> \$type,
                     "preserve_order!"=> \$preserve_order,
                     "verbose!" => \$verbose);

if (!$res or ($input_file eq "") or (not defined $length &&
    not defined $centroid && not defined $position &&
    not defined $sim_with_first)) {
        usage();
        exit;
}

my $doc = new Clair::Document(type=>$type, file=>$input_file);
if(lc($type) eq "html"){
    print "Stripping HTML\n" if $verbose;
    $doc->strip_html2();
}

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
$doc->compute_sentence_features(%features);
print "Normalizing Sentence Features\n" if $verbose;
$doc->normalize_sentence_features(keys %features);
# Score the sentences using the weights
print "Scoring Sentences\n" if $verbose;
$doc->score_sentences( weights => \%weights );
print "Getting Summary Setences\n" if $verbose;
my @summary = $doc->get_summary(size => $size, preserve_order => $preserve_order);

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
        print "usage: $0 --input file [--output file] [--length float] [--position float] [--centroid float] [--sim_with_first float] [--max_sentences integer] [--type text|html] [--preserve_order]\n\n";
        print "  --input file\n";
        print "       Name of input file\n";
        print "  --output file\n";
        print "       Name of output file where the summary will be written. If not specified, the result will be printed on the screen\n";
        print "  --length float\n";
        print "       Consider the sentence length when computing the sentence features. The value is the weight of the lenght feature when scoring the sentences\n";
        print "  --position float\n";
        print "       Consider the sentence position when computing the sentence features. The value is the weight of the position feature when scoring the sentences\n";
        print "  --sim_with_first float\n";
        print "       Consider the similarity of the sentence with the first sentence when computing the sentences features. The value is the weight of the similarity feature when scoring the sentences\n";
        print "  --centroid float\n";
        print "       Consider the sentence centroid when computing the sentence features. The value is the weight of the centroid feature when scoring the sentence\n";
        print "  --type text|html\n";
        print "       The type of the input file\n";
        print "  --max_sentences integer\n";
        print "       The maximum number of sentences in the summary\n";
        print "  --presever_order\n";
        print "       Preserve the order of the sentences in the summary as they were in the input\n";
        print "  --verbose\n";
        print "       Preserve the order of the sentences in the summary as they were in the input\n";

        print "\n";

        print "example: $0 --input article.txt --type text --output summary.txt --length 0.7 --position 0.8 --max_sentences 5\n";

        exit;
}

