
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::FFT;

@EXPORT_OK  = qw( PDL::PP fft PDL::PP ifft  fftnd ifftnd fftconvolve realfft realifft kernctr PDL::PP convmath PDL::PP cmul PDL::PP cdiv );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::FFT ;




=head1 NAME

PDL::FFT - FFTs for PDL

=head1 DESCRIPTION

FFTs for PDL.  These work for arrays of any dimension, although ones
with small prime factors are likely to be the quickest.

For historical reasons, these routines work in-place and do not recognize
the in-place flag.  That should be fixed.

=head1 SYNOPSIS

        use PDL::FFT qw/:Func/;

	fft($real, $imag);
	ifft($real, $imag);
	realfft($real);
	realifft($real);

	fftnd($real,$imag);
	ifftnd($real,$imag);

	$kernel = kernctr($image,$smallk);
	fftconvolve($image,$kernel);

=head1 ALTERNATIVE FFT PACKAGES

Various other modules - such as 
L<PDL::FFTW|PDL::FFTW> and L<PDL::Slatec|PDL::Slatec> - 
contain FFT routines.
However, unlike PDL::FFT, these modules are optional,
and so may not be installed.

=cut







=head1 FUNCTIONS



=cut






=head2 fft

=for sig

  Signature: ([o,nc]real(n); [o,nc]imag(n))

=for ref

Complex FFT of the "real" and "imag" arrays [inplace]



=cut






*fft = \&PDL::fft;




=head2 ifft

=for sig

  Signature: ([o,nc]real(n); [o,nc]imag(n))

=for ref

Complex Inverse FFT of the "real" and "imag" arrays [inplace]



=cut






*ifft = \&PDL::ifft;



use Carp;
use PDL::Core qw/:Func/;
use PDL::Basic qw/:Func/;
use PDL::Types;
use PDL::ImageND qw/kernctr/; # moved to ImageND since FFTW uses it too

END {
  # tidying up required after using fftn
  print "Freeing FFT space\n" if $PDL::verbose;
  fft_free();
}

sub todouble {
    my ($arg) = @_;
    $arg = $arg->double if $arg->get_datatype != $PDL_D;
    $_[0] = $arg;
1;}

=head2 realfft()

=for ref

One-dimensional FFT of real function [inplace].

The real part of the transform ends up in the first half of the array
and the imaginary part of the transform ends up in the second half of
the array.

=for usage

	realfft($real);

=cut

*realfft = \&PDL::realfft;

sub PDL::realfft {
    barf("Usage: realfft(real(*)") if $#_ != 0;
    my ($a) = @_;
    todouble($a);
# FIX: could eliminate $b
    my ($b) = 0*$a;
    fft($a,$b);
    my ($n) = int((($a->dims)[0]-1)/2); my($t);
    ($t=$a->slice("-$n:-1")) .= $b->slice("1:$n");
    undef;
}

=head2 realifft()

=for ref

Inverse of one-dimensional realfft routine [inplace].

=for usage

	realifft($real);

=cut

*realifft = \&PDL::realifft;

sub PDL::realifft {
    use PDL::Ufunc 'max';
    barf("Usage: realifft(xfm(*)") if $#_ != 0;
    my ($a) = @_;
    todouble($a);
    my ($n) = int((($a->dims)[0]-1)/2); my($t);
# FIX: could eliminate $b
    my ($b) = 0*$a;
    ($t=$b->slice("1:$n")) .= $a->slice("-$n:-1");
    ($t=$a->slice("-$n:-1")) .= $a->slice("$n:1");
    ($t=$b->slice("-$n:-1")) .= -$b->slice("$n:1");
    ifft($a,$b);
# Sanity check -- shouldn't happen
    carp "Bad inverse transform in realifft" if max(abs($b)) > 1e-6*max(abs($a));
    undef;
}

=head2 fftnd()

=for ref

N-dimensional FFT (inplace)

=for example

	fftnd($real,$imag);

=cut

*fftnd = \&PDL::fftnd;

sub PDL::fftnd {
    barf "Must have real and imaginary parts for fftnd" if $#_ != 1;
    my ($r,$i) = @_;
    my ($n) = $r->getndims;
    barf "Dimensions of real and imag must be the same for fft"
        if ($n != $i->getndims);
    $n--;
    todouble($r);
    todouble($i);
    # need the copy in case $r and $i point to same memory
    $i = $i->copy;
    foreach (0..$n) {
      fft($r,$i);
      $r = $r->mv(0,$n);
      $i = $i->mv(0,$n);
    }
    $_[0] = $r; $_[1] = $i;
    undef;
}

=head2 ifftnd()

=for ref

N-dimensional inverse FFT

=for example

	ifftnd($real,$imag);

=cut

*ifftnd = \&PDL::ifftnd;

sub PDL::ifftnd {
    barf "Must have real and imaginary parts for ifftnd" if $#_ != 1;
    my ($r,$i) = @_;
    my ($n) = $r->getndims;
    barf "Dimensions of real and imag must be the same for ifft"
        if ($n != $i->getndims);
    todouble($r);
    todouble($i);
    # need the copy in case $r and $i point to same memory
    $i = $i->copy;
    $n--;
    foreach (0..$n) {
      ifft($r,$i);
      $r = $r->mv(0,$n);
      $i = $i->mv(0,$n);
    }
    $_[0] = $r; $_[1] = $i;
    undef;
}




=head2 fftconvolve()

=for ref

N-dimensional convolution with periodic boundaries (FFT method)

=for usage

	$kernel = kernctr($image,$smallk);
	fftconvolve($image,$kernel);

fftconvolve works inplace, and returns an error array in kernel as an
accuracy check -- all the values in it should be negligible.

See also L<PDL::ImageND::convolveND|PDL::ImageND/convolveND>, which 
performs speed-optimized convolution with a variety of boundary conditions.

The sizes of the image and the kernel must be the same.
L<kernctr|PDL::ImageND/kernctr> centres a small kernel to emulate the
behaviour of the direct convolution routines.

The speed cross-over between using straight convolution 
(L<PDL::Image2D::conv2d()|PDL::Image2D/conv2d>) and
these fft routines is for kernel sizes roughly 7x7.

=cut

*fftconvolve = \&PDL::fftconvolve;

sub PDL::fftconvolve {
    barf "Must have image & kernel for fftconvolve" if $#_ != 1;
    my ($hr, $hi) = @_;
    my ($n) = $hr->getndims;
    todouble($hr);
    todouble($hi);
    # need the copy in case $r and $i point to same memory
    $hi = $hi->copy;
    $hr = $hr->copy;
    fftnd($hr,$hi);
    convmath($hr->clump(-1),$hi->clump(-1));
    my ($str1, $str2, $tmp, $i);
    chop($str1 = '-1:1,' x $n);
    chop($str2 = '1:-1,' x $n);

# FIX: do these inplace -- cuts the arithmetic by a factor 2 as well.

    ($tmp = $hr->slice($str2)) += $hr->slice($str1)->copy;
    ($tmp = $hi->slice($str2)) -= $hi->slice($str1)->copy;
    for ($i = 0; $i<$n; $i++) {
	chop ($str1 = ('(0),' x $i).'-1:1,'.('(0),'x($n-$i-1)));
	chop ($str2 = ('(0),' x $i).'1:-1,'.('(0),'x($n-$i-1)));
	($tmp = $hr->slice($str2)) += $hr->slice($str1)->copy;
        ($tmp = $hi->slice($str2)) -= $hi->slice($str1)->copy;
    }
    $hr->clump(-1)->set(0,$hr->clump(-1)->at(0)*2);
    $hi->clump(-1)->set(0,0.);
    ifftnd($hr,$hi);
    $_[0] = $hr; $_[1] = $hi;
    ($hr,$hi);
}


=cut





=head2 convmath

=for sig

  Signature: ([o,nc]a(m); [o,nc]b(m))

=for ref

Internal routine doing maths for convolution



=cut






*convmath = \&PDL::convmath;




=head2 cmul

=for sig

  Signature: (ar(); ai(); br(); bi(); [o]cr(); [o]ci())

=for ref

Complex multiplication



=cut






*cmul = \&PDL::cmul;




=head2 cdiv

=for sig

  Signature: (ar(); ai(); br(); bi(); [o]cr(); [o]ci())

=for ref

Complex division



=cut






*cdiv = \&PDL::cdiv;



1; # OK




=head1 BUGS

Where the source is marked `FIX', could re-implement using phase-shift
factors on the transforms and some real-space bookkeeping, to save
some temporary space and redundant transforms.

=head1 AUTHOR

This file copyright (C) 1997, 1998 R.J.R. Williams
(rjrw@ast.leeds.ac.uk), Karl Glazebrook (kgb@aaoepp.aao.gov.au),
Tuomas J. Lukka, (lukka@husc.harvard.edu).  All rights reserved. There
is no warranty. You are allowed to redistribute this software /
documentation under certain conditions. For details, see the file
COPYING in the PDL distribution. If this file is separated from the
PDL distribution, the copyright notice should be included in the file.


=cut



;



# Exit with OK status

1;

		   