#!/usr/local/bin/perl

use aan;
use strict;
use Getopt::Long;


my $metafile = '';
my $to_year = 2008;
my $help = 0;

GetOptions("year:i" => \$to_year,
		   "help" => \$help);

if($help)
{
		usage();
		exit;
}

$metafile = "../release/2008/acl-metadata.txt";

my %meta = aan::buildmeta($metafile);



my @collabs = ();
foreach my $id ( keys %meta ) {
	if(&aan::select_year($id,$to_year) == 1) {
	my $value = $meta{$id};
	$value =~ s/ ::: .+//;
	if ($value =~ m/ :: /) {
		my @chunks = split(/ :: /, $value);
		push(@collabs, @chunks);
	}
	else {
		push(@collabs, $value);
	}
  }
}
foreach my $collab (@collabs) {
	if ($collab =~ m/; /) {
		my @auths = split(/; /, $collab);
		foreach my $auth1 (@auths) {
			foreach my $auth2 (@auths) {
				if ($auth1 ne $auth2) {
					print "$auth1 ==> $auth2\n";
				}
			}
		}
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

