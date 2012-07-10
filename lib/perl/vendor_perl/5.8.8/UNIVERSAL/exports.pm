package UNIVERSAL::exports;
$UNIVERSAL::exports::VERSION = '0.05';


package UNIVERSAL;

use strict;
use Exporter::Lite qw(import);

=head1 NAME

UNIVERSAL::exports - Lightweight, universal exporting of variables

=head1 SYNOPSIS

  package Foo;
  use UNIVERSAL::exports;

  # Just like Exporter.
  @EXPORT       = qw($This &That);
  @EXPORT_OK    = qw(@Left %Right);


  # Meanwhile, in another piece of code!
  package Bar;
  use Foo;  # exports $This and &That.


=head1 DESCRIPTION

This is an alternative to Exporter intended to provide a universal,
lightweight subset of its functionality.  It uses Exporter::Lite, so
look there for details.

Additionally, C<exports()> is provided to find out what symbols a
module exports.

UNIVERSAL::exports places its methods in the UNIVERSAL namespace, so
there is no need to subclass from it.


=head1 Methods

UNIVERSAL::exports has two public methods, import() derived from
Exporter::Lite, and exports().

=over 4

=item B<import>

  Some::Module->import;
  Some::Module->import(@symbols);

This is Exporter::Lite's import() method.  Look in L<Exporter::Lite>
for details.

=item B<exports>

  @exported_symbols = Some::Module->exports;
  Some::Module->exports($symbol);

Reports what symbols are exported by Some::Module.  With no arguments,
it simply returns a list of all exportable symbols.  Otherwise, it
reports if it will export a given $symbol.

=cut


sub exports {
    my($exporter) = shift;

    my %exports;

    {
        no strict 'refs';
        %exports = map { $_ => 1 } @{$exporter.'::EXPORT'},
                                   @{$exporter.'::EXPORT_OK'};
    }

    if( @_ ) {
        return exists $exports{$_[0]};
    }
    else {
        return keys %exports;
    }
}


=back

=head1 DIAGNOSTICS

=over 4

=item '"%s" is not exported by the %s module'

Attempted to import a symbol which is not in @EXPORT or @EXPORT_OK.

=item 'Can\'t export symbol: %s'

Attempted to import a symbol of an unknown type (ie. the leading $@% salad
wasn't recognized).

=back

=head1 AUTHORS

Michael G Schwern <schwern@pobox.com>

=head1 BUGS and ISSUES

Please report bugs and issues via L<http://rt.cpan.org>

=head1 LICENSE and COPYRIGHT

Copyright 2001, 2006 Michael G Schwern

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=head1 SEE ALSO

Other ways to Export: L<Exporter>, L<Exporter::Lite>,
L<Sub::Exporter>, L<Exporter::Simple>

The Perl 6 RFC that started it all:  L<http://dev.perl.org/rfc/257.pod>

More UNIVERSAL magic:  L<UNIVERSAL::require>

=cut


007;
