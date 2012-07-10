#!/usr/bin/perl
# script: learn.pl
# functionality: Train a model using perceptron

use strict;
use warnings;

use Getopt::Long;

use Clair::Learn;

sub usage;

my $directory = "";
my $filter = "";
my $output = "";
my $select;
my $documents_limit;
my $stem=1;
my $lowercase=1;
my $mode = "train";
my $parser = "";
my $verbose=0;

my $res = GetOptions("directory=s" => \$directory,
                     "filter=s" => \$filter,
                     "output=s" =>\$output,
                     "select=s" =>\$select,
                     "documents_limit=s" =>\$documents_limit,
                     "stem!" =>\$stem,
                     "lowercase!" =>\$lowercase,
                     "mode=s" =>\$mode,
                     "parser=s" =>\$parser,
                     "verbose!" => \$verbose);

if (!$res or ($output eq "") or ($directory eq "") or ($parser eq "")) {
        usage();
        exit;
}

my $DEBUG=0;

if($filter eq ""){
    open FILES,"find $directory -type f -print|";
}else{
    open FILES,"find $directory -type f -name '$filter' -print|";
}

my @files = <FILES>;

chomp(@files);


close FILES;

#print "Number ",scalar(@files),"\n";

my $fea = new Clair::Features(
        DEBUG => $DEBUG,
        document_limit => $documents_limit,
        features_file => "feature_lookup_map",
        mode => $mode,
);

for my $file (@files)
{
        #$my $content = `cat $file`;
        print "Parsing $file\n" if $verbose;
        my $gdoc = new Clair::GenericDoc(
                DEBUG => $DEBUG,
                content => $file,
                stem => $stem,
                lowercase => $lowercase,
                use_parser_module => $parser
        );

        $fea->register($gdoc);
        undef $gdoc; # memory conscious
}

if(defined $select){
   $fea->select($select);
}else{
   $fea->select();
}


# save the  data into a file in the svm_light format.
$fea->output($output);

#
# Print out usage message
#
sub usage
{
        print "usage: $0 --directory string --output string --parser string [--mode string] [--select integer] [--documents_limit integer] [--select] [--stem] [--verbose]\n\n";
        print "  --directory string\n";
        print "       The name of the directory where the set of files are located\n";
        print "  --output string\n";
        print "       Name of resulting features file which will be in the svm_light format\n";
        print "  --mode string\n";
        print "       Takes by the value 'train' (default) if the files are from the training set and 'test' if the files are from the testing set\n";
        print "  --parser string\n";
        print "       Specify the proper parser that matches the files format\n";
        print "  --documents_limit integer\n";
        print "       An upper limit on the number of documents considered from the dataset\n";
        print "  --select integer\n";
        print "       If passed a vlaue of N, the top N most discriminative features will be picked using the chi-square method. The default behavios is that all the features are selected\n";
        print "  --stem string\n";
        print "       If set (default), the words will be stemmed before being used as features \n";
        print "  --lowercase string\n";
        print "       If set (default), the words will be lowercased before being used as features \n";
        print "  --verbose\n";

        print "\n";

        print "example: $0 --directory training_dataset --output features.train --parser sports --mode train --select 50 --verbose\n";

        exit;
}
