use strict;
use warnings;

use 5.8.2;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME      => 'Clairlib-Ext',
    VERSION   => 1.02,
    AUTHOR    => 'The Clair group<clair@umich.edu>',
    ABSTRACT  => 'a distribution extending Clairlib-core with optional functionality and hooks to external code.',
    PL_FILES  => { },
    PREREQ_PM => { 'BerkeleyDB'             => 0,
                   'Carp'                   => 0,
                   'File::Type'             => 0,
                   'Getopt::Long'           => 0,
                   'Graph::Directed'        => 0,          
                   'HTML::LinkExtractor'    => 0,          
                   'HTML::Parse'            => 0,          
                   'IO::File'               => 0,          
                   'IO::Handle'             => 0,           
                   'IO::Pipe'               => 0,
                   'Lingua::Stem'           => 0,
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
