#!/usr/bin/perl

# Remove the large temporary clusters from clairlib-dev before copying
`rm -rf /data0/projects/clairlib-dev/t/docs/testhtml/* 2> /dev/null`;
`rm -rf /data0/projects/clairlib-dev/t/docs/produced/corpus_download/* 2> /dev/null`;
print "Temporary clusters removed.\n";

# Remove the old /data0/projects/clairlib/$date
my $date = `date -I`;
chomp $date;
`rm -r -f /data0/projects/clairlib/$date`;

# Create /data0/projects/clairlib
`mkdir /data0/projects/clairlib/$date`;

# Copy the files from clairlib-dev into clairlib
print "Copying README.\n";
`cp /data0/projects/clairlib-dev/README /data0/projects/clairlib/$date/`;
print "README copied.\n";
	
print "Copying lib.\n";
`cp -r /data0/projects/clairlib-dev/lib /data0/projects/clairlib/$date/`;
print "lib copied.\n";

print "Copying t.\n";
`cp -r /data0/projects/clairlib-dev/t /data0/projects/clairlib/$date/`;
print "t copied.\n";

print "Copying util.\n";
`cp -r /data0/projects/clairlib-dev/util /data0/projects/clairlib/$date/`;
print "util copied.\n";

print "Copying test.\n";
`cp -r /data0/projects/clairlib-dev/test /data0/projects/clairlib/$date/`;
print "test copied.\n";

print "Copying remaining folders.\n";
`cp  /data0/projects/clairlib-dev/Makefile.PL /data0/projects/clairlib/$date/`;
`cp -r /data0/projects/clairlib-dev/temp /data0/projects/clairlib/$date/`;
`cp /data0/projects/clairlib-dev/first_test.pl /data0/projects/clairlib/$date/`;
	
# Remove the unnecessary files from clairlib
print "Removing unnecessary files.\n";
`rm -rf /data0/projects/clairlib/$date/lib/Nutch`;
`rm -rf /data0/projects/clairlib/$date/lib/Bio`;
`rm -rf /data0/projects/clairlib/$date/lib/Polisci`;
`rm -f /data0/projects/clairlib/$date/t/test_nutchsearch.t`;
`rm -f /data0/projects/clairlib/$date/t/test_connection.t`;

#Added by Mark Joseph -- 09-17-06
`rm -f /data0/projects/clairlib/$date/t/test_esearch.t`;
`rm -f /data0/projects/clairlib/$date/test/test_esearch.pl`;
`rm -f /data0/projects/clairlib/$date/t/test_esearchhandler.t`;
`rm -f /data0/projects/clairlib/$date/t/test_eutils.t`;
`rm -f /data0/projects/clairlib/$date/t/test_generif.t`;
`rm -f /data0/projects/clairlib/$date/test/test_generif.pl`;
`rm -f /data0/projects/clairlib/$date/t/test_graf.t`;
	
`rm -f /data0/projects/clairlib/$date/t/test_record.t`;
`rm -f /data0/projects/clairlib/$date/t/test_speaker.t`;
`rm -f /data0/projects/clairlib/$date/t/test_us_connection.t`;
`rm -f /data0/projects/clairlib/$date/test/test_us_connection.pl`;
#End of MJ adds
	
`rm -f /data0/projects/clairlib/$date/lib/*~`;
`rm -f /data0/projects/clairlib/$date/lib/Clair/*~`;
`rm -f /data0/projects/clairlib/$date/t/*~`;
`rm -f /data0/projects/clairlib/$date/test/*~`;
`rm -f /data0/projects/clairlib/$date/t/docs/produced/cluster/*`;
`rm -rf /data0/projects/clairlib/$date/t/docs/produced/corpus_download/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/produced/mega/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/produced/network/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/compare_idf/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/gen/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/gg2/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/html/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/hyperlink/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/idf-dbm*`;
`rm -f /data0/projects/clairlib/$date/t/docs/lexrank/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/lexrank2/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/lexrank3/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/lexrank_large/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/lookup/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/pagerank/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/randomwalk/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/websearch/produced/*`;
`rm -f /data0/projects/clairlib/$date/t/docs/link_corpus/corpus-data/testhtml/*`;
`rm -rf /data0/projects/clairlib/$date/t/docs/testhtml/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/cluster/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/corpusdownload/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/corpusdownload_hyperlink/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/corpusdownload_list/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/document/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/document_idf/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/hyperlink/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/idf/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/mega/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/parse/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/random_walk/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/web_search/produced/*`;
`rm -rf /data0/projects/clairlib/$date/test/docs/network_stat/a/*`;
`mv /data0/projects/clairlib/$date/test/docs/network_stat/a.txt /data0/projects/clairlib/$date/test/docs/network_stat/a/a.txt`;

print "Removing subversion directories";
`find /data0/projects/clairlib/$date -name '.svn' | xargs rm -rf`;

print "Unnecessary files removed.\n";

# Remove the Google key from WebSearch.pm
print "Removing the Google key from WebSearch.pm\n";
system "./remove_Google_key.pl";

if ($? != 0) {
	exit($?);
}


