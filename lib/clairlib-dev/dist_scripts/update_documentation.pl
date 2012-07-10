#!/usr/local/bin/perl

use warnings;

#--------------------------
# FILE PATHS
#--------------------------

$CODEROOT="/data0/projects/clairlib-dev";
$WORKINGDIR="/data0/projects/clairlib-dev";
$HTMLDIR="/data0/html/clairlib";
$OUTLOG="$WORKINGDIR/dist_scripts/update_documentation.log";

$PDOCSRC="$CODEROOT/lib/Clair";
$PDOCTARGET="$HTMLDIR/pdoc";
$PDOCWROOT="http://belobog.si.umich.edu/clair/clairlib/pdoc/";

$AUTHORSPOD="$WORKINGDIR/Authors.pod";
$AUTHORSTEX="$WORKINGDIR/tutorial/authors.tex";
$AUTHORSWIK="$HTMLDIR/Authors.wiki";
$AUTHORSTXT="$WORKINGDIR/Authors";

$CHANGESPOD="$WORKINGDIR/Changes.pod";
$CHANGESTEX="$WORKINGDIR/tutorial/Changes.tex";
$CHANGESWIK="$HTMLDIR/Changes.wiki";
$CHANGESTXT="$WORKINGDIR/Changes";

$INSTALLPOD="$WORKINGDIR/INSTALL.pod";
$INSTALLTEX="$WORKINGDIR/tutorial/INSTALL.tex";
$INSTALLWIK="$HTMLDIR/Install.wiki";
$INSTALLTXT="$WORKINGDIR/INSTALL";

$UTILTUTPOD="$WORKINGDIR/UtilTut.pod";
$UTILTUTTEX="$WORKINGDIR/tutorial/utilTut.tex";
$UTILTUTWIK="$HTMLDIR/UtilTut.wiki";
$UTILTUTHTM="$HTMLDIR/UtilTut.html";

$PDFDIR="$WORKINGDIR/tutorial";
$TESTHTML="$PDFDIR/testlist.html";


#--------------------------
# START PROCESSING
#--------------------------

#recreate pdoc
print "***CREATE PDOC***\n";
if( $ENV{PERL5LIB}) {
  $ENV{PERL5LIB}=$ENV{PERL5LIB} . ":/data0/projects/pdoc-live";
}else{
  $ENV{PERL5LIB}="/data0/projects/pdoc-live";
}
#`perl /data0/projects/pdoc-live/scripts/perlmod2www.pl -source $PDOCSRC -target $PDOCTARGET -style html &> $OUTLOG`;

#manage authors
print "***UPDATE AUTHORS PAGES***\n";
create_authors_tex();
`pod2wiki -s mediawiki $AUTHORSPOD $AUTHORSWIK`;
`pod2text $AUTHORSPOD $AUTHORSTXT`;

#manage changes
print "***UPDATE CHANGES PAGES***\n";
`pod2latex $CHANGESPOD -out $CHANGESTEX`;
`pod2wiki -s mediawiki $CHANGESPOD $CHANGESWIK`;
`pod2text $CHANGESPOD $CHANGESTXT`;

#manage install
print "***UPDATE INSTALL PAGES***\n";
`pod2latex $INSTALLPOD -out $INSTALLTEX`;
`pod2wiki -s mediawiki $INSTALLPOD $INSTALLWIK`;
`pod2text $INSTALLPOD $INSTALLTXT`;

#manage UtilTut
print "***UPDATE UTILTUT PAGES***\n";
#`pod2latex $UTILTUTPOD -out $UTILTUTTEX`;
`pod2wiki -s mediawiki $UTILTUTPOD $UTILTUTWIK`;
`pod2html --infile $UTILTUTPOD --outfile $UTILTUTHTM`;

#move into pdfdir
chdir($PDFDIR);

#update testlist
print "***UPDATE TESTLIST***\n";
`./compile_test_lists.pl`;
`cp $TESTHTML $HTMLDIR`;

#create and update pdfs
print "***UPDATE PDFS***\n";
`./compile_recipes.pl`;
ttt(clTut);
ttt(clPolsciTut);
ttt(clBioTut);
ttt(clAllTut);
`cp ./clTut.pdf $HTMLDIR`;
`cp ./clPolsciTut.pdf $HTMLDIR`;
`cp ./clBioTut.pdf $HTMLDIR`;
`cp ./clAllTut.pdf $HTMLDIR`;


#---------------------------
# SUBS
#---------------------------

# creates a contracted list from the AUTHORS text for the front page of the pdf
sub create_authors_tex {
  open (IN, "$AUTHORSPOD") or die "Can't open $AUTHORSPOD for reading: $!";
  open (OUT, ">$AUTHORSTEX") or die "Can't open $AUTHORSTEX for writing: $!";

  print OUT q<\author{\\\ \\\ \\\ \\\ \\\ \\\ \\\ \\\ \\\ \\\ >."\n";

  my $flag = 1;

  while(<IN>){
    chomp;
    if( /Contributors/ ) {
      $flag = 0;
    }
    if( !/=/ && /\w/ && $flag ){
      print OUT $_.q< \\\ >."\n";
    }
  }

  print OUT q< \\\ >."\n";
  print OUT q<        \url{http://www.clairlib.org} \\\ \\\ }>."\n";
}

# the pdf creation pipeline
sub ttt {
  my $ver = shift;

  `rm $ver.log $ver.dvi $ver.ps`;
  `rm $ver.bbl $ver.blg`;
  `latex $ver`;
  `latex $ver`;
  `bibtex $ver`;
  `latex $ver`;
  `latex $ver`;
  `dvips -f $ver.dvi >| $ver.ps`;
  `ps2pdf $ver.ps`;
}
