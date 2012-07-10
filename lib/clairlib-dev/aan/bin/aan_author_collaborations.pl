#!/usr/local/bin/perl

use aan;
use strict;
use Getopt::Long;


my $metafile = '';
my $acl_file = '';
my $to_year = 2008;
my $help = 0;

GetOptions("year:i" => \$to_year,
		   "help" => \$help);
if($help)
{
		usage();
		exit;
}


$acl_file = "../release/2008/acl.txt";
$metafile = "../release/2008/acl-metadata.txt";


my %meta = aan::buildmeta($metafile);

my %collaborations = '';

foreach my $paper_id (sort (keys(%meta))) {
	
	if(&aan::select_year($paper_id,$to_year) == 1) {
	
	my $auths = $meta{$paper_id};
    $auths =~ s/ ::: .+//;
    $auths =~ s/ :: /; /;
	my @fas = '';
    if ($auths ne "na")
	{
		if ($auths =~ m/;/) {
			@fas = split(/; /, $auths);
		}
		else {
		    push(@fas, $auths);
		}
		my $num_collabs = $#fas;
		foreach my $auth (@fas)
		{
				$collaborations{$auth} += $num_collabs;
		}
	 }
	}
}





my $key = '';

foreach $key (sort (keys(%collaborations))) {
		if($key ne "")
		{
		   print "$collaborations{$key}\t$key\n";
		}
}


sub usage
{
		print "Usage: $0 [-year=to_year] [-help]\n";
		print "\t-year=to_year\n";
		print "\t\twhen specified, only citations which are older than the year mentioned are included. Can be any year greater than 1965, defaults to 2008.\n";
		print "\t-help\n";
		print "\t\tprints out the different options available\n";

}
