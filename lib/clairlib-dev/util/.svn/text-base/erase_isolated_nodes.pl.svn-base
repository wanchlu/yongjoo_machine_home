#! /usr/bin/perl -w
#
# script: remove all single nodes in a edgelist network
#

use strict;
use warnings;

use Getopt::Long;

sub usage;

# print out the usgage message
sub usage {
	print "usage: $0 -i graph name -o output graph name\n";
	print "  --input name\n";
	print "          name of the graph\n";
	print "  --output name\n";
	print "           name of the output graph, removed nodes with degree 0\n";
	exit;
}

my $input = "";
my $output = "";

my $res = GetOptions("input=s" => \$input, "output=s" => \$output);

if (!$res or ($input eq "") or ($output eq "")) {
	print "please specify both input and output\n";
	usage();
	exit;
}
if ($input eq $output) {
	print "input and output name should be different\n";
	exit;
}

open (FIN, "<", $input) || die "$!";
open (FOUT, ">", $output) || die "$!";

while (<FIN>) {
	chomp();	
	$_ = trim($_);
	my @nodes = split();
	next if $#nodes == 0;

	print FOUT join(" ", @nodes);
	print FOUT "\n";

}
close(FIN);
close(FOUT);



sub trim{
	my $str = shift;
	$str =~ s/^\s*|\s*$//g;
	return $str;
}
