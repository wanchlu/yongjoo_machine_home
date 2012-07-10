#!/usr/bin/perl


# Where the distributions will be split into:
$date = `date -I`;
chomp $date;
my $ext_dest_dir = "../../ext/$date";
my $core_dest_dir = "../../core/$date";
`mkdir ../../core`;
`mkdir ../../ext`;


# Remove the old core and ext destination files:

print "Removing old core distribution:\n";
`rm -r -f $core_dest_dir/`;
print "Old core distribution removed.\n";

print "Removing old ext distribution:\n";
`rm -r -f $ext_dest_dir/`;
print "Old ext distribution removed.\n";


# Create the core and ext distribution locations:
`mkdir $core_dest_dir`;
`mkdir $ext_dest_dir`;


# Copy the info files from clairlib into $core_dest_dir, $ext_dest_dir: 

print "Copying ANNOUNCE.\n";
`cp ../ANNOUNCE $core_dest_dir/`;
`cp ../ANNOUNCE $ext_dest_dir/`;
print "ANNOUNCE copied.\n";

print "Copying Changes.\n";
`cp ../Changes $core_dest_dir/`;
`cp ../Changes $ext_dest_dir/`;
print "Changes copied.\n";

print "Copying INSTALL.\n";
`cp ../INSTALL $core_dest_dir/`;
`cp ../INSTALL $ext_dest_dir/`;
print "INSTALL copied.\n";

print "Copying README.\n";
`cp ../README $core_dest_dir/`;
`cp ../README $ext_dest_dir/`;
print "README copied.\n";

print "Copying Makefile.\n";
`cp ../Makefile-core.PL $core_dest_dir/Makefile.PL`;
`cp ../Makefile-ext.PL $ext_dest_dir/Makefile.PL`;
print "Makefile copied.\n";


# Strategy:
# Copy all the files into the core directory.  Move the extension files
# from the core directory into the appropriate locations in the
# extension directory.

# Create the destinations for files moved from -core to -ext:
print "Building ext directory structure.\n";
`mkdir $ext_dest_dir/lib`;
`mkdir $ext_dest_dir/lib/Clair`;
`mkdir $ext_dest_dir/lib/Clair/SentenceSegmenter`;
`mkdir $ext_dest_dir/lib/Clair/Utils`;
`mkdir $ext_dest_dir/lib/Clair/Interface`;
`mkdir $ext_dest_dir/t`;
`mkdir $ext_dest_dir/test`;
`mkdir $ext_dest_dir/test/input`;
`mkdir $ext_dest_dir/test/input/parse`;
`mkdir $ext_dest_dir/test/input/classify`;
`mkdir $ext_dest_dir/test/input/lsi`;
`mkdir $ext_dest_dir/test/produced`;
`mkdir $ext_dest_dir/test/produced/parse`;
`mkdir $ext_dest_dir/test/produced/classify`;
`mkdir $ext_dest_dir/test/produced/lsi`;
`mkdir $ext_dest_dir/util`;
print "ext directory structure built.\n";

print "Copying lib.\n";
`cp -r ../lib $core_dest_dir/`;
print "lib copied.\n";

# ** Why are input, expected, and produced only copied into $ext_dest_dir???
print "Copying t.\n";
`cp -r ../t $core_dest_dir/`;
`cp -r ../t/input $ext_dest_dir/t/`;
`cp -r ../t/expected $ext_dest_dir/t/`;
`cp -r ../t/produced $ext_dest_dir/t/`;
print "t copied.\n";

print "Copying test.\n";
`cp -r ../test $core_dest_dir/`;
`cp -r ../test/input/parse $ext_dest_dir/test/input/`;
`cp -r ../test/input/classify $ext_dest_dir/test/input/`;
`cp -r ../test/input/lsi $ext_dest_dir/test/input/`;
print "test copied.\n";

print "Copying tutorial.\n";
`cp -r ../tutorial $core_dest_dir/`;
print "tutorial copied.\n";

print "Copying util.\n";
`cp -r ../util $core_dest_dir/`;
print "util copied.\n";

	
# Moving extension files from $core_dest_dir to $ext_dest_dir
print "Moving extension files.\n";

# ... root namespace; associated tests:
`mv $core_dest_dir/lib/Clair/Utils/ALE.pm $ext_dest_dir/lib/Clair/Utils/ `;
`mv $core_dest_dir/lib/Clair/Utils/WebSearch.pm $ext_dest_dir/lib/Clair/Utils/ `;
`mv $core_dest_dir/t/test_web_search.t $ext_dest_dir/t/ `;
`mv $core_dest_dir/util/search_to_url.pl $ext_dest_dir/util/ `;
`mv $core_dest_dir/util/wordnet_to_network.pl $ext_dest_dir/util/ `;

# ... ALE namespace; ALE tests:
`mv $core_dest_dir/lib/Clair/ALE $ext_dest_dir/lib/Clair `;
`mv $core_dest_dir/t/test_aleextract.t $ext_dest_dir/t/ `;
`mv $core_dest_dir/t/test_alesearch.t $ext_dest_dir/t/ `;

# ... Weka toolkit interface:
`mv $core_dest_dir/lib/Clair/Interface/Weka.pm $ext_dest_dir/lib/Clair/Interface `;
`mv $core_dest_dir/test/classify_weka.pl $ext_dest_dir/test/ `;
`mv $core_dest_dir/test/lsi.pl $ext_dest_dir/test/ `;

# ... Bio namespace; Bio tests; uncomment these lines to move them into the
#     ext distribution.  After the block of commented lines there is a set
#     of commands that remove all Bio modules from both distributions.
#`mv $core_dest_dir/lib/Clair/Bio $ext_dest_dir/lib/Clair `;
#`mv $core_dest_dir/t/test_connection.t $ext_dest_dir/t/ `;
#`mv $core_dest_dir/t/test_esearchhandler.t $ext_dest_dir/t/ `;
#`mv $core_dest_dir/t/test_esearch.t $ext_dest_dir/t/ `;
#`mv $core_dest_dir/t/test_eutils.t $ext_dest_dir/t/ `;
#`mv $core_dest_dir/t/test_generif.t $ext_dest_dir/t/ `;
`rm -rf $core_dest_dir/lib/Clair/Bio `;
`rm -rf $core_dest_dir/t/test_connection.t `;
`rm -rf $core_dest_dir/t/test_esearchhandler.t `;
`rm -rf $core_dest_dir/t/test_esearch.t `;
`rm -rf $core_dest_dir/t/test_eutils.t `;
`rm -rf $core_dest_dir/t/test_generif.t `;

# ... Nutch namespace; Nutch tests:
`mv $core_dest_dir/lib/Clair/Nutch $ext_dest_dir/lib/Clair `;

# ... Polisci namespace; ; uncomment these lines to move them into the
#     ext distribution.  After the block of commented lines there is a set
#     of commands that remove all Polisci modules from both distributions.
#`mv $core_dest_dir/lib/Clair/Polisci $ext_dest_dir/lib/Clair `;
#`mv $core_dest_dir/t/test_graf.t $ext_dest_dir/t/ `;
#`mv $core_dest_dir/t/test_record.t $ext_dest_dir/t/ `;
#`mv $core_dest_dir/t/test_speaker.t $ext_dest_dir/t/ `;
`rm -rf $core_dest_dir/lib/Clair/Polisci `;
`rm -rf $core_dest_dir/t/test_graf.t `;
`rm -rf $core_dest_dir/t/test_record.t `;
`rm -rf $core_dest_dir/t/test_speaker.t `;

# ... Parser tests:
`mv $core_dest_dir/t/test_parse.t $ext_dest_dir/t/ `;
`mv $core_dest_dir/test/parse.pl $ext_dest_dir/test/ `;

# ... Extensions distribution versioning file:
`mv $core_dest_dir/lib/Clair/Extensions.pm $ext_dest_dir/lib/Clair/ `;

# Deleting (remaining) undistributable files:
`rm $core_dest_dir/t/test_us_connection.t `;

# Moving alternative implementations of clairlib functionality and the tests that are specific to them:
# ... SentenceSegmenter::MxTerminator (which may replace SentenceSegmenter::Text) 
# `mv $core_dest_dir/lib/Clair/SentenceSegmenter/MxTerminator.pm $ext_dest_dir/lib/Clair/SentenceSegmenter/ `; # Needed again in core distro.
`mv $core_dest_dir/t/test_lexrank_large_mxt.t $ext_dest_dir/t/ `;
`mv $core_dest_dir/t/test_meadwrapper_mxt.t $ext_dest_dir/t/ `;

# Copying all files that belong in BOTH core and extension distributions.
# (excepting the files ANNOUNCE, CHANGES, INSTALL, and README)
# (Currently no files are expected to belong to both distributions.)


# Here, mjschal still needs to add other files that need to be removed from lib/ and
# any other code locations.  (None currently known about; this space for rent.)


# Remove all test code produced stuff:
# First from the core distribution:
`rm -f $core_dest_dir/lib/*~`;
`rm -f $core_dest_dir/lib/Clair/*~`;
`rm -f $core_dest_dir/t/*~`;
`rm -f $core_dest_dir/test/*~`;
`rm -f $core_dest_dir/t/produced/cidrmead/*`;
`rm -f $core_dest_dir/t/produced/cidrwrapper/*`;
`rm -f $core_dest_dir/t/produced/cluster/*`;
`rm -f $core_dest_dir/t/produced/compare_idf/*`;
`rm -rf $core_dest_dir/t/produced/corpus_download/*`;
`rm -f $core_dest_dir/t/produced/document_idf/*`;
`rm -f $core_dest_dir/t/produced/gen/*`;
`rm -f $core_dest_dir/t/produced/generif/*`;
`rm -f $core_dest_dir/t/produced/hyperlink/*`;
`rm -f $core_dest_dir/t/produced/idf/*`;
`rm -f $core_dest_dir/t/produced/lexrank/*`;
`rm -f $core_dest_dir/t/produced/lexrank2/*`;
`rm -f $core_dest_dir/t/produced/lexrank3/*`;
`rm -f $core_dest_dir/t/produced/lexrank_large/*`;
`rm -f $core_dest_dir/t/produced/meadwrapper/*`;
`rm -f $core_dest_dir/t/produced/network/*`;
`rm -f $core_dest_dir/t/produced/network_stat/*`;
`rm -f $core_dest_dir/t/produced/nutchsearch/*`;
`rm -f $core_dest_dir/t/produced/pagerank/*`;
`rm -f $core_dest_dir/t/produced/parse/*`;
`rm -f $core_dest_dir/t/produced/random_walk/*`;
`rm -f $core_dest_dir/t/produced/web_search/*`;
`rm -f $core_dest_dir/t/produced/link_corpus/corpus-data/testhtml/*`;
`rm -rf $core_dest_dir/t/produced/testhtml/*`;
`rm -rf $core_dest_dir/test/produced/cidr/*`;
`rm -rf $core_dest_dir/test/produced/cluster/*`;
`rm -rf $core_dest_dir/test/produced/classify/*`;
`rm -rf $core_dest_dir/test/produced/compare_idf/*`;
`rm -rf $core_dest_dir/test/produced/corpusdownload/*`;
`rm -rf $core_dest_dir/test/produced/corpusdownload_hyperlink/*`;
`rm -rf $core_dest_dir/test/produced/corpusdownload_list/*`;
`rm -rf $core_dest_dir/test/produced/document/*`;
`rm -rf $core_dest_dir/test/produced/document_idf/*`;
`rm -rf $core_dest_dir/test/produced/features/*`;
`rm -rf $core_dest_dir/test/produced/genericdoc/*`;
`rm -rf $core_dest_dir/test/produced/idf/*`;
`rm -rf $core_dest_dir/test/produced/index_dirfiles/*`;
`rm -rf $core_dest_dir/test/produced/index_mldbm/*`;
`rm -rf $core_dest_dir/test/produced/ir/*`;
`rm -rf $core_dest_dir/test/produced/lexrank/*`;
`rm -rf $core_dest_dir/test/produced/lexrank4/*`;
`rm -rf $core_dest_dir/test/produced/lsi/*`;
`rm -rf $core_dest_dir/test/produced/mead_summary/*`;
`rm -rf $core_dest_dir/test/produced/mega/*`;
`rm -rf $core_dest_dir/test/produced/networkstat/*`;
`rm -rf $core_dest_dir/test/produced/parse/*`;
`rm -rf $core_dest_dir/test/produced/random_walk/*`;
# Secondly from the extensions distribution:
`rm -f $ext_dest_dir/lib/*~`;
`rm -f $ext_dest_dir/lib/Clair/*~`;
`rm -f $ext_dest_dir/t/*~`;
`rm -f $ext_dest_dir/test/*~`;
`rm -f $ext_dest_dir/t/produced/cidrmead/*`;
`rm -f $ext_dest_dir/t/produced/cidrwrapper/*`;
`rm -f $ext_dest_dir/t/produced/cluster/*`;
`rm -f $ext_dest_dir/t/produced/compare_idf/*`;
`rm -rf $ext_dest_dir/t/produced/corpus_download/*`;
`rm -f $ext_dest_dir/t/produced/document_idf/*`;
`rm -f $ext_dest_dir/t/produced/gen/*`;
`rm -f $ext_dest_dir/t/produced/generif/*`;
`rm -f $ext_dest_dir/t/produced/hyperlink/*`;
`rm -f $ext_dest_dir/t/produced/idf/*`;
`rm -f $ext_dest_dir/t/produced/lexrank/*`;
`rm -f $ext_dest_dir/t/produced/lexrank2/*`;
`rm -f $ext_dest_dir/t/produced/lexrank3/*`;
`rm -f $ext_dest_dir/t/produced/lexrank_large/*`;
`rm -f $ext_dest_dir/t/produced/meadwrapper/*`;
`rm -f $ext_dest_dir/t/produced/network/*`;
`rm -f $ext_dest_dir/t/produced/network_stat/*`;
`rm -f $ext_dest_dir/t/produced/nutchsearch/*`;
`rm -f $ext_dest_dir/t/produced/pagerank/*`;
`rm -f $ext_dest_dir/t/produced/parse/*`;
`rm -f $ext_dest_dir/t/produced/random_walk/*`;
`rm -f $ext_dest_dir/t/produced/web_search/*`;
`rm -f $ext_dest_dir/t/produced/link_corpus/corpus-data/testhtml/*`;
`rm -rf $ext_dest_dir/t/produced/testhtml/*`;
`rm -rf $ext_dest_dir/test/produced/cidr/*`;
`rm -rf $ext_dest_dir/test/produced/cluster/*`;
`rm -rf $ext_dest_dir/test/produced/classify/*`;
`rm -rf $ext_dest_dir/test/produced/compare_idf/*`;
`rm -rf $ext_dest_dir/test/produced/corpusdownload/*`;
`rm -rf $ext_dest_dir/test/produced/corpusdownload_hyperlink/*`;
`rm -rf $ext_dest_dir/test/produced/corpusdownload_list/*`;
`rm -rf $ext_dest_dir/test/produced/document/*`;
`rm -rf $ext_dest_dir/test/produced/document_idf/*`;
`rm -rf $ext_dest_dir/test/produced/features/*`;
`rm -rf $ext_dest_dir/test/produced/genericdoc/*`;
`rm -rf $ext_dest_dir/test/produced/idf/*`;
`rm -rf $ext_dest_dir/test/produced/index_dirfiles/*`;
`rm -rf $ext_dest_dir/test/produced/index_mldbm/*`;
`rm -rf $ext_dest_dir/test/produced/ir/*`;
`rm -rf $ext_dest_dir/test/produced/lexrank/*`;
`rm -rf $ext_dest_dir/test/produced/lexrank4/*`;
`rm -rf $ext_dest_dir/test/produced/lsi/*`;
`rm -rf $ext_dest_dir/test/produced/mead_summary/*`;
`rm -rf $ext_dest_dir/test/produced/mega/*`;
`rm -rf $ext_dest_dir/test/produced/networkstat/*`;
`rm -rf $ext_dest_dir/test/produced/parse/*`;
`rm -rf $ext_dest_dir/test/produced/random_walk/*`;

print "Removing subversion directories\n";
`find $core_dest_dir -name '.svn' | xargs rm -rf`;
`find $ext_dest_dir -name '.svn' | xargs rm -rf`;

print "Unnecessary files removed.\n";

# Remove the Google key from WebSearch.pm
print "Removing the Google key from WebSearch.pm\n";
system "./remove_Google_key.pl";


# New!! Make CPAN distributions
print "Making CPAN distributions...\n";
foreach my $dir ($core_dest_dir, $ext_dest_dir) {
	$dir;
	`perl Makefile.PL`;
	`make manifest`;
	`make tardist`;
}
print "CPAN distributions made.\n";

if ($? != 0) {
	exit($?);
}
