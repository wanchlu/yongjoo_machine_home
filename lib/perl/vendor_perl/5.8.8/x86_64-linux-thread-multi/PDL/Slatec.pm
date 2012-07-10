
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Slatec;

@EXPORT_OK  = qw(  eigsys matinv fft fftb polyfit polycoef polyvalue PDL::PP svdc PDL::PP poco PDL::PP geco PDL::PP gefa PDL::PP podi PDL::PP gedi PDL::PP gesl PDL::PP rs PDL::PP ezffti PDL::PP ezfftf PDL::PP ezfftb PDL::PP pcoef PDL::PP pvalue PDL::PP chim PDL::PP chic PDL::PP chsp PDL::PP chfd PDL::PP chfe PDL::PP chia PDL::PP chid PDL::PP chcm PDL::PP polfit );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Slatec ;





=head1 NAME

PDL::Slatec - PDL interface to the slatec numerical programming library

=head1 SYNOPSIS

 use PDL::Slatec;

 ($ndeg, $r, $ierr, $a) = polyfit($x, $y, $w, $maxdeg, $eps);

=head1 DESCRIPTION

This module serves the dual purpose of providing an interface to
parts of the slatec library and showing how to interface PDL
to an external library.
Using this library requires a fortran compiler; the source for the routines
is provided for convenience.

Currently available are routines to:
manipulate matrices; calculate FFT's; 
fit data using polynomials; 
and interpolate/integrate data using piecewise cubic Hermite interpolation.

=head2 Piecewise cubic Hermite interpolation (PCHIP)

PCHIP is the slatec package of routines to perform piecewise cubic
Hermite interpolation of data.
It features software to produce a monotone and "visually pleasing"
interpolant to monotone data.  
According to Fritsch & Carlson ("Monotone piecewise
cubic interpolation", SIAM Journal on Numerical Analysis 
17, 2 (April 1980), pp. 238-246),
such an interpolant may be more reasonable than a cubic spline if
the data contains both "steep" and "flat" sections.  
Interpolation of cumulative probability distribution functions is 
another application.
These routines are cryptically named (blame FORTRAN), 
beginning with 'ch', and accept either float or double piddles. 

Most of the routines require an integer parameter called C<check>;
if set to 0, then no checks on the validity of the input data are
made, otherwise these checks are made.
The value of C<check> can be set to 0 if a routine
such as L<chim|/chim> has already been successfully called.

=over 4

=item * 

If not known, estimate derivative values for the points
using the L<chim|/chim>, L<chic|/chic>, or L<chsp|/chsp> routines
(the following routines require both the function (C<f>)
and derivative (C<d>) values at a set of points (C<x>)). 

=item * 

Evaluate, integrate, or differentiate the resulting PCH
function using the routines:
L<chfd|/chfd>; L<chfe|/chfe>; L<chia|/chia>; L<chid|/chid>.

=item * 

If desired, you can check the monotonicity of your
data using L<chcm|/chcm>. 

=back
 






=head1 FUNCTIONS



=cut




=head2 eigsys

=for ref

Eigenvalues and eigenvectors of a real positive definite symmetric matrix.

=for usage

 ($eigvals,$eigvecs) = eigsys($mat)

Note: this function should be extended to calculate only eigenvalues if called 
in scalar context!

=head2 matinv

=for ref

Inverse of a square matrix

=for usage

 ($inv) = matinv($mat)

=head2 polyfit

Convenience wrapper routine about the C<polfit> C<slatec> function.
Separates supplied arguments and return values.

=for ref

Fit discrete data in a least squares sense by polynomials
in one variable.  Handles threading correctly--one can pass in a 2D PDL (as C<$y>)
and it will pass back a 2D PDL, the rows of which are the polynomial regression
results (in C<$r> corresponding to the rows of $y.

=for usage

 ($ndeg, $r, $ierr, $a) = polyfit($x, $y, $w, $maxdeg, $eps);

 where on input:

 C<x> and C<y> are the values to fit to a polynomial.
 C<w> are weighting factors
 C<maxdeg> is the maximum degree of polynomial to use and 
 C<eps> is the required degree of fit.

 and on output:

 C<ndeg> is the degree of polynomial actually used
 C<r> is the values of the fitted polynomial 
 C<ierr> is a return status code, and
 C<a> is some working array or other
 C<eps> is modified to contain the rms error of the fit.

=for bad

This version of polyfit handles bad values correctly.  It strips them out
of the $x variable and creates an appropriate $y variable containing indices
of the non-bad members of $x before calling the Slatec routine C<polfit>.

=head2 polycoef

Convenience wrapper routine around the C<pcoef> C<slatec> function.
Separates supplied arguments and return values.                               

=for ref

Convert the C<polyfit>/C<polfit> coefficients to Taylor series form.

=for usage

 $tc = polycoef($l, $c, $a);

=head2 polyvalue

Convenience wrapper routine around the C<pvalue> C<slatec> function.
Separates supplied arguments and return values.

For multiple input x positions, a corresponding y position is calculated.

The derivatives PDL is one dimensional (of size C<nder>) if a single x
position is supplied, two dimensional if more than one x position is
supplied.                                                                     

=for ref

Use the coefficients generated by C<polyfit> (or C<polfit>) to evaluate
the polynomial fit of degree C<l>, along with the first C<nder> of its
derivatives, at a specified point.

=for usage

 ($yfit, $yp) = polyvalue($l, $nder, $x, $a);

=head2 detslatec

=for ref

compute the determinant of an invertible matrix

=for example

  $mat = zeroes(5,5); $mat->diagonal(0,1) .= 1; # unity matrix
  $det = detslatec $mat;

Usage:

=for usage

  $determinant = detslatec $matrix;

=for sig

  Signature: detslatec(mat(n,m); [o] det())

C<detslatec> computes the determinant of an invertible matrix and barfs if
the matrix argument provided is non-invertible. The matrix threads as usual.

This routine was previously known as C<det> which clashes now with
L<det:PDL::MatrixOps/det> which is provided by
L<PDL::MatrixOps|PDL::MatrixOps>. For the moment L<PDL::Slatec> will
also load L<PDL::MatrixOps> thereby making sure that older scripts work.

=cut




use PDL::Core;
use PDL::Basic;
use PDL::Primitive;
use PDL::Ufunc;
use strict;

# Note: handles only real symmetric positive-definite.

*eigsys = \&PDL::eigsys;

sub PDL::eigsys {
	my($h) = @_;
	$h = float($h);
	rs($h, 
		(my $eigval=PDL->null),
		(long (pdl (1))),(my $eigmat=PDL->null),
		(my $fvone = PDL->null),(my $fvtwo = PDL->null),
		(my $errflag=PDL->null)
	);
#	print $covar,$eigval,$eigmat,$fvone,$fvtwo,$errflag;
	if(sum($errflag) > 0) {
		barf("Non-positive-definite matrix given to eigsys: $h\n");
	}
	return ($eigval,$eigmat);
}

*matinv = \&PDL::matinv;

sub PDL::matinv {
	my($m) = @_;
	my(@dims) = $m->dims;

	# Keep from dumping core (FORTRAN does no error checking)
	barf("matinv requires a 2-D square matrix")
		unless( @dims >= 2 && $dims[0] == $dims[1] );
  
	$m = $m->copy(); # Make sure we don't overwrite :(
	gefa($m,(my $ipvt=null),(my $info=null));
	if(sum($info) > 0) {
		barf("Uninvertible matrix given to inv: $m\n");
	}
	gedi($m,$ipvt,(pdl 0,0),(null),(long( pdl (1))));
	$m;
}

*detslatec = \&PDL::detslatec;
sub PDL::detslatec {
	my($m) = @_;
	$m = $m->copy(); # Make sure we don't overwrite :(
	gefa($m,(my $ipvt=null),(my $info=null));
	if(sum($info) > 0) {
		barf("Uninvertible matrix given to inv: $m\n");
	}
	gedi($m,$ipvt,(my $det=null),(null),(long( pdl (10))));
	return $det->slice('(0)')*10**$det->slice('(1)');
}


sub prepfft {
	my($n) = @_;
	my $tmp = PDL->zeroes(float(),$n*3+15);
	$n = pdl $n;
	ezffti($n,$tmp);
	return $tmp;
}

*fft = \&PDL::fft;
sub PDL::fft (;@) {
	my($v) = @_;
	my $ws = prepfft($v->getdim(0));
	ezfftf($v,(my $az = PDL->null), (my $a = PDL->null),
		  (my $b = PDL->null), $ws);
	return ($az,$a,$b);
}

sub rfft {
	my($az,$a,$b) = @_;
	my $ws = prepfft($a->getdim(0));
	my $v = $a->copy();
	ezfftb($v,$az,$a,$b,$ws);
	return $v;
}

# polynomial fitting routines
# simple wrappers around the SLATEC implementations

*polyfit = \&PDL::polyfit;
sub PDL::polyfit {
  barf 'Usage: polyfit($x, $y, $w, $maxdeg, $eps);'
    unless @_ == 5;

  # Create the output arrays
  my $r = PDL->null;

  # A array needs some work space
  my $sz = ((3*$_[0]->getdim(0)) + (3*$_[3]) + 3);
  my @otherdims = $_[0]->dims; shift @otherdims;
  my $a = $_[0]->zeroes( $sz, @otherdims ); # This should be of type $x

  my $ierr = PDL->null;
  my $ndeg = PDL->null;

  # Now call polfit                                                           
  polfit($_[0], $_[1], $_[2], $_[3], $ndeg, $_[4], $r, $ierr, $a);

  # Return the arrays
  return ($ndeg, $r, $ierr, $a);
}


*polycoef = \&PDL::polycoef;
sub PDL::polycoef {
  barf 'Usage: polycoef($l, $c, $a);'
    unless @_ == 3;

  # Allocate memory for return PDL
  # Simply l + 1 but cant see how to get PP to do this - TJ
  # Not sure the return type since I do not know
  # where PP will get the information from
  my $tc = PDL->zeroes( abs($_[0]) + 1 );                                     

  # Run the slatec routine
  pcoef($_[0], $_[1], $tc, $_[2]);

  # Return results
  return $tc;

}

*polyvalue = \&PDL::polyvalue;
sub PDL::polyvalue {
  barf 'Usage: polyvalue($l, $nder, $x, $a);'
    unless @_ == 4;

  # Two output arrays
  my $yfit = PDL->null;

  # This one must be preallocated and must take into account
  # the size of $x if greater than 1
  my $yp;
  if ($_[2]->getdim(0) == 1) {
    $yp = $_[2]->zeroes($_[1]);
  } else {
    $yp = $_[2]->zeroes($_[1], $_[2]->getdim(0));
  }

  # Run the slatec function
  pvalue($_[0], $_[2], $yfit, $yp, $_[3]);

  # Returns
  return ($yfit, $yp);

}
                                                                              




=head2 svdc

=for sig

  Signature: (x(n,p);[o]s(p);[o]e(p);[o]u(n,p);[o]v(p,p);[o]work(n);int job();int [o]info())

=for ref

singular value decomposition of a matrix



=cut






*svdc = \&PDL::svdc;




=head2 poco

=for sig

  Signature: (a(n,n);rcond();[o]z(n);int [o]info())

Factor a real symmetric positive definite matrix
and estimate the condition number of the matrix.



=cut






*poco = \&PDL::poco;




=head2 geco

=for sig

  Signature: (a(n,n);int [o]ipvt(n);[o]rcond();[o]z(n))

Factor a matrix using Gaussian elimination and estimate
the condition number of the matrix.



=cut






*geco = \&PDL::geco;




=head2 gefa

=for sig

  Signature: (a(n,n);int [o]ipvt(n);int [o]info())

=for ref

Factor a matrix using Gaussian elimination.



=cut






*gefa = \&PDL::gefa;




=head2 podi

=for sig

  Signature: (a(n,n);[o]det(two=2);int job())

Compute the determinant and inverse of a certain real
symmetric positive definite matrix using the factors
computed by L<poco|/poco>.



=cut






*podi = \&PDL::podi;




=head2 gedi

=for sig

  Signature: (a(n,n);int [o]ipvt(n);[o]det(two=2);[o]work(n);int job())

Compute the determinant and inverse of a matrix using the
factors computed by L<geco|/geco> or L<gefa|/gefa>.



=cut






*gedi = \&PDL::gedi;




=head2 gesl

=for sig

  Signature: (a(lda,n);int ipvt(n);b(n);int job())

Solve the real system C<A*X=B> or C<TRANS(A)*X=B> using the
factors computed by L<geco|/geco> or L<gefa|/gefa>.



=cut






*gesl = \&PDL::gesl;




=head2 rs

=for sig

  Signature: (a(n,n);[o]w(n);int matz();[o]z(n,n);[t]fvone(n);[t]fvtwo(n);int [o]ierr())

This subroutine calls the recommended sequence of
subroutines from the eigensystem subroutine package (EISPACK)
to find the eigenvalues and eigenvectors (if desired)
of a REAL SYMMETRIC matrix.



=cut






*rs = \&PDL::rs;




=head2 ezffti

=for sig

  Signature: (int n();[o]wsave(foo))

Subroutine ezffti initializes the work array C<wsave()>
which is used in both L<ezfftf|/ezfftf> and 
L<ezfftb|/ezfftb>.  
The prime factorization
of C<n> together with a tabulation of the trigonometric functions
are computed and stored in C<wsave()>.



=cut






*ezffti = \&PDL::ezffti;




=head2 ezfftf

=for sig

  Signature: (r(n);[o]azero();[o]a(n);[o]b(n);wsave(foo))

=for ref





=cut






*ezfftf = \&PDL::ezfftf;




=head2 ezfftb

=for sig

  Signature: ([o]r(n);azero();a(n);b(n);wsave(foo))

=for ref





=cut






*ezfftb = \&PDL::ezfftb;




=head2 pcoef

=for sig

  Signature: (int l();c();[o]tc(bar);a(foo))

Convert the C<polfit> coefficients to Taylor series form.
C<c> and C<a()> must be of the same type.



=cut






*pcoef = \&PDL::pcoef;




=head2 pvalue

=for sig

  Signature: (int l();x();[o]yfit();[o]yp(nder);a(foo))

Use the coefficients generated by C<polfit> to evaluate the
polynomial fit of degree C<l>, along with the first C<nder> of
its derivatives, at a specified point. C<x> and C<a> must be of the
same type.



=cut






*pvalue = \&PDL::pvalue;




=head2 chim

=for sig

  Signature: (x(n);f(n);[o]d(n);int [o]ierr())


=for ref

Calculate the derivatives of (x,f(x)) using cubic Hermite interpolation.

Calculate the derivatives at the given set of points (C<$x,$f>,
where C<$x> is strictly increasing).
The resulting set of points - C<$x,$f,$d>, referred to
as the cubic Hermite representation - can then be used in
other functions, such as L<chfe|/chfe>, L<chfd|/chfd>,
and L<chia|/chia>.

The boundary conditions are compatible with monotonicity,
and if the data are only piecewise monotonic, the interpolant
will have an extremum at the switch points; for more control
over these issues use L<chic|/chic>. 

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

E<gt> 0 if there were C<ierr> switches in the direction of 
monotonicity (data still valid).

=item *

-1 if C<nelem($x) E<lt> 2>.

=item *

-3 if C<$x> is not strictly increasing.

=back




=cut






*chim = \&PDL::chim;




=head2 chic

=for sig

  Signature: (int ic(two=2);vc(two=2);mflag();x(n);f(n);[o]d(n);wk(nwk);int [o]ierr())


=for ref

Calculate the derivatives of (x,f(x)) using cubic Hermite interpolation.

Calculate the derivatives at the given points (C<$x,$f>,
where C<$x> is strictly increasing).
Control over the boundary conditions is given by the 
C<$ic> and C<$vc> piddles, and the value of C<$mflag> determines
the treatment of points where monotoncity switches
direction. A simpler, more restricted, interface is available 
using L<chim|/chim>.

The first and second elements of C<$ic> determine the boundary
conditions at the start and end of the data respectively.
If the value is 0, then the default condition, as used by
L<chim|/chim>, is adopted.
If greater than zero, no adjustment for monotonicity is made,
otherwise if less than zero the derivative will be adjusted.
The allowed magnitudes for C<ic(0)> are:

=over 4

=item *  

1 if first derivative at C<x(0)> is given in C<vc(0)>.

=item *

2 if second derivative at C<x(0)> is given in C<vc(0)>.

=item *

3 to use the 3-point difference formula for C<d(0)>.
(Reverts to the default b.c. if C<n E<lt> 3>)

=item *

4 to use the 4-point difference formula for C<d(0)>.
(Reverts to the default b.c. if C<n E<lt> 4>)

=item *

5 to set C<d(0)> so that the second derivative is 
continuous at C<x(1)>.
(Reverts to the default b.c. if C<n E<lt> 4>) 

=back

The values for C<ic(1)> are the same as above, except that
the first-derivative value is stored in C<vc(1)> for cases 1 and 2.
The values of C<$vc> need only be set if options 1 or 2 are chosen
for C<$ic>.

Set C<$mflag = 0> if interpolant is required to be monotonic in
each interval, regardless of the data. This causes C<$d> to be
set to 0 at all switch points. Set C<$mflag> to be non-zero to
use a formula based on the 3-point difference formula at switch
points. If C<$mflag E<gt> 0>, then the interpolant at swich points
is forced to not deviate from the data by more than C<$mflag*dfloc>, 
where C<dfloc> is the maximum of the change of C<$f> on this interval
and its two immediate neighbours.
If C<$mflag E<lt> 0>, no such control is to be imposed.            

The piddle C<$wk> is only needed for work space. However, I could
not get it to work as a temporary variable, so you must supply
it; it is a 1D piddle with C<2*n> elements.

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

1 if C<ic(0) E<lt> 0> and C<d(0)> had to be adjusted for
monotonicity.

=item *

2 if C<ic(1) E<lt> 0> and C<d(n-1)> had to be adjusted
for monotonicity.

=item * 

3 if both 1 and 2 are true.

=item *

-1 if C<n E<lt> 2>.

=item *

-3 if C<$x> is not strictly increasing.

=item *

-4 if C<abs(ic(0)) E<gt> 5>.

=item *

-5 if C<abs(ic(1)) E<gt> 5>.

=item *

-6 if both -4 and -5  are true.

=item *

-7 if C<nwk E<lt> 2*(n-1)>.

=back




=cut






*chic = \&PDL::chic;




=head2 chsp

=for sig

  Signature: (int ic(two=2);vc(two=2);x(n);f(n);[o]d(n);wk(nwk);int [o]ierr())


=for ref

Calculate the derivatives of (x,f(x)) using cubic spline interpolation.

Calculate the derivatives, using cubic spline interpolation,
at the given points (C<$x,$f>), with the specified
boundary conditions. 
Control over the boundary conditions is given by the 
C<$ic> and C<$vc> piddles.
The resulting values - C<$x,$f,$d> - can
be used in all the functions which expect a cubic
Hermite function.

The first and second elements of C<$ic> determine the boundary
conditions at the start and end of the data respectively.
The allowed values for C<ic(0)> are:

=over 4

=item *

0 to set C<d(0)> so that the third derivative is 
continuous at C<x(1)>.

=item *

1 if first derivative at C<x(0)> is given in C<vc(0>).

=item *

2 if second derivative at C<x(0>) is given in C<vc(0)>.

=item *

3 to use the 3-point difference formula for C<d(0)>.
(Reverts to the default b.c. if C<n E<lt> 3>.)

=item *

4 to use the 4-point difference formula for C<d(0)>.
(Reverts to the default b.c. if C<n E<lt> 4>.)                 

=back

The values for C<ic(1)> are the same as above, except that
the first-derivative value is stored in C<vc(1)> for cases 1 and 2.
The values of C<$vc> need only be set if options 1 or 2 are chosen
for C<$ic>.

The piddle C<$wk> is only needed for work space. However, I could
not get it to work as a temporary variable, so you must supply
it; it is a 1D piddle with C<2*n> elements.

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

-1  if C<nelem($x) E<lt> 2>.

=item *

-3  if C<$x> is not strictly increasing.

=item *

-4  if C<ic(0) E<lt> 0> or C<ic(0) E<gt> 4>.

=item *

-5  if C<ic(1) E<lt> 0> or C<ic(1) E<gt> 4>.

=item *

-6  if both of the above are true.

=item *

-7  if C<nwk E<lt> 2*n>.

=item *

-8  in case of trouble solving the linear system
for the interior derivative values.

=back




=cut






*chsp = \&PDL::chsp;




=head2 chfd

=for sig

  Signature: (x(n);f(n);d(n);int check();xe(ne);[o]fe(ne);[o]de(ne);int [o]ierr())


=for ref

Interpolate function and derivative values.

Given a piecewise cubic Hermite function - such as from
L<chim|/chim> - evaluate the function (C<$fe>) and 
derivative (C<$de>) at a set of points (C<$xe>).
If function values alone are required, use L<chfe|/chfe>.
Set C<check> to 0 to skip checks on the input data.

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

E<gt>0 if extrapolation was performed at C<ierr> points
(data still valid).

=item *

-1 if C<nelem($x) E<lt> 2>

=item *

-3 if C<$x> is not strictly increasing.

=item *

-4 if C<nelem($xe) E<lt> 1>.

=item *

-5 if an error has occurred in a lower-level routine,
which should never happen.

=back




=cut






*chfd = \&PDL::chfd;




=head2 chfe

=for sig

  Signature: (x(n);f(n);d(n);int check();xe(ne);[o]fe(ne);int [o]ierr())


=for ref

Interpolate function values.

Given a piecewise cubic Hermite function - such as from
L<chim|/chim> - evaluate the function (C<$fe>) at
a set of points (C<$xe>).
If derivative values are also required, use L<chfd|/chfd>.
Set C<check> to 0 to skip checks on the input data.

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

E<gt>0 if extrapolation was performed at C<ierr> points
(data still valid).

=item *

-1 if C<nelem($x) E<lt> 2>

=item *

-3 if C<$x> is not strictly increasing.

=item *

-4 if C<nelem($xe) E<lt> 1>.

=back




=cut






*chfe = \&PDL::chfe;




=head2 chia

=for sig

  Signature: (x(n);f(n);d(n);int check();a();b();[o]ans();int [o]ierr())


=for ref

Integrate (x,f(x)) over arbitrary limits.

Evaluate the definite integral of a a piecewise
cubic Hermite function over an arbitrary interval,
given by C<[$a,$b]>.
See L<chid|/chid> if the integration limits are
data points.
Set C<check> to 0 to skip checks on the input data.

The values of C<$a> and C<$b> do not have
to lie within C<$x>, although the resulting integral
value will be highly suspect if they are not.

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

1 if C<$a> lies outside C<$x>.

=item *

2 if C<$b> lies outside C<$x>.

=item *

3 if both 1 and 2 are true.

=item *

-1 if C<nelem($x) E<lt> 2>

=item *

-3 if C<$x> is not strictly increasing.

=item *

-4 if an error has occurred in a lower-level routine,
which should never happen.

=back




=cut






*chia = \&PDL::chia;




=head2 chid

=for sig

  Signature: (x(n);f(n);d(n);int check();int ia();int ib();[o]ans();int [o]ierr())


=for ref

Integrate (x,f(x)) between data points.

Evaluate the definite integral of a a piecewise
cubic Hermite function between C<x($ia)> and
C<x($ib)>. 

See L<chia|/chia> for integration between arbitrary
limits.

Although using a fortran routine, the values of
C<$ia> and C<$ib> are zero offset.
Set C<check> to 0 to skip checks on the input data.

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

-1 if C<nelem($x) E<lt> 2>.

=item *

-3 if C<$x> is not strictly increasing.

=item *

-4 if C<$ia> or C<$ib> is out of range.

=back




=cut






*chid = \&PDL::chid;




=head2 chcm

=for sig

  Signature: (x(n);f(n);d(n);int check();int [o]ismon(n);int [o]ierr())


=for ref

Check the given piecewise cubic Hermite function for monotonicity.

The outout piddle C<$ismon> indicates over
which intervals the function is monotonic.
Set C<check> to 0 to skip checks on the input data.

For the data interval C<[x(i),x(i+1)]>, the
values of C<ismon(i)> can be:

=over 4

=item *

-3 if function is probably decreasing

=item *

-1 if function is strictly decreasing

=item *

0  if function is constant

=item *

1  if function is strictly increasing

=item *

2  if function is non-monotonic

=item *

3  if function is probably increasing

=back

If C<abs(ismon(i)) == 3>, the derivative values are
near the boundary of the monotonicity region. A small
increase produces non-monotonicity, whereas a decrease
produces strict monotonicity.

The above applies to C<i = 0 .. nelem($x)-1>. The last element of
C<$ismon> indicates whether
the entire function is monotonic over $x.

Error status returned by C<$ierr>:

=over 4

=item *

0 if successful.

=item *

-1 if C<n E<lt> 2>.

=item *

-3 if C<$x> is not strictly increasing.

=back




=cut






*chcm = \&PDL::chcm;




=head2 polfit

=for sig

  Signature: (x(n);y(n);w(n);int maxdeg();int [o]ndeg();[o]eps();[o]r(n);int [o]ierr();[o]a(foo);[t]xtmp(n);[t]ytmp(n);[t]wtmp(n);[t]rtmp(n))

Fit discrete data in a least squares sense by polynomials
          in one variable. C<x()>, C<y()> and C<w()> must be of the same type.
	  This version handles bad values appropriately



=cut






*polfit = \&PDL::polfit;



=head1 AUTHOR

Copyright (C) 1997 Tuomas J. Lukka. 
Copyright (C) 2000 Tim Jenness, Doug Burke.            
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL 
distribution. If this file is separated from the PDL distribution, 
the copyright notice should be included in the file.

=cut


;



# Exit with OK status

1;

		   