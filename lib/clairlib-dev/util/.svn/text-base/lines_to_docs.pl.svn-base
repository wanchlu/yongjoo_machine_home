#! /usr/bin/perl -w
# script: lines_to_docs.pl
# functionality: Converts a document with sentences into a set of
# functionality: documents with one sentence per document

use warnings;
use Getopt::Long;

sub usage;

my $fileName = "";
my $folderName = "";

my $res = GetOptions("input=s" => \$fileName, "output=s" => \$folderName);

if (!$res or ($folderName eq "")) {
	usage();
	exit;
}
open (FIN, "<", $fileName) || die $!;
my $folder = $folderName;

#`rm -rf ./$folder`;
`mkdir $folder`;
my $counter = 0;

while (<FIN>) {
	chomp;
	open (FOUT, ">", "$folder/$counter")|| die $!;
	$counter++;
	print FOUT $_ . "\n";
       	close (FOUT);
}

close(FIN);

sub usage {
  print "  --input in_file\n";
  print "       Input file to parse into sentences\n";
  print "  --output output\n";
  print "       Output filename or directory\n";
	print "example: ./lines_to_docs.pl -i 99.txt -o ./99\n";
}
