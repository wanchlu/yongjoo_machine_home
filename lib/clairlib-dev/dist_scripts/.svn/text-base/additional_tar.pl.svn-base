#!/usr/bin/perl

print "Creating the additional tar file.\n";

chdir "/data0/projects/clairlib-dev/";

`tar -cvf /data0/projects/clairlib-temp2/additional.tar lib/Nutch t/test_nutchsearch.t t/test_us_connection.t test/test_us_connection.pl`;
`gzip -f /data0/projects/clairlib-temp2/additional.tar`;
print "Additional tar file created.\n";

#`tar -cvf /data0/projects/clairlib/additional.tar.gz lib/Nutch lib/Polisci lib/Bio t/test_nutchsearch.t t/test_connection.t t/test_us_connection.t`

