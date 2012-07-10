
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Ufunc;

@EXPORT_OK  = qw( PDL::PP prodover PDL::PP dprodover PDL::PP cumuprodover PDL::PP dcumuprodover PDL::PP sumover PDL::PP dsumover PDL::PP cumusumover PDL::PP dcumusumover PDL::PP orover PDL::PP bandover PDL::PP borover PDL::PP zcover PDL::PP andover PDL::PP intover PDL::PP average PDL::PP daverage PDL::PP medover PDL::PP oddmedover PDL::PP pctover PDL::PP oddpctover  pct  oddpct  avg  sum  prod  davg  dsum  dprod  zcheck  and  band  or  bor  min  max  median  oddmedian  any all  minmax PDL::PP qsort PDL::PP qsorti PDL::PP qsortvec PDL::PP minimum PDL::PP minimum_ind PDL::PP minimum_n_ind PDL::PP maximum PDL::PP maximum_ind PDL::PP maximum_n_ind PDL::PP minmaximum );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Ufunc ;





=head1 NAME

PDL::Ufunc - primitive ufunc operations for pdl

=head1 DESCRIPTION

This module provides some primitive and useful functions defined
using PDL::PP based on functionality of what are sometimes called
I<ufuncs> (for example NumPY and Mathematica talk about these).
It collects all the functions generally used to C<reduce> or
C<accumulate> along a dimension. These all do their job across the
first dimension but by using the slicing functions you can do it
on any dimension.

The L<PDL::Reduce|PDL::Reduce> module provides an alternative interface
to many of the functions in this module.

=head1 SYNOPSIS

 use PDL::Ufunc;

=cut

use PDL::Slices;
use Carp;







=head1 FUNCTIONS



=cut






=head2 prodover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via product to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the product along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = prodover($b);

=for example

 $spectrum = prodover $image->xchg(0,1)







=cut






*prodover = \&PDL::prodover;




=head2 dprodover

=for sig

  Signature: (a(n); double [o]b())


=for ref

Project via product to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the product along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = dprodover($b);

=for example

 $spectrum = dprodover $image->xchg(0,1)

Unlike L<prodover|/prodover>, the calculations are performed in double
precision.





=cut






*dprodover = \&PDL::dprodover;




=head2 cumuprodover

=for sig

  Signature: (a(n); int+ [o]b(n))


=for ref

Cumulative product

This function calculates the cumulative product
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative product
is the first element of the parameter.

=for usage

 $a = cumuprodover($b);

=for example

 $spectrum = cumuprodover $image->xchg(0,1)







=cut






*cumuprodover = \&PDL::cumuprodover;




=head2 dcumuprodover

=for sig

  Signature: (a(n); double [o]b(n))


=for ref

Cumulative product

This function calculates the cumulative product
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative product
is the first element of the parameter.

=for usage

 $a = cumuprodover($b);

=for example

 $spectrum = cumuprodover $image->xchg(0,1)

Unlike L<cumuprodover|/cumuprodover>, the calculations are performed in double
precision.





=cut






*dcumuprodover = \&PDL::dcumuprodover;




=head2 sumover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via sum to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the sum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = sumover($b);

=for example

 $spectrum = sumover $image->xchg(0,1)







=cut






*sumover = \&PDL::sumover;




=head2 dsumover

=for sig

  Signature: (a(n); double [o]b())


=for ref

Project via sum to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the sum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = dsumover($b);

=for example

 $spectrum = dsumover $image->xchg(0,1)

Unlike L<sumover|/sumover>, the calculations are performed in double
precision.





=cut






*dsumover = \&PDL::dsumover;




=head2 cumusumover

=for sig

  Signature: (a(n); int+ [o]b(n))


=for ref

Cumulative sum

This function calculates the cumulative sum
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative sum
is the first element of the parameter.

=for usage

 $a = cumusumover($b);

=for example

 $spectrum = cumusumover $image->xchg(0,1)







=cut






*cumusumover = \&PDL::cumusumover;




=head2 dcumusumover

=for sig

  Signature: (a(n); double [o]b(n))


=for ref

Cumulative sum

This function calculates the cumulative sum
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative sum
is the first element of the parameter.

=for usage

 $a = cumusumover($b);

=for example

 $spectrum = cumusumover $image->xchg(0,1)

Unlike L<cumusumover|/cumusumover>, the calculations are performed in double
precision.





=cut






*dcumusumover = \&PDL::dcumusumover;




=head2 orover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via or to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the or along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = orover($b);

=for example

 $spectrum = orover $image->xchg(0,1)







=cut






*orover = \&PDL::orover;




=head2 bandover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via bitwise and to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the bitwise and along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = bandover($b);

=for example

 $spectrum = bandover $image->xchg(0,1)







=cut






*bandover = \&PDL::bandover;




=head2 borover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via bitwise or to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the bitwise or along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = borover($b);

=for example

 $spectrum = borover $image->xchg(0,1)







=cut






*borover = \&PDL::borover;




=head2 zcover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via == 0 to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the == 0 along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = zcover($b);

=for example

 $spectrum = zcover $image->xchg(0,1)







=cut






*zcover = \&PDL::zcover;




=head2 andover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via and to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the and along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = andover($b);

=for example

 $spectrum = andover $image->xchg(0,1)







=cut






*andover = \&PDL::andover;




=head2 intover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via integral to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the integral along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = intover($b);

=for example

 $spectrum = intover $image->xchg(0,1)

Notes:

For C<n E<gt> 3>, these are all C<O(h^4)> (like Simpson's rule), but are
integrals between the end points assuming the pdl gives values just at
these centres: for such `functions', sumover is correct to C<O(h)>, but
is the natural (and correct) choice for binned data, of course.






=cut






*intover = \&PDL::intover;




=head2 average

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via average to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the average along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = average($b);

=for example

 $spectrum = average $image->xchg(0,1)







=cut






*average = \&PDL::average;




=head2 daverage

=for sig

  Signature: (a(n); double [o]b())


=for ref

Project via average to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the average along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = daverage($b);

=for example

 $spectrum = daverage $image->xchg(0,1)

Unlike L<average|/average>, the calculation is performed in double
precision.





=cut






*daverage = \&PDL::daverage;




=head2 medover

=for sig

  Signature: (a(n); [o]b(); [t]tmp(n))


=for ref

Project via median to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the median along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = medover($b);

=for example

 $spectrum = medover $image->xchg(0,1)







=cut






*medover = \&PDL::medover;




=head2 oddmedover

=for sig

  Signature: (a(n); [o]b(); [t]tmp(n))


=for ref

Project via oddmedian to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the oddmedian along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = oddmedover($b);

=for example

 $spectrum = oddmedover $image->xchg(0,1)



The median is sometimes not a good choice as if the array has
an even number of elements it lies half-way between the two
middle values - thus it does not always correspond to a data
value. The lower-odd median is just the lower of these two values
and so it ALWAYS sits on an actual data value which is useful in
some circumstances.
	





=cut






*oddmedover = \&PDL::oddmedover;




=head2 pctover

=for sig

  Signature: (a(n); p(); [o]b(); [t]tmp(n))



Project via percentile to N-1 dimensions

This function reduces the dimensionality of a piddle by one by finding
the specified percentile (p) along the 1st dimension.  The specified
percentile must be between 0.0 and 1.0.  When the specified percentile
falls between data points, the result is interpolated.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = pctover($b, $p);

=for example

 $spectrum = pctover $image->xchg(0,1) $p





=cut






*pctover = \&PDL::pctover;




=head2 oddpctover

=for sig

  Signature: (a(n); p(); [o]b(); [t]tmp(n))



Project via percentile to N-1 dimensions

This function reduces the dimensionality of a piddle by one by finding
the specified percentile along the 1st dimension.  The specified
percentile must be between 0.0 and 1.0.  When the specified percentile
falls between two values, the nearest data value is the result.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = oddpctover($b, $p);

=for example

 $spectrum = oddpctover $image->xchg(0,1) $p





=cut






*oddpctover = \&PDL::oddpctover;



=head2 pct

=for ref

Return the specified percentile of all elements in a piddle. The
specified percentile (p) must be between 0.0 and 1.0.  When the
specified percentile falls between data points, the result is
interpolated.

=for usage

 $x = pct($data, $pct);

=cut

*pct = \&PDL::pct;
sub PDL::pct {
	my($x, $p) = @_; 
    my $tmp;
	$x->clump(-1)->pctover($p, $tmp=PDL->nullcreate($x));
	return $tmp->at();
}




=head2 oddpct

=for ref

Return the specified percentile of all elements in a piddle. The
specified percentile must be between 0.0 and 1.0.  When the specified
percentile falls between two values, the nearest data value is the
result.

=for usage

 $x = oddpct($data, $pct);

=cut

*oddpct = \&PDL::oddpct;
sub PDL::oddpct {
	my($x, $p) = @_; 
    my $tmp;
	$x->clump(-1)->oddpctover($p, $tmp=PDL->nullcreate($x));
	return $tmp->at();
}




=head2 avg

=for ref

Return the average of all elements in a piddle

=for usage

 $x = avg($data);



=cut

*avg = \&PDL::avg;
sub PDL::avg {
	my($x) = @_; my $tmp;
	$x->clump(-1)->average( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 sum

=for ref

Return the sum of all elements in a piddle

=for usage

 $x = sum($data);



=cut

*sum = \&PDL::sum;
sub PDL::sum {
	my($x) = @_; my $tmp;
	$x->clump(-1)->sumover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 prod

=for ref

Return the product of all elements in a piddle

=for usage

 $x = prod($data);



=cut

*prod = \&PDL::prod;
sub PDL::prod {
	my($x) = @_; my $tmp;
	$x->clump(-1)->prodover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 davg

=for ref

Return the average (in double precision) of all elements in a piddle

=for usage

 $x = davg($data);



=cut

*davg = \&PDL::davg;
sub PDL::davg {
	my($x) = @_; my $tmp;
	$x->clump(-1)->daverage( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 dsum

=for ref

Return the sum (in double precision) of all elements in a piddle

=for usage

 $x = dsum($data);



=cut

*dsum = \&PDL::dsum;
sub PDL::dsum {
	my($x) = @_; my $tmp;
	$x->clump(-1)->dsumover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 dprod

=for ref

Return the product (in double precision) of all elements in a piddle

=for usage

 $x = dprod($data);



=cut

*dprod = \&PDL::dprod;
sub PDL::dprod {
	my($x) = @_; my $tmp;
	$x->clump(-1)->dprodover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 zcheck

=for ref

Return the check for zero of all elements in a piddle

=for usage

 $x = zcheck($data);



=cut

*zcheck = \&PDL::zcheck;
sub PDL::zcheck {
	my($x) = @_; my $tmp;
	$x->clump(-1)->zcover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 and

=for ref

Return the logical and of all elements in a piddle

=for usage

 $x = and($data);



=cut

*and = \&PDL::and;
sub PDL::and {
	my($x) = @_; my $tmp;
	$x->clump(-1)->andover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 band

=for ref

Return the bitwise and of all elements in a piddle

=for usage

 $x = band($data);



=cut

*band = \&PDL::band;
sub PDL::band {
	my($x) = @_; my $tmp;
	$x->clump(-1)->bandover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 or

=for ref

Return the logical or of all elements in a piddle

=for usage

 $x = or($data);



=cut

*or = \&PDL::or;
sub PDL::or {
	my($x) = @_; my $tmp;
	$x->clump(-1)->orover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 bor

=for ref

Return the bitwise or of all elements in a piddle

=for usage

 $x = bor($data);



=cut

*bor = \&PDL::bor;
sub PDL::bor {
	my($x) = @_; my $tmp;
	$x->clump(-1)->borover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 min

=for ref

Return the minimum of all elements in a piddle

=for usage

 $x = min($data);



=cut

*min = \&PDL::min;
sub PDL::min {
	my($x) = @_; my $tmp;
	$x->clump(-1)->minimum( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 max

=for ref

Return the maximum of all elements in a piddle

=for usage

 $x = max($data);



=cut

*max = \&PDL::max;
sub PDL::max {
	my($x) = @_; my $tmp;
	$x->clump(-1)->maximum( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 median

=for ref

Return the median of all elements in a piddle

=for usage

 $x = median($data);



=cut

*median = \&PDL::median;
sub PDL::median {
	my($x) = @_; my $tmp;
	$x->clump(-1)->medover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 oddmedian

=for ref

Return the oddmedian of all elements in a piddle

=for usage

 $x = oddmedian($data);



=cut

*oddmedian = \&PDL::oddmedian;
sub PDL::oddmedian {
	my($x) = @_; my $tmp;
	$x->clump(-1)->oddmedover( $tmp=PDL->nullcreate($x) );
	return $tmp->at();
}



=head2 any

=for ref

Return true if any element in piddle set

Useful in conditional expressions:

=for example

 if (any $a>15) { print "some values are greater than 15\n" }



=cut

*any = \&or;
*PDL::any = \&PDL::or;

=head2 all

=for ref

Return true if all elements in piddle set

Useful in conditional expressions:

=for example

 if (all $a>15) { print "all values are greater than 15\n" }



=cut

*all = \&and;
*PDL::all = \&PDL::and;




=head2 minmax

=for ref

Returns an array with minimum and maximum values of a piddle.

=for usage

 ($mn, $mx) = minmax($pdl);

This routine does I<not> thread over the dimensions of C<$pdl>; 
it returns the minimum and maximum values of the whole array.
See L<minmaximum|/minmaximum> if this is not what is required.
The two values are returned as Perl scalars similar to min/max.

=for example

 perldl> $x = pdl [1,-2,3,5,0]
 perldl> ($min, $max) = minmax($x);
 perldl> p "$min $max\n";
 -2 5

=cut

*minmax = \&PDL::minmax;
sub PDL::minmax {
  my ($x)=@_; my $tmp;
  my @arr = $x->clump(-1)->minmaximum;
  return map {$_->sclr} @arr[0,1]; # return as scalars !
}





=head2 qsort

=for sig

  Signature: (a(n); [o]b(n))


=for ref

Quicksort a vector into ascending order.

=for example

 print qsort random(10);





=cut






*qsort = \&PDL::qsort;




=head2 qsorti

=for sig

  Signature: (a(n); int [o]indx(n))


=for ref

Quicksort a vector and return index of elements in ascending order.

=for example

 $ix = qsorti $a;
 print $a->index($ix); # Sorted list





=cut






*qsorti = \&PDL::qsorti;




=head2 qsortvec

=for sig

  Signature: (a(n,m); [o]b(n,m))


=for ref

Sort a list of vectors lexicographically.

The 0th dimension of the source piddle is dimension in the vector;
the 1st dimension is list order.  Higher dimensions are threaded over.

=for example

 print qsortvec pdl([[1,2],[0,500],[2,3],[4,2],[3,4],[3,5]]);
 [
  [  0 500]
  [  1   2]
  [  2   3]
  [  3   4]
  [  3   5]
  [  4   2]
 ]
 





=cut






*qsortvec = \&PDL::qsortvec;




=head2 minimum

=for sig

  Signature: (a(n); [o]c())


=for ref

Project via minimum to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the minimum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = minimum($b);

=for example

 $spectrum = minimum $image->xchg(0,1)







=cut






*minimum = \&PDL::minimum;




=head2 minimum_ind

=for sig

  Signature: (a(n); int [o] c())

=for ref

Like minimum but returns the index rather than the value



=cut






*minimum_ind = \&PDL::minimum_ind;




=head2 minimum_n_ind

=for sig

  Signature: (a(n); int[o]c(m))

=for ref

Returns the index of C<m> minimum elements



=cut






*minimum_n_ind = \&PDL::minimum_n_ind;




=head2 maximum

=for sig

  Signature: (a(n); [o]c())


=for ref

Project via maximum to N-1 dimensions

This function reduces the dimensionality of a piddle
by one by taking the maximum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $a = maximum($b);

=for example

 $spectrum = maximum $image->xchg(0,1)







=cut






*maximum = \&PDL::maximum;




=head2 maximum_ind

=for sig

  Signature: (a(n); int [o] c())

=for ref

Like maximum but returns the index rather than the value



=cut






*maximum_ind = \&PDL::maximum_ind;




=head2 maximum_n_ind

=for sig

  Signature: (a(n); int[o]c(m))

=for ref

Returns the index of C<m> maximum elements



=cut






*maximum_n_ind = \&PDL::maximum_n_ind;




=head2 minmaximum

=for sig

  Signature: (a(n); [o]cmin(); [o] cmax(); int [o]cmin_ind(); int [o]cmax_ind())


=for ref

Find minimum and maximum and their indices for a given piddle;

=for usage

 perldl> $a=pdl [[-2,3,4],[1,0,3]]
 perldl> ($min, $max, $min_ind, $max_ind)=minmaximum($a)
 perldl> p $min, $max, $min_ind, $max_ind
 [-2 0] [4 3] [0 1] [2 2]

See also L<minmax|/minmax>, which clumps the piddle together.





=cut






*minmaximum = \&PDL::minmaximum;


;


=head1 AUTHOR

Copyright (C) Tuomas J. Lukka 1997 (lukka@husc.harvard.edu).
Contributions by Christian Soeller (c.soeller@auckland.ac.nz)
and Karl Glazebrook (kgb@aaoepp.aao.gov.au).  All rights
reserved. There is no warranty. You are allowed to redistribute this
software / documentation under certain conditions. For details, see
the file COPYING in the PDL distribution. If this file is separated
from the PDL distribution, the copyright notice should be included in
the file.

=cut





# Exit with OK status

1;

		   