
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Primitive;

@EXPORT_OK  = qw( PDL::PP inner PDL::PP outer  matmult PDL::PP innerwt PDL::PP inner2 PDL::PP inner2d PDL::PP inner2t PDL::PP crossp PDL::PP norm PDL::PP indadd PDL::PP conv1d PDL::PP in  uniq  uniqind  uniqvec PDL::PP hclip PDL::PP lclip  clip PDL::PP wtstat PDL::PP statsover  stats PDL::PP histogram PDL::PP whistogram PDL::PP histogram2d PDL::PP whistogram2d PDL::PP fibonacci PDL::PP append PDL::PP axisvalues PDL::PP random PDL::PP randsym  grandom PDL::PP vsearch PDL::PP interpolate  interpol  interpND  one2nd PDL::PP which PDL::PP which_both  where  whichND  setops  intersect );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Primitive ;





use PDL::Slices;
use Carp;

=head1 NAME

PDL::Primitive - primitive operations for pdl

=head1 DESCRIPTION

This module provides some primitive and useful functions defined
using PDL::PP and able to use the new indexing tricks.

See L<PDL::Indexing|PDL::Indexing> for how to use indices creatively.
For explanation of the signature format, see L<PDL::PP|PDL::PP>.

=head1 SYNOPSIS

 use PDL::Primitive;

=cut







=head1 FUNCTIONS



=cut






=head2 inner

=for sig

  Signature: (a(n); b(n); [o]c())


=for ref

Inner product over one dimension

 c = sum_i a_i * b_i





=cut






*inner = \&PDL::inner;




=head2 outer

=for sig

  Signature: (a(n); b(m); [o]c(n,m))


=for ref

outer product over one dimension

Naturally, it is possible to achieve the effects of outer
product simply by threading over the "C<*>"
operator but this function is provided for convenience.





=cut






*outer = \&PDL::outer;


=head2 x

 Signature: (a(i,x), b(z,i),[o]c(x,z))

=for ref

Matrix multiplication

PDL overloads the C<x> operator (normally the repeat operator) for
matrix multiplication.  The number of columns (size of the 0
dimension) in the left-hand argument must normally equal the number of 
rows (size of the 1 dimension) in the right-hand argument. 

Row vectors are represented as (N x 1) two-dimensional PDLs, or you
may be sloppy and use a one-dimensional PDL.  Column vectors are 
represented as (1 x N) two-dimensional PDLs.

Threading occurs in the usual way, but as both the 0 and 1 dimension
(if present) are included in the operation, you must be sure that 
you don't try to thread over either of those dims.

EXAMPLES

Here are some simple ways to define vectors and matrices:

 perldl> $r = pdl(1,2);                # A row vector 
 perldl> $c = pdl([[3],[4]]);          # A column vector 
 perldl> $c = pdl(3,4)->(*1);          # A column vector, using NiceSlice
 perldl> $m = pdl([[1,2],[3,4]]);      # A 2x2 matrix

Now that we have a few objects prepared, here is how to
matrix-multiply them:

 perldl> print $r x $m                 # row x matrix = row
 [
  [ 7 10]
 ]

 perldl> print $m x $r                 # matrix x row = ERROR
 PDL: Dim mismatch in matmult of [2x2] x [2x1]: 2 != 1

 perldl> print $m x $c                 # matrix x column = column
 [
  [ 5]
  [11]
 ]

 perldl> print $m x 2                  # Trivial case: scalar mult.
 [
  [2 4]
  [6 8]
 ]

 perldl> print $r x $c                 # row x column = scalar
 [
  [11]
 ]

 perldl> print $c x $r                 # column x row = matrix
 [
  [3 6]
  [4 8]
 ]


INTERNALS

The mechanics of the multiplication are carried out by the
L<matmult|/matmult> method.


=head2 matmult

=for sig

 Signature: (a(i,x),b(z,i),[o]c(x,z))

=for ref

Matrix multiplication

We peruse the inner product to define matrix multiplication
via a threaded inner product.

For usage, see L<x|/x>, a description of the overloaded 'x' operator

=cut

  sub PDL::matmult {
    barf "Invalid number of arguments for matmult" if $#_ < 1;
    my ($a,$b,$c) = @_;

    $b=pdl($b) unless UNIVERSAL::isa($b,'PDL'); # Make sure 2nd arg's a PDL

    while ($a->getndims < 2) {$a = $a->dummy(-1)} # promote if necessary
    while ($b->getndims < 2) {$b = $b->dummy(-1)} 

    return ($c .= $a * $b) if ( ($a->dim(0)==1 && $a->dim(1)==1) ||
	                        ($b->dim(0)==1 && $b->dim(1)==1) ) ;

    if($b->dim(1) != $a->dim(0)) {
	barf(sprintf("Dim mismatch in matmult of [%dx%d] x [%dx%d]: %d != %d",$a->dim(0),$a->dim(1),$b->dim(0),$b->dim(1),$a->dim(0),$b->dim(1)));
    }

    if(!defined $c) {$c = PDL->nullcreate($a)}
    $a->dummy(1)->inner($b->xchg(0,1)->dummy(2),$c);
    return $c;
  }

  *matmult = \&PDL::matmult;





=head2 innerwt

=for sig

  Signature: (a(n); b(n); c(n); [o]d())

=for ref

Weighted (i.e. triple) inner product

 d = sum_i a(i) b(i) c(i)





=cut






*innerwt = \&PDL::innerwt;




=head2 inner2

=for sig

  Signature: (a(n); b(n,m); c(m); [o]d())

=for ref

Inner product of two vectors and a matrix

 d = sum_ij a(i) b(i,j) c(j)

Note that you should probably not thread over C<a> and C<c> since that would be  
very wasteful. Instead, you should use a temporary for C<b*c>.





=cut






*inner2 = \&PDL::inner2;




=head2 inner2d

=for sig

  Signature: (a(n,m); b(n,m); [o]c())

=for ref

Inner product over 2 dimensions.

Equivalent to

 $c = inner($a->clump(2), $b->clump(2))





=cut






*inner2d = \&PDL::inner2d;




=head2 inner2t

=for sig

  Signature: (a(j,n); b(n,m); c(m,k); [t]tmp(n,k); [o]d(j,k)))

=for ref

Efficient Triple matrix product C<a*b*c>

Efficiency comes from by using the temporary C<tmp>. This operation only 
scales as C<N**3> whereas threading using L<inner2|/inner2> would scale 
as C<N**4>.

The reason for having this routine is that you do not need to
have the same thread-dimensions for C<tmp> as for the other arguments,
which in case of large numbers of matrices makes this much more
memory-efficient.

It is hoped that things like this could be taken care of as a kind of
closures at some point.





=cut






*inner2t = \&PDL::inner2t;




=head2 crossp

=for sig

  Signature: (a(tri=3); b(tri); [o] c(tri))

=for ref

Cross product of two 3D vectors

After

=for example

 $c = crossp $a, $b

the inner product C<$c*$a> and C<$c*$b> will be zero, i.e. C<$c> is
orthogonal to C<$a> and C<$b>





=cut






*crossp = \&PDL::crossp;




=head2 norm

=for sig

  Signature: (vec(n); [o] norm(n))

=for ref

Normalises a vector to unit Euclidean length



=cut






*norm = \&PDL::norm;




=head2 indadd

=for sig

  Signature: (a(); int ind(); [o] sum(m))


=for ref

Threaded Index Add: Add C<a> to the C<ind> element of C<sum>, i.e:

 sum(ind) += a

=for example

Simple Example:

  $a = 2;
  $ind = 3;
  $sum = zeroes(10);
  indadd($a,$ind, $sum);
  print $sum
  #Result: ( 2 added to element 3 of $sum)
  # [0 0 0 2 0 0 0 0 0 0]

Threaded Example:

  $a = pdl( 1,2,3);
  $ind = pdl( 1,4,6);
  $sum = zeroes(10);
  indadd($a,$ind, $sum);
  print $sum."\n";
  #Result: ( 1, 2, and 3 added to elements 1,4,6 $sum)
  # [0 1 0 0 2 0 3 0 0 0]





=cut






*indadd = \&PDL::indadd;




=head2 conv1d

=for sig

  Signature: (a(m); kern(p); [o]b(m); int reflect)

=for ref

1d convolution along first dimension

=for example

  $con = conv1d sequence(10), pdl(-1,0,1), {Boundary => 'reflect'};

By default, periodic boundary conditions are assumed (i.e. wrap around).
Alternatively, you can request reflective boundary conditions using
the C<Boundary> option:

  {Boundary => 'reflect'} # case in 'reflect' doesn't matter

The convolution is performed along the first dimension. To apply it across
another dimension use the slicing routines, e.g.

  $b = $a->mv(2,0)->conv1d($kernel)->mv(0,2); # along third dim

This function is useful for threaded filtering of 1D signals.

Compare also L<conv2d|PDL::Image2D/conv2d>, L<convolve|PDL::ImageND/convolve>,
L<fftconvolve|PDL::FFT/fftconvolve>, L<fftwconv|PDL::FFTW/fftwconv>,
L<rfftwconv|PDL::FFTW/rfftwconv>





=cut





        
sub PDL::conv1d {
   my $opt = pop @_ if ref($_[$#_]) eq 'HASH';
   die 'Usage: conv1d( a(m), kern(p), [o]b(m), {Options} )'
      if $#_<1 || $#_>2;
   my($a,$kern) = @_;
   my $c = $#_ == 2 ? $_[2] : PDL->null;
   &PDL::_conv1d_int($a,$kern,$c,
		     !(defined $opt && exists $$opt{Boundary}) ? 0 :
		     lc $$opt{Boundary} eq "reflect");
   return $c;
}



*conv1d = \&PDL::conv1d;




=head2 in

=for sig

  Signature: (a(); b(n); [o] c())

=for ref

test if a is in the set of values b

=for example

   $goodmsk = $labels->in($goodlabels);
   print pdl(4,3,1)->in(pdl(2,3,3));
  [0 1 0]

C<in> is akin to the I<is an element of> of set theory. In priciple,
PDL threading could be used to achieve its functionality by using a
construct like

   $msk = ($labels->dummy(0) == $goodlabels)->orover;

However, C<in> doesn't create a (potentially large) intermediate
and is generally faster.




=cut






*in = \&PDL::in;



=head2 uniq

=for ref

return all unique elements of a piddle

The unique elements are returned in ascending order.

=for example

  print pdl(2,2,2,4,0,-1,6,6)->uniq;
 [-1 0 2 4 6]

Note: The returned pdl is 1D; any structure of the input
piddle is lost.

See L<uniqind|uniqind> if you need the indices of the unique
elements rather than the values.




=cut

*uniq = \&PDL::uniq;
# return unique elements of array
# find as jumps in the sorted array
# flattens in the process
sub PDL::uniq {
  use PDL::Core 'barf';
  my ($arr) = @_;
  return $arr if($arr->nelem == 0); # The null list is unique (CED)
  my $srt = $arr->clump(-1)->qsort;
  $srt=$srt->nslice([0,$srt->ngood-1]) if ($PDL::Bad::Status && $srt->badflag);
  my $uniq = $srt->where($srt != $srt->rotate(-1));
  # make sure we return something if there is only one value
  return $uniq->nelem == 0 ? $srt->index(0) : $uniq;
}




=head2 uniqind

=for ref

return the indices of all unique elements of a piddle
The order is in the order of the values to be consistent
with uniq

=for example

  print pdl(2,2,2,4,0,-1,6,6)->uniqind;
	 [5, 4, 1, 3, 6]

Note: The returned pdl is 1D; any structure of the input
piddle is lost.

See L<uniq|uniq> if you want the unique values instead of the
indices.




=cut

*uniqind = \&PDL::uniqind;
# return unique elements of array
# find as jumps in the sorted array
# flattens in the process
sub PDL::uniqind {
  use PDL::Core 'barf';
  my ($arr) = @_;
  return $arr if($arr->nelem == 0); # The null list is unique (CED)
  # Different from uniq we sort and store the result in an intermediary
  my $i_srt = $arr->clump(-1)->qsorti;
  my $srt = $arr->index($i_srt);
  $srt=$srt->nslice([0,$srt->ngood-1]) if ($PDL::Bad::Status && $srt->badflag);
  my $uniqind = which($srt != $srt->rotate(-1));
  # Now map back to the original space
  $uniqind = $i_srt->index($uniqind);	
  # make sure we return something if there is only one value
  return $uniqind->nelem == 0 ? 0 : $uniqind;
}




=head2 uniqvec

=for ref

return all unique vectors out of a collection

The unique vectors are returned in lexicographically sorted
ascending order.  The 0th dimension of the input PDL is treated
as a dimensional index within each vector, and the 1st and any higher
dimensions are taken to run across vectors.  The return value is always
2D; any structure of the input PDL (beyond using the 0th dimension 
for vector index) is lost.  

See also L<uniq|uniq> for a uniqe list of scalars; and
L<qsortvec|PDL::Ufunc/qsortvec> for sorting a list of vectors
lexicographcally.




=cut

sub PDL::uniqvec {
  my($pdl) = shift;
  return $pdl if($pdl->nelem == 0 || $pdl->ndims <2 || $pdl->slice("(0)")->nelem < 2);  # slice is not cheap but uniqvec isn't either -- shouldn't cost too much.

  my $srt = $pdl->mv(0,-1)->
	clump($pdl->ndims - 1)->
	mv(-1,0)->qsortvec->
	mv(0,-1);
  $srt=$srt->dice($srt->mv(0,-1)->ngoodover->which) if ($PDL::Bad::Status && $srt->badflag);
##use dice instead of nslice since qsortvec might be packing the badvals to the front of the array instead of the end like the docs say. If that is the case and it gets fixed, it won't bust uniqvec. DAL 14-March 2006
  my $uniq = ($srt != $srt->rotate(-1)) -> mv(0,-1) -> orover->which;

  return $uniq->nelem==0 ? 
	$srt->slice(":,(0)") :
	$srt->dice($uniq)->mv(0,-1);
}

	
  
  
	





=head2 hclip

=for sig

  Signature: (a(); b(); [o] c())

=for ref

clip (threshold) C<$a> by C<$b> (C<$b> is upper bound)



=cut




sub PDL::hclip {
   my ($a,$b) = @_;
   my $c;
   if ($a->is_inplace) {
       $a->set_inplace(0); $c = $a;
   } elsif ($#_ > 1) {$c=$_[2]} else {$c=PDL->nullcreate($a)}
   &PDL::_hclip_int($a,$b,$c);
   return $c;
}


*hclip = \&PDL::hclip;




=head2 lclip

=for sig

  Signature: (a(); b(); [o] c())

=for ref

clip (threshold) C<$a> by C<$b> (C<$b> is lower bound)



=cut




sub PDL::lclip {
   my ($a,$b) = @_;
   my $c;
   if ($a->is_inplace) {
       $a->set_inplace(0); $c = $a;
   } elsif ($#_ > 1) {$c=$_[2]} else {$c=PDL->nullcreate($a)}
   &PDL::_lclip_int($a,$b,$c);
   return $c;
}


*lclip = \&PDL::lclip;



=head2 clip

=for ref

Clip (threshold) a piddle by (optional) upper or lower bounds.

=for usage

 $b = $a->clip(0,3);
 $c = $a->clip(undef, $x);



=cut

*clip = \&PDL::clip;
sub PDL::clip {
  my($a, $b, $c) = @_;
  my $d; if($a->is_inplace) {$a->set_inplace(0); $d = $a} 
  elsif($#_ > 2) {$d=$_[3]} else {$d = PDL->nullcreate($a)}
 if(defined $b) {
  	&PDL::_lclip_int($a,$b,$d);
	if(defined $c) {
		&PDL::_hclip_int($d,$c,$d);
	}
  } elsif(defined $c) {
	&PDL::_hclip_int($a,$c,$d);
  }
  return $d;
}





=head2 wtstat

=for sig

  Signature: (a(n); wt(n); avg(); [o]b(); int deg)

=for ref

Weighted statistical moment of given degree

This calculates a weighted statistic over the vector C<a>.
The formula is

 b() = (sum_i wt_i * (a_i ** degree - avg)) / (sum_i wt_i)





=cut






*wtstat = \&PDL::wtstat;




=head2 statsover

=for sig

  Signature: (a(n); w(n); float+ [o]avg(); float+ [o]prms(); int+ [o]median(); int+ [o]min(); int+ [o]max(); float+ [o]adev(); float+ [o]rms())


=for ref 

Calculate useful statistics over a dimension of a piddle

=for usage

  ($mean,$prms,$median,$min,$max,$adev,$rms) = statsover($piddle, $weights);

This utility function calculates various useful
quantities of a piddle. These are:

=over 3

=item * the mean:

  MEAN = sum (x)/ N

with C<N> being the number of elements in x

=item * RMS deviation from the mean:

  RMS = sqrt(sum( (x-mean(x))^2 )/N)

(also known as the root-mean-square deviation, or the square root of the
variance)

=item * the median

The median is the 50th percentile data value.  Median is found by
L<medover|PDL::Ufunc/medover>, so WEIGHTING IS IGNORED FOR THE MEDIAN CALCULATION.

=item * the minimum

=item * the maximum

=item * the absolute deviation:

  ADEV = sqrt(sum( abs(x-mean(x)) )/N)

(This is also called the standard deviation)

=item * the population RMS deviation from the mean:

  PRMS = sqrt( sum( (x-mean(x))^2 )/(N-1)

The population deviation is the best-estimate of the deviation 
of the population from which a sample is drawn.

=back

This operator is a projection operator so the calculation
will take place over the final dimension. Thus if the input 
is N-dimensional each returned value will be N-1 dimensional, 
to calculate the statistics for the entire piddle either
use C<clump(-1)> directly on the piddle or call C<stats>.






=cut






sub PDL::statsover {
   barf('Usage: ($mean,[$prms, $median, $min, $max, $adev, $rms]) = statsover($data,[$weights])') if $#_>1;
   my ($data, $weights) = @_;
   $weights = $data->ones() if !defined($weights);

   my $median = $data->medover();
   my $mean = PDL->nullcreate($data);
   my $rms = PDL->nullcreate($data);
   my $min = PDL->nullcreate($data);
   my $max = PDL->nullcreate($data);
   my $adev = PDL->nullcreate($data);
   my $prms = PDL->nullcreate($data);
   &PDL::_statsover_int($data, $weights, $mean, $prms, $median, $min, $max, $adev, $rms);

   return $mean unless wantarray;
   return ($mean, $prms, $median, $min, $max, $adev, $rms);
}



*statsover = \&PDL::statsover;



=head2 stats

=for ref

Calculates useful statistics on a piddle

=for usage

 ($mean,$prms,$median,$min,$max,$adev,$rms) = stats($piddle,[$weights]);

This utility calculates all the most useful quantities in one call.
It works the same way as L</statsover>, except that the quantities are
calculated considering the entire input PDL as a single sample, rather
than as a collection of rows. See L</statsover> for definitions of the
returned quantities.




=cut

*stats	  = \&PDL::stats;
sub PDL::stats {
    barf('Usage: ($mean,[$rms]) = stats($data,[$weights])') if $#_>1;
    my ($data,$weights) = @_;

    # Ensure that $weights is properly threaded over; this could be
    # done rather more efficiently...
    if(defined $weights) {
	$weights = pdl($weights) unless UNIVERSAL::isa($weights,'PDL');
	if( ($weights->ndims != $data->ndims) or 
	    (pdl($weights->dims) != pdl($data->dims))->or
	  ) {
		$weights = $weights + zeroes($data)
	}
	$weights = $weights->flat;
    } 
	
    return PDL::statsover($data->flat,$weights);
}




=head2 histogram

=for sig

  Signature: (in(n); int+[o] hist(m); double step; double min; int msize => m)


=for ref

Calculates a histogram for given stepsize and minimum.

=for usage

 $h = histogram($data, $step, $min, $numbins);
 $hist = zeroes $numbins;  # Put histogram in existing piddle.
 histogram($data, $hist, $step, $min, $numbins);

The histogram will contain C<$numbins> bins starting from C<$min>, each
C<$step> wide. The value in each bin is the number of
values in C<$data> that lie within the bin limits.

Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

The output is reset in a different threadloop so that you
can take a histogram of C<$a(10,12)> into C<$b(15)> and get the result
you want.

Use L<hist|PDL::Basic/hist> instead for a high-level interface.


=for example

 perldl> p histogram(pdl(1,1,2),1,0,3)
 [0 2 1]





=cut






*histogram = \&PDL::histogram;




=head2 whistogram

=for sig

  Signature: (in(n); float+ wt(n);float+[o] hist(m); double step; double min; int msize => m)


=for ref

Calculates a histogram from weighted data for given stepsize and minimum.

=for usage

 $h = whistogram($data, $weights, $step, $min, $numbins);
 $hist = zeroes $numbins;  # Put histogram in existing piddle.
 whistogram($data, $weights, $hist, $step, $min, $numbins);

The histogram will contain C<$numbins> bins starting from C<$min>, each
C<$step> wide. The value in each bin is the sum of the values in C<$weights>
that correspond to values in C<$data> that lie within the bin limits.

Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

The output is reset in a different threadloop so that you
can take a histogram of C<$a(10,12)> into C<$b(15)> and get the result
you want.


=for example

 perldl> p whistogram(pdl(1,1,2), pdl(0.1,0.1,0.5), 1, 0, 4)
 [0 0.2 0.5 0]





=cut






*whistogram = \&PDL::whistogram;




=head2 histogram2d

=for sig

  Signature: (ina(n); inb(n); int+[o] hist(ma,mb); double stepa; double mina; int masize => ma;
	             double stepb; double minb; int mbsize => mb;)


=for ref

Calculates a 2d histogram.

=for usage

 $h = histogram2d($datax, $datay,
       $stepx, $minx, $nbinx, $stepy, $miny, $nbiny);
 $hist = zeroes $nbinx, $nbiny;  # Put histogram in existing piddle.
 histogram2d($datax, $datay, $hist,
       $stepx, $minx, $nbinx, $stepy, $miny, $nbiny);

The histogram will contain C<$nbinx> x C<$nbiny> bins, with the lower
limits of the first one at C<($minx, $miny)>, and with bin size
C<($stepx, $stepy)>. 
The value in each bin is the number of
values in C<$datax> and C<$datay> that lie within the bin limits.

Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

=for example

 perldl> p histogram2d(pdl(1,1,1,2,2),pdl(2,1,1,1,1),1,0,3,1,0,3)
 [
  [0 0 0]
  [0 2 2]
  [0 1 0]
 ]







=cut






*histogram2d = \&PDL::histogram2d;




=head2 whistogram2d

=for sig

  Signature: (ina(n); inb(n); float+ wt(n);float+[o] hist(ma,mb); double stepa; double mina; int masize => ma;
	             double stepb; double minb; int mbsize => mb;)


=for ref

Calculates a 2d histogram from weighted data.

=for usage

 $h = whistogram2d($datax, $datay, $weights,
       $stepx, $minx, $nbinx, $stepy, $miny, $nbiny);
 $hist = zeroes $nbinx, $nbiny;  # Put histogram in existing piddle.
 whistogram2d($datax, $datay, $weights, $hist,
       $stepx, $minx, $nbinx, $stepy, $miny, $nbiny);

The histogram will contain C<$nbinx> x C<$nbiny> bins, with the lower
limits of the first one at C<($minx, $miny)>, and with bin size
C<($stepx, $stepy)>. 
The value in each bin is the sum of the values in
C<$weights> that correspond to values in C<$datax> and C<$datay> that lie within the bin limits.

Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

=for example

 perldl> p whistogram2d(pdl(1,1,1,2,2),pdl(2,1,1,1,1),pdl(0.1,0.2,0.3,0.4,0.5),1,0,3,1,0,3)
 [
  [  0   0   0]
  [  0 0.5 0.9]
  [  0 0.1   0]
 ]







=cut






*whistogram2d = \&PDL::whistogram2d;




=head2 fibonacci

=for sig

  Signature: ([o]x(n))

=for ref

Constructor - a vector with Fibonacci's sequence



=cut




sub fibonacci { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->fibonacci : PDL->fibonacci(@_) }
sub PDL::fibonacci{
   my $class = shift;
   my $x = scalar(@_)? $class->new_from_specification(@_) : $class->new_or_inplace;
   &PDL::_fibonacci_int($x->clump(-1));
   return $x;
}







=head2 append

=for sig

  Signature: (a(n); b(m); [o] c(mn))

=for ref

append two or more piddles by concatenating along their first dimensions

=for example

 $a = ones(2,4,7);
 $b = sequence 5;
 $c = $a->append($b);  # size of $c is now (7,4,7) (a jumbo-piddle ;)

C<append> appends two piddles along their first dims. Rest of the dimensions
must be compatible in the threading sense. Resulting size of first dim is
the sum of the sizes of the first dims of the two argument piddles -
ie C<n + m>.





=cut






*append = \&PDL::append;



=head2 glue

=for usage

  $c = $a->glue(<dim>,$b,...)

=for ref

Glue two or more PDLs together along an arbitrary dimension 
(N-D L<append|append>).

Sticks $a, $b, and all following arguments together along the
specified dimension.  All other dimensions must be compatible in the 
threading sense.  

Glue is permissive, in the sense that every PDL is treated as having an
infinite number of trivial dimensions of order 1 -- so C<$a->glue(3,$b)>
works, even if $a and $b are only one dimensional.

If one of the PDLs has no elements, it is ignored.  Likewise, if one
of them is actually the undefined value, it is treated as if it had no
elements.

If the first parameter is a defined perl scalar rather than a pdl,
then it is taken as a dimension along which to glue everything else,
so you can say C<$cube = PDL::glue(3,@image_list);> if you like.

C<glue> is implemented in pdl, using a combination of L<xchg|xchg> and
L<append|append>.  It should probably be updated (one day) to a pure PP
function.

=cut

sub PDL::glue{
    my($a) = shift;
    my($dim) = shift;

    if(defined $a && !(ref $a)) {
	my $b = $dim;
	$dim = $a;
	$a = $b;
    }

    if(!defined $a || $a->nelem==0) {
	return $a unless(@_);
	return shift() if(@_<=1);
	$a=shift;
	return PDL::glue($a,$dim,@_);
    }

    if($dim - $a->dim(0) > 100) {
	print STDERR "warning:: PDL::glue allocating >100 dimensions!\n";
    }
    while($dim >= $a->ndims) {
	$a = $a->dummy(-1,1);
    }
    $a = $a->xchg(0,$dim);

    while(scalar(@_)){
	my $b = shift;
	next unless(defined $b && $b->nelem);

	while($dim >= $b->ndims) {
		$b = $b->dummy(-1,1);
        }
	$b = $b->xchg(0,$dim);
	$a = $a->append($b);
    }
    $a->xchg(0,$dim);
}
	
	
	





=head2 axisvalues

=for sig

  Signature: ([o,nc]a(n))


=for ref

Internal routine

C<axisvalues> is the internal primitive that implements 
L<axisvals|PDL::Basic/axisvals> 
and alters its argument.





=cut






*axisvalues = \&PDL::axisvalues;



=head2 random

=for ref

Constructor which returns piddle of random numbers

=for usage

 $a = random([type], $nx, $ny, $nz,...);
 $a = random $b;

etc (see L<zeroes|PDL::Core/zeroes>).

This is the uniform distribution between 0 and 1 (assumedly
excluding 1 itself). The arguments are the same as C<zeroes>
(q.v.) - i.e. one can specify dimensions, types or give
a template.

You can use the perl function L<srand|perlfunc/srand> to seed the random
generator. For further details consult Perl's  L<srand|perlfunc/srand>
documentation.

=head2 randsym

=for ref

Constructor which returns piddle of random numbers

=for usage

 $a = randsym([type], $nx, $ny, $nz,...);
 $a = randsym $b;

etc (see L<zeroes|PDL::Core/zeroes>).

This is the uniform distribution between 0 and 1 (excluding both 0 and
1, cf L<random|/random>). The arguments are the same as C<zeroes> (q.v.) -
i.e. one can specify dimensions, types or give a template.

You can use the perl function L<srand|perlfunc/srand> to seed the random
generator. For further details consult Perl's  L<srand|perlfunc/srand>
documentation.

=cut


sub random { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->random : PDL->random(@_) }
sub PDL::random {
   my $class = shift;
   my $x = scalar(@_)? $class->new_from_specification(@_) : $class->new_or_inplace;
   &PDL::_random_int($x);
   return $x;
}





sub randsym { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->randsym : PDL->randsym(@_) }
sub PDL::randsym {
   my $class = shift;
   my $x = scalar(@_)? $class->new_from_specification(@_) : $class->new_or_inplace;
   &PDL::_randsym_int($x);
   return $x;
}






=head2 grandom

=for ref

Constructor which returns piddle of Gaussian random numbers

=for usage

 $a = grandom([type], $nx, $ny, $nz,...);
 $a = grandom $b;

etc (see L<zeroes|PDL::Core/zeroes>).

This is generated using the math library routine C<ndtri>.

Mean = 0, Stddev = 1


You can use the perl function L<srand|perlfunc/srand> to seed the random
generator. For further details consult Perl's  L<srand|perlfunc/srand>
documentation.

=cut

sub grandom { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->grandom : PDL->grandom(@_) }
sub PDL::grandom {
   my $class = shift;
   my $x = scalar(@_)? $class->new_from_specification(@_) : $class->new_or_inplace;
   use PDL::Math 'ndtri';
   $x .= ndtri(randsym($x));
   return $x;
}





=head2 vsearch

=for sig

  Signature: (i(); x(n); int [o]ip())


=for ref

routine for searching 1D values i.e. step-function interpolation.

=for usage

 $inds = vsearch($vals, $xs);

Returns for each value of C<$vals> the index of the least larger member
of C<$xs> (which need to be in increasing order). If the value is larger
than any member of C<$xs>, the index to the last element of C<$xs> is 
returned.

=for example

This function is useful e.g. when you have a list of probabilities
for events and want to generate indices to events:

 $a = pdl(.01,.86,.93,1); # Barnsley IFS probabilities cumulatively
 $b = random 20;
 $c = vsearch($b, $a); # Now, $c will have the appropriate distr.

It is possible to use the L<cumusumover|PDL::Ufunc/cumusumover>
function to obtain cumulative probabilities from absolute probabilities.





=cut






*vsearch = \&PDL::vsearch;




=head2 interpolate

=for sig

  Signature: (xi(); x(n); y(n); [o] yi(); int [o] err())


=for ref

routine for 1D linear interpolation

=for usage

 ( $yi, $err ) = interpolate($xi, $x, $y)

Given a set of points C<($x,$y)>, use linear interpolation
to find the values C<$yi> at a set of points C<$xi>.

C<interpolate> uses a binary search to find the suspects, er...,
interpolation indices and therefore abscissas (ie C<$x>)
have to be I<strictly> ordered (increasing or decreasing). 
For interpolation at lots of
closely spaced abscissas an approach that uses the last index found as
a start for the next search can be faster (compare Numerical Recipes
C<hunt> routine). Feel free to implement that on top of the binary
search if you like. For out of bounds values it just does a linear
extrapolation and sets the corresponding element of C<$err> to 1,
which is otherwise 0.

See also L<interpol|/interpol>, which uses the same routine,
differing only in the handling of extrapolation - an error message
is printed rather than returning an error piddle.





=cut






*interpolate = \&PDL::interpolate;



=head2 interpol

=for sig

 Signature: (xi(); x(n); y(n); [o] yi())

=for ref

routine for 1D linear interpolation

=for usage

 $yi = interpol($xi, $x, $y)

C<interpol> uses the same search method as L<interpolate|/interpolate>,
hence C<$x> must be I<strictly> ordered (either increasing or decreasing).
The difference occurs in the handling of out-of-bounds values; here
an error message is printed.

=cut

# kept in for backwards compatability
sub interpol ($$$;$) {
    my $xi = shift;
    my $x  = shift;
    my $y  = shift;

    my $yi;
    if ( $#_ == 0 ) { $yi = $_[0]; }
    else            { $yi = PDL->null; }

    interpolate( $xi, $x, $y, $yi, my $err = PDL->null );
    print "some values had to be extrapolated\n"
	if any $err;

    return $yi if $#_ == -1;

} # sub: interpol()
*PDL::interpol = \&interpol;




=head2 interpND 

=for ref 

Interpolate values from an N-D piddle, with switchable method

=for example

  $source = 10*xvals(10,10) + yvals(10,10);
  $index = pdl([[2.2,3.5],[4.1,5.0]],[[6.0,7.4],[8,9]]);
  print $source->interpND( $index );

InterpND acts like L<indexND|PDL::Slices/indexND>,
collapsing C<$index> by lookup
into C<$source>; but it does interpolation rather than direct sampling.  
The interpolation method and boundary condition are switchable via 
an options hash. 

By default, linear or sample interpolation is used, with constant
value outside the boundaries of the source pdl.  No dataflow occurs,
because in general the output is computed rather than indexed.

All the interpolation methods treat the pixels as value-centered, so
the C<sample> method will return $a->(0) for coordinate values on 
the set [-0.5,0.5), and all methods will return $a->(1) for 
a coordinate value of exactly 1.


Recognized options:

=over 3

=item method 

Values can be:

=over 3 

=item * 0, s, sample, Sample (default for integer source types)

The nearest value is taken. Pixels are regarded as centered on their
respective integer coordinates (no offset from the linear case).

=item * 1, l, linear, Linear (default for floating point source types)

The values are N-linearly interpolated from an N-dimensional cube of size 2.

=item * 3, c, cube, cubic, Cubic

The values are interpolated using a local cubic fit to the data.  The
fit is constrained to match the original data and its derivative at the
data points.  The second derivative of the fit is not continuous at the 
data points.  Multidimensional datasets are interpolated by the 
successive-collapse method.

(Note that the constraint on the first derivative causes a small amount
of ringing around sudden features such as step functions).

=item * f, fft, fourier, Fourier

The source is Fourier transformed, and the interpolated values are
explicitly calculated from the coefficients.  The boundary condition
option is ignored -- periodic boundaries are imposed.

If you pass in the option "fft", and it is a list (ARRAY) ref, then it
is a stash for the magnitude and phase of the source FFT.  If the list
has two elements then they are taken as already computed; otherwise
they are calculated and put in the stash.

=back

=item b, bound, boundary, Boundary

This option is passed unmodified into L<indexND|PDL::Slices/indexND>, 
which is used as the indexing engine for the interpolation.
Some current allowed values are 'extend', 'periodic', 'truncate', and 'mirror'
(default is 'truncate').

=item bad

contains the fill value used for 'truncate' boundary.  (default 0)

=item fft

An array ref whose associated list is used to stash the FFT of the source
data, for the FFT method.

=back

=cut

*interpND = *PDL::interpND;
sub PDL::interpND {
  my $source = shift;
  my $index = shift;
  my $options = shift;

  barf 'Usage: interp_nd($source,$index,[{%options}])\n'
    if(defined $options   and    ref $options ne 'HASH');

  my($opt) = (defined $options) ? $options : {};

  my($method)   = $opt->{m} || $opt->{meth} || $opt->{method} || $opt->{Method};
  if(!defined $method) {
	$method = ($source->type <= zeroes(long,1)->type) ? 
	   	   'sample' : 
	           'linear';
  }

  my($boundary) = $opt->{b} || $opt->{boundary} || $opt->{Boundary} || $opt->{bound} || $opt->{Bound} || 'extend';
  my($bad) = $opt->{bad} || $opt->{Bad} || 0.0;

  if($method =~ m/^s(am(p(le)?)?)?/i) {
    return $source->range(PDL::Math::floor($index+0.5),0,$boundary);
  }

  elsif (($method eq 1) || $method =~ m/^l(in(ear)?)?/i) {
    ## key: (ith = index thread; cth = cube thread; sth = source thread)
    my $d = $index->dim(0);
    my $di = $index->ndims - 1;

    # Grab a 2-on-a-side n-cube around each desired pixel
    my $samp = $source->range($index->floor,2,$boundary); # (ith, cth, sth)

    # Reorder to put the cube dimensions in front and convert to a list
    $samp = $samp->reorder( $di .. $di+$d-1,
			    0 .. $di-1,
			    $di+$d .. $samp->ndims-1) # (cth, ith, sth)
                  ->clump($d); # (clst, ith, sth)

    # Enumerate the corners of an n-cube and convert to a list
    # (the 'x' is the normal perl repeat operator)
    my $crnr = PDL::Basic::ndcoords( (2) x $index->dim(0) ) # (index,cth)
             ->mv(0,-1)->clump($index->dim(0))->mv(-1,0); # (index, clst)

    # a & b are the weighting coefficients.
    my($a,$b);
    $index->where( 0 * $index ) .= -10; # Change NaN to invalid
    {
      my $bb = PDL::Math::floor($index);
      $a = ($index - $bb)     -> dummy(1,$crnr->dim(1)); # index, clst, ith
      $b = ($bb + 1 - $index) -> dummy(1,$crnr->dim(1)); # index, clst, ith
    }

    # Use 1/0 corners to select which multiplier happens, multiply
    # 'em all together to get sample weights, and sum to get the answer.
    my $out =  ( ($a * ($crnr==1) + $b * ($crnr==0)) #index, clst, ith
		 -> prodover                          #clst, ith
		 );

    $out = ($out * $samp)->sumover; # ith, sth

    return $out;

  } elsif(($method eq 3) || $method =~ m/^c(u(b(e|ic)?)?)?/i) {

      my ($d,@di) = $index->dims;
      my $di = $index->ndims - 1;
      
      # Grab a 4-on-a-side n-cube around each desired pixel
      my $samp = $source->range($index->floor - 1,4,$boundary) #ith, cth, sth
	  ->reorder( $di .. $di+$d-1, 0..$di-1, $di+$d .. $source->ndims-1 );
	                   # (cth, ith, sth)
      
      # Make a cube of the subpixel offsets, and expand its dims to 
      # a 4-on-a-side N-1 cube, to match the slices of $samp (used below).
      my $b = $index - $index->floor;
      for my $i(1..$d-1) {
	  $b = $b->dummy($i,4);
      }

      # Collapse by interpolation, one dimension at a time...
      for my $i(0..$d-1) {
	  my $a0 = $samp->slice("(1)");    # Just-under-sample
	  my $a1 = $samp->slice("(2)");    # Just-over-sample
	  my $a1a0 = $a1 - $a0;

	  my $gradient = 0.5 * ($samp->slice("2:3")-$samp->slice("0:1"));
	  my $s0 = $gradient->slice("(0)");   # Just-under-gradient
	  my $s1 = $gradient->slice("(1)");   # Just-over-gradient

	  $bb = $b->slice("($i)");

	  # Collapse the sample...
	  $samp = ( $a0 + 
		    $bb * (
			   $s0  +  
			   $bb * ( (3 * $a1a0 - 2*$s0 - $s1) +  
				   $bb * ( $s1 + $s0 - 2*$a1a0 ) 
				   )
			   )
		    );
	  
	  # "Collapse" the subpixel offset...
	  $b = $b->slice(":,($i)");
      }
      
      return $samp;

  } elsif($method =~ m/^f(ft|ourier)?/i) {

     eval "use PDL::FFT;";
     my $fftref = $opt->{fft};
     $fftref = [] unless(ref $fftref eq 'ARRAY');
     if(@$fftref != 2) {
	 my $a = $source->copy;
	 my $b = zeroes($source);
	 fftnd($a,$b);
	 $fftref->[0] = sqrt($a*$a+$b*$b) / $a->nelem;
	 $fftref->[1] = - atan2($b,$a);
     }

     my $i;
     my $c = PDL::Basic::ndcoords($source);               # (dim, source-dims)
     for $i(1..$index->ndims-1) {
	 $c = $c->dummy($i,$index->dim($i)) 
     }
     my $id = $index->ndims-1;
     my $phase = (($c * $index * 3.14159 * 2 / pdl($source->dims))
		  ->sumover) # (index-dims, source-dims)
 	          ->reorder($id..$id+$source->ndims-1,0..$id-1); # (src, index)

     my $phref = $fftref->[1]->copy;        # (source-dims)
     my $mag = $fftref->[0]->copy;          # (source-dims)

     for $i(1..$index->ndims-1) {
	 $phref = $phref->dummy(-1,$index->dim($i));
	 $mag = $mag->dummy(-1,$index->dim($i));
     }
     my $out = cos($phase + $phref ) * $mag;
     $out = $out->clump($source->ndims)->sumover;
     
     return $out;		
 }  else {
     barf("interpND: unknown method '$method'; valid ones are 'linear' and 'sample'.\n");
 }
}




=head2 one2nd

=for ref

Converts a one dimensional index piddle to a set of ND coordinates

=for usage

 @coords=one2nd($a, $indices)

returns an array of piddles containing the ND indexes corresponding to
the one dimensional list indices. The indices are assumed to correspond
to array C<$a> clumped using C<clump(-1)>. This routine is used in 
L<whichND|/whichND>,
but is useful on its own occasionally.

=for example

 perldl> $a=pdl [[[1,2],[-1,1]], [[0,-3],[3,2]]]; $c=$a->clump(-1)
 perldl> $maxind=maximum_ind($c); p $maxind;
 6
 perldl> print one2nd($a, maximum_ind($c))
 0 1 1
 perldl> p $a->at(0,1,1)
 3

=cut

*one2nd = \&PDL::one2nd;
sub PDL::one2nd {
  barf "Usage: one2nd \$array \$indices\n" if $#_ != 1;
  my ($a, $ind)=@_;
  my @dimension=$a->dims;
  my(@index);
  my $count=0;
  foreach (@dimension) {
    $index[$count++]=$ind % $_;
    $ind=long($ind/$_);
  }
  return @index;
}





=head2 which

=for sig

  Signature: (mask(n); int [o] inds(m))


=for ref

Returns indices of non-zero values from a 1-D PDL

=for usage

 $i = which($mask);

returns a pdl with indices for all those elements that are nonzero in
the mask. Note that the returned indices will be 1D. If you feed in a
multidimensional mask, it will be flattened before the indices are
calculated.  See also L<whichND|/whichND> for multidimensional masks.

If you want to index into the original mask or a similar piddle
with output from C<which>, remember to flatten it before calling index:

  $data = random 5, 5;
  $idx = which $data > 0.5; # $idx is now 1D
  $bigsum = $data->flat->index($idx)->sum;  # flatten before indexing

Compare also L<where|/where> for similar functionality.

SEE ALSO: 

L<which_both|/which_both> returns separately the indices of both
zero and nonzero values in the mask.

L<where|/where> returns associated values from a data PDL, rather than 
indices into the mask PDL.

L<whichND|/whichND> returns N-D indices into a multidimensional PDL.

=for example

 perldl> $x = sequence(10); p $x
 [0 1 2 3 4 5 6 7 8 9]
 perldl> $indx = which($x>6); p $indx
 [7 8 9]





=cut




   sub which { my ($this,$out) = @_;
		$this = $this->flat;
		$out = $this->nullcreate unless defined $out;
		PDL::_which_int($this,$out);
		return $out;
   }
   *PDL::which = \&which;


*which = \&PDL::which;




=head2 which_both

=for sig

  Signature: (mask(n); int [o] inds(m); int [o]notinds(q))


=for ref

Returns indices of zero and nonzero values in a mask PDL

=for usage

 ($i, $c_i) = which_both($mask);

This works just as L<which|/which>, but the complement of C<$i> will be in
C<$c_i>.

=for example

 perldl> $x = sequence(10); p $x
 [0 1 2 3 4 5 6 7 8 9]
 perldl> ($small, $big) = which_both ($x >= 5); p "$small\n $big"
 [5 6 7 8 9]
 [0 1 2 3 4]





=cut




   sub which_both { my ($this,$outi,$outni) = @_;
		$this = $this->flat;
		$outi = $this->nullcreate unless defined $outi;	
		$outni = $this->nullcreate unless defined $outni;
		PDL::_which_both_int($this,$outi,$outni);
		return wantarray ? ($outi,$outni) : $outi;
   }
   *PDL::which_both = \&which_both;


*which_both = \&PDL::which_both;


=head2 where

=for ref

Use a mask to select values from one or more data PDLs

C<where> accepts one or more data piddles and a mask piddle.  It
returns a list of output piddles, corresponding to the input data
piddles.  Each output piddle is a 1-dimensional list of values in its
corresponding data piddle. The values are drawn from locations where
the mask is nonzero.

The output PDLs are still connected to the original data PDLs, for the
purpose of dataflow.

C<where> combines the functionality of L<which|/which> and L<index|PDL::Slices/index>
into a single operation.

BUGS:

There is no C<whereND>, and probably should be.  While C<where> works
OK for most N-dimensional cases, it does not thread properly over (for
example) the (N+1)th dimension in data that is compared to an
N-dimensional mask.

=for usage

 $i = $x->where($x+5 > 0); # $i contains those elements of $x
                           # where mask ($x+5 > 0) is 1
 $i .= -5;  # Set those elements (of $x) to -5. Together, these
            # commands clamp $x to a maximum of -5. 

It is also possible to use the same mask for several piddles with
the same call:

 ($i,$j,$k) = where($x,$y,$z, $x+5>0);

Note: C<$i> is always 1-D, even if C<$x> is >1-D. 

WARNING: The first argument
(the values) and the second argument (the mask) currently have to have
the exact same dimensions (or horrible things happen). You *cannot*
thread over a smaller mask, for example.


=cut

sub PDL::where {
    barf "Usage: where( \$pdl1, ..., \$pdlN, \$mask )\n" if $#_ == 0;

    if($#_ == 1) {
	my($data,$mask) = @_;
	$data = $_[0]->clump(-1) if $_[0]->getndims>1;
	$mask = $_[1]->clump(-1) if $_[0]->getndims>1;
	return $data->index($mask->which());
    } else {
	if($_[-1]->getndims > 1) {
	    my $mask = $_[-1]->clump(-1)->which;
	    return map {$_->clump(-1)->index($mask)} @_[0..$#_-1];
	} else {
	    my $mask = $_[-1]->which;
	    return map {$_->index($mask)} @_[0..$#_-1];
	}
    }
}
*where = \&PDL::where;



=head2 whichND

=for ref

Return the coordinates of non-zero values in a mask. 

=for usage

WhichND returns the N-dimensional coordinates of each nonzero value in a
mask PDL with any number of dimensions. 

For historical reasons the return value is different in list and scalar
context.  In scalar context, you get back a PDL containing coordinates suitable
for use in L<indexND|PDL::Slices/indexND> or L<range|PDL::Slices/range>;
in list context, the coordinates are broken out into separate PDLs.

 $coords = whichND($mask);

returns a PDL containing the coordinates of the elements that are non-zero 
in C<$mask>, suitable for use in indexND.  The 0th dimension contains the
full coordinate listing of each point; the 1st dimension lists all the points.
For example, if $mask has rank 4 and 100 matching elements, then $coords has
dimension 4x100.

 @coords=whichND($mask);

returns a perl list of piddles containing the coordinates of the
elements that are non-zero in C<$mask>.  Each element corresponds to a
particular index dimension.  For example, if $mask has rank 4 and 100
matching elements, then @coords has 4 elements, each of which is a pdl
of size 100.

SEE ALSO:

L<which|/which> finds coordinates of nonzero values in a 1-D mask.

L<where|/where> extracts values from a data PDL that are associated 
with nonzero values in a mask PDL.

=for example

 perldl> $a=sequence(10,10,3,4)
 perldl> ($x, $y, $z, $w)=whichND($a == 203); p $x, $y, $z, $w
 [3] [0] [2] [0]
 perldl> print $a->at(list(cat($x,$y,$z,$w)))
 203

=cut

*whichND = \&PDL::whichND;
sub PDL::whichND {
  my $mask = shift;

  # List context: generate a perl list by dimension
  if(wantarray) {
	  my $ind=($mask->clump(-1))->which;
	  return $mask->one2nd($ind);
  } 

  # Scalar context: generate an N-D index piddle


  return null() unless ($mask->getndims);

  $ind = $mask->flat->which->dummy(0,$mask->getndims)->long->make_physical;

  my $mult = ones($mask->getndims)->long;
  my @mdims = $mask->dims;
  my $i;

  for $i(0..$#mdims-1) {
   # use $tmp for 5.005_03 compatibility
   (my $tmp = $mult->index($i+1)) .= $mult->index($i)*$mdims[$i];
  }

  for $i(0..$#mdims) {
   my($s) = $ind->index($i);
   $s /= $mult->index($i);
   $s %= $mdims[$i];
  }

  return $ind;
}




=head2 setops

=for ref

Implements simple set operations like union and intersection

=for usage

   Usage: $set = setops($a, <OPERATOR>, $b);

The operator can be C<OR>, C<XOR> or C<AND>. This is then applied
to C<$a> viewed as a set and C<$b> viewed as a set. The functioning
is as follows:

=over

=item C<OR>

The resulting vector will contain the elements that are either in C<$a>
I<or> in C<$b> or both. This is the union in set operation terms

=item C<XOR>

The resulting vector will contain the elements that are either in C<$a>
or C<$b>, but not in both. This is

     Union($a, $b) - Intersection($a, $b)

in set operation terms.

=item C<AND>

The resulting vector will contain the intersection of C<$a> and C<$b>, so
the elements that are in both C<$a> and C<$b>. Note that for convenience
this operation is also aliased to L<intersect|intersect>

=back

It should be emphasized that these routines are used when one or both of
the sets C<$a>, C<$b> are hard to calculate or that you get from a separate
subroutine.

Finally IDL users might be familiar with Craig Markwardt's C<cmset_op.pro>
routine which has inspired this routine although it was written independently
However the present routine has a few less options (but see the exampels)

=for example

You will very often use these functions on an index vector, so that is
what we will show here. We will in fact something slightly silly. First
we will find all squares that are also cubes below 10000.

Create a sequence vector:

  perldl> $x = sequence(10000)

Find all odd and even elements:

  perldl> ($even, $odd) = which_both( ($x % 2) == 0)

Find all squares

  perldl> $squares= which(ceil(sqrt($x)) == floor(sqrt($x)))

Find all cubes (being careful with roundoff error!)

  perldl> $cubes= which(ceil($x**(1.0/3.0)) == floor($x**(1.0/3.0)+1e-6))

Then find all squares that are cubes:

  perldl> $both = setops($squares, 'AND', $cubes)

And print these (assumes that C<PDL::NiceSlice> is loaded!)

  perldl> p $x($both)
   [0 1 64 729 4096]

Then find all numbers that are either cubes or squares, but not both:

  perldl> $cube_xor_square = setops($squares, 'XOR', $cubes)

  perldl> p $cube_xor_square->nelem()
   112

So there are a total of 112 of these!

Finally find all odd squares:

  perldl> $odd_squares = setops($squares, 'AND', $odd)


Another common occurance is to want to get all objects that are
in C<$a> and in the complement of C<$b>. But it is almost always best
to create the complement explicitly since the universe that both are
taken from is not known. Thus use L<which_both|which_both> if possible
to keep track of complements.

If this is impossible the best approach is to make a temporary:

This creates an index vector the size of the universe of the sets and
set all elements in C<$b> to 0

  perldl> $tmp = ones($n_universe); $tmp($b)=0;

This then finds the complement of C<$b>

  perldl> $C_b = which($tmp == 1);

and this does the final selection:

  perldl> $set = setops($a, 'AND', $C_b)

=cut

*setops = \&PDL::setops;

sub PDL::setops {

  my ($a, $op, $b)=@_;

  # Check that $a and $b are 1D.
  if ($a->ndims() > 1 || $b->ndims() > 1) {
     warn 'setops: $a and $b must be 1D - flattening them!'."\n";
     $a = $a->flat;
     $b = $b->flat;
  }

  my $result;

  if ($op eq 'OR') {
    # Easy...
    $result = uniq(cat($a, $b));
  } elsif ($op eq 'XOR') {
    # Make ordered list of set union.
    my $union = append($a, $b)->qsort;
    # Index lists.
    my $s1=zeroes(byte, $union->nelem());
    my $s2=zeroes(byte, $union->nelem());

    # Find indices which are duplicated - these are to be excluded
    #
    # We do this by comparing x with x shifted each way.
    my $i1 = which($union != rotate($union, 1));
    my $i2 = which($union != rotate($union, -1));
    #
    # We then mark/mask these in the s1 and s2 arrays to indicate which ones
    # are not equal to their neighbours.
    #
    $s1->index($i1) .= 1 if $i1->nelem() > 0;
    $s2->index($i2) .= 1 if $i2->nelem() > 0;

    my $inds=which($s1 == $s2);

    if ($inds->nelem() > 0) {
      return $union->index($inds);
    } else {
      return $inds;
    }

  } elsif ($op eq 'AND') {
    # The intersection of the arrays.

    # Make ordered list of set union.
    my $union = append($a, $b)->qsort;

    return $union->where($union == rotate($union, -1));
  } else {
    print "The operation $op is not known!";
    return -1;
  }

}



=head2 intersect

=for ref

Calculate the intersection of two piddles

=for usage

   Usage: $set = intersect($a, $b);

This routine is merely a simple interface to L<setops|setops>. See
that for more information

=for example

Find all numbers less that 100 that are of the form 2*y and 3*x

perldl> $x=sequence(100)

perldl> $factor2 = which( ($x % 2) == 0)

perldl> $factor3 = which( ($x % 3) == 0)

perldl> $ii=intersect($factor2, $factor3)

perldl> p $x($ii)

   [0 6 12 18 24 30 36 42 48 54 60 66 72 78 84 90 96]

=cut

*intersect = \&PDL::intersect;

sub PDL::intersect {

   return setops($_[0], 'AND', $_[1]);

}



;


=head1 AUTHOR

Copyright (C) Tuomas J. Lukka 1997 (lukka@husc.harvard.edu). Contributions
by Christian Soeller (c.soeller@auckland.ac.nz), Karl Glazebrook
(kgb@aaoepp.aao.gov.au), Craig DeForest (deforest@boulder.swri.edu)
and Jarle Brinchmann (jarle@astro.up.pt)
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.

=cut





# Exit with OK status

1;

		   