package Algorithm::CheckDigits::M11_015;

use 5.006;
use strict;
use warnings;
use integer;

our @ISA = qw(Algorithm::CheckDigits);

my @weight = ( 2, 3, 4, 5, 6, 7 );

sub new {
	my $proto = shift;
	my $type  = shift;
	my $class = ref($proto) || $proto;
	my $self  = bless({}, $class);
	$self->{type} = lc($type);
	return $self;
} # new()

sub is_valid {
	my ($self,$number) = @_;
	if ($number =~ /^(\d+)(\d)$/) {
		return $2 == $self->_compute_checkdigits($1);
	}
	return ''
} # is_valid()

sub complete {
	my ($self,$number) = @_;
	if ($number =~ /^(\d+)$/) {
		return "$1" . $self->_compute_checkdigits($1);
	}
	return '';
} # complete()

sub basenumber {
	my ($self,$number) = @_;
	if ($number =~ /^(\d+)(\d)$/) {
		return $1 if ($2 == $self->_compute_checkdigits($1));
	}
	return '';
} # basenumber()

sub checkdigit {
	my ($self,$number) = @_;
	if ($number =~ /^(\d+)(\d)$/) {
		return $2 if ($2 == $self->_compute_checkdigits($1));
	}
	return '';
} # checkdigit()

sub _compute_checkdigits {
	my $self    = shift;

	my @digits = split(//,shift);
	my $sum = 0;
	for (my $i = $#digits; $i >= 0; $i--) {
		$sum += $weight[($#digits - $i) % 6] * $digits[$i];
	}
	$sum %= 11;
	my $retval = (0 == $sum) ? '00' : (11 - $sum);
	$retval;
} # _compute_checkdigit()

# Preloaded methods go here.

1;
__END__

=head1 NAME

CheckDigits::M11_015 - compute check digits for ESR5 (CH)

=head1 SYNOPSIS

  use Algorithm::CheckDigits;

  $ustid = CheckDigits('esr5_ch');

  if ($ustid->is_valid('123456786')) {
	# do something
  }

  $cn = $ustid->complete('12345678');
  # $cn = '123456786'

  $cd = $ustid->checkdigit('123456786');
  # $cd = '6'

  $bn = $ustid->basenumber('123456786');
  # $bn = '12345678';
  
=head1 DESCRIPTION

=head2 ALGORITHM

=over 4

=item 1

Beginning left every digit is weighted with 7,9,10,5,8,4,2.

=item 2

The weighted digits are added.

=item 3

The sum from step 2 is taken modulo 11.

=item 4

The checkdigit is 11 minus the sum from step 3. Is the difference 10,
the number won't be taken. If the difference is 11, the checkdigit is
0.

=back

=head2 METHODS

=over 4

=item is_valid($number)

Returns true only if C<$number> consists solely of numbers and hyphens
and the two digits in the middle
are valid check digits according to the algorithm given above.

Returns false otherwise,

=item complete($number)

The check digit for C<$number> is computed and inserted into the
middle of C<$number>.

Returns the complete number with check digit or '' if C<$number>
does not consist solely of digits, hyphens and spaces.

=item basenumber($number)

Returns the basenumber of C<$number> if C<$number> has a valid check
digit.

Return '' otherwise.

=item checkdigit($number)

Returns the check digits of C<$number> if C<$number> has valid check
digits.

Return '' otherwise.

=back

=head2 EXPORT

None by default.

=head1 AUTHOR

Mathias Weidner, E<lt>mathias@weidner.in-bad-schmiedeberg.deE<gt>

=head1 SEE ALSO

L<perl>,
L<CheckDigits>,
F<www.pruefziffernberechnung.de>,

=cut
