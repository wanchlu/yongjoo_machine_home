#!/usr/bin/perl

my $date = `date -I`;
chomp $date;

# Remove the files from clairlib now included in the archive
print "Removing files now in archive.\n";
`rm -r -f /data0/projects/clairlib/$date`;
print "Archived files removed.\n";

#Move tar.gz files to directory
`mkdir /data0/projects/clairlib/$date`;
`cp /data0/projects/clairlib-temp2/*.tar.gz /data0/projects/clairlib/$date/`;
`rm -f /data2/html/clairlib/clairlib*.tar.gz`;
`rm -f /data2/html/clairlib/additional.tar.gz`;
`cp /data0/projects/clairlib-temp2/*.tar.gz /data2/html/clairlib/`;


