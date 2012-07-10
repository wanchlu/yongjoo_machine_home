#!/usr/bin/perl

# Remove the large temporary clusters from clairlib-dev before copying
#`rm -rf /data0/projects/clairlib-dev/t/docs/testhtml/* 2> /dev/null`;
#`rm -rf /data0/projects/clairlib-dev/t/docs/produced/corpus_download/* 2> /dev/null`;
#print "Temporary clusters removed.\n";

my $date = `date -I`;
chomp $date;
# Remove the old /data0/projects/clairlib
#`rm -r -f /data0/projects/clairlib/$date`;

# Create /data0/projects/clairlib/$date
#`mkdir /data0/projects/clairlib/$date`;

$type = shift;
#print "$type\n";

if ($type eq "clairlib") {
	removeBio();
	removePolisci();
	`rm -f /data0/projects/clairlib/$date/*.pdf`;
	`cp /data0/projects/clairlib-dev/tutorial/clTut.pdf /data0/projects/clairlib/$date/`;
}
if ($type eq "clairlibBio") {
	removeBio();
	removePolisci();
	copyBio();
	`rm -f /data0/projects/clairlib/$date/*.pdf`;
	`cp /data0/projects/clairlib-dev/tutorial/clBioTut.pdf /data0/projects/clairlib/$date/`;
}
if ($type eq "clairlibPolisci") {
	removeBio();
	removePolisci();
	copyPolisci();
	`rm -f /data0/projects/clairlib/$date/*.pdf`;
	`cp /data0/projects/clairlib-dev/tutorial/clPolsciTut.pdf /data0/projects/clairlib/$date/`;
}
if ($type eq "clairlibAll") {
	removeBio();
	removePolisci();
	copyBio();
	copyPolisci();
	`rm -f /data0/projects/clairlib/$date/*.pdf`;
	`cp /data0/projects/clairlib-dev/tutorial/clAllTut.pdf /data0/projects/clairlib/$date/`;
}
#if ($type eq "bioAddition") {
#	copyBio();
#	`cp /data0/projects/clairlib-dev/tutorial/clBioTut.pdf /data0/projects/clairlib/$date/`;
#}
#if ($type eq "polisciAddition") {
#	copyPolisci();
#	copyTutorial(clairlib);
#	`cp /data0/projects/clairlib-dev/tutorial/clPolsciTut.pdf /data0/projects/clairlib/$date/`;
#}

# Remove the Google key from WebSearch.pm
#print "Removing the Google key from WebSearch.pm\n";
#system "./remove_Google_key.pl";

if ($? != 0) {
	exit($?);
}

sub removeBio {
	print "Removing Bio files\n";
	`rm -r -f /data0/projects/clairlib/$date/lib/Bio`;
	`rm -f /data0/projects/clairlib/$date/t/test_esearch.t`;
	`rm -f /data0/projects/clairlib/$date/test/test_esearch.pl`;
	`rm -f /data0/projects/clairlib/$date/t/test_esearchhandler.t`;
	`rm -f /data0/projects/clairlib/$date/t/test_eutils.t`;
	`rm -f /data0/projects/clairlib/$date/t/test_generif.t`;
	`rm -f /data0/projects/clairlib/$date/test/test_generif.pl`;
	print "Bio files removed successfully.\n";
}

sub removePolisci {
	print "Removing PoliSci files\n";
	`rm -r -f /data0/projects/clairlib/$date/lib/Polisci`;
	`rm -f /data0/projects/clairlib/$date/t/test_record.t`;
	`rm -f /data0/projects/clairlib/$date/t/test_speaker.t`;
	`rm -f /data0/projects/clairlib/$date/t/test_us_connection.t`;
	`rm -f /data0/projects/clairlib/$date/t/test_graf.t`;
	`rm -f /data0/projects/clairlib/$date/test/test_us_connection.pl`;
	print "Polisci files removed successfully.\n";
}

sub copyBio {
	print "Copying Bio files\n";
	`cp -r /data0/projects/clairlib-dev/lib/Bio /data0/projects/clairlib/$date/lib`;
	cleanup_svn("/data0/projects/clairlib/$date/lib/Bio");
	`cp /data0/projects/clairlib-dev/t/test_esearch.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/test/test_esearch.pl /data0/projects/clairlib/$date/test/`;
	`cp /data0/projects/clairlib-dev/t/test_esearchhandler.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/t/test_eutils.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/t/test_generif.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/test/test_generif.pl /data0/projects/clairlib/$date/test/`;
	print "Bio files copied successfully.\n";
}

sub copyPolisci {
	print "Copying PoliSci files\n";
	`cp -r /data0/projects/clairlib-dev/lib/Polisci /data0/projects/clairlib/$date/lib/`;
	cleanup_svn("/data0/projects/clairlib/$date/lib/Polisci");
	`cp /data0/projects/clairlib-dev/t/test_record.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/t/test_speaker.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/t/test_us_connection.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/t/test_graf.t /data0/projects/clairlib/$date/t/`;
	`cp /data0/projects/clairlib-dev/test/test_us_connection.pl /data0/projects/clairlib/$date/test/`;
	print "Polisci files copied successfully.\n";
}

sub cleanup_svn {
	my $dir = shift;
	if ($dir eq "") {
	  return;
	}
	`find $dir -name '.svn' | xargs rm -rf`;
}
