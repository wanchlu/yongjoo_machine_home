
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Slices;

@EXPORT_OK  = qw( PDL::PP affineinternal PDL::PP s_identity PDL::PP index PDL::PP index2d  indexND indexNDb PDL::PP rangeb PDL::PP rld PDL::PP rle PDL::PP flowconvert PDL::PP converttypei PDL::PP _clump_int PDL::PP xchg PDL::PP mv PDL::PP oneslice PDL::PP slice  using PDL::PP affine PDL::PP diagonalI PDL::PP lags PDL::PP splitdim PDL::PP rotate PDL::PP threadI PDL::PP identvaff PDL::PP unthread  dice dice_axis );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Slices ;





=head1 NAME

PDL::Slices -- Indexing, slicing, and dicing

=head1 SYNOPSIS

  use PDL;
  $a = ones(3,3);
  $b = $a->slice('-1:0,(1)');
  $c = $a->dummy(2);


=head1 DESCRIPTION

This package provides many of the powerful PerlDL core index
manipulation routines.  These routines mostly allow two-way data flow,
so you can modify your data in the most convenient representation.
For example, you can make a 1000x1000 unit matrix with 

 $a = zeroes(1000,1000);
 $a->diagonal(0,1) ++;

which is quite efficient. See L<PDL::Indexing> and L<PDL::Tips> for
more examples.  

Slicing is so central to the PDL language that a special compile-time
syntax has been introduced to handle it compactly; see L<PDL::NiceSlice> 
for details.

PDL indexing and slicing functions usually include two-way data flow, 
so that you can separate the actions of reshaping your data structures
and modifying the data themselves.  Two special methods, L<copy|copy> and
L<sever|sever>, help you control the data flow connection between related 
variables.

 $b = $a->slice("1:3"); # Slice maintains a link between $a and $b.
 $b += 5;   		# $a is changed!

If you want to force a physical copy and no data flow, you can copy or
sever the slice expression:

 $b = $a->slice("1:3")->copy;
 $b += 5;		# $a is not changed.

 $b = $a->slice("1:3")->sever;
 $b += 5;               # $a is not changed.

The difference between C<sever> and C<copy> is that sever acts on (and
returns) its argument, while copy produces a disconnected copy.  If you
say

 $b = $a->slice("1:3");
 $c = $b->sever;

then the variables C<$b> and C<$c> point to the same object but with 
C<-E<gt>copy> they would not.

=head1 BUGS 

For the moment, you can't slice the empty piddle.  This should probably
change:  slices of the empty piddle should probably return the empty piddle.

Many types of index errors are reported far from the indexing
operation that caused them.  This is caused by the underlying architecture:
slice() sets up a mapping between variables, but that mapping isn't 
tested for correctness until it is used (potentially much later).

=cut

use PDL::Core ':Internal';







=head1 FUNCTIONS



=cut






*affineinternal = \&PDL::affineinternal;




=head2 s_identity

=for sig

  Signature: (P(); C())

=for ref

Internal vaffine identity function.





=cut






*s_identity = \&PDL::s_identity;




=head2 index

=for sig

  Signature: (a(n); int ind(); [oca] c())

=for ref

C<index> and C<index2d> provide rudimentary index indirection.

=for example

 $c = index($source,$ind);
 $c = index2d($source2,$ind1,$ind2);

use the C<$ind> variables as indices to look up values in C<$source>.  
C<index2d> uses separate piddles for X and Y coordinates.  For more
general N-dimensional indexing, see L<PDL::Slices> or the L<PDL::NiceSlice>
syntax.

These functions are two-way, i.e. after

 $c = $a->index(pdl[0,5,8]);
 $c .= pdl [0,2,4];

the changes in C<$c> will flow back to C<$a>.

C<index> provids simple threading:  multiple-dimensioned arrays are treated
as collections of 1-D arrays, so that

 $a = xvals(10,10)+10*yvals(10,10);
 $b = $a->index(3);
 $c = $a->index(9-xvals(10));

puts a single column from C<$a> into C<$b>, and puts a single element
from each column of C<$a> into C<$c>.  If you want to extract multiple
columns from an array in one operation, see L<dice|/dice> or
L<indexND|/indexND>.





=cut






*index = \&PDL::index;




=head2 index2d

=for sig

  Signature: (a(na,nb); int inda(); int indb(); [oca] c())

=for ref

C<index> and C<index2d> provide rudimentary index indirection.

=for example

 $c = index($source,$ind);
 $c = index2d($source2,$ind1,$ind2);

use the C<$ind> variables as indices to look up values in C<$source>.  
C<index2d> uses separate piddles for X and Y coordinates.  For more
general N-dimensional indexing, see L<PDL::Slices> or the L<PDL::NiceSlice>
syntax.

These functions are two-way, i.e. after

 $c = $a->index(pdl[0,5,8]);
 $c .= pdl [0,2,4];

the changes in C<$c> will flow back to C<$a>.

C<index> provids simple threading:  multiple-dimensioned arrays are treated
as collections of 1-D arrays, so that

 $a = xvals(10,10)+10*yvals(10,10);
 $b = $a->index(3);
 $c = $a->index(9-xvals(10));

puts a single column from C<$a> into C<$b>, and puts a single element
from each column of C<$a> into C<$c>.  If you want to extract multiple
columns from an array in one operation, see L<dice|/dice> or
L<indexND|/indexND>.





=cut






*index2d = \&PDL::index2d;



=head2 indexNDb

=for ref 

  Backwards-compatibility alias for indexND

=head2 indexND

=for ref

  Find selected elements in an N-D piddle, with optional boundary handling

=for example

  $out = $source->indexND( $index, [$method] )

  $source = 10*xvals(10,10) + yvals(10,10);
  $index  = pdl([[2,3],[4,5]],[[6,7],[8,9]]);
  print $source->indexND( $index );

  [
   [23 45]
   [67 89]
  ]

IndexND collapses C<$index> by lookup into C<$source>.  The 
0th dimension of C<$index> is treated as coordinates in C<$source>, and 
the return value has the same dimensions as the rest of C<$index>.
The returned elements are looked up from C<$source>.  Dataflow
works -- propagated assignment flows back into C<$source>.  

IndexND and IndexNDb were originally separate routines but they are both
now implemented as a call to L<range|/range>, and have identical syntax to
one another.

=cut

sub PDL::indexND {
	my($source,$index, $boundary) = @_;
	return PDL::range($source,$index,undef,$boundary);
}

*PDL::indexNDb = \&PDL::indexND;




sub PDL::range {
  my($source,$ind,$sz,$bound) = @_;
  my $index = PDL->pdl($ind);
  $index = $index->dummy(0,1) unless $index->ndims;
  my $size = defined($sz) ? PDL->pdl($sz) : undef;

	
  # Pack boundary string if necessary
  if(defined $bound) {
    if(ref $bound eq 'ARRAY') {
      my ($s,$el);
      foreach $el(@$bound) {
	barf "Illegal boundary value '$el' in range"
  	  unless( $el =~ m/^([0123fFtTeEpPmM])/ );
	$s .= $1;
      }
      $bound = $s;
    }
    elsif($bound !~ m/^[0123ftepx]+$/  && $bound =~ m/^([0123ftepx])/i ) {
      $bound = $1;
    }
  }

  no warnings; # shut up about passing undef into rangeb
  $source->rangeb($index,$size,$bound);
}




=head2 rangeb

=for sig

  Signature: (P(); C(); SV *index; SV *size; SV *boundary)

=for ref

Engine for L<range|/range>

=for example

Same calling convention as L<range|/range>, but you must supply all
parameters.  C<rangeb> is marginally faster as it makes a direct PP call,
avoiding the perl argument-parsing step. 


=head2 range

=for ref 

Extract selected chunks from a source piddle, with boundary conditions

=for example

	$out = $source->range($index,[$size,[$boundary]])

Returns elements or rectangular slices of the original piddle, indexed by 
the C<$index> piddle.  C<$source> is an N-dimensional piddle, and C<$index> is 
a piddle whose first dimension has order up to N.  Each row of C<$index> is 
treated as coordinates of a single value or chunk from C<$source>, specifying 
the location(s) to extract.  

If you specify a single index location, then range is essentially an expensive
slice, with controllable boundary conditions.

B<INPUTS>

C<$index> and C<$size> can be piddles or array refs such as you would
feed to L<zeroes|PDL::Core/zeroes> and its ilk.  If C<$index>'s 0th dimension
has order higher than the number of dimensions in C<$source>, then
C<$source> is treated as though it had trivial dummy dimensions of
order 1, up to the required size to be indexed by C<$index> -- so if
your source array is 1-D and your index array is a list of 3-vectors, 
you get two dummy dimensions of order 1 on the end of your source array.

You can extract single elements or N-D rectangular ranges from C<$source>,
by setting C<$size>.  If C<$size> is undef or zero, then you get a single
sample for each row of C<$index>.  This behavior is similar to 
L<indexNDb|/indexNDb>, which is in fact implemented as a call to L<range|/range>.

If C<$size> is positive then you get a range of values from C<$source> at 
each location, and the output has extra dimensions allocated for them.
C<$size> can be a scalar, in which case it applies to all dimensions, or an 
N-vector, in which case each element is applied independently to the 
corresponding dimension in C<$source>.  See below for details.

C<$boundary> is a number, string, or list ref indicating the type of 
boundary conditions to use when ranges reach the edge of C<$source>.  If you
specify no boundary conditions the default is to forbid boundary violations
on all axes.  If you specify exactly one boundary condition, it applies to 
all axes.  If you specify more (as elements of a list ref, or as a packed
string, see below), then they apply to dimensions in the order in which they
appear, and the last one applies to all subsequent dimensions.  (This is 
less difficult than it sounds; see the examples below).

=over 3

=item 0 (synonyms: 'f','forbid') B<(default)>

Ranges are not allowed to cross the boundary of the original PDL.  Disallowed
ranges throw an error.  The errors are thrown at evaluation time, not
at the time of the range call (this is the same behavior as L<slice|/slice>).

=item 1 (synonyms: 't','truncate')

Values outside the original piddle get BAD if you've got bad value
support compiled into your PDL and set the badflag for the source PDL;
or 0 if you haven't (you must set the badflag if you want BADs for out
of bound values, otherwise you get 0).  Reverse dataflow works OK for
the portion of the child that is in-bounds.  The out-of-bounds part of
the child is reset to (BAD|0) during each dataflow operation, but
execution continues.

=item 2 (synonyms: 'e','x','extend')

Values that would be outside the original piddle point instead to the 
nearest allowed value within the piddle.  See the CAVEAT below on 
mappings that are not single valued.

=item 3 (synonyms: 'p','periodic')

Periodic boundary conditions apply: the numbers in $index are applied,
strict-modulo the corresponding dimensions of $source.  This is equivalent to
duplicating the $source piddle throughout N-D space.  See the CAVEAT below 
about mappings that are not single valued.

=item 4 (synonyms: 'm','mirror')

Mirror-reflection periodic boundary conditions apply.  See the CAVEAT
below about mappings that are not single valued.

=back

The boundary condition identifiers all begin with unique characters, so 
you can feed in multiple boundary conditions as either a list ref or a 
packed string.  (The packed string is marginally faster to run).  For 
example, the four expressions [0,1], ['forbid','truncate'], ['f','t'], 
and 'ft' all specify that violating the boundary in the 0th dimension 
throws an error, and all other dimensions get truncated.  

If you feed in a single string, it is interpreted as a packed boundary
array if all of its characters are valid boundary specifiers (e.g. 'pet'),
but as a single word-style specifier if they are not (e.g. 'forbid').

B<OUTPUT>

The output threads over both C<$index> and C<$source>.  Because implicit 
threading can happen in a couple of ways, a little thought is needed.  The
returned dimension list is stacked up like this:

   (index thread dims), (index dims (size)), (source thread dims)

The first few dims of the output correspond to the extra dims of
C<$index> (beyond the 0 dim). They allow you to pick out individual
ranges from a large, threaded collection.

The middle few dims of the output correspond to the size dims
specified in C<$size>, and contain the range of values that is extracted
at each location in C<$source>.  Every nonzero element of C<$size> is copied to
the dimension list here, so that if you feed in (for example) C<$size
= [2,0,1]> you get an index dim list of C<(2,1)>.

The last few dims of the output correspond to extra dims of C<$source> beyond
the number of dims indexed by C<$index>.  These dims act like ordinary 
thread dims, because adding more dims to C<$source> just tacks extra dims
on the end of the output.  Each source thread dim ranges over the entire
corresponding dim of C<$source>.

B<Dataflow>: Dataflow is bidirectional.

B<Examples>:
Here are basic examples of C<range> operation, showing how to get 
ranges out of a small matrix.  The first few examples show extraction
and selection of individual chunks.  The last example shows
how to mark loci in the original matrix (using dataflow).

 perldl> $src = 10*xvals(10,5)+yvals(10,5)
 perldl> print $src->range([2,3])    # Cut out a single element
 23
 perldl> print $src->range([2,3],1)  # Cut out a single 1x1 block
 [
  [23]
 ]
 perldl> print $src->range([2,3], [2,1]) # Cut a 2x1 chunk
 [
  [23 33]
 ]
 perldl> print $src->range([[2,3]],[2,1]) # Trivial list of 1 chunk
 [
  [
   [23]
   [33]
  ]
 ]
 perldl> print $src->range([[2,3],[0,1]], [2,1])   # two 2x1 chunks
 [
  [
   [23  1]
   [33 11]
  ]
 ]
 perldl> # A 2x2 collection of 2x1 chunks
 perldl> print $src->range([[[1,1],[2,2]],[[2,3],[0,1]]],[2,1])
 [
  [
   [
    [11 22]
    [23  1]
   ]
   [
    [21 32]
    [33 11]
   ]
  ]
 ]
 perldl> $src = xvals(5,3)*10+yvals(5,3)
 perldl> print $src->range(3,1)  # Thread over y dimension in $src 
 [
  [30]
  [31]
  [32]
 ]

 perldl> $src = zeroes(5,4);
 perldl> $src->range(pdl([2,3],[0,1]),pdl(2,1)) .= xvals(2,2,1) + 1
 perldl> print $src
 [
  [0 0 0 0 0]
  [2 2 0 0 0]
  [0 0 0 0 0]
  [0 0 1 1 0]
 ]

B<CAVEAT>: It's quite possible to select multiple ranges that
intersect.  In that case, modifying the ranges doesn't have a
guaranteed result in the original PDL -- the result is an arbitrary
choice among the valid values.  For some things that's OK; but for
others it's not. In particular, this doesn't work:

    perldl> $photon_list = new PDL::RandVar->sample(500)->reshape(2,250)*10
    perldl> histogram = zeroes(10,10)
    perldl> histogram->range($photon_list,1)++;  #not what you wanted

The reason is that if two photons land in the same bin, then that bin 
doesn't get incremented twice.  (That may get fixed in a later version...)

B<PERMISSIVE RANGING>: If C<$index> has too many dimensions compared
to C<$source>, then $source is treated as though it had dummy
dimensions of order 1, up to the required number of dimensions.  These
virtual dummy dimensions have the usual boundary conditions applied to
them.  

If the 0 dimension of C<$index> is ludicrously large (if its order is
more than 5 greater than the number of dims in the source PDL) then
range will insist that you specify a size in every dimension, to make
sure that you know what you're doing.  That catches a common error with
range usage: confusing the initial dim (usually of low order) with another
index dim (perhaps of order 1000).

B<EFFICIENCY>: Because C<range> isn't an affine transformation (it
involves lookup into a list of N-D indices), it is somewhat
memory-inefficient for long lists of ranges, and keeping dataflow open
is much slower than for affine transformations (which don't have to copy
data around).  

Doing operations on small subfields of a large range is inefficient
because the engine must flow the entire range back into the original
PDL with every atomic perl operation, even if you only touch a single element.
One way to speed up such code is to sever your range, so that PDL
doesn't have to copy the data with each operation, then copy the
elements explicitly at the end of your loop.  Here's an example that
labels each region in a range sequentially, using many small
operations rather than a single xvals assignment:

  ### How to make a collection of small ops run fast with range...
  $a =  $data->range($index, $sizes, $bound)->sever; 
  $aa = $data->range($index, $sizes, $bound);        
  map { $a($_ - 1) .= $_; } (1..$a->nelem);    # Lots of little ops
  $aa .= $a;

C<range> is a perl front-end to a PP function, C<rangeb>.  Calling
C<rangeb> is marginally faster but requires that you include all arguments.

DEVEL NOTES

* index thread dimensions are effectively clumped internally.  This
makes it easier to loop over the index array but a little more brain-bending 
to tease out the algorithm.

* Currently the index threads really do run fastest in memory; this is 
probably the wrong direction to thread, for fastest behavior -- modifying 
the appropriate dimincs in RedoDims ought to take care of it.

=cut 





=cut






*rangeb = \&PDL::rangeb;




=head2 rld

=for sig

  Signature: (int a(n); b(n); [o]c(m))

=for ref

Run-length decode a vector

Given a vector C<$a> of the numbers of instances of values C<$b>, run-length
decode to C<$c>.

=for example

 rld($a,$b,$c=null);





=cut




sub PDL::rld {
  my ($a,$b) = @_;
  my ($c);
  if ($#_ == 2) {
    $c = $_[2];
  } else {
# XXX Need to improve emulation of threading in auto-generating c
    my ($size) = $a->sumover->max;
    my (@dims) = $a->dims;
    shift @dims;
    $c = $b->zeroes($size,@dims);
  }
  &PDL::_rld_int($a,$b,$c);
  $c;
}


*rld = \&PDL::rld;




=head2 rle

=for sig

  Signature: (c(n); int [o]a(n); [o]b(n))

=for ref

Run-length encode a vector

Given vector C<$c>, generate a vector C<$a> with the number of each element,
and a vector C<$b> of the unique values.  Only the elements up to the
first instance of C<0> in C<$a> should be considered.

=for example

 rle($c,$a=null,$b=null);





=cut






*rle = \&PDL::rle;




*flowconvert = \&PDL::flowconvert;




*converttypei = \&PDL::converttypei;




*_clump_int = \&PDL::_clump_int;




=head2 xchg

=for sig

  Signature: (P(); C(); int n1; int n2)

=for ref

exchange two dimensions

Negative dimension indices count from the end.

The command

=for example

 $b = $a->xchg(2,3);

creates C<$b> to be like C<$a> except that the dimensions 2 and 3
are exchanged with each other i.e.

 $b->at(5,3,2,8) == $a->at(5,3,8,2)





=cut






*xchg = \&PDL::xchg;



=head2 reorder

=for ref

Re-orders the dimensions of a PDL based on the supplied list.

Similar to the L<xchg|/xchg> method, this method re-orders the dimensions
of a PDL. While the L<xchg|/xchg> method swaps the position of two dimensions,
the reorder method can change the positions of many dimensions at
once.

=for usage

 # Completely reverse the dimension order of a 6-Dim array.
 $reOrderedPDL = $pdl->reorder(5,4,3,2,1,0); 

The argument to reorder is an array representing where the current dimensions
should go in the new array. In the above usage, the argument to reorder 
C<(5,4,3,2,1,0)>
indicates that the old dimensions (C<$pdl>'s dims) should be re-arranged to make the
new pdl (C<$reOrderPDL>) according to the following:

   Old Position   New Position
   ------------   ------------
   5              0
   4              1
   3 		  2
   2		  3
   1		  4
   0		  5

=for example 

Example:

 perldl> $a = sequence(5,3,2);	  # Create a 3-d Array
 perldl> p $a
 [
  [
   [ 0  1  2  3  4]
   [ 5  6  7  8  9]
   [10 11 12 13 14]
  ]
  [
   [15 16 17 18 19]
   [20 21 22 23 24]
   [25 26 27 28 29]
  ]
 ]
 perldl> p $a->reorder(2,1,0); # Reverse the order of the 3-D PDL
 [
  [
   [ 0 15]
   [ 5 20]
   [10 25]
  ]
  [
   [ 1 16]
   [ 6 21]
   [11 26]
  ]
  [
   [ 2 17]
   [ 7 22]
   [12 27]
  ]
  [
   [ 3 18]
   [ 8 23]
   [13 28]
  ]
  [
   [ 4 19]
   [ 9 24]
   [14 29]
  ]
 ]

The above is a simple example that could be duplicated by calling
C<$a-E<gt>xchg(0,2)>, but it demonstrates the basic functionality of reorder.

As this is an index function, any modifications to the
result PDL will change the parent.

=cut

sub PDL::reorder {
	my ($pdl,@newDimOrder) = @_;
	
	my $arrayMax = $#newDimOrder;
  
	#Error Checking:
	if( $pdl->getndims != scalar(@newDimOrder) ){
		my $errString = "PDL::reoderDims: Number of elements (".scalar(@newDimOrder).") in newDimOrder array doesn't\n";
		$errString .= "match the number of dims in the supplied PDL ($ndims)";
		barf($errString);
	}
	# a quicker way to do the reorder
	return $pdl->thread(@newDimOrder)->unthread(0);
}





=head2 mv

=for sig

  Signature: (P(); C(); int n1; int n2)

=for ref

move a dimension to another position

The command

=for example

 $b = $a->mv(4,1);

creates C<$b> to be like C<$a> except that the dimension 4 is moved to the
place 1, so:

 $b->at(1,2,3,4,5,6) == $a->at(1,5,2,3,4,6);

The other dimensions are moved accordingly.
Negative dimension indices count from the end.




=cut






*mv = \&PDL::mv;




=head2 oneslice

=for sig

  Signature: (P(); C(); int nth; int from; int step; int nsteps)

=for ref

experimental function - not for public use

=for example

 $a = oneslice();

This is not for public use currently. See the source if you have to.
This function can be used to accomplish run-time changing of
transformations i.e. changing the size of some piddle at run-time.

However, the mechanism is not yet finalized and this is just a demonstration.





=cut






*oneslice = \&PDL::oneslice;




=head2 slice

=for sig

  Signature: (P(); C(); char* str)

=for ref

Extract a rectangular slice of a piddle, from a string specifier.

C<slice> was the original Swiss-army-knife PDL indexing routine, but is
largely superseded by the L<NiceSlice|PDL::NiceSlice> source prefilter
and its associated L<nslice|PDL::Core/nslice> method.  It is still used as the
basic underlying slicing engine for L<nslice|PDL::Core/nslice>,
and is especially useful in particular niche applications.

=for example

 $a->slice('1:3');  #  return the second to fourth elements of $a
 $a->slice('3:1');  #  reverse the above
 $a->slice('-2:1'); #  return last-but-one to second elements of $a

The argument string is a comma-separated list of what to do
for each dimension. The current formats include
the following, where I<a>, I<b> and I<c> are integers and can
take legal array index values (including -1 etc):

=over 8

=item :

takes the whole dimension intact.

=item ''

(nothing) is a synonym for ":"
(This means that C<$a-E<gt>slice(':,3')> is equal to C<$a-E<gt>slice(',3')>).

=item a

slices only this value out of the corresponding dimension.

=item (a)

means the same as "a" by itself except that the resulting
dimension of length one is deleted (so if C<$a> has dims C<(3,4,5)> then
C<$a-E<gt>slice(':,(2),:')> has dimensions C<(3,5)> whereas
C<$a-E<gt>slice(':,2,:')> has dimensions C<(3,1,5))>.

=item a:b

slices the range I<a> to I<b> inclusive out of the dimension.

=item a:b:c

slices the range I<a> to I<b>, with step I<c> (i.e. C<3:7:2> gives the indices
C<(3,5,7)>). This may be confusing to Matlab users but several other
packages already use this syntax.

=item '*'

inserts an extra dimension of width 1 and

=item '*a'

inserts an extra (dummy) dimension of width I<a>.

=back

An extension is planned for a later stage allowing
C<$a-E<gt>slice('(=1),(=1|5:8),3:6(=1),4:6')>
to express a multidimensional diagonal of C<$a>.

Trivial out-of-bounds slicing is allowed: if you slice a source
dimension that doesn't exist, but only index the 0th element, then
C<slice> treats the source as if there were a dummy dimension there.
The following are all equivalent:

	xvals(5)->dummy(1,1)->slice('(2),0')  # Add dummy dim, then slice
	xvals(5)->slice('(2),0')              # Out-of-bounds slice adds dim.
	xvals(5)->slice((2),0)                # NiceSlice syntax
	xvals(5)->((2))->dummy(0,1) 	      # NiceSlice syntax

This is an error:

	xvals(5)->slice('(2),1')	# nontrivial out-of-bounds slice dies

Because slicing doesn't directly manipulate the source and destination 
pdl -- it just sets up a transformation between them -- indexing errors 
often aren't reported until later.  This is either a bug or a feature,
depending on whether you prefer error-reporting clarity or speed of execution.





=cut






*slice = \&PDL::slice;



=head2 using

=for ref

Returns array of column numbers requested

=for usage

 line $pdl->using(1,2);

Plot, as a line, column 1 of C<$pdl> vs. column 2

=for example

 perldl> $pdl = rcols("file");
 perldl> line $pdl->using(1,2);

=cut

*using = \&PDL::using;
sub PDL::using {
  my ($x,@ind)=@_;
  @ind = list $ind[0] if (ref $ind[0] eq 'PDL');
  foreach (@ind) {
    $_ = $x->slice("($_)");
  }
  @ind;
}





*affine = \&PDL::affine;




=head2 diagonalI

=for sig

  Signature: (P(); C(); SV *list)

=for ref

Returns the multidimensional diagonal over the specified dimensions.

The diagonal is placed at the first (by number) dimension that is
diagonalized.
The other diagonalized dimensions are removed. So if C<$a> has dimensions
C<(5,3,5,4,6,5)> then after

=for example

 $b = $a->diagonal(0,2,5);

the piddle C<$b> has dimensions C<(5,3,4,6)> and 
C<$b-E<gt>at(2,1,0,1)> refers
to C<$a-E<gt>at(2,1,2,0,1,2)>.

NOTE: diagonal doesn't handle threadids correctly. XXX FIX





=cut






*diagonalI = \&PDL::diagonalI;




=head2 lags

=for sig

  Signature: (P(); C(); int nthdim; int step; int n)

=for ref

Returns a piddle of lags to parent.

Usage:

=for usage

  $lags = $a->lags($nthdim,$step,$nlags);

I.e. if C<$a> contains

 [0,1,2,3,4,5,6,7]

then

=for example

 $b = $a->lags(0,2,2);

is a (5,2) matrix

 [2,3,4,5,6,7]
 [0,1,2,3,4,5]

This order of returned indices is kept because the function is
called "lags" i.e. the nth lag is n steps behind the original.

C<$step> and C<$nlags> must be positive. C<$nthdim> can be
negative and will then be counted from the last dim backwards
in the usual way (-1 = last dim).





=cut






*lags = \&PDL::lags;




=head2 splitdim

=for sig

  Signature: (P(); C(); int nthdim; int nsp)

=for ref

Splits a dimension in the parent piddle (opposite of L<clump|PDL::Core/clump>)

After

=for example

 $b = $a->splitdim(2,3);

the expression

 $b->at(6,4,x,y,3,6) == $a->at(6,4,x+3*y)

is always true (C<x> has to be less than 3).





=cut






*splitdim = \&PDL::splitdim;




=head2 rotate

=for sig

  Signature: (x(n); int shift(); [oca]y(n))

=for ref

Shift vector elements along with wrap. Flows data back&forth.





=cut






*rotate = \&PDL::rotate;




=head2 threadI

=for sig

  Signature: (P(); C(); int id; SV *list)

=for ref

internal

Put some dimensions to a threadid.

=for example

 $b = $a->threadI(0,1,5); # thread over dims 1,5 in id 1





=cut






*threadI = \&PDL::threadI;




=head2 identvaff

=for sig

  Signature: (P(); C())

=for ref

A vaffine identity transformation (includes thread_id copying).

Mainly for internal use.





=cut






*identvaff = \&PDL::identvaff;




=head2 unthread

=for sig

  Signature: (P(); C(); int atind)

=for ref

All threaded dimensions are made real again.

See [TBD Doc] for details and examples.





=cut






*unthread = \&PDL::unthread;



=head2 dice

=for ref

Dice rows/columns/planes out of a PDL using indexes for
each dimension.

This function can be used to extract irregular subsets
along many dimension of a PDL, e.g. only certain rows in an image,
or planes in a cube. This can of course be done with
the usual dimension tricks but this saves having to
figure it out each time!

This method is similar in functionality to the L<slice|/slice>
method, but L<slice|/slice> requires that contiguous ranges or ranges
with constant offset be extracted. ( i.e. L<slice|/slice> requires 
ranges of the form C<1,2,3,4,5> or C<2,4,6,8,10>). Because of this
restriction, L<slice|/slice> is more memory efficient and slightly faster
than dice

=for usage

 $slice = $data->dice([0,2,6],[2,1,6]); # Dicing a 2-D array

The arguments to dice are arrays (or 1D PDLs) for each dimension
in the PDL. These arrays are used as indexes to which rows/columns/cubes,etc
to dice-out (or extract) from the C<$data> PDL. 

Use C<X> to select all indices along a given dimension (compare also
L<mslice|PDL::Core/mslice>). As usual (in slicing methods) trailing
dimensions can be omitted implying C<X>'es for those.

=for example 

 perldl> $a = sequence(10,4)
 perldl> p $a
 [
  [ 0  1  2  3  4  5  6  7  8  9]
  [10 11 12 13 14 15 16 17 18 19]
  [20 21 22 23 24 25 26 27 28 29]
  [30 31 32 33 34 35 36 37 38 39]
 ]
 perldl> p $a->dice([1,2],[0,3]) # Select columns 1,2 and rows 0,3
 [
  [ 1  2]
  [31 32]
 ]
 perldl> p $a->dice(X,[0,3])
 [
  [ 0  1  2  3  4  5  6  7  8  9]
  [30 31 32 33 34 35 36 37 38 39]
 ]
 perldl> p $a->dice([0,2,5])
 [
  [ 0  2  5]
  [10 12 15]
  [20 22 25]
  [30 32 35]
 ]

As this is an index function, any modifications to the
slice change the parent (use the C<.=> operator).

=cut

sub PDL::dice { 

	my $self = shift;
	my @dim_indexes = @_;  # array of dimension indexes
	
	# Check that the number of dim indexes <=
	#    number of dimensions in the PDL
	my $no_indexes = scalar(@dim_indexes);
	my $noDims = $self->getndims;
	barf("PDL::dice: Number of index arrays ($no_indexes) not equal to the dimensions of the PDL ($noDims")
			 if $no_indexes > $noDims;
	my $index;
	my $pdlIndex;
	my $outputPDL=$self;
	my $indexNo = 0;

	# Go thru each index array and dice the input PDL:
	foreach $index(@dim_indexes){
		$outputPDL = $outputPDL->dice_axis($indexNo,$index)
			unless !ref $index && $index eq 'X';

		$indexNo++;
	}

	return $outputPDL;
}  
*dice = \&PDL::dice;


=head2 dice_axis

=for ref

Dice rows/columns/planes from a single PDL axis (dimension)
using index along a specified axis

This function can be used to extract irregular subsets
along any dimension, e.g. only certain rows in an image,
or planes in a cube. This can of course be done with
the usual dimension tricks but this saves having to
figure it out each time!

=for usage

 $slice = $data->dice_axis($axis,$index);

=for example

 perldl> $a = sequence(10,4)
 perldl> $idx = pdl(1,2)
 perldl> p $a->dice_axis(0,$idx) # Select columns
 [
  [ 1  2]
  [11 12]
  [21 22]
  [31 32]
 ]
 perldl> $t = $a->dice_axis(1,$idx) # Select rows
 perldl> $t.=0
 perldl> p $a
 [
  [ 0  1  2  3  4  5  6  7  8  9]
  [ 0  0  0  0  0  0  0  0  0  0]
  [ 0  0  0  0  0  0  0  0  0  0]
  [30 31 32 33 34 35 36 37 38 39]
 ]

The trick to using this is that the index selects
elements along the dimensions specified, so if you
have a 2D image C<axis=0> will select certain C<X> values
- i.e. extract columns

As this is an index function, any modifications to the
slice change the parent.

=cut

sub PDL::dice_axis { 
  my($self,$axis,$idx) = @_;
  
  # Convert to PDLs: array refs using new, otherwise use topdl:
  my $ix = (ref($idx) eq 'ARRAY') ? ref($self)->new($idx) : ref($self)->topdl($idx);
  my $n = $self->getndims;
  my $a = $ix->getndims;
  barf("index_axis: index must be <=1D") if $a>1;
  for ($a..$n-1) {
     $ix = $ix->dummy(0);
  }
  	
  return $self->mv($axis,0)->index($ix)->mv($n-1,$axis);
}  
*dice_axis = \&PDL::dice_axis;




;


=head1 AUTHOR

Copyright (C) 1997 Tuomas J. Lukka.  Contributions by
Craig DeForest, deforest@boulder.swri.edu.
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.

=cut





# Exit with OK status

1;

		   