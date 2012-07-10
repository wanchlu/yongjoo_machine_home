use strict;
use warnings;

use 5.8.2;
use ExtUtils::MakeMaker;
# chen's test
# chen's test1

WriteMakefile(
    NAME      => 'Clairlib',
    VERSION   => 1.06,
    AUTHOR    => 'The Clair group<clair@umich.edu>',
    ABSTRACT  => 'a library designed to simplify generic tasks in natural language processing (NLP), information retrieval (IR), and network analysis (NA)',
    PL_FILES  => {'lib/bin/write-idf.pl etc/enidf.txt' => 'lib/bin/write-idf etc/enidf.txt'},
    PREREQ_PM => { 'BerkeleyDB'             => 0,
                   'Carp'                   => 0,
                   'File::Type'             => 0,
                   'Getopt::Long'           => 0,
                   'Graph::Directed'        => 0,
                   'Hash::Flatten'          => 0,
                   'HTML::LinkExtractor'    => 0,
                   'HTML::Parse'            => 0,
                   'IO::File'               => 0,
                   'IO::Handle'             => 0,
                   'IO::Pipe'               => 0,
                   'Lingua::Stem'           => 0,
                   'Lingua::EN::Sentence'   => 0,
                   'Math::MatrixReal'       => 0,
                   'Math::Random'           => 0,
                   'MLDBM'                  => 0,
                   'PDL'                    => 0,
                   'POSIX'                  => 0,
                   'Scalar::Util'           => 0,
                   'Statistics::ChisqIndep' => 0,
                   'Storable'               => 0,
                   'Test::More'             => 0,
                   'Text::Sentence'         => 0,
                   'XML::Parser'            => 0,
                   'XML::Simple'            => 0
                 },
    dist      => { COMPRESS => 'gzip -9f',
                       SUFFIX   => 'gz'
                     },
    clean     => { FILES    => 'clairlib-dev-*' },
);
