package ccom;

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	HASH_COUNT
	PHONET_VERSION
	null
);
$VERSION = '1.4';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
		croak "Your vendor has not defined ccom macro $constname";
	}
    }
    no strict 'refs';
    *$AUTOLOAD = sub () { $val };
    goto &$AUTOLOAD;
}

bootstrap ccom $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

	ccom - Perl extension for "phonet" algorithm developed from Jörg Michael

=head1 SYNOPSIS

  	use ccom;
  
  	$phonetic = ccom::phonet( StringToEncode )
	$phonetic = ccom::phonetRulesetOne( StringToEncode )
	$phonetic = ccom::phonetRulesetTwo( StringToEncode )

=head1 DESCRIPTION

	"ccom" is a wrapper library for the C-sources of "phonet" algorithm written
	by Jörg Michael. 
	Main Target of "phonet" is to transform a String into it's phonetic
	representation. This algoritm is mainly used to eliminate errors in 
	spelling of single words. The algorithm is specially developed to cover
	the needs of the GERMAN language.

=head1 INSTALLATION

	For installation purposes see delivered "README.txt".

=head1 AUTHOR

Michael Maretzke, michael@maretzke.de

=head1 SEE ALSO

perl(1).

=cut
