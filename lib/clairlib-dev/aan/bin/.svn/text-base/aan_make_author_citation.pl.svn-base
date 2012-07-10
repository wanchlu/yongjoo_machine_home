#!/usr/local/bin/perl

use aan;
use strict;
use Getopt::Long;


my $metafile = '';
my $acl_file = '';
my $to_year = 2008;
my $nonself = 0;
my $help;

GetOptions("year:i" => \$to_year,
		   "nonself" => \$nonself,
		   "help" => \$help);

if($help)
{
		usage();
		exit;
}

$acl_file = "../release/2008/acl.txt";
$metafile = "../release/2008/acl-metadata.txt";

my %meta = aan::buildmeta($metafile);

open (IN, $acl_file) || die ("Could not open network.\n");
chomp (my @network = <IN>);
close IN;

foreach my $pair (@network) {
		$pair =~ /(.+) ==> (.+)/;
	my ($from, $cites) = ($1, $2);
	#print "citation is from $from to $cites\n";
	if(&aan::select_year($from,$to_year) == 1 && &aan::select_year($cites,$to_year) == 1) {
	my $from_auths = $meta{$from};
	#print "$from_auths\n";
	$from_auths =~ s/ ::: .+//;
	$from_auths =~ s/ :: /; /;
	my $cites_auths = $meta{$cites};
	$cites_auths =~ s/ ::: .+//;
	$cites_auths =~ s/ :: /; /;
	my (@fas, @cas);
	if (($from_auths ne "na") && ($cites_auths ne "na") && ($cites_auths ne "") && ($cites_auths ne "")) {
		if ($from_auths =~ m/;/) {
			@fas = split(/; /, $from_auths);
		}
		else {
			push(@fas, $from_auths);
		}
		if ($cites_auths =~ m/;/) {
			@cas = split(/; /, $cites_auths);
		}
		else {
			push(@cas, $cites_auths);
		}
		foreach my $fa (@fas) {
			foreach my $ca (@cas) {
				if(!$nonself || !($fa eq $ca))
				{
					print "$fa ==> $ca\n";
				}
			}
		}
	 }
	}
}

sub usage
{
		print "Usage: $0 [-year=to_year] [-nonself] [-help]\n";
		print "\t-year=to_year\n";
		print "\t\twhen specified, only citations which are older than the year mentioned are included. Can be any year greater than 1965, defaults to 2008.\n";
		print "\t-nonself\n";
		print "\t\twhen specified, self citations are excluded. By default self citations are included.\n";
		print "\t-help\n";
		print "\t\tprints out the different options available\n";
}

