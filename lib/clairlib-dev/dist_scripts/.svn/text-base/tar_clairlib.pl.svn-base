#!/usr/bin/perl

$type = shift;
#print "$type\n";

my $date = `date -I`;
chomp $date;

chdir "/data0/projects/clairlib";

print "Copying clairlib over for the tarball\n";
`rm -Rf clairlib`;
`cp -R $date clairlib`;
`rm -Rf clairlib/$date`;

# Tar the /data0/projects/clairlib directory - Create clairlibAll.tar.gz
print "Creating the tar file.\n";

if ($type eq "clairlib") {
	`tar -cvf /data0/projects/clairlib-temp2/clairlib.tar clairlib`;
	`gzip -f /data0/projects/clairlib-temp2/clairlib.tar`;
}
if ($type eq "clairlibBio") {
	`tar -cvf /data0/projects/clairlib-temp2/clairlibBio.tar clairlib`;
	`gzip -f /data0/projects/clairlib-temp2/clairlibBio.tar`;
}
if ($type eq "clairlibPolisci") {
	`tar -cvf /data0/projects/clairlib-temp2/clairlibPolisci.tar clairlib`;
	`gzip -f /data0/projects/clairlib-temp2/clairlibPolisci.tar`;
}
if ($type eq "clairlibAll") {
	`tar -cvf /data0/projects/clairlib-temp2/clairlibAll.tar clairlib`;
	`gzip -f /data0/projects/clairlib-temp2/clairlibAll.tar`;
}

#`tar -cvf /data0/projects/clairlib-dev/clairlibAll.tar.gz  clairlib`;
#`tar -cvfX /data0/projects/clairlib-dev/clairlibAll.tar.gz /data0/projects/clairlib-dev/dist_scripts/exclude_tar.txt clairlib`;
#`tar -cvf /data0/projects/clairlib-dev/clairlibAll.tar.gz -I /data0/projects/clairlib-dev/dist_scripts/include_all_tar.txt`;
#rename("/data0/projects/clairlib-dev/clairlibAll.tar.gz", "/data0/projects/clairlib/$date/clairlibAll.tar.gz");
#`tar -cvf /data0/projects/clairlib/$date/clairlibAll.tar.gz --exclude=clairlibBioTutorial.pdf --exclude=clairlibPolisciTutorial.pdf --exclude=clairlibTutorial.pdf clairlib`

# Tar the /data0/projects/clairlib directory - Create clairlib.tar.gz
#print "Creating the new clairlib tar.gz file.\n";
#`tar -cvf /data0/projects/clairlib/$date/additional.tar.gz lib/Nutch lib/Polisci lib/Bio t/test_nutchsearch.t t/test_connection.t t/test_esearch.t test/test_esearch.pl t/test_esearchhandler.t t/test_eutils.t t/test_generif.t test/test_generif.pl t/test_graf.t t/test_record.t t/test_speaker.t t/test_us_connection.t test/test_us_connection.pl`

# Tar the /data0/projects/clairlib directory - Create clairlibBio.tar.gz
#print "Creating the new clairlib + bio tar.gz file.\n";
#`tar -cvf /data0/projects/clairlib/$date/additional.tar.gz lib/Nutch lib/Polisci lib/Bio t/test_nutchsearch.t t/test_connection.t t/test_esearch.t test/test_esearch.pl t/test_esearchhandler.t t/test_eutils.t t/test_generif.t test/test_generif.pl t/test_graf.t t/test_record.t t/test_speaker.t t/test_us_connection.t test/test_us_connection.pl`

# Tar the /data0/projects/clairlib directory - Create clairlibPolisci.tar.gz
#print "Creating the new clairlib + polisci tar.gz file.\n";
#`tar -cvf /data0/projects/clairlib/$date/additional.tar.gz lib/Nutch lib/Polisci lib/Bio t/test_nutchsearch.t t/test_connection.t t/test_esearch.t test/test_esearch.pl t/test_esearchhandler.t t/test_eutils.t t/test_generif.t test/test_generif.pl t/test_graf.t t/test_record.t t/test_speaker.t t/test_us_connection.t test/test_us_connection.pl`

#rename("/data0/projects/clairlib-dev/clairlib.tar.gz", "/data0/projects/clairlib/$date/clairlib.tar.gz");
#`tar cvf /data0/projects/clairlib-dev/clairlib.tar.gz /data0/projects/clairlib-dev/dist_scripts/exclude_tar.txt clairlib`;

# blib
# pm_to_blib
# Makefile
# additional.tar.gz
# clairlib.tar.gz


`rm -Rf current`;
`mv clairlib current`;
