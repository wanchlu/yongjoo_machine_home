
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::MatrixOps;

@EXPORT_OK  = qw(  identity  stretcher  inv  det  determinant PDL::PP eigens_sym PDL::PP eigens PDL::PP svd  lu_decomp  lu_decomp2  lu_backsub PDL::PP simq PDL::PP squaretotri );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::MatrixOps ;





=head1 NAME

PDL::MatrixOps -- Some Useful Matrix Operations

=head1 SYNOPSIS

   $inv = $a->inv;

   $det = $a->det;

   ($lu,$perm,$par) = $a->lu_decomp;
   $x = lu_backsub($lu,$perm,$b); # solve $a x $x = $b

=head1 DESCRIPTION

PDL::MatrixOps is PDL's built-in matrix manipulation code.  It
contains utilities for many common matrix operations: inversion,
determinant finding, eigenvalue/vector finding, singular value
decomposition, etc.  PDL::MatrixOps routines are written in a mixture
of Perl and C, so that they are reliably present even when there is no
FORTRAN compiler or external library available (e.g.
L<PDL::Slatec|/PDL::Slatec> or L<PDL::GSL>).

Matrix manipulation, particularly with large matrices, is a
challenging field and no one algorithm is suitable in all cases.  The
utilities here use general-purpose algorithms that work acceptably for
many cases but might not scale well to very large or pathological
(near-singular) matrices.

Except as noted, the matrices are PDLs whose 0th dimension ranges over
column and whose 1st dimension ranges over row.  The matrices appear
correctly when printed.

These routines should work OK with L<PDL::Matrix|PDL::Matrix> objects
as well as with normal PDLs.

=head1 TIPS ON MATRIX OPERATIONS

Like most computer languages, PDL addresses matrices in (column,row)
order in most cases; this corresponds to (X,Y) coordinates in the
matrix itself, counting rightwards and downwards from the upper left
corner.  This means that if you print a PDL that contains a matrix,
the matrix appears correctly on the screen, but if you index a matrix
element, you use the indices in the reverse order that you would in a
math textbook.  If you prefer your matrices indexed in (row, column)
order, you can try using the L<PDL::Matrix|PDL::Matrix> object, which
includes an implicit exchange of the first two dimensions but should
be compatible with most of these matrix operations.  TIMTOWDTI.)

Matrices, row vectors, and column vectors can be multiplied with the 'x'
operator (which is, of course, threadable):

	$m3 = $m1 x $m2;
        $col_vec2 = $m1 x $col_vec1;
	$row_vec2 = $row_vec1 x $m1;
        $scalar = $row_vec x $col_vec;

Because of the (column,row) addressing order, 1-D PDLs are treated as
_row_ vectors; if you want a _column_ vector you must add a dummy dimension:
      
      $rowvec  = pdl(1,2);            # row vector
      $colvec  = $rowvec->(*1);	      # 1x2 column vector
      $matrix  = pdl([[3,4],[6,2]]);  # 2x2 matrix
      $rowvec2 = $rowvec x $matrix;   # right-multiplication by matrix
      $colvec  = $matrix x $colvec;   # left-multiplication by matrix
      $m2      = $matrix x $rowvec;   # Throws an error

Implicit threading works correctly with most matrix operations, but
you must be extra careful that you understand the dimensionality.  In 
particular, matrix multiplication and other matrix ops need nx1 PDLs
as row vectors and 1xn PDLs as column vectors.  In most cases you must
explicitly include the trailing 'x1' dimension in order to get the expected
results when you thread over multiple row vectors.

When threading over matrices, it's very easy to get confused about 
which dimension goes where. It is useful to include comments with 
every expression, explaining what you think each dimension means:

	$a = xvals(360)*3.14159/180;        # (angle)
	$rot = cat(cat(cos($a),sin($a)),    # rotmat: (col,row,angle)
	           cat(-sin($a),cos($a)));

=head1 ACKNOWLEDGEMENTS

MatrixOps includes algorithms and pre-existing code from several
origins.  In particular, C<eigens_sym> is the work of Stephen Moshier,
C<svd> uses an SVD subroutine written by Bryant Marks, and C<eigens>
uses a subset of the Small Scientific Library by Kenneth Geisshirt.
They are free software, distributable under same terms as PDL itself.


=head1 NOTES

This is intended as a general-purpose linear algebra package for
small-to-mid sized matrices.  The algorithms may not scale well to
large matrices (hundreds by hundreds) or to near singular matrices.

If there is something you want that is not here, please add and
document it!

=cut

use Carp;
use PDL::NiceSlice;
use strict;







=head1 FUNCTIONS



=cut




=head2 identity

=for sig

 Signature: (n; [o]a(n,n))

=for ref

Return an identity matrix of the specified size.  If you hand in a
scalar, its value is the size of the identity matrix; if you hand in a
dimensioned PDL, the 0th dimension is the size of the matrix.

=cut

sub identity {
  my $n = shift;
  my $out = ((UNIVERSAL::isa($n,'PDL')) ? 
	  (  ($n->getndims > 0) ? 
	     zeroes($n->dim(0),$n->dim(0)) : 
	     zeroes($n->at(0),$n->at(0))
	  ) :
	  zeroes($n,$n)
	  );
  $out->diagonal(0,1)++;
  $out;
}



=head2 stretcher

=for sig
  
  Signature: (a(n); [o]b(n,n))

=for usage

  $mat = stretcher($eigenvalues);

=for ref 

Return a diagonal matrix with the specified diagonal elements

=cut

sub stretcher {
  my $in = shift;
  my $out = zeroes($in->dim(0),$in->dims);
  $out->diagonal(0,1) += $in;	
  $out;
}




=head2 inv

=for sig

 Signature: (a(m,m); sv opt )

=for usage

  $a1 = inv($a, {$opt});                

=for ref

Invert a square matrix.

You feed in an NxN matrix in $a, and get back its inverse (if it
exists).  The code is inplace-aware, so you can get back the inverse
in $a itself if you want -- though temporary storage is used either
way.  You can cache the LU decomposition in an output option variable.

C<inv> uses lu_decomp by default; that is a numerically stable
(pivoting) LU decomposition method.  If you ask it to thread then a
numerically unstable (non-pivoting) method is used instead, so avoid
threading over collections of large (say, more than 4x4) or
near-singular matrices unless precision is not important.


OPTIONS:

=over 3

=item * s

Boolean value indicating whether to complain if the matrix is singular.  If
this is false, singular matrices cause inverse to barf.  If it is true, then 
singular matrices cause inverse to return undef.  In the threading case, no 
checking for singularity is performed, if any of the matrices in your threaded 
collection are singular, they receive NaN entries.

=item * lu (I/O)

This value contains a list ref with the LU decomposition, permutation,
and parity values for $a.  If you do not mention the key, or if the
value is undef, then inverse calls lu_decomp.  If the key exists with
an undef value, then the output of lu_decomp is stashed here (unless
the matrix is singular).  If the value exists, then it is assumed to
hold the lu decomposition.

=item * det (Output)

If this key exists, then the determinant of C<$a> get stored here,
whether or not the matrix is singular.

=back

=cut

*PDL::inv = \&inv;
sub inv {
  my $a = shift;
  my $opt = shift;
  $opt = {} unless defined($opt);


  barf "inverse needs a square PDL as a matrix\n" 
    unless(UNIVERSAL::isa($a,'PDL') &&
	   $a->dims >= 2 &&
	   $a->dim(0) == $a->dim(1)
	   );

  my ($lu,$perm,$par);
  if(exists($opt->{lu}) &&
     ref $opt->{lu} eq 'ARRAY' &&
     ref $opt->{lu}->[0] eq 'PDL') {
	    ($lu,$perm,$par) = @{$opt->{lu}};
  } else {
    ($lu,$perm,$par) = lu_decomp($a);
    @{$opt->{lu}} = ($lu,$perm,$par)
     if(ref $opt->{lu} eq 'ARRAY');
  }

  my $det = (defined $lu) ? $lu->diagonal(0,1)->prodover * $par : pdl(0);
  $opt->{det} = $det
    if exists($opt->{det});

  unless($det->nelem > 1 || $det) {
    return undef 
      if $opt->{s};
    barf("PDL::inv: got a singular matrix or LU decomposition\n");
  }

  my $out = lu_backsub($lu,$perm,$par,identity($a))->xchg(0,1)->sever;

  return $out
    unless($a->is_inplace);

  $a .= $out;
  $a;
}




=head2 det

=for sig

 Signature: (a(m,m); sv opt)

=for usage

  $det = det($a,{opt});

=for ref

Determinant of a square matrix using LU decomposition (for large matrices)

You feed in a square matrix, you get back the determinant.  Some
options exist that allow you to cache the LU decomposition of the
matrix (note that the LU decomposition is invalid if the determinant
is zero!).  The LU decomposition is cacheable, in case you want to
re-use it.  This method of determinant finding is more rapid than
recursive-descent on large matrices, and if you reuse the LU
decomposition it's essentially free.

If you ask det to thread (by giving it a 3-D or higher dim piddle)
then L<lu_decomp|lu_decomp> drops you through to
L<lu_decomp2|lu_decomp2>, which is numerically unstable (and hence not
useful for very large matrices) but quite fast.

If you want to use threading on a matrix that's less than, say, 10x10,
and might be near singular, then you might want to use
L<determinant|determinant>, which is a more robust (but slower)
determinant finder, instead.

OPTIONS:

=over 3

=item * lu (I/O)

Provides a cache for the LU decomposition of the matrix.  If you 
provide the key but leave the value undefined, then the LU decomposition
goes in here; if you put an LU decomposition here, it will be used and
the matrix will not be decomposed again.

=back

=cut
*PDL::det = \&det;
sub det {
  my($a) = shift;
  my($opt) = shift;
  $opt = {} unless defined($opt);

  my($lu,$perm,$par);
  if(exists ($opt->{u}) and (ref $opt->{lu} eq 'ARRAY')) {
    ($lu,$perm,$par) =  @{$opt->{lu}};
  } else {
    ($lu,$perm,$par) = lu_decomp($a);
    $opt->{lu} = [$lu,$perm,$par]
      if(exists($opt->{lu}));
  }
   
  ( (defined $lu) ? $lu->diagonal(0,1)->prodover * $par : 0 );
}




=head2 determinant

=for sig
 
 Signature: (a(m,m))

=for usage

  $det = determinant($a);

=for ref

Determinant of a square matrix, using recursive descent (threadable).

This is the traditional, robust recursive determinant method taught in
most linear algebra courses.  It scales like C<O(n!)> (and hence is
pitifully slow for large matrices) but is very robust because no 
division is involved (hence no division-by-zero errors for singular
matrices).  It's also threadable, so you can find the determinants of 
a large collection of matrices all at once if you want.

Matrices up to 3x3 are handled by direct multiplication; larger matrices
are handled by recursive descent to the 3x3 case.

The LU-decomposition method L<det|det> is faster in isolation for
single matrices larger than about 4x4, and is much faster if you end up
reusing the LU decomposition of $a, but does not thread well.

=cut

*PDL::determinant = \&determinant;
sub determinant {
  my($a) = shift;
  my($n);
  return undef unless(
		      UNIVERSAL::isa($a,'PDL') &&
		      $a->getndims >= 2 &&
		      ($n = $a->dim(0)) == $a->dim(1)
		      );
  
  return $a->clump(2) if($n==1);
  if($n==2) {
    my($b) = $a->clump(2);
    return $b->index(0)*$b->index(3) - $b->index(1)*$b->index(2);
  }
  if($n==3) {
    my($b) = $a->clump(2);
    
    my $b3 = $b->index(3);
    my $b4 = $b->index(4);
    my $b5 = $b->index(5);
    my $b6 = $b->index(6);
    my $b7 = $b->index(7);
    my $b8 = $b->index(8);

    return ( 
	 $b->index(0) * ( $b4 * $b8 - $b5 * $b7 )
      +  $b->index(1) * ( $b5 * $b6 - $b3 * $b8 )
      +  $b->index(2) * ( $b3 * $b7 - $b4 * $b6 )
	     );
  }
  
  my($i);
  my($sum) = zeroes($a->((0),(0)));

  # Do middle submatrices
  for $i(1..$n-2) {
    my $el = $a->(($i),(0));
    next if( ($el==0)->all );  # Optimize away unnecessary recursion

    $sum += $el * (1-2*($i%2)) * 
      determinant(        $a->(0:$i-1,1:-1)->
		   append($a->($i+1:-1,1:-1)));
  }

  # Do beginning and end submatrices
  $sum += $a->((0),(0))  * determinant($a->(1:-1,1:-1));
  $sum -= $a->((-1),(0)) * determinant($a->(0:-2,1:-1)) * (1 - 2*($n % 2));
  
  return $sum;
}





=head2 eigens_sym

=for sig

  Signature: ([phys]a(m); [o,phys]ev(n,n); [o,phys]e(n))


=for ref

Eigenvalues and -vectors of a symmetric square matrix.  If passed
an asymmetric matrix, the routine will warn and symmetrize it, by taking
the average value.  That is, it will solve for 0.5*($a+$a->mv(0,1)).

It's threadable, so if $a is 3x3x100, it's treated as 100 separate 3x3
matrices, and both $ev and $e get extra dimensions accordingly.

If called in scalar context it hands back only the eigenvalues.  Ultimately,
it should switch to a faster algorithm in this case (as discarding the 
eigenvectors is wasteful).

The algorithm used is due to J. vonNeumann, which was a rediscovery of
Jacobi's method.  http://en.wikipedia.org/wiki/Jacobi_eigenvalue_algorithm

The eigenvectors are returned in COLUMNS of the returned PDL.  That
makes it slightly easier to access individual eigenvectors, since the
0th dim of the output PDL runs across the eigenvectors and the 1st dim
runs across their components.

	($ev,$e) = eigens_sym $a;  # Make eigenvector matrix
	$vector = $ev->($n);       # Select nth eigenvector as a column-vector
	$vector = $ev->(($n));     # Select nth eigenvector as a row-vector

=for usage

 ($ev, $e) = eigens_sym($a); # e'vects & e'vals
 $e = eigens_sym($a);        # just eigenvalues



=for bad

eigens_sym ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut





   sub PDL::eigens_sym {
      my ($a) = @_;
      my (@d) = $a->dims;
      barf "Need real square matrix for eigens_sym" 
            if $#d < 1 or $d[0] != $d[1];
      my ($n) = $d[0];
      my ($sym) = 0.5*($a + $a->mv(0,1));
      my ($err) = PDL::max(abs($sym));
      barf "Need symmetric component non-zero for eigens_sym"
          if $err == 0;
      $err = PDL::max(abs($a-$sym))/$err;
      warn "Using symmetrized version of the matrix in eigens_sym"
	if $err > 1e-5 && $PDL::debug;

      ## Get lower diagonal form 
      ## Use whichND/indexND because whereND doesn't exist (yet?) and
      ## the combo is threadable (unlike where).  Note that for historical 
      ## reasons whichND needs a scalar() around it to give back a 
      ## nice 2xn PDL index. 
      my $lt  = PDL::indexND($sym,
			     scalar(PDL::whichND(PDL->xvals($n,$n) <=
						 PDL->yvals($n,$n)))
			     )->copy;
      my $ev  = PDL->zeroes($sym->dims);
      my $e   = PDL->zeroes($sym->index(0)->dims);
      
      &PDL::_eigens_sym_int($lt, $ev, $e);

      return $ev->xchg(0,1), $e
	if(wantarray);
      $e;                #just eigenvalues
   }


*eigens_sym = \&PDL::eigens_sym;




=head2 eigens

=for sig

  Signature: ([phys]a(m); [o,phys]ev(l,n,n); [o,phys]e(l,n))


=for ref

Real eigenvalues and -vectors of a real square matrix.  

(See also L<"eigens_sym"|/eigens_sym>, for eigenvalues and -vectors
of a real, symmetric, square matrix).

The eigens function will attempt to compute the eigenvalues and
eigenvectors of a square matrix with real components.  If the matrix
is symmetric, the same underlying code as L<"eigens_sym"|/eigens_sym>
is used.  If asymmetric, the eigenvalues and eigenvectors are computed
with algorithms from the sslib library.  If any imaginary components
exist in the eigenvalues, the results are currently considered to be
invalid, and such eigenvalues are returned as "NaN"s.  This is true
for eigenvectors also.  That is if there are imaginary components to
any of the values in the eigenvector, the eigenvalue and corresponding
eigenvectors are all set to "NaN".  Finally, if there are any repeated
eigenvectors, they are replaced with all "NaN"s.

Use of the eigens function on asymmetric matrices should be considered
experimental!  For asymmetric matrices, nearly all observed matrices
with real eigenvalues produce incorrect results, due to errors of the
sslib algorithm.  If your assymmetric matrix returns all NaNs, do not
assume that the values are complex.  Also, problems with memory access
is known in this library.

Not all square matrices are diagonalizable.  If you feed in a
non-diagonalizable matrix, then one or more of the eigenvectors will
be set to NaN, along with the corresponding eigenvalues.

C<eigens> is threadable, so you can solve 100 eigenproblems by 
feeding in a 3x3x100 array. Both $ev and $e get extra dimensions accordingly.

If called in scalar context C<eigens> hands back only the eigenvalues.  This
is somewhat wasteful, as it calculates the eigenvectors anyway.

The eigenvectors are returned in COLUMNS of the returned PDL (ie the
the 0 dimension).  That makes it slightly easier to access individual
eigenvectors, since the 0th dim of the output PDL runs across the
eigenvectors and the 1st dim runs across their components.

	($ev,$e) = eigens $a;  # Make eigenvector matrix
	$vector = $ev->($n);   # Select nth eigenvector as a column-vector
	$vector = $ev->(($n)); # Select nth eigenvector as a row-vector

DEVEL NOTES: 

For now, there is no distinction between a complex eigenvalue and an
invalid eigenvalue, although the underlying code generates complex
numbers.  It might be useful to be able to return complex eigenvalues.

=for usage

 ($ev, $e) = eigens($a); # e'vects & e'vals
 $e = eigens($a);        # just eigenvalues



=for bad

eigens ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut





   sub PDL::eigens {
      my ($a) = @_;
      my (@d) = $a->dims;
      my $n = $d[0];
      barf "Need real square matrix for eigens" 
            if $#d < 1 or $d[0] != $d[1];
      my $deviation = PDL::max(abs($a - $a->mv(0,1)))/PDL::max(abs($a));
      if ( $deviation <= 1e-5 ) {
          #taken from eigens_sym code

          my $lt  = PDL::indexND($a,
			     scalar(PDL::whichND(PDL->xvals($n,$n) <=
						 PDL->yvals($n,$n)))
			     )->copy;
          my $ev  = PDL->zeroes($a->dims);
          my $e   = PDL->zeroes($a->index(0)->dims);
      
          &PDL::_eigens_sym_int($lt, $ev, $e);

          return $ev->xchg(0,1), $e   if wantarray;
          return $e;  #just eigenvalues
      }
      else {
          if($PDL::verbose || $PDL::debug) {
   	    print "eigens: using the asymmetric case from SSL\n";
	  }
	  if( !$PDL::eigens_bug_ack && !$ENV{PDL_EIGENS_ACK} ) {
	    print STDERR "WARNING: using sketchy algorithm for PDL::eigens asymmetric case -- you might\n".
	          "    miss an eigenvector or two\nThis should be fixed in PDL v2.5 (due 2009), \n".
		  "    or you might fix it yourself (hint hint).  You can shut off this warning\n".
		  "    by setting the variable $PDL::eigens_bug_ack, or the environment variable\n".
		  "    PDL_EIGENS_HACK prior to calling eigens() with a non-symmetric matrix.\n";
		  $PDL::eigens_bug_ack = 1;
	  }
	  
          my $ev  = PDL->zeroes(2, $a->dims);
          my $e   = PDL->zeroes(2, $a->index(0)->dims);

          &PDL::_eigens_int($a->clump(0,1), $ev, $e);

          return $ev->index(0)->xchg(0,1)->sever, $e->index(0)->sever
              if(wantarray);
          return $e->index(0)->sever;  #just eigenvalues
      }
   }


*eigens = \&PDL::eigens;




=head2 svd

=for sig

  Signature: (a(n,m); [o]u(n,m); [o,phys]z(n); [o]v(n,n))


=for usage

 ($r1, $s, $r2) = svd($a);

=for ref

Singular value decomposition of a matrix.

C<svd> is threadable.

C<$r1> and C<$r2> are rotation matrices that convert from the original
matrix's singular coordinates to final coordinates, and from original
coordinates to singular coordinates, respectively.  C<$s> is the
diagonal of the singular value matrix, so that, if C<$a> is square,
then you can make an expensive copy of C<$a> by saying:

 $ess = zeroes($r1); $ess->diagonal(0,1) .= $s;
 $a_copy .= $r2 x $ess x $r1;

EXAMPLE

The computing literature has loads of examples of how to use SVD.
Here's a trivial example (used in L<PDL::Transform::Map|PDL::Transform::map>)
of how to make a matrix less, er, singular, without changing the 
orientation of the ellipsoid of transformation:

 { my($r1,$s,$r2) = svd $a;
   $s++;             # fatten all singular values
   $r2 *= $s;        # implicit threading for cheap mult.
   $a .= $r2 x $r1;  # a gets r2 x ess x r1
 }



=for bad

svd ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*svd = \&PDL::svd;



=head2 lu_decomp

=for sig

  Signature: (a(m,m); [o]b(n); [o]c; [o]lu)

=for ref

LU decompose a matrix, with row permutation

=for usage

  ($lu, $perm, $parity) = lu_decomp($a);

  $lu = lu_decomp($a, $perm, $par);  # $perm and $par are outputs!

  lu_decomp($a->inplace,$perm,$par); # Everything in place.

=for description

lu_decomp returns an LU decomposition of a square matrix, using
Crout's method with partial pivoting.  It's ported from I<Numerical
Recipes>.  The partial pivoting keeps it numerically stable but
defeats efficient threading, so if you have a few matrices to
decompose accurately, you should use lu_decomp, but if you have a
million matrices to decompose and don't mind a higher error budget you
probably want to use L<lu_decomp2|lu_decomp2>, which doesn't do the
pivoting (and hence gives wrong answers for near-singular or large
matrices), but does do threading.

lu_decomp decomposes the input matrix into matrices L and U such that
LU = A, L is a subdiagonal matrix, and U is a superdiagonal matrix.
By convention, the diagonal of L is all 1's.  

The single output matrix contains all the variable elements of both
the L and U matrices, stacked together.  Because the method uses
pivoting (rearranging the lower part of the matrix for better
numerical stability), you have to permute input vectors before applying
the L and U matrices.  The permutation is returned either in the
second argument or, in list context, as the second element of the
list.  You need the permutation for the output to make any sense, so 
be sure to get it one way or the other.

LU decomposition is the answer to a lot of matrix questions, including
inversion and determinant-finding, and lu_decomp is used by
L<inverse|/inverse>.

If you pass in $perm and $parity, they either must be predeclared PDLs
of the correct size ($perm is an n-vector, $parity is a scalar) or
scalars.

If the matrix is singular, then the LU decomposition might not be
defined; in those cases, lu_decomp silently returns undef.  Some 
singular matrices LU-decompose just fine, and those are handled OK but
give a zero determinant (and hence can't be inverted).

lu_decomp uses pivoting, which rearranges the values in the matrix for
more numerical stability.  This makes it really good for large and
even near-singular matrices, but makes it unable to properly vectorize
threaded operation.  If you have a LOT of small matrices to
invert (like, say, a 3x3x1000000 PDL) you should use L<lu_decomp2>,
which doesn't pivot and is therefore threadable (and, of course, works
in-place).

If you ask lu_decomp to thread (by having a nontrivial third dimension
in the matrix) then it will call lu_decomp2 instead.  That is a
numerically unstable (non-pivoting) method that is mainly useful for
smallish, not-so-singular matrices but is threadable.

lu_decomp is ported from _Numerical_Recipes to PDL.  It should probably
be implemented in C.

=cut

*PDL::lu_decomp = \&lu_decomp;

sub lu_decomp {
  my($in) = shift;
  my($permute) = shift;
  my($parity) = shift;
  my($sing_ok) = shift;

  my $TINY = 1e-30;

  barf("lu_decomp requires a square (2D) PDL\n")
    if(!UNIVERSAL::isa($in,'PDL') || 
       $in->ndims < 2 || 
       $in->dim(0) != $in->dim(1));

  if(($in->ndims > 2) && !( (pdl($in->dims)->(2:-1) < 2)->all )  ) {
    warn('lu_decomp: calling lu_decomp2 for threadability') 
      if($PDL::debug);
    return lu_decomp2($in,$permute,$parity,$sing_ok);
  }
  
  my($n) = $in->dim(0);
  my($n1) = $n; $n1--;

  my($inplace) = $in->is_inplace;
  my($out) = ($inplace) ? $in : $in->copy;


  if(defined $permute) {
    barf('lu_decomp: permutation vector must match the matrix')
      if(!UNIVERSAL::isa($permute,'PDL') || 
	 $permute->ndims != 1 || 
	 $permute->dim(0) != $out->dim(0));
    $permute .= PDL->xvals($in->dim(0));
  } else {
    $permute = PDL->xvals($in->dim(0));
  }

  if(defined $parity) {
    barf('lu_decomp: parity must be a scalar PDL') 
      if(!UNIVERSAL::isa($parity,'PDL') ||
	 $parity->nelem != 1);
    $parity .= 1.0;
  } else {
    $parity = pdl(1.0);
  }
  
  my($scales) = $in->abs->maximum; # elementwise by rows
  
  if(($scales==0)->sum) {
    return undef;
  }

  # Some holding tanks
  my($tmprow) = zeroes(double(),$out->dim(0)); 
  my($tmpval) = pdl(0.0);
  
  my($out_diag) = $out->diagonal(0,1);
  
  my($col,$row);
  for $col(0..$n1) {       
    for $row(1..$n1) {   
      my($klim) = $row<$col ? $row : $col;
      if($klim > 0) {
	$klim--;
	my($el) = $out->index2d($col,$row);
	$el -= ( $out->(($col),0:$klim) *
		 $out->(0:$klim,($row)) )->sum;
      }

    }
    
    # Figure a_ij, with pivoting
    
    if($col < $n1) {
      # Find the maximum value in the rest of the row
      my $sl = $out->(($col),$col:$n1);
      my $wh = $sl->abs->maximum_ind;
      my $big = $sl->index($wh)->sever;
      
      # Permute if necessary to make the diagonal the maximum
      if($wh != 0) {  # Permute rows to place maximum element on diagonal.
	my $whc = $wh+$col;
	
	my $sl1 = $out->(:,($whc));
	my $sl2 = $out->(:,($col));
	$tmprow .= $sl1;  $sl1 .= $sl2;  $sl2 .= $tmprow;
	
	$sl1 = $permute->index($whc);
	$sl2 = $permute->index($col);
	$tmpval .= $sl1; $sl1 .= $sl2; $sl2 .= $tmpval;
	
	$parity *= -1.0;
      }

      # Sidestep near-singularity (NR does this; not sure if it is helpful)
      $big = $TINY * (1.0 - 2.0*($big < 0))
	if(abs($big) < $TINY);
      
      # Divide by the diagonal element (which is now the largest element)
      my $tout;
      ($tout = $out->(($col),$col+1:$n1)) /= $big;
    } # end of pivoting part
  } # end of column loop

  if(wantarray) {
    return ($out,$permute,$parity);
  }
  $out;
}



=head2 lu_decomp2

=for sig

 Signature: (a(m,m); [0]lu(n)

=for ref

LU decompose a matrix, with no row permutation (threadable!)

=for usage

  ($lu, $perm, $parity) = lu_decomp2($a);

  $lu = lu_decomp2($a,[$perm,$par]); 

  lu_decomp($a->inplace,[$perm,$par]);

=for description

C<lu_decomp2> works just like L<lu_decomp|lu_decomp>, but it does no
pivoting at all and hence can be usefully threaded.  For compatibility
with L<lu_decomp|lu_decomp>, it will give you a permutation list and a parity
scalar if you ask for them -- but they are always trivial.

Because C<lu_decomp2> does not pivot, it is numerically unstable --
that means it is less precise than L<lu_decomp>, particularly for
large or near-singular matrices.  There are also specific types of 
non-singular matrices that confuse it (e.g. ([0,-1,0],[1,0,0],[0,0,1]),
which is a 90 degree rotation matrix but which confuses lu_decomp2).
On the other hand, if you want to invert rapidly a few hundred thousand
small matrices and don't mind missing one or two, it's just the ticket.

The output is a single matrix that contains the LU decomposition of $a;
you can even do it in-place, thereby destroying $a, if you want.  See
L<lu_decomp> for more information about LU decomposition. 

lu_decomp2 is ported from _Numerical_Recipes_ into PDL.  If lu_decomp
were implemented in C, then lu_decomp2 might become unnecessary.

=cut

*PDL::lu_decomp2 = \&lu_decomp2;

sub lu_decomp2 {
  my($in) = shift;
  my($perm) = shift;
  my($par) = shift;

  my($sing_ok) = shift;

  my $TINY = 1e-30;
  
  barf("lu_decomp2 requires a square (2D) PDL\n")
    if(!UNIVERSAL::isa($in,'PDL') || 
       $in->ndims < 2 || 
       $in->dim(0) != $in->dim(1));
  
  my($n) = $in->dim(0);
  my($n1) = $n; $n1--;

  my($inplace) = $in->is_inplace;
  my($out) = ($inplace) ? $in : $in->copy;


  if(defined $perm) {
    barf('lu_decomp2: permutation vector must match the matrix')
      if(!UNIVERSAL::isa($perm,'PDL') || 
	 $perm->ndims != 1 || 
	 $perm->dim(0) != $out->dim(0));
    $perm .= PDL->xvals($in->dim(0));
  } else {
    $perm = PDL->xvals($in->dim(0));
  }

  if(defined $par) {
    barf('lu_decomp: parity must be a scalar PDL') 
      if(!UNIVERSAL::isa($par,'PDL') ||
	 $par->nelem != 1);
    $par .= 1.0;
  } else {
    $par = pdl(1.0);
  }

  my $diagonal = $out->diagonal(0,1);

  my($col,$row);
  for $col(0..$n1) {       
    for $row(1..$n1) {   
      my($klim) = $row<$col ? $row : $col;
      if($klim > 0) {
	$klim--;
	my($el) = $out->index2d($col,$row);

	$el -= ( $out->(($col),0:$klim) *
		 $out->(0:$klim,($row)) )->sumover;
      }

    }
    
    # Figure a_ij, with no pivoting
    if($col < $n1) {
      # Divide the rest of the column by the diagonal element 
      $out->(($col),$col+1:$n1) /= $diagonal->index($col)->dummy(0,$n1-$col);
    }

  } # end of column loop

  if(wantarray) {
    return ($out,$perm,$par);
  }
  $out;
}




=head2 lu_backsub

=for sig

 Signature: (lu(m,m); perm(m); b(m))

=for ref

Solve A X = B for matrix A, by back substitution into A's LU decomposition.

=for usage

  ($lu,$perm) = lu_decomp($a);
  $x = lu_backsub($lu,$perm,$par,$b);
  
  lu_backsub($lu,$perm,$b->inplace); # modify $b in-place

  $x = lu_backsub(lu_decomp($a),$b); # (ignores parity value from lu_decomp)

=for description

Given the LU decomposition of a square matrix (from L<lu_decomp|lu_decomp>),
lu_backsub does back substitution into the matrix to solve C<A X = B> for 
given vector C<B>.  It is separated from the lu_decomp method so that you can
call the cheap lu_backsub multiple times and not have to do the expensive
LU decomposition more than once.  

lu_backsub acts on single vectors and threads in the usual way, which
means that it treats C<$b> as the I<transpose> of the input.  If you
want to process a matrix, you must hand in the I<transpose> of the
matrix, and then transpose the output when you get it back.  That is
because PDLs are indexed by (col,row), and matrices are (row,column)
by convention, so a 1-D PDL corresponds to a row vector, not a column
vector.

If C<$lu> is dense and you have more than a few points to solve for,
it is probably cheaper to find C<A^-1> with L<inverse|/inverse>, and
just multiply C<X = A^-1 B>.)  In fact, L<inverse|/inverse> works by
calling lu_backsub with the identity matrix.

lu_backsub is ported from Section 2.3 of I<Numerical Recipes>.  It is 
written in PDL but should probably be implemented in C.

=cut

*PDL::lu_backsub = \&lu_backsub;
sub lu_backsub {
  my ($lu, $perm, $b, $par);
  if(@_==3) {
    ($lu, $perm, $b) = @_;
  } elsif(@_==4) {
    ($lu, $perm, $par, $b) = @_;
  } 
  
  barf("lu_backsub: LU decomposition is undef -- probably from a singular matrix.\n")
    unless defined($lu);

  barf("Usage: \$x = lu_backsub(\$lu,\$perm,\$b); all must be PDLs\n") 
    unless(UNIVERSAL::isa($lu,'PDL') &&
	 UNIVERSAL::isa($perm,'PDL') &&
	   UNIVERSAL::isa($b,'PDL'));

  my $n = $b->dim(0);
  my $n1 = $n; $n1--;


  # Permute the vector and make a copy if necessary.
  my $out;
  my $nontrivial = !(($perm==(PDL->xvals($perm->dims)))->all);

  if($nontrivial) {
    if($b->is_inplace) {
      $b .= $b->dummy(1,$b->dim(0))->index($perm)->sever;
      $out = $b;
    } else {
      $out = $b->dummy(1,$b->dim(0))->index($perm)->sever;
    }
  } else {
    $out = ($b->is_inplace ? $b : $b->copy);
  }

  # Make sure threading over lu happens OK...

  if($out->ndims < $lu->ndims) {
    do {
      $out = $out->dummy(-1,$lu->dim($out->ndims));
    } while($out->ndims < $lu->ndims);
    $out = $out->sever;
  }

  ## Do forward substitution into L
  my $row; my $r1;

  for $row(1..$n1) {
    $r1 = $row-1;
    $out->index($row) -= ($lu->(0:$r1,$row) * 
		       $out->(0:$r1)
		       )->sumover;
  }

  ## Do backward substitution into U, and normalize by the diagonal
  my $ludiag = $lu->diagonal(0,1)->dummy(1,$n);
  $out->index($n1) /= $ludiag->index($n1);

  for ($row=$n1; $row>0; $row--) {
    $r1 = $row-1;
    $out->index($r1) -= ($lu->($row:$n1,$r1) * 
			$out->($row:$n1)
			)->sumover;
    $out->index($r1) /= $ludiag->index($r1);
  }

  $out;
}





=head2 simq

=for sig

  Signature: ([phys]a(n,n); [phys]b(n); [o,phys]x(n); int [o,phys]ips(n); int flag)


=for ref

Solution of simultaneous linear equations, C<a x = b>.

C<$a> is an C<n x n> matrix (i.e., a vector of length C<n*n>), stored row-wise:
that is, C<a(i,j) = a[ij]>, where C<ij = i*n + j>.  

While this is the transpose of the normal column-wise storage, this
corresponds to normal PDL usage.  The contents of matrix a may be
altered (but may be required for subsequent calls with flag = -1).

C<$b>, C<$x>, C<$ips> are vectors of length C<n>.

Set C<flag=0> to solve.  
Set C<flag=-1> to do a new back substitution for
different C<$b> vector using the same a matrix previously reduced when
C<flag=0> (the C<$ips> vector generated in the previous solution is also
required).

See also L<lu_backsub|lu_backsub>, which does the same thing with a slightly
less opaque interface.



=for bad

simq ignores the bad-value flag of the input piddles.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*simq = \&PDL::simq;




=head2 squaretotri

=for sig

  Signature: (a(n,n); b(m))


=for ref

Convert a symmetric square matrix to triangular vector storage.



=for bad

squaretotri does not process bad values.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut






*squaretotri = \&PDL::squaretotri;


;


sub eigen_c {
	print STDERR "eigen_c is no longer part of PDL::MatrixOps or PDL::Math; use eigens instead.\n";

##	my($mat) = @_;
##	my $s = $mat->getdim(0);
##	my $z = zeroes($s * ($s+1) / 2);
##	my $ev = zeroes($s);
##	squaretotri($mat,$z);
##	my $k = 0 * $mat;
##	PDL::eigens($z, $k, $ev);
##	return ($ev, $k);
}


=head1 AUTHOR

Copyright (C) 2002 Craig DeForest (deforest@boulder.swri.edu),
R.J.R. Williams (rjrw@ast.leeds.ac.uk), Karl Glazebrook
(kgb@aaoepp.aao.gov.au).  There is no warranty.  You are allowed to
redistribute and/or modify this work under the same conditions as PDL
itself.  If this file is separated from the PDL distribution, then the
PDL copyright notice should be included in this file.

=cut





# Exit with OK status

1;

		   