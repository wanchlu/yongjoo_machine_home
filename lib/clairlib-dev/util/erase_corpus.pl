#! /usr/bin/perl -w
# 
# script: remove all information of the corpus.
# 

use warnings;

use Getopt::Long;

sub usage;

# print out the usage message
sub usage {
	print "usage: $0 -c corpus name -b base directory for the corpus.\n";
	print "  --corpus-name name\n";
	print "          name of the corpus\n ";
	print "  --base-dir\n";
	print "          base directory of the corpus.\n";
	exit;
}

my $corpusName = "";
my $baseDir = "";

my $res = GetOptions("corpus-name=s" => \$corpusName, "base-dir=s" => \$baseDir);

if (!$res or ($corpusName eq "") or ($baseDir eq "")) {
	print "please specify both corpus name and base directory of the corpus\n";
	usage();
	exit;
}

`rm $baseDir/$corpusName.download.uniq`;
`rm -rf $baseDir/corpora/$corpusName`;
`rm -rf $baseDir/corpus-data/$corpusName`;
`rm -rf $baseDir/corpus-data/$corpusName-tf`;
`rm -rf $baseDir/corpus-data/$corpusName-tf-s`;
`rm -rf $baseDir/download/$corpusName`;
print "Done!\n";

