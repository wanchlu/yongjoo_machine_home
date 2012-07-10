#!/usr/local/bin/perl

# script: test_corpusdownload.pl
# functionality: Downloads a corpus from a file containing URLs;
# functionality:  makes IDFs and TFs

use strict;
use warnings;
use FindBin;

use Clair::Utils::CorpusDownload;
use Clair::Utils::Idf;
use Clair::Utils::Tf;
use DB_File;

my $basedir = $FindBin::Bin;
my $gen_dir = "$basedir/produced/corpusdownload";
my $input_dir = "$basedir/input/corpusdownload";

# -------------------------------------------------------------------
#  This is the constructor.  It simply stores the directory
#  and name of the corpus.  It must be called prior to
#  any other routine.
# -------------------------------------------------------------------
my $corpusref = Clair::Utils::CorpusDownload->new(corpusname => "t2",
                rootdir => "$gen_dir");

# -------------------------------------------------------------------
#  Here's how to build a corpus.  An array @urls needs to be
#  built somehow.  (Here, we read the URLs from a file
#  $corpusname.urls.)  Then, the corpus will be built in
#  the directory $rootdir/$corpusname
# -------------------------------------------------------------------
my $uref = $corpusref->readUrlsFile("$input_dir/t.urls");

$corpusref->buildCorpus(urlsref => $uref, cleanup => 0);


# -------------------------------------------------------------------
#  This is how to build the IDF.  First we build the unstemmed IDF,
#  then the stemmed one.
# -------------------------------------------------------------------
$corpusref->buildIdf(stemmed => 0);
$corpusref->buildIdf(stemmed => 1);

# -------------------------------------------------------------------
#  This is how to build the TF.  First we build the DOCNO/URL
#  database, which is necessary to build the TFs.  Then we build
#  unstemmed and stemmed TFs.
# -------------------------------------------------------------------
$corpusref->build_docno_dbm();
$corpusref->buildTf(stemmed => 0);
$corpusref->buildTf(stemmed => 1);

# -------------------------------------------------------------------
#  Here is how to use a IDF.  The constructor (new) opens the
#  unstemmed IDF.  Then we ask for IDFs for the words "have"
#  "and" and "zimbabwe."
# -------------------------------------------------------------------
my $idfref = Clair::Utils::Idf->new( rootdir => "$gen_dir",
                       corpusname => "t2" ,
                       stemmed => 0 );

my $result = $idfref->getIdfForWord("have");
print "IDF(have) = $result\n";
$result = $idfref->getIdfForWord("and");
print "IDF(and) = $result\n";
$result = $idfref->getIdfForWord("zimbabwe");
print "IDF(zimbabwe) = $result\n";

# -------------------------------------------------------------------
#  Here is how to use a TF for term queries.  The constructor (new)
#  opens the unstemmed TF.  Then we ask for information about the
#  word "have":
#
#  1 first, we get the number of documents in the corpus with
#    the word "have"
#  2 then, we get the total number of occurrences of the word "have"
#  3 then, we print a list of URLs of the documents that have the
#    word "have" and the number of times each occurs in the document
# -------------------------------------------------------------------
my $tfref = Clair::Utils::Tf->new( rootdir => "$gen_dir",
                     corpusname => "t2" ,
                     stemmed => 0 );

print "\n\n---Direct term queries (unstemmed):---\n";
$result = $tfref->getNumDocsWithWord("have");
my $freq   = $tfref->getFreq("have");
my @urls = $tfref->getDocs("have");
print "TF(have) = $freq total in $result docs\n";
print "Documents with \"have\"\n";
foreach my $url (@urls)  {
	my $url_freq = $tfref->getFreqInDocument("have", url => $url);
	print "  $url: $url_freq\n";
}
print "\n";

# -------------------------------------------------------------------
#  Then we do 1-3 with the word "and"
# -------------------------------------------------------------------
$result = $tfref->getNumDocsWithWord("and");
$freq   = $tfref->getFreq("and");
@urls = $tfref->getDocs("and");
print "TF(and) = $freq total in $result docs\n";
print "Documents with \"and\"\n";
foreach my $url (@urls)  {
	my $url_freq = $tfref->getFreqInDocument("and", url => $url);
	print "  $url: $url_freq\n";
}
print "\n";


# -------------------------------------------------------------------
#  Then we do 1-3 with the word "zimbabwe"
#  And also print out the number of times zimbabwe is used in each
#  document
# -------------------------------------------------------------------
$result = $tfref->getNumDocsWithWord("zimbabwe");
$freq   = $tfref->getFreq("zimbabwe");
@urls = $tfref->getDocs("zimbabwe");
print "TF(zimbabwe) = $freq total in $result docs\n";
print "Documents with \"zimbabwe\"\n";
foreach my $url (@urls)  {
	my $url_freq = $tfref->getFreqInDocument("zimbabwe", url => $url);
	print "  $url: $url_freq\n";
}
print "\n";


# -------------------------------------------------------------------
#  Here is how to use a TF for phrase queries.  The constructor (new)
#  opens the stemmed TF.  Then we ask for information about the
#  phrase "result in":
#
#  1 first, we get the number of documents in the corpus with
#    the phrase "result in"
#  2 then, we get the total number of occurrences of the phrase
#    "result in"
#  3 then, we print a list of URLs of the documents that have the
#    word "result in" and the number of times each occurs in the
#    document, as well as the position in the document of the initial
#    term ("result") in each occurrence of the phrase
#  4 finally, using a different method, we print the number of times
#    "result in" occurs in each document in which it occurs (from 3),
#    as well as the position(s) of its occurrence (as in 3)
# -------------------------------------------------------------------
$tfref = Clair::Utils::Tf->new( rootdir => "$gen_dir",
                     corpusname => "t2" ,
                     stemmed => 1 );

print "\n---Direct phrase queries (stemmed):---\n";
my @phrase = ("result", "in");
$result = $tfref->getNumDocsWithPhrase(@phrase);
$freq   = $tfref->getPhraseFreq(@phrase);
my $positionsByUrlsRef = $tfref->getDocsWithPhrase(@phrase);
print "freq(\"result in\") = $freq total in $result docs\n";
print "Documents with \"result in\"\n";
foreach my $url (keys %$positionsByUrlsRef)  {
    my $url_freq = scalar keys %{$positionsByUrlsRef->{$url}};
    print "  $url:\n";
    print "      freq      = $url_freq\n";
    print "      positions = " . join(" ", reverse sort keys %{$positionsByUrlsRef->{$url}}) . "\n";
}
print "\n";

print "The following should be identical to the previous:\n";
foreach my $url (keys %$positionsByUrlsRef) {
    my ($url_freq, $url_positions_ref) = $tfref->getPhraseFreqInDocument(\@phrase, url => $url);
    print "  $url:\n";
    print "      freq      = $url_freq\n";
    print "      positions = " . join(" ", reverse sort keys %$url_positions_ref) . "\n";
}
print "\n\n";


# -------------------------------------------------------------------
#  Then we do 1-4 with the phrase "resulting in"
#  And also print out the number of times "resulting in" is used in each
#  document
#  Because of stemming, the results this time should be the
#  same as those from last time (see directly above)
# -------------------------------------------------------------------

@phrase = ("resulting", "in");
$result = $tfref->getNumDocsWithPhrase(@phrase);
$freq   = $tfref->getPhraseFreq(@phrase);
$positionsByUrlsRef = $tfref->getDocsWithPhrase(@phrase);
print "freq(\"result in\") = $freq total in $result docs\n";
print "Documents with \"resulting in\" (should be the same as for \"result in\")\n";
foreach my $url (keys %$positionsByUrlsRef)  {
    my $url_freq = scalar keys %{$positionsByUrlsRef->{$url}};
    print "  $url:\n";
    print "      freq      = $url_freq\n";
    print "      positions = " . join(" ", reverse sort keys %{$positionsByUrlsRef->{$url}}) . "\n";
}
print "\n";

print "The following should be identical to the previous:\n";
foreach my $url (keys %$positionsByUrlsRef) {
    my ($url_freq, $url_positions_ref) = $tfref->getPhraseFreqInDocument(\@phrase, url => $url);
    print "  $url:\n";
    print "      freq      = $url_freq\n";
    print "      positions = " . join(" ", reverse sort keys %$url_positions_ref) . "\n";
}
print "\n";


# -------------------------------------------------------------------
#  Here is how to use a TF for fuzzy OR queries.  We query the
#  (stemmed index of the) corpus as follows:
#
#  1 first, we get the number and scores of documents in the corpus
#    matching a query over the negated term !"thisisnotaword" (# = N),
#    then try the same query formulated as a negated phrase
#  2 then, we get the number and scores of documents in the corpus
#    matching a query over the term "result" (# = A),
#    then try the same query formulated as a phrase
#  3 then, we get the number and scores of documents in the corpus
#    matching a query over the term "in" (# = B)
#  4 then, we get the number and scores of documents in the corpus
#    matching a query over terms "result", "in" (# = C <= A + B)
#  5 then, we get the number and scores of documents in the corpus
#    matching the phrase query "result in" (# = D <= A, B)
#  6 then, we get the number and scores of documents in the corpus
#    matching a query over the negated phrase !"result in" (# = E = N - D)
#  7 finally, we get the number and scores of documents in the corpus
#    matching a query over the phrases "due to", "according to"
# -------------------------------------------------------------------

print "\n---Fuzzy OR Queries (stemmed):---\n";
#1a
    print "Query 1a: !\"thisisnotaword\" (negated term query)\n";
    my ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = ([], ["thisisnotaword"], [], []);
    my %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    my $N = scalar keys %docScores;
    my @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: N = $N\n";
    print "             scores: " . join(" ", @scores) . "\n";
#1b
    print "Query 1b: !\"thisisnotaword\" (negated phrase query)\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = ([], [], [], [["thisisnotaword"]]);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    $N = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: N = $N\n";
    print "             scores: " . join(" ", @scores) . "\n\n";


#2a
    print "Query 2a: \"result\" (term query)\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = (["result"], [], [], []);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    my $A = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: A = $A\n";
    print "             scores: " . join(" ", @scores) . "\n";
#2b
    print "Query 2b: \"result\" (phrase query)\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = ([], [], [["result"]], []);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    $A = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: A = $A\n";
    print "             scores: " . join(" ", @scores) . "\n\n";
#3
    print "Query 3: \"in\"\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = (["in"], [], [], []);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    my $B = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: B = $B\n";
    print "             scores: " . join(" ", @scores) . "\n\n";
#4
    print "Query 4: \"result\", \"in\"\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = (["in"], [], [], []);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    my $C = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: C = $C <= A + B = " . ($A + $B) . "\n";
    print "             scores: " . join(" ", @scores) . "\n\n";
#5
    print "Query 5: \"result in\"\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = ([], [], [["result", "in"]], []);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    my $D = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: D = $D <= min{A, B}\n";
    print "             scores: " . join(" ", @scores) . "\n\n";
#6
    print "Query 6: !\"result in\"\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = ([], [], [], [["result", "in"]]);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    my $E = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: E = $E = N - D = " . ($N - $D) . "\n";
    print "             scores: " . join(" ", @scores) . "\n\n";
#7
    print "Query 7: \"due to\", \"according to\"\n";
    ($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs) = ([], [], [["due","to"], ["according","to"]], []);
    %docScores = $tfref->getDocsMatchingFuzzyORQuery($pTerms, $pNegTerms, $pPhrasePtrs, $pNegPhrasePtrs);
    my $F = scalar keys %docScores;
    @scores = sort {$b <=> $a} values %docScores;
    print "    # docs matching: F = $F\n";
    print "             scores: " . join(" ", @scores) . "\n\n";


# -------------------------------------------------------------------
#  Finally, we tell the user to have a nice day.
# -------------------------------------------------------------------
print "\nHave a nice day!\n";
