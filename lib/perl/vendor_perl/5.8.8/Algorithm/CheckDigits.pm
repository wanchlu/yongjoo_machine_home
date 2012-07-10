# vim: ts=4 sw=4 tw=78 et si:
package Algorithm::CheckDigits;

use 5.006;
use strict;
use warnings;
use Carp;
use vars qw($AUTOLOAD);

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use CheckDigits ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = (
    'all' => [
        qw(
          CheckDigits method_list print_methods
          ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( CheckDigits );

my %methods = (
    'mbase-001'          => 'Algorithm::CheckDigits::MBase_001',
    'upc'                => 'Algorithm::CheckDigits::MBase_001',
    'mbase-002'          => 'Algorithm::CheckDigits::MBase_002',
    'blutbeutel'         => 'Algorithm::CheckDigits::MBase_002',
    'bzue_de'            => 'Algorithm::CheckDigits::MBase_002',
    'ustid_de'           => 'Algorithm::CheckDigits::MBase_002',
    'vatrn_de'           => 'Algorithm::CheckDigits::MBase_002',
    'mbase-003'          => 'Algorithm::CheckDigits::MBase_003',
    'sici'               => 'Algorithm::CheckDigits::MBase_003',
    'm07-001'            => 'Algorithm::CheckDigits::M07_001',
    'm09-001'            => 'Algorithm::CheckDigits::M09_001',
    'euronote'           => 'Algorithm::CheckDigits::M09_001',
    'm10-001'            => 'Algorithm::CheckDigits::M10_001',
    'amex'               => 'Algorithm::CheckDigits::M10_001',
    'bahncard'           => 'Algorithm::CheckDigits::M10_001',
    'diners'             => 'Algorithm::CheckDigits::M10_001',
    'discover'           => 'Algorithm::CheckDigits::M10_001',
    'enroute'            => 'Algorithm::CheckDigits::M10_001',
    'eurocard'           => 'Algorithm::CheckDigits::M10_001',
    'happydigits'        => 'Algorithm::CheckDigits::M10_001',
    'jcb'                => 'Algorithm::CheckDigits::M10_001',
    'klubkarstadt'       => 'Algorithm::CheckDigits::M10_001',
    'mastercard'         => 'Algorithm::CheckDigits::M10_001',
    'miles&more'         => 'Algorithm::CheckDigits::M10_001',
    'visa'               => 'Algorithm::CheckDigits::M10_001',
    'isin'               => 'Algorithm::CheckDigits::M10_001',
    'imei'               => 'Algorithm::CheckDigits::M10_001',
    'imeisv'             => 'Algorithm::CheckDigits::M10_001',
    'm10-002'            => 'Algorithm::CheckDigits::M10_002',
    'siren'              => 'Algorithm::CheckDigits::M10_002',
    'siret'              => 'Algorithm::CheckDigits::M10_002',
    'm10-003'            => 'Algorithm::CheckDigits::M10_003',
    'ismn'               => 'Algorithm::CheckDigits::M10_003',
    'm10-004'            => 'Algorithm::CheckDigits::M10_004',
    'ean'                => 'Algorithm::CheckDigits::M10_004',
    'iln'                => 'Algorithm::CheckDigits::M10_004',
    'nve'                => 'Algorithm::CheckDigits::M10_004',
    '2aus5'              => 'Algorithm::CheckDigits::M10_004',
    'isbn13'             => 'Algorithm::CheckDigits::M10_004',
    'm10-005'            => 'Algorithm::CheckDigits::M10_005',
    'identcode_dp'       => 'Algorithm::CheckDigits::M10_005',
    'leitcode_dp'        => 'Algorithm::CheckDigits::M10_005',
    'm10-006'            => 'Algorithm::CheckDigits::M10_006',
    'rentenversicherung' => 'Algorithm::CheckDigits::M10_006',
    'm10-008'            => 'Algorithm::CheckDigits::M10_008',
    'sedol'              => 'Algorithm::CheckDigits::M10_008',
    'm10-009'            => 'Algorithm::CheckDigits::M10_009',
    'betriebsnummer'     => 'Algorithm::CheckDigits::M10_009',
    'm10-010'            => 'Algorithm::CheckDigits::M10_010',
    'postcheckkonti'     => 'Algorithm::CheckDigits::M10_010',
    'm10-011'            => 'Algorithm::CheckDigits::M10_011',
    'ups'                => 'Algorithm::CheckDigits::M10_011',
    'm11-001'            => 'Algorithm::CheckDigits::M11_001',
    'isbn'               => 'Algorithm::CheckDigits::M11_001',
    'issn'               => 'Algorithm::CheckDigits::M11_001',
    'ustid_pt'           => 'Algorithm::CheckDigits::M11_001',
    'vatrn_pt'           => 'Algorithm::CheckDigits::M11_001',
    'hkid'               => 'Algorithm::CheckDigits::M11_001',
    'wagonnr_br'         => 'Algorithm::CheckDigits::M11_001',
    'nhs_gb'             => 'Algorithm::CheckDigits::M11_001',
    'vat_sl'             => 'Algorithm::CheckDigits::M11_001',
    'm11-002'            => 'Algorithm::CheckDigits::M11_002',
    'pzn'                => 'Algorithm::CheckDigits::M11_002',
    'm11-003'            => 'Algorithm::CheckDigits::M11_003',
    'pkz'                => 'Algorithm::CheckDigits::M11_003',
    'm11-004'            => 'Algorithm::CheckDigits::M11_004',
    'cpf'                => 'Algorithm::CheckDigits::M11_004',
    'titulo_eleitor'     => 'Algorithm::CheckDigits::M11_004',
    'm11-006'            => 'Algorithm::CheckDigits::M11_006',
    'ccc_es'             => 'Algorithm::CheckDigits::M11_006',
    'm11-007'            => 'Algorithm::CheckDigits::M11_007',
    'ustid_fi'           => 'Algorithm::CheckDigits::M11_007',
    'vatrn_fi'           => 'Algorithm::CheckDigits::M11_007',
    'm11-008'            => 'Algorithm::CheckDigits::M11_008',
    'ustid_dk'           => 'Algorithm::CheckDigits::M11_008',
    'vatrn_dk'           => 'Algorithm::CheckDigits::M11_008',
    'm11-009'            => 'Algorithm::CheckDigits::M11_009',
    'nric_sg'            => 'Algorithm::CheckDigits::M11_009',
    'm11-010'            => 'Algorithm::CheckDigits::M11_010',
    'ahv_ch'             => 'Algorithm::CheckDigits::M11_010',
    'm11-011'            => 'Algorithm::CheckDigits::M11_011',
    'ustid_nl'           => 'Algorithm::CheckDigits::M11_011',
    'vatrn_nl'           => 'Algorithm::CheckDigits::M11_011',
    'm11-012'            => 'Algorithm::CheckDigits::M11_012',
    'bwpk_de'            => 'Algorithm::CheckDigits::M11_012',
    'm11-013'            => 'Algorithm::CheckDigits::M11_013',
    'ustid_gr'           => 'Algorithm::CheckDigits::M11_013',
    'vatrn_gr'           => 'Algorithm::CheckDigits::M11_013',
    'm11-015'            => 'Algorithm::CheckDigits::M11_015',
    'esr5_ch'            => 'Algorithm::CheckDigits::M11_015',
    'm11-016'            => 'Algorithm::CheckDigits::M11_016',
    'ustid_pl'           => 'Algorithm::CheckDigits::M11_016',
    'vatrn_pl'           => 'Algorithm::CheckDigits::M11_016',
    'm11-017'            => 'Algorithm::CheckDigits::M11_017',
    'ecno'               => 'Algorithm::CheckDigits::M11_017',
    'ec-no'              => 'Algorithm::CheckDigits::M11_017',
    'einecs'             => 'Algorithm::CheckDigits::M11_017',
    'elincs'             => 'Algorithm::CheckDigits::M11_017',
    'm16-001'            => 'Algorithm::CheckDigits::M16_001',
    'isan'               => 'Algorithm::CheckDigits::M16_001',
    'm23-001'            => 'Algorithm::CheckDigits::M23_001',
    'dni_es'             => 'Algorithm::CheckDigits::M23_001',
    'm23-002'            => 'Algorithm::CheckDigits::M23_002',
    'ustid_ie'           => 'Algorithm::CheckDigits::M23_002',
    'vatrn_ie'           => 'Algorithm::CheckDigits::M23_002',
    'm43-001'            => 'Algorithm::CheckDigits::M43_001',
    'code_39'            => 'Algorithm::CheckDigits::M43_001',
    'm89-001'            => 'Algorithm::CheckDigits::M89_001',
    'ustid_lu'           => 'Algorithm::CheckDigits::M89_001',
    'vatrn_lu'           => 'Algorithm::CheckDigits::M89_001',
    'm97-001'            => 'Algorithm::CheckDigits::M97_001',
    'ustid_be'           => 'Algorithm::CheckDigits::M97_001',
    'vatrn_be'           => 'Algorithm::CheckDigits::M97_001',
    'm97-002'            => 'Algorithm::CheckDigits::M97_002',
    'iban'               => 'Algorithm::CheckDigits::M97_002',
    'mxx-001'            => 'Algorithm::CheckDigits::MXX_001',
    'pa_de'              => 'Algorithm::CheckDigits::MXX_001',
    'mxx-002'            => 'Algorithm::CheckDigits::MXX_002',
    'cas'                => 'Algorithm::CheckDigits::MXX_002',
    'mxx-003'            => 'Algorithm::CheckDigits::MXX_003',
    'dem'                => 'Algorithm::CheckDigits::MXX_003',
    'mxx-004'            => 'Algorithm::CheckDigits::MXX_004',
    'ustid_at'           => 'Algorithm::CheckDigits::MXX_004',
    'vatrn_at'           => 'Algorithm::CheckDigits::MXX_004',
    'mxx-005'            => 'Algorithm::CheckDigits::MXX_005',
    'esr9_ch'            => 'Algorithm::CheckDigits::MXX_005',
    'verhoeff'           => 'Algorithm::CheckDigits::MXX_006',
);

sub CheckDigits {
    my $method = shift || '';

    if ( my $pkg = $methods{ lc($method) } ) {
        my $file = $pkg;
        $file =~ s{::}{/}g;
        require "$file.pm";
        return new $pkg($method);
    }
    else {
        die "Don't know checkdigit algorithm for '$method'!";
    }
}    # CheckDigits()

sub method_list {
    my @methods = ();
    foreach my $method ( sort keys %methods ) {
        push @methods, $method;
    }
    return wantarray ? @methods : \@methods;
}    # method_list()

sub print_methods {
    foreach my $method ( sort keys %methods ) {
        print "$method => $methods{$method}\n";
    }
}    # print_methods()

sub AUTOLOAD {
    my $self = shift;
    my $attr = $AUTOLOAD;
    unless ( $attr =~ /^Algorithm::CheckDigits::[A-Za-z_0-9]*$/ ) {
        croak "$attr is not defined";
    }
    return '';
}    # AUTOLOAD()

sub DESTROY {
}

# Preloaded methods go here.

1;
__END__

=head1 NAME

Algorithm::CheckDigits - Perl extension to generate and test check digits

=head1 SYNOPSIS

  perl -MAlgorithm::CheckDigits -e Algorithm::CheckDigits::print_methods

or

  use Algorithm::CheckDigits;
  
  @ml = Algorithm::CheckDigits->method_list();

  $isbn = CheckDigits('ISBN');

  if ($isbn->is_valid('3-930673-48-7')) {
	# do something
  }

  $cn = $isbn->complete('3-930673-48');     # $cn = '3-930673-48-7'

  $cd = $isbn->checkdigit('3-930673-48-7'); # $cd = '7'

  $bn = $isbn->basenumber('3-930673-48-7'); # $bn = '3-930673-48'

=head1 ABSTRACT

This module provides a number of methods to test and generate check
digits. For more information have a look at the web site
F<www.pruefziffernberechnung.de> (german).

=head1 SUBROUTINES/METHODS

=head2 CheckDigits($method)

Returns an object of an appropriate Algorithm::CheckDigits class for the
given algorithm.

Dies with an error message if called with an unknown algorithm.

See below for the available algorithms. Every object understands the following
methods:

=over 4

=item is_valid($number)

Returns true or false if C<$number> contains/contains no valid check digit.

=item complete($number)

Returns a string representation of C<$number> completed with the appropriate
check digit.

=item checkdigit($number)

Extracts the check digit from C<$number> if C<$number> contains a valid check
digit.

=item basenumber($number)

Extracts the basenumber from C<$number> if C<$number> contains a valid check
digit.

=back

=head2 Algorithm::CheckDigits::method_list()

Returns a list of known methods for check digit computation.

=head2 Algorithm::CheckDigits::print_methods()

Returns a list of known methods for check digit computation.

You may use the following to find out which methods your version of
Algorithm::CheckDigits provides and where to look for further
information.

 perl -MAlgorithm::CheckDigits -e Algorithm::CheckDigits::print_methods

=head2 CHECK SUM METHODS

At the moment these methods to compute check digits are provided:
(vatrn - VAT Return Number, in german ustid UmsatzSTeuer-ID)

=over 4

=item m07-001

See L<Algorithm::CheckDigits::M07_001>.

=item euronote, m09-001

European bank notes, see L<Algorithm::CheckDigits::M09_001>.

=item amex, bahncard, diners, discover, enroute, eurocard, happydigits,
      isin, jcb, klubkarstadt, mastercard, miles&more, visa, m09-001,
      imei, imeisv

See L<Algorithm::CheckDigits::M10_001>.

=item siren, siret, m10-002

See L<Algorithm::CheckDigits::M10_002>.

=item ismn, m10-003

See L<Algorithm::CheckDigits::M10_003>.

=item ean, iln, isbn13, nve, 2aus5, m10-004

See L<Algorithm::CheckDigits::M10_004>.

=item identcode_dp, leitcode_dp, m10-005

See L<Algorithm::CheckDigits::M10_005>.

=item rentenversicherung, m10-006

See L<Algorithm::CheckDigits::M10_006>.

=item sedol, m10-008

See L<Algorithm::CheckDigits::M10_008>.

=item betriebsnummer, m10-009

See L<Algorithm::CheckDigits::M10_009>.

=item postscheckkonti, m10-010

See L<Algorithm::CheckDigits::M10_010>.

=item ups, m10-011

See L<Algorithm::CheckDigits::M10_011>.

=item hkid, isbn, issn, nhs_gb, ustid_pt, vat_sl, wagonnr_br, m11-001

See L<Algorithm::CheckDigits::M11_001>.

=item pzn, m11-002

See L<Algorithm::CheckDigits::M11_002>.

=item pkz, m11-003

See L<Algorithm::CheckDigits::M11_003>.

=item cpf, titulo_eleitor, m11-004

See L<Algorithm::CheckDigits::M11_004>.

=item ccc_es, m11-006

See L<Algorithm::CheckDigits::M11_006>.

=item ustid_fi, vatrn_fi, m11-007

See L<Algorithm::CheckDigits::M11_007>.

=item ustid_dk, vatrn_dk, m11-008

See L<Algorithm::CheckDigits::M11_008>.

=item nric_sg, m11-009

See L<Algorithm::CheckDigits::M11_009>.

=item ahv_ch, m11-010

See L<Algorithm::CheckDigits::M11_010>.

=item ustid_nl, vatrn_nl, m11-011

See L<Algorithm::CheckDigits::M11_011>.

=item bwpk_de, m11-012

See L<Algorithm::CheckDigits::M11_012>.

=item ustid_gr, vatrn_gr, m11-013

See L<Algorithm::CheckDigits::M11_013>.

=item esr5_ch, m11-015

See L<Algorithm::CheckDigits::M11_015>.

=item ustid_pl, vatrn_pl, m11-016

See L<Algorithm::CheckDigits::M11_016>.

=item ecno, ec-no, einecs, elincs, m11-017

See L<Algorithm::CheckDigits::M11_017>.

=item isan, m16-001

See L<Algorithm::CheckDigits::M16_001>.

=item dni_es, m23-001

See L<Algorithm::CheckDigits::M23_001>.

=item ustid_ie, vatrn_ie, m23-002

See L<Algorithm::CheckDigits::M23_002>.

=item code_39, m43-001

See L<Algorithm::CheckDigits::M43_001>.

=item ustid_lu, vatrn_lu, m89-001

See L<Algorithm::CheckDigits::M89_001>.

=item ustid_be, vatrn_be, m97-001

See L<Algorithm::CheckDigits::M97_001>.

=item iban, m97-002

See L<Algorithm::CheckDigits::M97_002>.

=item upc, mbase-001

See L<Algorithm::CheckDigits::MBase_001>.

=item blutbeutel, bzue_de, ustid_de, vatrn_de, mbase-002

See L<Algorithm::CheckDigits::MBase_002>.

=item sici, mbase-003

See L<Algorithm::CheckDigits::MBase_003>.

=item pa_de, mxx-001

See L<Algorithm::CheckDigits::MXX_001>.

=item cas, mxx-002

See L<Algorithm::CheckDigits::MXX_002>.

=item dem, mxx-003

Old german bank notes (DEM), see L<Algorithm::CheckDigits::MXX_003>.

=item ustid_at, vatrn_at, mxx-004

See L<Algorithm::CheckDigits::MXX_004>.

=item esr9_ch, mxx-005

See L<Algorithm::CheckDigits::MXX_005>.

=item verhoeff, mxx-006

Verhoeff scheme, see L<Algorithm::CheckDigits::MXX_006> or
L<Algorithm::Verhoeff>

=back

=head2 EXPORT

None by default.

=head1 SEE ALSO

L<perl>,
F<www.pruefziffernberechnung.de>.

=head1 AUTHOR

Mathias Weidner, E<lt>mathias@weidner.in-bad-schmiedeberg.deE<gt>

=head1 THANKS

Petri Oksanen made me aware that CheckDigits('IMEI') would invoke no test at
all since there was no entry for this in the methods hash.

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2006 by Mathias Weidner

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
