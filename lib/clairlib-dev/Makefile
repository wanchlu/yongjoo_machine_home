# This Makefile is for the Clairlib extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.57_05 (Revision: 65705) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT => q[a library designed to simplify generic tasks in natural language processing (NLP), information retrieval (IR), and network analysis (NA)]
#     AUTHOR => [q[The Clair group<clair@umich.edu>]]
#     BUILD_REQUIRES => {  }
#     NAME => q[Clairlib]
#     PL_FILES => { lib/bin/write-idf.pl etc/enidf.txt=>q[lib/bin/write-idf etc/enidf.txt] }
#     PREREQ_PM => { Scalar::Util=>q[0], IO::Pipe=>q[0], Math::Random=>q[0], IO::Handle=>q[0], MLDBM=>q[0], Storable=>q[0], XML::Simple=>q[0], PDL=>q[0], HTML::LinkExtractor=>q[0], Hash::Flatten=>q[0], POSIX=>q[0], Statistics::ChisqIndep=>q[0], Math::MatrixReal=>q[0], XML::Parser=>q[0], Getopt::Long=>q[0], IO::File=>q[0], Lingua::Stem=>q[0], Carp=>q[0], Test::More=>q[0], Lingua::EN::Sentence=>q[0], BerkeleyDB=>q[0], File::Type=>q[0], Text::Sentence=>q[0], HTML::Parse=>q[0], Graph::Directed=>q[0] }
#     VERSION => q[1.06]
#     clean => { FILES=>q[clairlib-dev-*] }
#     dist => { COMPRESS=>q[gzip -9f], SUFFIX=>q[gz] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/lib/perl/5.14/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,-E
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = cc
LDDLFLAGS = -shared -O2 -g -L/usr/local/lib -fstack-protector
LDFLAGS =  -fstack-protector -L/usr/local/lib
LIBC = 
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 2.6.24-31-server
RANLIB = :
SITELIBEXP = /usr/local/share/perl/5.14.2
SITEARCHEXP = /usr/local/lib/perl/5.14.2
SO = so
VENDORARCHEXP = /usr/lib/perl5
VENDORLIBEXP = /usr/share/perl5


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = Clairlib
NAME_SYM = Clairlib
VERSION = 1.06
VERSION_MACRO = VERSION
VERSION_SYM = 1_06
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 1.06
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1p
MAN3EXT = 3pm
INSTALLDIRS = site
DESTDIR = 
PREFIX = /usr
PERLPREFIX = $(PREFIX)
SITEPREFIX = $(PREFIX)/local
VENDORPREFIX = $(PREFIX)
INSTALLPRIVLIB = $(PERLPREFIX)/share/perl/5.14
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = $(SITEPREFIX)/share/perl/5.14.2
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = $(VENDORPREFIX)/share/perl5
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = $(PERLPREFIX)/lib/perl/5.14
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = $(SITEPREFIX)/lib/perl/5.14.2
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = $(VENDORPREFIX)/lib/perl5
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = $(PERLPREFIX)/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = $(SITEPREFIX)/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = $(VENDORPREFIX)/bin
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = $(PERLPREFIX)/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = $(SITEPREFIX)/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = $(VENDORPREFIX)/bin
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = $(PERLPREFIX)/share/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = $(SITEPREFIX)/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = $(VENDORPREFIX)/share/man/man1
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = $(PERLPREFIX)/share/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = $(SITEPREFIX)/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = $(VENDORPREFIX)/share/man/man3
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /usr/share/perl/5.14
PERL_ARCHLIB = /usr/lib/perl/5.14
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/lib/perl/5.14/CORE
PERL = /usr/bin/perl
FULLPERL = /usr/bin/perl
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /usr/share/perl/5.14/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.57_05
MM_REVISION = 65705

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = Clairlib
BASEEXT = Clairlib
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = 
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = 
MAN3PODS = Authors.pod \
	Changes.pod \
	INSTALL.pod \
	UtilTut.pod \
	lib/Clair/ALE/Conn.pm \
	lib/Clair/ALE/Default/Stemmer.pm \
	lib/Clair/ALE/Extract.pm \
	lib/Clair/ALE/Link.pm \
	lib/Clair/ALE/Search.pm \
	lib/Clair/ALE/Stemmer.pm \
	lib/Clair/ALE/URL.pm \
	lib/Clair/ALE/_SQL.pm \
	lib/Clair/Algorithm/LSI.pm \
	lib/Clair/Bio/Connection.pm \
	lib/Clair/Bio/EUtils.pm \
	lib/Clair/Bio/EUtils/ESearch.pm \
	lib/Clair/Bio/EUtils/ESearchHandler.pm \
	lib/Clair/Bio/GIN.pm \
	lib/Clair/Bio/GIN/Data.pm \
	lib/Clair/Bio/GIN/Interaction.pm \
	lib/Clair/Bio/GeneRIF.pm \
	lib/Clair/CIDR.pm \
	lib/Clair/CIDR/Wrapper.pm \
	lib/Clair/Centroid.pm \
	lib/Clair/ChisqIndependent.pm \
	lib/Clair/Classify.pm \
	lib/Clair/Cluster.pm \
	lib/Clair/Config.pm \
	lib/Clair/Corpus.pm \
	lib/Clair/Debug.pm \
	lib/Clair/Document.pm \
	lib/Clair/Extensions.pm \
	lib/Clair/Features.pm \
	lib/Clair/Gen.pm \
	lib/Clair/GenericDoc.pm \
	lib/Clair/GenericDoc/html.pm \
	lib/Clair/GenericDoc/octet_stream.pm \
	lib/Clair/GenericDoc/plain.pm \
	lib/Clair/GenericDoc/shakespear.pm \
	lib/Clair/GenericDoc/sports.pm \
	lib/Clair/GenericDoc/xml.pm \
	lib/Clair/GraphWrapper.pm \
	lib/Clair/GraphWrapper/Boost.pm \
	lib/Clair/Harmonic.pm \
	lib/Clair/IDF.pm \
	lib/Clair/Index.pm \
	lib/Clair/Index/dirfiles.pm \
	lib/Clair/Index/mldbm.pm \
	lib/Clair/Info/Query.pm \
	lib/Clair/Interface/Weka.pm \
	lib/Clair/LM/Ngram.pm \
	lib/Clair/Learn.pm \
	lib/Clair/LinkPolicy/BarabasiAlbert.pm \
	lib/Clair/LinkPolicy/ErdosRenyi.pm \
	lib/Clair/LinkPolicy/LinkPolicyBase.pm \
	lib/Clair/LinkPolicy/MenczerMacro.pm \
	lib/Clair/LinkPolicy/MenczerPAMixed.pm \
	lib/Clair/LinkPolicy/RadevMicro.pm \
	lib/Clair/LinkPolicy/RadevPAMixed.pm \
	lib/Clair/LinkPolicy/WattsStrogatz.pm \
	lib/Clair/Network.pm \
	lib/Clair/Network/AdamicAdar.pm \
	lib/Clair/Network/CFNetwork.pm \
	lib/Clair/Network/Centrality.pm \
	lib/Clair/Network/Centrality/Betweenness.pm \
	lib/Clair/Network/Centrality/CPPLexRank.pm \
	lib/Clair/Network/Centrality/Closeness.pm \
	lib/Clair/Network/Centrality/Degree.pm \
	lib/Clair/Network/Centrality/LexRank.pm \
	lib/Clair/Network/Centrality/PageRank.pm \
	lib/Clair/Network/Generator/ErdosRenyi.pm \
	lib/Clair/Network/Generator/GeneratorBase.pm \
	lib/Clair/Network/GirvanNewman.pm \
	lib/Clair/Network/KernighanLin.pm \
	lib/Clair/Network/Reader.pm \
	lib/Clair/Network/Reader/Edgelist.pm \
	lib/Clair/Network/Reader/GML.pm \
	lib/Clair/Network/Reader/GraphML.pm \
	lib/Clair/Network/Reader/Pajek.pm \
	lib/Clair/Network/Sample/ForestFire.pm \
	lib/Clair/Network/Sample/RandomEdge.pm \
	lib/Clair/Network/Sample/RandomNode.pm \
	lib/Clair/Network/Sample/SampleBase.pm \
	lib/Clair/Network/SignedNetwork.pm \
	lib/Clair/Network/Spectral.pm \
	lib/Clair/Network/Writer.pm \
	lib/Clair/Network/Writer/Edgelist.pm \
	lib/Clair/Network/Writer/Graclus.pm \
	lib/Clair/Network/Writer/GraphML.pm \
	lib/Clair/Network/Writer/Pajek.pm \
	lib/Clair/Network/Writer/PajekProject.pm \
	lib/Clair/NetworkWrapper.pm \
	lib/Clair/Nutch/Search.pm \
	lib/Clair/Polisci/AustralianParser.pm \
	lib/Clair/Polisci/Graf.pm \
	lib/Clair/Polisci/Record.pm \
	lib/Clair/Polisci/Speaker.pm \
	lib/Clair/Polisci/US/Connection.pm \
	lib/Clair/RandomDistribution/Gaussian.pm \
	lib/Clair/RandomDistribution/LogNormal.pm \
	lib/Clair/RandomDistribution/Poisson.pm \
	lib/Clair/RandomDistribution/RandomDistributionBase.pm \
	lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm \
	lib/Clair/RandomDistribution/Zipfian.pm \
	lib/Clair/RandomWalk.pm \
	lib/Clair/SentenceFeatures.pm \
	lib/Clair/Statistics/Distributions/Geometric.pm \
	lib/Clair/StringManip.pm \
	lib/Clair/SyntheticCollection.pm \
	lib/Clair/Util.pm \
	lib/Clair/Utils/ALE.pm \
	lib/Clair/Utils/CorpusDownload.pm \
	lib/Clair/Utils/Idf.pm \
	lib/Clair/Utils/LinearAlgebra.pm \
	lib/Clair/Utils/Parse.pm \
	lib/Clair/Utils/Polynomial.pm \
	lib/Clair/Utils/Robot2.pm \
	lib/Clair/Utils/Stem.pm \
	lib/Clair/Utils/TFIDFUtils.pm \
	lib/Clair/Utils/Tf.pm \
	lib/Clair/Utils/WebSearch.pm \
	lib/Lingua/EN/Sentence.pm \
	lib/bin/poacher-new.pl

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = Authors.pod \
	Changes.pod \
	INSTALL.pod \
	UtilTut.pod \
	lib/.DS_Store \
	lib/Clair/.DS_Store \
	lib/Clair/ALE/Conn.pm \
	lib/Clair/ALE/Default/NormalizeURL.pm \
	lib/Clair/ALE/Default/Stemmer.pm \
	lib/Clair/ALE/Default/Tokenizer.pm \
	lib/Clair/ALE/Extract.pm \
	lib/Clair/ALE/Link.pm \
	lib/Clair/ALE/NormalizeURL.pm \
	lib/Clair/ALE/Search.pm \
	lib/Clair/ALE/Stemmer.pm \
	lib/Clair/ALE/Tokenizer.pm \
	lib/Clair/ALE/URL.pm \
	lib/Clair/ALE/Wget.pm \
	lib/Clair/ALE/Wget/Hash.pm \
	lib/Clair/ALE/_SQL.pm \
	lib/Clair/Algorithm/LSI.pm \
	lib/Clair/Bio/Connection.pm \
	lib/Clair/Bio/EUtils.pm \
	lib/Clair/Bio/EUtils/ESearch.pm \
	lib/Clair/Bio/EUtils/ESearchHandler.pm \
	lib/Clair/Bio/GIN.pm \
	lib/Clair/Bio/GIN/Data.pm \
	lib/Clair/Bio/GIN/Interaction.pm \
	lib/Clair/Bio/GeneRIF.pm \
	lib/Clair/Bio/soap.properties \
	lib/Clair/CIDR.pm \
	lib/Clair/CIDR/Wrapper.pm \
	lib/Clair/Centroid.pm \
	lib/Clair/ChisqIndependent.pm \
	lib/Clair/Classify.pm \
	lib/Clair/Cluster.pm \
	lib/Clair/Config.pm \
	lib/Clair/Corpus.pm \
	lib/Clair/Debug.pm \
	lib/Clair/Document.pm \
	lib/Clair/Extensions.pm \
	lib/Clair/Features.pm \
	lib/Clair/Gen.pm \
	lib/Clair/GenericDoc.pm \
	lib/Clair/GenericDoc/html.pm \
	lib/Clair/GenericDoc/octet_stream.pm \
	lib/Clair/GenericDoc/plain.pm \
	lib/Clair/GenericDoc/shakespear.pm \
	lib/Clair/GenericDoc/sports.pm \
	lib/Clair/GenericDoc/xml.pm \
	lib/Clair/GraphWrapper.pm \
	lib/Clair/GraphWrapper/Boost.pm \
	lib/Clair/Harmonic.pm \
	lib/Clair/IDF.pm \
	lib/Clair/Index.pm \
	lib/Clair/Index/dirfiles.pm \
	lib/Clair/Index/mldbm.pm \
	lib/Clair/Info/Query.pm \
	lib/Clair/Info/Stats.pm \
	lib/Clair/Interface/Weka.pm \
	lib/Clair/LM/Ngram.pm \
	lib/Clair/Learn.pm \
	lib/Clair/LinkPolicy/BarabasiAlbert.pm \
	lib/Clair/LinkPolicy/ErdosRenyi.pm \
	lib/Clair/LinkPolicy/LinkPolicyBase.pm \
	lib/Clair/LinkPolicy/MenczerMacro.pm \
	lib/Clair/LinkPolicy/MenczerPAMixed.pm \
	lib/Clair/LinkPolicy/RadevMicro.pm \
	lib/Clair/LinkPolicy/RadevPAMixed.pm \
	lib/Clair/LinkPolicy/WattsStrogatz.pm \
	lib/Clair/Network.pm \
	lib/Clair/Network/.DS_Store \
	lib/Clair/Network/AdamicAdar.pm \
	lib/Clair/Network/CFNetwork.pm \
	lib/Clair/Network/Centrality.pm \
	lib/Clair/Network/Centrality/Betweenness.pm \
	lib/Clair/Network/Centrality/CPPLexRank.pm \
	lib/Clair/Network/Centrality/Closeness.pm \
	lib/Clair/Network/Centrality/Degree.pm \
	lib/Clair/Network/Centrality/LexRank.pm \
	lib/Clair/Network/Centrality/PageRank.pm \
	lib/Clair/Network/DoreianMrvar.pm \
	lib/Clair/Network/FordFulkerson.pm \
	lib/Clair/Network/Generator/ErdosRenyi.pm \
	lib/Clair/Network/Generator/GeneratorBase.pm \
	lib/Clair/Network/GirvanNewman.pm \
	lib/Clair/Network/KernighanLin.pm \
	lib/Clair/Network/Mincut.pm \
	lib/Clair/Network/Modularity.pm \
	lib/Clair/Network/Reader.pm \
	lib/Clair/Network/Reader/Edgelist.pm \
	lib/Clair/Network/Reader/GML.pm \
	lib/Clair/Network/Reader/GraphML.pm \
	lib/Clair/Network/Reader/Pajek.pm \
	lib/Clair/Network/Sample/ForestFire.pm \
	lib/Clair/Network/Sample/RandomEdge.pm \
	lib/Clair/Network/Sample/RandomNode.pm \
	lib/Clair/Network/Sample/SampleBase.pm \
	lib/Clair/Network/SignedNetwork.pm \
	lib/Clair/Network/Spectral.pm \
	lib/Clair/Network/Subnet.pm \
	lib/Clair/Network/Writer.pm \
	lib/Clair/Network/Writer/Edgelist.pm \
	lib/Clair/Network/Writer/Graclus.pm \
	lib/Clair/Network/Writer/GraphML.pm \
	lib/Clair/Network/Writer/Pajek.pm \
	lib/Clair/Network/Writer/PajekProject.pm \
	lib/Clair/NetworkWrapper.pm \
	lib/Clair/Nutch/README \
	lib/Clair/Nutch/Search.pm \
	lib/Clair/Nutch/simple_searcher.jar \
	lib/Clair/Polisci/AU/XMLHandler.pm \
	lib/Clair/Polisci/AustralianParser.pm \
	lib/Clair/Polisci/Graf.pm \
	lib/Clair/Polisci/Record.pm \
	lib/Clair/Polisci/Speaker.pm \
	lib/Clair/Polisci/US/Connection.pm \
	lib/Clair/Polisci/US/XMLHandler.pm \
	lib/Clair/RandomDistribution/Gaussian.pm \
	lib/Clair/RandomDistribution/LogNormal.pm \
	lib/Clair/RandomDistribution/Poisson.pm \
	lib/Clair/RandomDistribution/RandomDistributionBase.pm \
	lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm \
	lib/Clair/RandomDistribution/Zipfian.pm \
	lib/Clair/RandomWalk.pm \
	lib/Clair/SentenceFeatures.pm \
	lib/Clair/SentenceSegmenter/MxTerminator.pm \
	lib/Clair/SentenceSegmenter/SentenceSegmenter.pm \
	lib/Clair/SentenceSegmenter/Text.pm \
	lib/Clair/Statistics/.DS_Store \
	lib/Clair/Statistics/Distributions/DistBase.pm \
	lib/Clair/Statistics/Distributions/Geometric.pm \
	lib/Clair/Statistics/Distributions/TDist.pm \
	lib/Clair/StringManip.pm \
	lib/Clair/SyntheticCollection.pm \
	lib/Clair/Util.pm \
	lib/Clair/Utils/ALE.pm \
	lib/Clair/Utils/CorpusDownload.pm \
	lib/Clair/Utils/Idf.pm \
	lib/Clair/Utils/LinearAlgebra.pm \
	lib/Clair/Utils/MxTerminator.pm \
	lib/Clair/Utils/Parse.pm \
	lib/Clair/Utils/Polynomial.pm \
	lib/Clair/Utils/Robot2.pm \
	lib/Clair/Utils/SimRoutines.pm \
	lib/Clair/Utils/Stem.pm \
	lib/Clair/Utils/TFIDFUtils.pm \
	lib/Clair/Utils/Tf.pm \
	lib/Clair/Utils/WebSearch.pm \
	lib/Clair/Utils/porter.pm \
	lib/Lingua/.DS_Store \
	lib/Lingua/EN/Sentence.pm \
	lib/bin/poacher-new.pl \
	lib/bin/write-idf.pl

PM_TO_BLIB = lib/Clair/Network/Generator/ErdosRenyi.pm \
	blib/lib/Clair/Network/Generator/ErdosRenyi.pm \
	lib/Clair/Network/Spectral.pm \
	blib/lib/Clair/Network/Spectral.pm \
	lib/Clair/RandomDistribution/Gaussian.pm \
	blib/lib/Clair/RandomDistribution/Gaussian.pm \
	lib/Clair/SentenceSegmenter/Text.pm \
	blib/lib/Clair/SentenceSegmenter/Text.pm \
	lib/Clair/Bio/EUtils.pm \
	blib/lib/Clair/Bio/EUtils.pm \
	lib/Clair/Utils/CorpusDownload.pm \
	blib/lib/Clair/Utils/CorpusDownload.pm \
	lib/Clair/Network/Writer/GraphML.pm \
	blib/lib/Clair/Network/Writer/GraphML.pm \
	lib/Clair/Network/Generator/GeneratorBase.pm \
	blib/lib/Clair/Network/Generator/GeneratorBase.pm \
	lib/Clair/Index/dirfiles.pm \
	blib/lib/Clair/Index/dirfiles.pm \
	lib/Clair/IDF.pm \
	blib/lib/Clair/IDF.pm \
	lib/Clair/Network/CFNetwork.pm \
	blib/lib/Clair/Network/CFNetwork.pm \
	lib/Clair/Utils/WebSearch.pm \
	blib/lib/Clair/Utils/WebSearch.pm \
	lib/Clair/LinkPolicy/RadevPAMixed.pm \
	blib/lib/Clair/LinkPolicy/RadevPAMixed.pm \
	lib/Clair/ALE/Conn.pm \
	blib/lib/Clair/ALE/Conn.pm \
	lib/Clair/Network/GirvanNewman.pm \
	blib/lib/Clair/Network/GirvanNewman.pm \
	lib/Clair/NetworkWrapper.pm \
	blib/lib/Clair/NetworkWrapper.pm \
	Changes.pod \
	$(INST_LIB)/Changes.pod \
	lib/Clair/ALE/Search.pm \
	blib/lib/Clair/ALE/Search.pm \
	lib/Clair/Utils/Idf.pm \
	blib/lib/Clair/Utils/Idf.pm \
	lib/Clair/Statistics/Distributions/Geometric.pm \
	blib/lib/Clair/Statistics/Distributions/Geometric.pm \
	lib/Clair/Utils/Robot2.pm \
	blib/lib/Clair/Utils/Robot2.pm \
	lib/Clair/Polisci/Graf.pm \
	blib/lib/Clair/Polisci/Graf.pm \
	lib/Clair/Bio/GIN/Data.pm \
	blib/lib/Clair/Bio/GIN/Data.pm \
	lib/Clair/LinkPolicy/ErdosRenyi.pm \
	blib/lib/Clair/LinkPolicy/ErdosRenyi.pm \
	lib/Clair/Utils/Stem.pm \
	blib/lib/Clair/Utils/Stem.pm \
	lib/Clair/ALE/Default/Tokenizer.pm \
	blib/lib/Clair/ALE/Default/Tokenizer.pm \
	lib/Clair/Util.pm \
	blib/lib/Clair/Util.pm \
	lib/Clair/Network/Writer/Graclus.pm \
	blib/lib/Clair/Network/Writer/Graclus.pm \
	lib/Lingua/EN/Sentence.pm \
	blib/lib/Lingua/EN/Sentence.pm \
	lib/bin/poacher-new.pl \
	blib/lib/bin/poacher-new.pl \
	lib/Clair/Bio/GeneRIF.pm \
	blib/lib/Clair/Bio/GeneRIF.pm \
	lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm \
	blib/lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm \
	lib/Clair/ALE/Default/NormalizeURL.pm \
	blib/lib/Clair/ALE/Default/NormalizeURL.pm \
	lib/Clair/Bio/EUtils/ESearchHandler.pm \
	blib/lib/Clair/Bio/EUtils/ESearchHandler.pm \
	lib/Clair/ALE/_SQL.pm \
	blib/lib/Clair/ALE/_SQL.pm \
	lib/Clair/Network/FordFulkerson.pm \
	blib/lib/Clair/Network/FordFulkerson.pm \
	lib/Clair/Network/DoreianMrvar.pm \
	blib/lib/Clair/Network/DoreianMrvar.pm \
	lib/Clair/GenericDoc/shakespear.pm \
	blib/lib/Clair/GenericDoc/shakespear.pm \
	lib/Clair/Bio/GIN/Interaction.pm \
	blib/lib/Clair/Bio/GIN/Interaction.pm \
	lib/Clair/Utils/ALE.pm \
	blib/lib/Clair/Utils/ALE.pm \
	lib/Clair/RandomDistribution/Zipfian.pm \
	blib/lib/Clair/RandomDistribution/Zipfian.pm \
	lib/Clair/Network/Centrality/Degree.pm \
	blib/lib/Clair/Network/Centrality/Degree.pm \
	lib/Clair/ALE/Wget/Hash.pm \
	blib/lib/Clair/ALE/Wget/Hash.pm \
	lib/Clair/ALE/NormalizeURL.pm \
	blib/lib/Clair/ALE/NormalizeURL.pm \
	lib/Clair/Network/Sample/SampleBase.pm \
	blib/lib/Clair/Network/Sample/SampleBase.pm \
	lib/Clair/RandomWalk.pm \
	blib/lib/Clair/RandomWalk.pm \
	lib/Clair/CIDR/Wrapper.pm \
	blib/lib/Clair/CIDR/Wrapper.pm \
	lib/Clair/Features.pm \
	blib/lib/Clair/Features.pm \
	lib/Clair/Network/Writer/PajekProject.pm \
	blib/lib/Clair/Network/Writer/PajekProject.pm \
	lib/.DS_Store \
	blib/lib/.DS_Store \
	lib/Clair/CIDR.pm \
	blib/lib/Clair/CIDR.pm \
	lib/Clair/Harmonic.pm \
	blib/lib/Clair/Harmonic.pm \
	lib/Clair/Corpus.pm \
	blib/lib/Clair/Corpus.pm \
	lib/Clair/Statistics/.DS_Store \
	blib/lib/Clair/Statistics/.DS_Store \
	lib/Clair/ALE/Link.pm \
	blib/lib/Clair/ALE/Link.pm \
	lib/Clair/Bio/EUtils/ESearch.pm \
	blib/lib/Clair/Bio/EUtils/ESearch.pm \
	lib/Clair/Utils/Parse.pm \
	blib/lib/Clair/Utils/Parse.pm \
	lib/Clair/Index/mldbm.pm \
	blib/lib/Clair/Index/mldbm.pm \
	lib/Clair/RandomDistribution/RandomDistributionBase.pm \
	blib/lib/Clair/RandomDistribution/RandomDistributionBase.pm \
	lib/Clair/Network/Subnet.pm \
	blib/lib/Clair/Network/Subnet.pm \
	lib/Clair/.DS_Store \
	blib/lib/Clair/.DS_Store \
	lib/Clair/Network/Writer/Pajek.pm \
	blib/lib/Clair/Network/Writer/Pajek.pm \
	lib/Clair/GenericDoc/sports.pm \
	blib/lib/Clair/GenericDoc/sports.pm \
	UtilTut.pod \
	$(INST_LIB)/UtilTut.pod \
	lib/Clair/Polisci/Record.pm \
	blib/lib/Clair/Polisci/Record.pm \
	lib/Clair/GraphWrapper/Boost.pm \
	blib/lib/Clair/GraphWrapper/Boost.pm \
	lib/Clair/Network/Mincut.pm \
	blib/lib/Clair/Network/Mincut.pm \
	INSTALL.pod \
	$(INST_LIB)/INSTALL.pod \
	lib/Clair/Document.pm \
	blib/lib/Clair/Document.pm \
	lib/Clair/Network/Sample/RandomNode.pm \
	blib/lib/Clair/Network/Sample/RandomNode.pm \
	lib/Clair/Gen.pm \
	blib/lib/Clair/Gen.pm \
	lib/bin/write-idf.pl \
	blib/lib/bin/write-idf.pl \
	lib/Clair/Statistics/Distributions/DistBase.pm \
	blib/lib/Clair/Statistics/Distributions/DistBase.pm \
	lib/Clair/LM/Ngram.pm \
	blib/lib/Clair/LM/Ngram.pm \
	lib/Clair/GraphWrapper.pm \
	blib/lib/Clair/GraphWrapper.pm \
	lib/Clair/ALE/URL.pm \
	blib/lib/Clair/ALE/URL.pm \
	lib/Clair/GenericDoc/octet_stream.pm \
	blib/lib/Clair/GenericDoc/octet_stream.pm \
	lib/Clair/Utils/SimRoutines.pm \
	blib/lib/Clair/Utils/SimRoutines.pm \
	lib/Clair/Network/AdamicAdar.pm \
	blib/lib/Clair/Network/AdamicAdar.pm \
	Authors.pod \
	$(INST_LIB)/Authors.pod \
	lib/Clair/Network/SignedNetwork.pm \
	blib/lib/Clair/Network/SignedNetwork.pm \
	lib/Clair/Nutch/README \
	blib/lib/Clair/Nutch/README \
	lib/Clair/Nutch/simple_searcher.jar \
	blib/lib/Clair/Nutch/simple_searcher.jar \
	lib/Clair/Network/Centrality/Closeness.pm \
	blib/lib/Clair/Network/Centrality/Closeness.pm \
	lib/Clair/Utils/Polynomial.pm \
	blib/lib/Clair/Utils/Polynomial.pm \
	lib/Clair/Network/Sample/RandomEdge.pm \
	blib/lib/Clair/Network/Sample/RandomEdge.pm \
	lib/Clair/SentenceSegmenter/SentenceSegmenter.pm \
	blib/lib/Clair/SentenceSegmenter/SentenceSegmenter.pm \
	lib/Clair/SentenceSegmenter/MxTerminator.pm \
	blib/lib/Clair/SentenceSegmenter/MxTerminator.pm \
	lib/Clair/Utils/Tf.pm \
	blib/lib/Clair/Utils/Tf.pm \
	lib/Clair/Polisci/AustralianParser.pm \
	blib/lib/Clair/Polisci/AustralianParser.pm \
	lib/Clair/Polisci/US/Connection.pm \
	blib/lib/Clair/Polisci/US/Connection.pm \
	lib/Clair/Network/Reader/GML.pm \
	blib/lib/Clair/Network/Reader/GML.pm \
	lib/Clair/Info/Query.pm \
	blib/lib/Clair/Info/Query.pm \
	lib/Clair/Nutch/Search.pm \
	blib/lib/Clair/Nutch/Search.pm \
	lib/Clair/Network.pm \
	blib/lib/Clair/Network.pm \
	lib/Clair/LinkPolicy/WattsStrogatz.pm \
	blib/lib/Clair/LinkPolicy/WattsStrogatz.pm \
	lib/Clair/ALE/Wget.pm \
	blib/lib/Clair/ALE/Wget.pm \
	lib/Clair/Polisci/US/XMLHandler.pm \
	blib/lib/Clair/Polisci/US/XMLHandler.pm \
	lib/Clair/Network/Writer/Edgelist.pm \
	blib/lib/Clair/Network/Writer/Edgelist.pm \
	lib/Clair/ALE/Stemmer.pm \
	blib/lib/Clair/ALE/Stemmer.pm \
	lib/Clair/SyntheticCollection.pm \
	blib/lib/Clair/SyntheticCollection.pm \
	lib/Clair/Config.pm \
	blib/lib/Clair/Config.pm \
	lib/Clair/Network/Reader/GraphML.pm \
	blib/lib/Clair/Network/Reader/GraphML.pm \
	lib/Clair/Info/Stats.pm \
	blib/lib/Clair/Info/Stats.pm \
	lib/Clair/Utils/LinearAlgebra.pm \
	blib/lib/Clair/Utils/LinearAlgebra.pm \
	lib/Clair/Network/Reader/Pajek.pm \
	blib/lib/Clair/Network/Reader/Pajek.pm \
	lib/Clair/Polisci/AU/XMLHandler.pm \
	blib/lib/Clair/Polisci/AU/XMLHandler.pm \
	lib/Clair/Bio/soap.properties \
	blib/lib/Clair/Bio/soap.properties \
	lib/Clair/Network/Centrality/CPPLexRank.pm \
	blib/lib/Clair/Network/Centrality/CPPLexRank.pm \
	lib/Clair/ALE/Extract.pm \
	blib/lib/Clair/ALE/Extract.pm \
	lib/Clair/SentenceFeatures.pm \
	blib/lib/Clair/SentenceFeatures.pm \
	lib/Clair/LinkPolicy/BarabasiAlbert.pm \
	blib/lib/Clair/LinkPolicy/BarabasiAlbert.pm \
	lib/Clair/Statistics/Distributions/TDist.pm \
	blib/lib/Clair/Statistics/Distributions/TDist.pm \
	lib/Clair/ALE/Tokenizer.pm \
	blib/lib/Clair/ALE/Tokenizer.pm \
	lib/Clair/Bio/Connection.pm \
	blib/lib/Clair/Bio/Connection.pm \
	lib/Clair/Debug.pm \
	blib/lib/Clair/Debug.pm \
	lib/Clair/GenericDoc/html.pm \
	blib/lib/Clair/GenericDoc/html.pm \
	lib/Clair/ALE/Default/Stemmer.pm \
	blib/lib/Clair/ALE/Default/Stemmer.pm \
	lib/Clair/GenericDoc.pm \
	blib/lib/Clair/GenericDoc.pm \
	lib/Clair/GenericDoc/plain.pm \
	blib/lib/Clair/GenericDoc/plain.pm \
	lib/Clair/Network/Centrality.pm \
	blib/lib/Clair/Network/Centrality.pm \
	lib/Clair/LinkPolicy/MenczerMacro.pm \
	blib/lib/Clair/LinkPolicy/MenczerMacro.pm \
	lib/Clair/Utils/MxTerminator.pm \
	blib/lib/Clair/Utils/MxTerminator.pm \
	lib/Clair/Interface/Weka.pm \
	blib/lib/Clair/Interface/Weka.pm \
	lib/Clair/RandomDistribution/Poisson.pm \
	blib/lib/Clair/RandomDistribution/Poisson.pm \
	lib/Clair/RandomDistribution/LogNormal.pm \
	blib/lib/Clair/RandomDistribution/LogNormal.pm \
	lib/Clair/Network/Reader/Edgelist.pm \
	blib/lib/Clair/Network/Reader/Edgelist.pm \
	lib/Clair/Utils/TFIDFUtils.pm \
	blib/lib/Clair/Utils/TFIDFUtils.pm \
	lib/Clair/Network/Reader.pm \
	blib/lib/Clair/Network/Reader.pm \
	lib/Clair/Utils/porter.pm \
	blib/lib/Clair/Utils/porter.pm \
	lib/Clair/Index.pm \
	blib/lib/Clair/Index.pm \
	lib/Clair/Centroid.pm \
	blib/lib/Clair/Centroid.pm \
	lib/Clair/Cluster.pm \
	blib/lib/Clair/Cluster.pm \
	lib/Clair/Classify.pm \
	blib/lib/Clair/Classify.pm \
	lib/Clair/Network/KernighanLin.pm \
	blib/lib/Clair/Network/KernighanLin.pm \
	lib/Clair/Network/Sample/ForestFire.pm \
	blib/lib/Clair/Network/Sample/ForestFire.pm \
	lib/Clair/Network/Writer.pm \
	blib/lib/Clair/Network/Writer.pm \
	lib/Clair/StringManip.pm \
	blib/lib/Clair/StringManip.pm \
	lib/Clair/Network/Modularity.pm \
	blib/lib/Clair/Network/Modularity.pm \
	lib/Lingua/.DS_Store \
	blib/lib/Lingua/.DS_Store \
	lib/Clair/Extensions.pm \
	blib/lib/Clair/Extensions.pm \
	lib/Clair/Network/Centrality/PageRank.pm \
	blib/lib/Clair/Network/Centrality/PageRank.pm \
	lib/Clair/Network/Centrality/Betweenness.pm \
	blib/lib/Clair/Network/Centrality/Betweenness.pm \
	lib/Clair/Algorithm/LSI.pm \
	blib/lib/Clair/Algorithm/LSI.pm \
	lib/Clair/Bio/GIN.pm \
	blib/lib/Clair/Bio/GIN.pm \
	lib/Clair/Network/.DS_Store \
	blib/lib/Clair/Network/.DS_Store \
	lib/Clair/LinkPolicy/LinkPolicyBase.pm \
	blib/lib/Clair/LinkPolicy/LinkPolicyBase.pm \
	lib/Clair/ChisqIndependent.pm \
	blib/lib/Clair/ChisqIndependent.pm \
	lib/Clair/LinkPolicy/RadevMicro.pm \
	blib/lib/Clair/LinkPolicy/RadevMicro.pm \
	lib/Clair/Network/Centrality/LexRank.pm \
	blib/lib/Clair/Network/Centrality/LexRank.pm \
	lib/Clair/Polisci/Speaker.pm \
	blib/lib/Clair/Polisci/Speaker.pm \
	lib/Clair/Learn.pm \
	blib/lib/Clair/Learn.pm \
	lib/Clair/LinkPolicy/MenczerPAMixed.pm \
	blib/lib/Clair/LinkPolicy/MenczerPAMixed.pm \
	lib/Clair/GenericDoc/xml.pm \
	blib/lib/Clair/GenericDoc/xml.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.57_05
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$ARGV[0], $$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip -9f
SUFFIX = gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = Clairlib
DISTVNAME = Clairlib-1.06


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(INST_DYNAMIC) $(INST_BOOT)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	lib/Clair/ALE/URL.pm \
	lib/Clair/GenericDoc/octet_stream.pm \
	lib/Clair/Network/Generator/ErdosRenyi.pm \
	lib/Clair/Network/Spectral.pm \
	lib/Clair/Network/AdamicAdar.pm \
	lib/Clair/RandomDistribution/Gaussian.pm \
	Authors.pod \
	lib/Clair/Network/SignedNetwork.pm \
	lib/Clair/Bio/EUtils.pm \
	lib/Clair/Utils/CorpusDownload.pm \
	lib/Clair/Network/Generator/GeneratorBase.pm \
	lib/Clair/Network/Writer/GraphML.pm \
	lib/Clair/Index/dirfiles.pm \
	lib/Clair/IDF.pm \
	lib/Clair/Network/Centrality/Closeness.pm \
	lib/Clair/Utils/Polynomial.pm \
	lib/Clair/Network/CFNetwork.pm \
	lib/Clair/LinkPolicy/RadevPAMixed.pm \
	lib/Clair/Utils/WebSearch.pm \
	lib/Clair/Network/Sample/RandomEdge.pm \
	lib/Clair/ALE/Conn.pm \
	Changes.pod \
	lib/Clair/NetworkWrapper.pm \
	lib/Clair/Network/GirvanNewman.pm \
	lib/Clair/Utils/Tf.pm \
	lib/Clair/Polisci/AustralianParser.pm \
	lib/Clair/Polisci/US/Connection.pm \
	lib/Clair/ALE/Search.pm \
	lib/Clair/Utils/Idf.pm \
	lib/Clair/Statistics/Distributions/Geometric.pm \
	lib/Clair/Network/Reader/GML.pm \
	lib/Clair/Utils/Robot2.pm \
	lib/Clair/Info/Query.pm \
	lib/Clair/Polisci/Graf.pm \
	lib/Clair/Nutch/Search.pm \
	lib/Clair/Bio/GIN/Data.pm \
	lib/Clair/LinkPolicy/ErdosRenyi.pm \
	lib/Clair/Network.pm \
	lib/Clair/LinkPolicy/WattsStrogatz.pm \
	lib/Clair/Network/Writer/Edgelist.pm \
	lib/Clair/Utils/Stem.pm \
	lib/Clair/ALE/Stemmer.pm \
	lib/Clair/SyntheticCollection.pm \
	lib/Clair/Util.pm \
	lib/Clair/Config.pm \
	lib/Clair/Network/Writer/Graclus.pm \
	lib/Lingua/EN/Sentence.pm \
	lib/Clair/Network/Reader/GraphML.pm \
	lib/bin/poacher-new.pl \
	lib/Clair/Utils/LinearAlgebra.pm \
	lib/Clair/Network/Reader/Pajek.pm \
	lib/Clair/Bio/GeneRIF.pm \
	lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm \
	lib/Clair/Network/Centrality/CPPLexRank.pm \
	lib/Clair/Bio/EUtils/ESearchHandler.pm \
	lib/Clair/ALE/_SQL.pm \
	lib/Clair/ALE/Extract.pm \
	lib/Clair/SentenceFeatures.pm \
	lib/Clair/LinkPolicy/BarabasiAlbert.pm \
	lib/Clair/GenericDoc/shakespear.pm \
	lib/Clair/Bio/GIN/Interaction.pm \
	lib/Clair/Utils/ALE.pm \
	lib/Clair/RandomDistribution/Zipfian.pm \
	lib/Clair/Network/Centrality/Degree.pm \
	lib/Clair/Bio/Connection.pm \
	lib/Clair/Debug.pm \
	lib/Clair/GenericDoc/html.pm \
	lib/Clair/ALE/Default/Stemmer.pm \
	lib/Clair/GenericDoc.pm \
	lib/Clair/GenericDoc/plain.pm \
	lib/Clair/Network/Sample/SampleBase.pm \
	lib/Clair/Network/Centrality.pm \
	lib/Clair/LinkPolicy/MenczerMacro.pm \
	lib/Clair/Interface/Weka.pm \
	lib/Clair/RandomDistribution/Poisson.pm \
	lib/Clair/RandomWalk.pm \
	lib/Clair/CIDR/Wrapper.pm \
	lib/Clair/Features.pm \
	lib/Clair/Network/Writer/PajekProject.pm \
	lib/Clair/CIDR.pm \
	lib/Clair/RandomDistribution/LogNormal.pm \
	lib/Clair/Network/Reader/Edgelist.pm \
	lib/Clair/Harmonic.pm \
	lib/Clair/Utils/TFIDFUtils.pm \
	lib/Clair/Network/Reader.pm \
	lib/Clair/Index.pm \
	lib/Clair/Centroid.pm \
	lib/Clair/Corpus.pm \
	lib/Clair/ALE/Link.pm \
	lib/Clair/Utils/Parse.pm \
	lib/Clair/Bio/EUtils/ESearch.pm \
	lib/Clair/Index/mldbm.pm \
	lib/Clair/Cluster.pm \
	lib/Clair/RandomDistribution/RandomDistributionBase.pm \
	lib/Clair/Classify.pm \
	lib/Clair/Network/KernighanLin.pm \
	lib/Clair/Network/Sample/ForestFire.pm \
	lib/Clair/Network/Writer.pm \
	lib/Clair/StringManip.pm \
	lib/Clair/Network/Writer/Pajek.pm \
	lib/Clair/Extensions.pm \
	lib/Clair/Network/Centrality/PageRank.pm \
	UtilTut.pod \
	lib/Clair/GenericDoc/sports.pm \
	lib/Clair/GraphWrapper/Boost.pm \
	lib/Clair/Polisci/Record.pm \
	lib/Clair/Network/Centrality/Betweenness.pm \
	lib/Clair/Algorithm/LSI.pm \
	lib/Clair/Bio/GIN.pm \
	INSTALL.pod \
	lib/Clair/LinkPolicy/LinkPolicyBase.pm \
	lib/Clair/ChisqIndependent.pm \
	lib/Clair/Document.pm \
	lib/Clair/Network/Sample/RandomNode.pm \
	lib/Clair/LinkPolicy/RadevMicro.pm \
	lib/Clair/Gen.pm \
	lib/Clair/Network/Centrality/LexRank.pm \
	lib/Clair/Polisci/Speaker.pm \
	lib/Clair/LM/Ngram.pm \
	lib/Clair/GraphWrapper.pm \
	lib/Clair/Learn.pm \
	lib/Clair/LinkPolicy/MenczerPAMixed.pm \
	lib/Clair/GenericDoc/xml.pm
	$(NOECHO) $(POD2MAN) --section=$(MAN3EXT) --perm_rw=$(PERM_RW) \
	  lib/Clair/ALE/URL.pm $(INST_MAN3DIR)/Clair::ALE::URL.$(MAN3EXT) \
	  lib/Clair/GenericDoc/octet_stream.pm $(INST_MAN3DIR)/Clair::GenericDoc::octet_stream.$(MAN3EXT) \
	  lib/Clair/Network/Generator/ErdosRenyi.pm $(INST_MAN3DIR)/Clair::Network::Generator::ErdosRenyi.$(MAN3EXT) \
	  lib/Clair/Network/Spectral.pm $(INST_MAN3DIR)/Clair::Network::Spectral.$(MAN3EXT) \
	  lib/Clair/Network/AdamicAdar.pm $(INST_MAN3DIR)/Clair::Network::AdamicAdar.$(MAN3EXT) \
	  lib/Clair/RandomDistribution/Gaussian.pm $(INST_MAN3DIR)/Clair::RandomDistribution::Gaussian.$(MAN3EXT) \
	  Authors.pod $(INST_MAN3DIR)/Authors.$(MAN3EXT) \
	  lib/Clair/Network/SignedNetwork.pm $(INST_MAN3DIR)/Clair::Network::SignedNetwork.$(MAN3EXT) \
	  lib/Clair/Bio/EUtils.pm $(INST_MAN3DIR)/Clair::Bio::EUtils.$(MAN3EXT) \
	  lib/Clair/Utils/CorpusDownload.pm $(INST_MAN3DIR)/Clair::Utils::CorpusDownload.$(MAN3EXT) \
	  lib/Clair/Network/Generator/GeneratorBase.pm $(INST_MAN3DIR)/Clair::Network::Generator::GeneratorBase.$(MAN3EXT) \
	  lib/Clair/Network/Writer/GraphML.pm $(INST_MAN3DIR)/Clair::Network::Writer::GraphML.$(MAN3EXT) \
	  lib/Clair/Index/dirfiles.pm $(INST_MAN3DIR)/Clair::Index::dirfiles.$(MAN3EXT) \
	  lib/Clair/IDF.pm $(INST_MAN3DIR)/Clair::IDF.$(MAN3EXT) \
	  lib/Clair/Network/Centrality/Closeness.pm $(INST_MAN3DIR)/Clair::Network::Centrality::Closeness.$(MAN3EXT) \
	  lib/Clair/Utils/Polynomial.pm $(INST_MAN3DIR)/Clair::Utils::Polynomial.$(MAN3EXT) \
	  lib/Clair/Network/CFNetwork.pm $(INST_MAN3DIR)/Clair::Network::CFNetwork.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/RadevPAMixed.pm $(INST_MAN3DIR)/Clair::LinkPolicy::RadevPAMixed.$(MAN3EXT) \
	  lib/Clair/Utils/WebSearch.pm $(INST_MAN3DIR)/Clair::Utils::WebSearch.$(MAN3EXT) \
	  lib/Clair/Network/Sample/RandomEdge.pm $(INST_MAN3DIR)/Clair::Network::Sample::RandomEdge.$(MAN3EXT) \
	  lib/Clair/ALE/Conn.pm $(INST_MAN3DIR)/Clair::ALE::Conn.$(MAN3EXT) \
	  Changes.pod $(INST_MAN3DIR)/Changes.$(MAN3EXT) \
	  lib/Clair/NetworkWrapper.pm $(INST_MAN3DIR)/Clair::NetworkWrapper.$(MAN3EXT) \
	  lib/Clair/Network/GirvanNewman.pm $(INST_MAN3DIR)/Clair::Network::GirvanNewman.$(MAN3EXT) \
	  lib/Clair/Utils/Tf.pm $(INST_MAN3DIR)/Clair::Utils::Tf.$(MAN3EXT) \
	  lib/Clair/Polisci/AustralianParser.pm $(INST_MAN3DIR)/Clair::Polisci::AustralianParser.$(MAN3EXT) \
	  lib/Clair/Polisci/US/Connection.pm $(INST_MAN3DIR)/Clair::Polisci::US::Connection.$(MAN3EXT) \
	  lib/Clair/ALE/Search.pm $(INST_MAN3DIR)/Clair::ALE::Search.$(MAN3EXT) \
	  lib/Clair/Utils/Idf.pm $(INST_MAN3DIR)/Clair::Utils::Idf.$(MAN3EXT) \
	  lib/Clair/Statistics/Distributions/Geometric.pm $(INST_MAN3DIR)/Clair::Statistics::Distributions::Geometric.$(MAN3EXT) \
	  lib/Clair/Network/Reader/GML.pm $(INST_MAN3DIR)/Clair::Network::Reader::GML.$(MAN3EXT) \
	  lib/Clair/Utils/Robot2.pm $(INST_MAN3DIR)/Clair::Utils::Robot2.$(MAN3EXT) 
	$(NOECHO) $(POD2MAN) --section=$(MAN3EXT) --perm_rw=$(PERM_RW) \
	  lib/Clair/Info/Query.pm $(INST_MAN3DIR)/Clair::Info::Query.$(MAN3EXT) \
	  lib/Clair/Polisci/Graf.pm $(INST_MAN3DIR)/Clair::Polisci::Graf.$(MAN3EXT) \
	  lib/Clair/Nutch/Search.pm $(INST_MAN3DIR)/Clair::Nutch::Search.$(MAN3EXT) \
	  lib/Clair/Bio/GIN/Data.pm $(INST_MAN3DIR)/Clair::Bio::GIN::Data.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/ErdosRenyi.pm $(INST_MAN3DIR)/Clair::LinkPolicy::ErdosRenyi.$(MAN3EXT) \
	  lib/Clair/Network.pm $(INST_MAN3DIR)/Clair::Network.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/WattsStrogatz.pm $(INST_MAN3DIR)/Clair::LinkPolicy::WattsStrogatz.$(MAN3EXT) \
	  lib/Clair/Network/Writer/Edgelist.pm $(INST_MAN3DIR)/Clair::Network::Writer::Edgelist.$(MAN3EXT) \
	  lib/Clair/Utils/Stem.pm $(INST_MAN3DIR)/Clair::Utils::Stem.$(MAN3EXT) \
	  lib/Clair/ALE/Stemmer.pm $(INST_MAN3DIR)/Clair::ALE::Stemmer.$(MAN3EXT) \
	  lib/Clair/SyntheticCollection.pm $(INST_MAN3DIR)/Clair::SyntheticCollection.$(MAN3EXT) \
	  lib/Clair/Util.pm $(INST_MAN3DIR)/Clair::Util.$(MAN3EXT) \
	  lib/Clair/Config.pm $(INST_MAN3DIR)/Clair::Config.$(MAN3EXT) \
	  lib/Clair/Network/Writer/Graclus.pm $(INST_MAN3DIR)/Clair::Network::Writer::Graclus.$(MAN3EXT) \
	  lib/Lingua/EN/Sentence.pm $(INST_MAN3DIR)/Lingua::EN::Sentence.$(MAN3EXT) \
	  lib/Clair/Network/Reader/GraphML.pm $(INST_MAN3DIR)/Clair::Network::Reader::GraphML.$(MAN3EXT) \
	  lib/bin/poacher-new.pl $(INST_MAN3DIR)/bin::poacher-new.$(MAN3EXT) \
	  lib/Clair/Utils/LinearAlgebra.pm $(INST_MAN3DIR)/Clair::Utils::LinearAlgebra.$(MAN3EXT) \
	  lib/Clair/Network/Reader/Pajek.pm $(INST_MAN3DIR)/Clair::Network::Reader::Pajek.$(MAN3EXT) \
	  lib/Clair/Bio/GeneRIF.pm $(INST_MAN3DIR)/Clair::Bio::GeneRIF.$(MAN3EXT) \
	  lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm $(INST_MAN3DIR)/Clair::RandomDistribution::RandomDistributionFromWeights.$(MAN3EXT) \
	  lib/Clair/Network/Centrality/CPPLexRank.pm $(INST_MAN3DIR)/Clair::Network::Centrality::CPPLexRank.$(MAN3EXT) \
	  lib/Clair/Bio/EUtils/ESearchHandler.pm $(INST_MAN3DIR)/Clair::Bio::EUtils::ESearchHandler.$(MAN3EXT) \
	  lib/Clair/ALE/_SQL.pm $(INST_MAN3DIR)/Clair::ALE::_SQL.$(MAN3EXT) \
	  lib/Clair/ALE/Extract.pm $(INST_MAN3DIR)/Clair::ALE::Extract.$(MAN3EXT) \
	  lib/Clair/SentenceFeatures.pm $(INST_MAN3DIR)/Clair::SentenceFeatures.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/BarabasiAlbert.pm $(INST_MAN3DIR)/Clair::LinkPolicy::BarabasiAlbert.$(MAN3EXT) \
	  lib/Clair/GenericDoc/shakespear.pm $(INST_MAN3DIR)/Clair::GenericDoc::shakespear.$(MAN3EXT) \
	  lib/Clair/Bio/GIN/Interaction.pm $(INST_MAN3DIR)/Clair::Bio::GIN::Interaction.$(MAN3EXT) \
	  lib/Clair/Utils/ALE.pm $(INST_MAN3DIR)/Clair::Utils::ALE.$(MAN3EXT) \
	  lib/Clair/RandomDistribution/Zipfian.pm $(INST_MAN3DIR)/Clair::RandomDistribution::Zipfian.$(MAN3EXT) 
	$(NOECHO) $(POD2MAN) --section=$(MAN3EXT) --perm_rw=$(PERM_RW) \
	  lib/Clair/Network/Centrality/Degree.pm $(INST_MAN3DIR)/Clair::Network::Centrality::Degree.$(MAN3EXT) \
	  lib/Clair/Bio/Connection.pm $(INST_MAN3DIR)/Clair::Bio::Connection.$(MAN3EXT) \
	  lib/Clair/Debug.pm $(INST_MAN3DIR)/Clair::Debug.$(MAN3EXT) \
	  lib/Clair/GenericDoc/html.pm $(INST_MAN3DIR)/Clair::GenericDoc::html.$(MAN3EXT) \
	  lib/Clair/ALE/Default/Stemmer.pm $(INST_MAN3DIR)/Clair::ALE::Default::Stemmer.$(MAN3EXT) \
	  lib/Clair/GenericDoc.pm $(INST_MAN3DIR)/Clair::GenericDoc.$(MAN3EXT) \
	  lib/Clair/GenericDoc/plain.pm $(INST_MAN3DIR)/Clair::GenericDoc::plain.$(MAN3EXT) \
	  lib/Clair/Network/Sample/SampleBase.pm $(INST_MAN3DIR)/Clair::Network::Sample::SampleBase.$(MAN3EXT) \
	  lib/Clair/Network/Centrality.pm $(INST_MAN3DIR)/Clair::Network::Centrality.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/MenczerMacro.pm $(INST_MAN3DIR)/Clair::LinkPolicy::MenczerMacro.$(MAN3EXT) \
	  lib/Clair/Interface/Weka.pm $(INST_MAN3DIR)/Clair::Interface::Weka.$(MAN3EXT) \
	  lib/Clair/RandomDistribution/Poisson.pm $(INST_MAN3DIR)/Clair::RandomDistribution::Poisson.$(MAN3EXT) \
	  lib/Clair/RandomWalk.pm $(INST_MAN3DIR)/Clair::RandomWalk.$(MAN3EXT) \
	  lib/Clair/CIDR/Wrapper.pm $(INST_MAN3DIR)/Clair::CIDR::Wrapper.$(MAN3EXT) \
	  lib/Clair/Features.pm $(INST_MAN3DIR)/Clair::Features.$(MAN3EXT) \
	  lib/Clair/Network/Writer/PajekProject.pm $(INST_MAN3DIR)/Clair::Network::Writer::PajekProject.$(MAN3EXT) \
	  lib/Clair/CIDR.pm $(INST_MAN3DIR)/Clair::CIDR.$(MAN3EXT) \
	  lib/Clair/RandomDistribution/LogNormal.pm $(INST_MAN3DIR)/Clair::RandomDistribution::LogNormal.$(MAN3EXT) \
	  lib/Clair/Network/Reader/Edgelist.pm $(INST_MAN3DIR)/Clair::Network::Reader::Edgelist.$(MAN3EXT) \
	  lib/Clair/Harmonic.pm $(INST_MAN3DIR)/Clair::Harmonic.$(MAN3EXT) \
	  lib/Clair/Utils/TFIDFUtils.pm $(INST_MAN3DIR)/Clair::Utils::TFIDFUtils.$(MAN3EXT) \
	  lib/Clair/Network/Reader.pm $(INST_MAN3DIR)/Clair::Network::Reader.$(MAN3EXT) \
	  lib/Clair/Index.pm $(INST_MAN3DIR)/Clair::Index.$(MAN3EXT) \
	  lib/Clair/Centroid.pm $(INST_MAN3DIR)/Clair::Centroid.$(MAN3EXT) \
	  lib/Clair/Corpus.pm $(INST_MAN3DIR)/Clair::Corpus.$(MAN3EXT) \
	  lib/Clair/ALE/Link.pm $(INST_MAN3DIR)/Clair::ALE::Link.$(MAN3EXT) \
	  lib/Clair/Utils/Parse.pm $(INST_MAN3DIR)/Clair::Utils::Parse.$(MAN3EXT) \
	  lib/Clair/Bio/EUtils/ESearch.pm $(INST_MAN3DIR)/Clair::Bio::EUtils::ESearch.$(MAN3EXT) \
	  lib/Clair/Index/mldbm.pm $(INST_MAN3DIR)/Clair::Index::mldbm.$(MAN3EXT) \
	  lib/Clair/Cluster.pm $(INST_MAN3DIR)/Clair::Cluster.$(MAN3EXT) \
	  lib/Clair/RandomDistribution/RandomDistributionBase.pm $(INST_MAN3DIR)/Clair::RandomDistribution::RandomDistributionBase.$(MAN3EXT) \
	  lib/Clair/Classify.pm $(INST_MAN3DIR)/Clair::Classify.$(MAN3EXT) \
	  lib/Clair/Network/KernighanLin.pm $(INST_MAN3DIR)/Clair::Network::KernighanLin.$(MAN3EXT) 
	$(NOECHO) $(POD2MAN) --section=$(MAN3EXT) --perm_rw=$(PERM_RW) \
	  lib/Clair/Network/Sample/ForestFire.pm $(INST_MAN3DIR)/Clair::Network::Sample::ForestFire.$(MAN3EXT) \
	  lib/Clair/Network/Writer.pm $(INST_MAN3DIR)/Clair::Network::Writer.$(MAN3EXT) \
	  lib/Clair/StringManip.pm $(INST_MAN3DIR)/Clair::StringManip.$(MAN3EXT) \
	  lib/Clair/Network/Writer/Pajek.pm $(INST_MAN3DIR)/Clair::Network::Writer::Pajek.$(MAN3EXT) \
	  lib/Clair/Extensions.pm $(INST_MAN3DIR)/Clair::Extensions.$(MAN3EXT) \
	  lib/Clair/Network/Centrality/PageRank.pm $(INST_MAN3DIR)/Clair::Network::Centrality::PageRank.$(MAN3EXT) \
	  UtilTut.pod $(INST_MAN3DIR)/UtilTut.$(MAN3EXT) \
	  lib/Clair/GenericDoc/sports.pm $(INST_MAN3DIR)/Clair::GenericDoc::sports.$(MAN3EXT) \
	  lib/Clair/GraphWrapper/Boost.pm $(INST_MAN3DIR)/Clair::GraphWrapper::Boost.$(MAN3EXT) \
	  lib/Clair/Polisci/Record.pm $(INST_MAN3DIR)/Clair::Polisci::Record.$(MAN3EXT) \
	  lib/Clair/Network/Centrality/Betweenness.pm $(INST_MAN3DIR)/Clair::Network::Centrality::Betweenness.$(MAN3EXT) \
	  lib/Clair/Algorithm/LSI.pm $(INST_MAN3DIR)/Clair::Algorithm::LSI.$(MAN3EXT) \
	  lib/Clair/Bio/GIN.pm $(INST_MAN3DIR)/Clair::Bio::GIN.$(MAN3EXT) \
	  INSTALL.pod $(INST_MAN3DIR)/INSTALL.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/LinkPolicyBase.pm $(INST_MAN3DIR)/Clair::LinkPolicy::LinkPolicyBase.$(MAN3EXT) \
	  lib/Clair/ChisqIndependent.pm $(INST_MAN3DIR)/Clair::ChisqIndependent.$(MAN3EXT) \
	  lib/Clair/Document.pm $(INST_MAN3DIR)/Clair::Document.$(MAN3EXT) \
	  lib/Clair/Network/Sample/RandomNode.pm $(INST_MAN3DIR)/Clair::Network::Sample::RandomNode.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/RadevMicro.pm $(INST_MAN3DIR)/Clair::LinkPolicy::RadevMicro.$(MAN3EXT) \
	  lib/Clair/Gen.pm $(INST_MAN3DIR)/Clair::Gen.$(MAN3EXT) \
	  lib/Clair/Network/Centrality/LexRank.pm $(INST_MAN3DIR)/Clair::Network::Centrality::LexRank.$(MAN3EXT) \
	  lib/Clair/Polisci/Speaker.pm $(INST_MAN3DIR)/Clair::Polisci::Speaker.$(MAN3EXT) \
	  lib/Clair/LM/Ngram.pm $(INST_MAN3DIR)/Clair::LM::Ngram.$(MAN3EXT) \
	  lib/Clair/GraphWrapper.pm $(INST_MAN3DIR)/Clair::GraphWrapper.$(MAN3EXT) \
	  lib/Clair/Learn.pm $(INST_MAN3DIR)/Clair::Learn.$(MAN3EXT) \
	  lib/Clair/LinkPolicy/MenczerPAMixed.pm $(INST_MAN3DIR)/Clair::LinkPolicy::MenczerPAMixed.$(MAN3EXT) \
	  lib/Clair/GenericDoc/xml.pm $(INST_MAN3DIR)/Clair::GenericDoc::xml.$(MAN3EXT) 




# --- MakeMaker processPL section:

all :: lib/bin/write-idf etc/enidf.txt
	$(NOECHO) $(NOOP)

lib/bin/write-idf etc/enidf.txt :: lib/bin/write-idf.pl etc/enidf.txt pm_to_blib
	$(PERLRUNINST) lib/bin/write-idf.pl etc/enidf.txt lib/bin/write-idf etc/enidf.txt


# --- MakeMaker installbin section:


# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  *$(LIB_EXT) core \
	  core.[0-9] $(INST_ARCHAUTODIR)/extralibs.all \
	  core.[0-9][0-9] $(BASEEXT).bso \
	  pm_to_blib.ts core.[0-9][0-9][0-9][0-9] \
	  MYMETA.yml $(BASEEXT).x \
	  $(BOOTSTRAP) perl$(EXE_EXT) \
	  tmon.out *$(OBJ_EXT) \
	  pm_to_blib $(INST_ARCHAUTODIR)/extralibs.ld \
	  blibdirs.ts core.[0-9][0-9][0-9][0-9][0-9] \
	  *perl.core core.*perl.*.? \
	  $(MAKE_APERL_FILE) perl \
	  $(BASEEXT).def core.[0-9][0-9][0-9] \
	  mon.out lib$(BASEEXT).def \
	  perlmain.c perl.exe \
	  so_locations $(BASEEXT).exp 
	- $(RM_RF) \
	  clairlib-dev-* blib 
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(MAKEFILE_OLD) $(FIRST_MAKEFILE) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '--- #YAML:1.0' > META_new.yml
	$(NOECHO) $(ECHO) 'name:               Clairlib' >> META_new.yml
	$(NOECHO) $(ECHO) 'version:            1.06' >> META_new.yml
	$(NOECHO) $(ECHO) 'abstract:           a library designed to simplify generic tasks in natural language processing (NLP), information retrieval (IR), and network analysis (NA)' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - The Clair group<clair@umich.edu>' >> META_new.yml
	$(NOECHO) $(ECHO) 'license:            unknown' >> META_new.yml
	$(NOECHO) $(ECHO) 'distribution_type:  module' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '    ExtUtils::MakeMaker:  0' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '    ExtUtils::MakeMaker:  0' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '    BerkeleyDB:           0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Carp:                 0' >> META_new.yml
	$(NOECHO) $(ECHO) '    File::Type:           0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Getopt::Long:         0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Graph::Directed:      0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Hash::Flatten:        0' >> META_new.yml
	$(NOECHO) $(ECHO) '    HTML::LinkExtractor:  0' >> META_new.yml
	$(NOECHO) $(ECHO) '    HTML::Parse:          0' >> META_new.yml
	$(NOECHO) $(ECHO) '    IO::File:             0' >> META_new.yml
	$(NOECHO) $(ECHO) '    IO::Handle:           0' >> META_new.yml
	$(NOECHO) $(ECHO) '    IO::Pipe:             0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Lingua::EN::Sentence:  0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Lingua::Stem:         0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Math::MatrixReal:     0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Math::Random:         0' >> META_new.yml
	$(NOECHO) $(ECHO) '    MLDBM:                0' >> META_new.yml
	$(NOECHO) $(ECHO) '    PDL:                  0' >> META_new.yml
	$(NOECHO) $(ECHO) '    POSIX:                0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Scalar::Util:         0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Statistics::ChisqIndep:  0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Storable:             0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Test::More:           0' >> META_new.yml
	$(NOECHO) $(ECHO) '    Text::Sentence:       0' >> META_new.yml
	$(NOECHO) $(ECHO) '    XML::Parser:          0' >> META_new.yml
	$(NOECHO) $(ECHO) '    XML::Simple:          0' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '    directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '        - t' >> META_new.yml
	$(NOECHO) $(ECHO) '        - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by:       ExtUtils::MakeMaker version 6.57_05' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '    url:      http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '    version:  1.4' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old 



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{META.yml} => q{Module meta-data (added by MakeMaker)}}) } ' \
	  -e '    or print "Could not add META.yml to MANIFEST: $${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) } ' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) umask 022; $(MOD_INSTALL) \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install :: all
	$(NOECHO) umask 02; $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) umask 022; $(MOD_INSTALL) \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)

doc_perl_install :: all

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLSITEARCH)/perllocal.pod
	-$(NOECHO) umask 02; $(MKPATH) $(DESTINSTALLSITEARCH)
	-$(NOECHO) umask 02; $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLSITEARCH)/perllocal.pod

doc_vendor_install :: all


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::



# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /usr/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-e" "test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="1.06">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>a library designed to simplify generic tasks in natural language processing (NLP), information retrieval (IR), and network analysis (NA)</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>The Clair group&lt;clair@umich.edu&gt;</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="BerkeleyDB::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Carp::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Type" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Getopt::Long" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Graph::Directed" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTML::LinkExtractor" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTML::Parse" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Hash::Flatten" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="IO::File" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="IO::Handle" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="IO::Pipe" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Lingua::EN::Sentence" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Lingua::Stem" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="MLDBM::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Math::MatrixReal" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Math::Random" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="PDL::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="POSIX::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Scalar::Util" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Statistics::ChisqIndep" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Storable::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Test::More" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Text::Sentence" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="XML::Parser" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="XML::Simple" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="x86_64-linux-gnu-thread-multi-5.14" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/Clair/Network/Generator/ErdosRenyi.pm blib/lib/Clair/Network/Generator/ErdosRenyi.pm \
	  lib/Clair/Network/Spectral.pm blib/lib/Clair/Network/Spectral.pm \
	  lib/Clair/RandomDistribution/Gaussian.pm blib/lib/Clair/RandomDistribution/Gaussian.pm \
	  lib/Clair/SentenceSegmenter/Text.pm blib/lib/Clair/SentenceSegmenter/Text.pm \
	  lib/Clair/Bio/EUtils.pm blib/lib/Clair/Bio/EUtils.pm \
	  lib/Clair/Utils/CorpusDownload.pm blib/lib/Clair/Utils/CorpusDownload.pm \
	  lib/Clair/Network/Writer/GraphML.pm blib/lib/Clair/Network/Writer/GraphML.pm \
	  lib/Clair/Network/Generator/GeneratorBase.pm blib/lib/Clair/Network/Generator/GeneratorBase.pm \
	  lib/Clair/Index/dirfiles.pm blib/lib/Clair/Index/dirfiles.pm \
	  lib/Clair/IDF.pm blib/lib/Clair/IDF.pm \
	  lib/Clair/Network/CFNetwork.pm blib/lib/Clair/Network/CFNetwork.pm \
	  lib/Clair/Utils/WebSearch.pm blib/lib/Clair/Utils/WebSearch.pm \
	  lib/Clair/LinkPolicy/RadevPAMixed.pm blib/lib/Clair/LinkPolicy/RadevPAMixed.pm \
	  lib/Clair/ALE/Conn.pm blib/lib/Clair/ALE/Conn.pm \
	  lib/Clair/Network/GirvanNewman.pm blib/lib/Clair/Network/GirvanNewman.pm \
	  lib/Clair/NetworkWrapper.pm blib/lib/Clair/NetworkWrapper.pm \
	  Changes.pod $(INST_LIB)/Changes.pod \
	  lib/Clair/ALE/Search.pm blib/lib/Clair/ALE/Search.pm \
	  lib/Clair/Utils/Idf.pm blib/lib/Clair/Utils/Idf.pm \
	  lib/Clair/Statistics/Distributions/Geometric.pm blib/lib/Clair/Statistics/Distributions/Geometric.pm \
	  lib/Clair/Utils/Robot2.pm blib/lib/Clair/Utils/Robot2.pm \
	  lib/Clair/Polisci/Graf.pm blib/lib/Clair/Polisci/Graf.pm \
	  lib/Clair/Bio/GIN/Data.pm blib/lib/Clair/Bio/GIN/Data.pm \
	  lib/Clair/LinkPolicy/ErdosRenyi.pm blib/lib/Clair/LinkPolicy/ErdosRenyi.pm \
	  lib/Clair/Utils/Stem.pm blib/lib/Clair/Utils/Stem.pm \
	  lib/Clair/ALE/Default/Tokenizer.pm blib/lib/Clair/ALE/Default/Tokenizer.pm \
	  lib/Clair/Util.pm blib/lib/Clair/Util.pm \
	  lib/Clair/Network/Writer/Graclus.pm blib/lib/Clair/Network/Writer/Graclus.pm \
	  lib/Lingua/EN/Sentence.pm blib/lib/Lingua/EN/Sentence.pm \
	  lib/bin/poacher-new.pl blib/lib/bin/poacher-new.pl \
	  lib/Clair/Bio/GeneRIF.pm blib/lib/Clair/Bio/GeneRIF.pm \
	  lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm blib/lib/Clair/RandomDistribution/RandomDistributionFromWeights.pm \
	  lib/Clair/ALE/Default/NormalizeURL.pm blib/lib/Clair/ALE/Default/NormalizeURL.pm \
	  lib/Clair/Bio/EUtils/ESearchHandler.pm blib/lib/Clair/Bio/EUtils/ESearchHandler.pm \
	  lib/Clair/ALE/_SQL.pm blib/lib/Clair/ALE/_SQL.pm \
	  lib/Clair/Network/FordFulkerson.pm blib/lib/Clair/Network/FordFulkerson.pm \
	  lib/Clair/Network/DoreianMrvar.pm blib/lib/Clair/Network/DoreianMrvar.pm \
	  lib/Clair/GenericDoc/shakespear.pm blib/lib/Clair/GenericDoc/shakespear.pm 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/Clair/Bio/GIN/Interaction.pm blib/lib/Clair/Bio/GIN/Interaction.pm \
	  lib/Clair/Utils/ALE.pm blib/lib/Clair/Utils/ALE.pm \
	  lib/Clair/RandomDistribution/Zipfian.pm blib/lib/Clair/RandomDistribution/Zipfian.pm \
	  lib/Clair/Network/Centrality/Degree.pm blib/lib/Clair/Network/Centrality/Degree.pm \
	  lib/Clair/ALE/Wget/Hash.pm blib/lib/Clair/ALE/Wget/Hash.pm \
	  lib/Clair/ALE/NormalizeURL.pm blib/lib/Clair/ALE/NormalizeURL.pm \
	  lib/Clair/Network/Sample/SampleBase.pm blib/lib/Clair/Network/Sample/SampleBase.pm \
	  lib/Clair/RandomWalk.pm blib/lib/Clair/RandomWalk.pm \
	  lib/Clair/CIDR/Wrapper.pm blib/lib/Clair/CIDR/Wrapper.pm \
	  lib/Clair/Features.pm blib/lib/Clair/Features.pm \
	  lib/Clair/Network/Writer/PajekProject.pm blib/lib/Clair/Network/Writer/PajekProject.pm \
	  lib/.DS_Store blib/lib/.DS_Store \
	  lib/Clair/CIDR.pm blib/lib/Clair/CIDR.pm \
	  lib/Clair/Harmonic.pm blib/lib/Clair/Harmonic.pm \
	  lib/Clair/Corpus.pm blib/lib/Clair/Corpus.pm \
	  lib/Clair/Statistics/.DS_Store blib/lib/Clair/Statistics/.DS_Store \
	  lib/Clair/ALE/Link.pm blib/lib/Clair/ALE/Link.pm \
	  lib/Clair/Bio/EUtils/ESearch.pm blib/lib/Clair/Bio/EUtils/ESearch.pm \
	  lib/Clair/Utils/Parse.pm blib/lib/Clair/Utils/Parse.pm \
	  lib/Clair/Index/mldbm.pm blib/lib/Clair/Index/mldbm.pm \
	  lib/Clair/RandomDistribution/RandomDistributionBase.pm blib/lib/Clair/RandomDistribution/RandomDistributionBase.pm \
	  lib/Clair/Network/Subnet.pm blib/lib/Clair/Network/Subnet.pm \
	  lib/Clair/.DS_Store blib/lib/Clair/.DS_Store \
	  lib/Clair/Network/Writer/Pajek.pm blib/lib/Clair/Network/Writer/Pajek.pm \
	  lib/Clair/GenericDoc/sports.pm blib/lib/Clair/GenericDoc/sports.pm \
	  UtilTut.pod $(INST_LIB)/UtilTut.pod \
	  lib/Clair/Polisci/Record.pm blib/lib/Clair/Polisci/Record.pm \
	  lib/Clair/GraphWrapper/Boost.pm blib/lib/Clair/GraphWrapper/Boost.pm \
	  lib/Clair/Network/Mincut.pm blib/lib/Clair/Network/Mincut.pm \
	  INSTALL.pod $(INST_LIB)/INSTALL.pod \
	  lib/Clair/Document.pm blib/lib/Clair/Document.pm \
	  lib/Clair/Network/Sample/RandomNode.pm blib/lib/Clair/Network/Sample/RandomNode.pm \
	  lib/Clair/Gen.pm blib/lib/Clair/Gen.pm \
	  lib/bin/write-idf.pl blib/lib/bin/write-idf.pl \
	  lib/Clair/Statistics/Distributions/DistBase.pm blib/lib/Clair/Statistics/Distributions/DistBase.pm \
	  lib/Clair/LM/Ngram.pm blib/lib/Clair/LM/Ngram.pm \
	  lib/Clair/GraphWrapper.pm blib/lib/Clair/GraphWrapper.pm \
	  lib/Clair/ALE/URL.pm blib/lib/Clair/ALE/URL.pm \
	  lib/Clair/GenericDoc/octet_stream.pm blib/lib/Clair/GenericDoc/octet_stream.pm \
	  lib/Clair/Utils/SimRoutines.pm blib/lib/Clair/Utils/SimRoutines.pm \
	  lib/Clair/Network/AdamicAdar.pm blib/lib/Clair/Network/AdamicAdar.pm \
	  Authors.pod $(INST_LIB)/Authors.pod 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/Clair/Network/SignedNetwork.pm blib/lib/Clair/Network/SignedNetwork.pm \
	  lib/Clair/Nutch/README blib/lib/Clair/Nutch/README \
	  lib/Clair/Nutch/simple_searcher.jar blib/lib/Clair/Nutch/simple_searcher.jar \
	  lib/Clair/Network/Centrality/Closeness.pm blib/lib/Clair/Network/Centrality/Closeness.pm \
	  lib/Clair/Utils/Polynomial.pm blib/lib/Clair/Utils/Polynomial.pm \
	  lib/Clair/Network/Sample/RandomEdge.pm blib/lib/Clair/Network/Sample/RandomEdge.pm \
	  lib/Clair/SentenceSegmenter/SentenceSegmenter.pm blib/lib/Clair/SentenceSegmenter/SentenceSegmenter.pm \
	  lib/Clair/SentenceSegmenter/MxTerminator.pm blib/lib/Clair/SentenceSegmenter/MxTerminator.pm \
	  lib/Clair/Utils/Tf.pm blib/lib/Clair/Utils/Tf.pm \
	  lib/Clair/Polisci/AustralianParser.pm blib/lib/Clair/Polisci/AustralianParser.pm \
	  lib/Clair/Polisci/US/Connection.pm blib/lib/Clair/Polisci/US/Connection.pm \
	  lib/Clair/Network/Reader/GML.pm blib/lib/Clair/Network/Reader/GML.pm \
	  lib/Clair/Info/Query.pm blib/lib/Clair/Info/Query.pm \
	  lib/Clair/Nutch/Search.pm blib/lib/Clair/Nutch/Search.pm \
	  lib/Clair/Network.pm blib/lib/Clair/Network.pm \
	  lib/Clair/LinkPolicy/WattsStrogatz.pm blib/lib/Clair/LinkPolicy/WattsStrogatz.pm \
	  lib/Clair/ALE/Wget.pm blib/lib/Clair/ALE/Wget.pm \
	  lib/Clair/Polisci/US/XMLHandler.pm blib/lib/Clair/Polisci/US/XMLHandler.pm \
	  lib/Clair/Network/Writer/Edgelist.pm blib/lib/Clair/Network/Writer/Edgelist.pm \
	  lib/Clair/ALE/Stemmer.pm blib/lib/Clair/ALE/Stemmer.pm \
	  lib/Clair/SyntheticCollection.pm blib/lib/Clair/SyntheticCollection.pm \
	  lib/Clair/Config.pm blib/lib/Clair/Config.pm \
	  lib/Clair/Network/Reader/GraphML.pm blib/lib/Clair/Network/Reader/GraphML.pm \
	  lib/Clair/Info/Stats.pm blib/lib/Clair/Info/Stats.pm \
	  lib/Clair/Utils/LinearAlgebra.pm blib/lib/Clair/Utils/LinearAlgebra.pm \
	  lib/Clair/Network/Reader/Pajek.pm blib/lib/Clair/Network/Reader/Pajek.pm \
	  lib/Clair/Polisci/AU/XMLHandler.pm blib/lib/Clair/Polisci/AU/XMLHandler.pm \
	  lib/Clair/Bio/soap.properties blib/lib/Clair/Bio/soap.properties \
	  lib/Clair/Network/Centrality/CPPLexRank.pm blib/lib/Clair/Network/Centrality/CPPLexRank.pm \
	  lib/Clair/ALE/Extract.pm blib/lib/Clair/ALE/Extract.pm \
	  lib/Clair/SentenceFeatures.pm blib/lib/Clair/SentenceFeatures.pm \
	  lib/Clair/LinkPolicy/BarabasiAlbert.pm blib/lib/Clair/LinkPolicy/BarabasiAlbert.pm \
	  lib/Clair/Statistics/Distributions/TDist.pm blib/lib/Clair/Statistics/Distributions/TDist.pm \
	  lib/Clair/ALE/Tokenizer.pm blib/lib/Clair/ALE/Tokenizer.pm \
	  lib/Clair/Bio/Connection.pm blib/lib/Clair/Bio/Connection.pm \
	  lib/Clair/Debug.pm blib/lib/Clair/Debug.pm \
	  lib/Clair/GenericDoc/html.pm blib/lib/Clair/GenericDoc/html.pm 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/Clair/ALE/Default/Stemmer.pm blib/lib/Clair/ALE/Default/Stemmer.pm \
	  lib/Clair/GenericDoc.pm blib/lib/Clair/GenericDoc.pm \
	  lib/Clair/GenericDoc/plain.pm blib/lib/Clair/GenericDoc/plain.pm \
	  lib/Clair/Network/Centrality.pm blib/lib/Clair/Network/Centrality.pm \
	  lib/Clair/LinkPolicy/MenczerMacro.pm blib/lib/Clair/LinkPolicy/MenczerMacro.pm \
	  lib/Clair/Utils/MxTerminator.pm blib/lib/Clair/Utils/MxTerminator.pm \
	  lib/Clair/Interface/Weka.pm blib/lib/Clair/Interface/Weka.pm \
	  lib/Clair/RandomDistribution/Poisson.pm blib/lib/Clair/RandomDistribution/Poisson.pm \
	  lib/Clair/RandomDistribution/LogNormal.pm blib/lib/Clair/RandomDistribution/LogNormal.pm \
	  lib/Clair/Network/Reader/Edgelist.pm blib/lib/Clair/Network/Reader/Edgelist.pm \
	  lib/Clair/Utils/TFIDFUtils.pm blib/lib/Clair/Utils/TFIDFUtils.pm \
	  lib/Clair/Network/Reader.pm blib/lib/Clair/Network/Reader.pm \
	  lib/Clair/Utils/porter.pm blib/lib/Clair/Utils/porter.pm \
	  lib/Clair/Index.pm blib/lib/Clair/Index.pm \
	  lib/Clair/Centroid.pm blib/lib/Clair/Centroid.pm \
	  lib/Clair/Cluster.pm blib/lib/Clair/Cluster.pm \
	  lib/Clair/Classify.pm blib/lib/Clair/Classify.pm \
	  lib/Clair/Network/KernighanLin.pm blib/lib/Clair/Network/KernighanLin.pm \
	  lib/Clair/Network/Sample/ForestFire.pm blib/lib/Clair/Network/Sample/ForestFire.pm \
	  lib/Clair/Network/Writer.pm blib/lib/Clair/Network/Writer.pm \
	  lib/Clair/StringManip.pm blib/lib/Clair/StringManip.pm \
	  lib/Clair/Network/Modularity.pm blib/lib/Clair/Network/Modularity.pm \
	  lib/Lingua/.DS_Store blib/lib/Lingua/.DS_Store \
	  lib/Clair/Extensions.pm blib/lib/Clair/Extensions.pm \
	  lib/Clair/Network/Centrality/PageRank.pm blib/lib/Clair/Network/Centrality/PageRank.pm \
	  lib/Clair/Network/Centrality/Betweenness.pm blib/lib/Clair/Network/Centrality/Betweenness.pm \
	  lib/Clair/Algorithm/LSI.pm blib/lib/Clair/Algorithm/LSI.pm \
	  lib/Clair/Bio/GIN.pm blib/lib/Clair/Bio/GIN.pm \
	  lib/Clair/Network/.DS_Store blib/lib/Clair/Network/.DS_Store \
	  lib/Clair/LinkPolicy/LinkPolicyBase.pm blib/lib/Clair/LinkPolicy/LinkPolicyBase.pm \
	  lib/Clair/ChisqIndependent.pm blib/lib/Clair/ChisqIndependent.pm \
	  lib/Clair/LinkPolicy/RadevMicro.pm blib/lib/Clair/LinkPolicy/RadevMicro.pm \
	  lib/Clair/Network/Centrality/LexRank.pm blib/lib/Clair/Network/Centrality/LexRank.pm \
	  lib/Clair/Polisci/Speaker.pm blib/lib/Clair/Polisci/Speaker.pm \
	  lib/Clair/Learn.pm blib/lib/Clair/Learn.pm \
	  lib/Clair/LinkPolicy/MenczerPAMixed.pm blib/lib/Clair/LinkPolicy/MenczerPAMixed.pm \
	  lib/Clair/GenericDoc/xml.pm blib/lib/Clair/GenericDoc/xml.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
