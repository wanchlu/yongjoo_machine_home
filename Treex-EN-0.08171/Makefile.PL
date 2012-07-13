
use strict;
use warnings;

BEGIN { require 5.010; }

use ExtUtils::MakeMaker 6.31;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  'ABSTRACT' => 'collection of blocks for processing English',
  'AUTHOR' => 'Treex team <treex@ufal.mff.cuni.cz>',
  'BUILD_REQUIRES' => {
    'English' => '0',
    'File::Find' => '0',
    'File::Slurp' => '9999',
    'File::Temp' => '0',
    'Readonly' => '0',
    'Test::More' => '0',
    'Treex::Core::Document' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31',
    'File::ShareDir::Install' => '0.03'
  },
  'DISTNAME' => 'Treex-EN',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Treex::EN',
  'PREREQ_PM' => {
    'File::Slurp' => '0',
    'Lingua::EN::Tagger' => '0',
    'Moose' => '0',
    'Treex::Block::W2A::ParseMSTperl' => '0',
    'Treex::Block::W2A::Tokenize' => '0',
    'Treex::Core::Block' => '0',
    'Treex::Core::Common' => '0',
    'Treex::Core::Log' => '0',
    'Treex::Core::Resource' => '0',
    'Treex::Tool::Segment::RuleBased' => '0',
    'Treex::Tool::Tagger::Featurama' => '0',
    'Treex::Unilang' => '0.08170',
    'utf8' => '0'
  },
  'VERSION' => '0.08171',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

package
MY;
use File::ShareDir::Install qw(postamble);


