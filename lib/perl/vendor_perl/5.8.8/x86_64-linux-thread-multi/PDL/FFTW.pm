
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::FFTW;

@EXPORT_OK  = qw( PDL::PP Cmul PDL::PP Cscale PDL::PP Cdiv PDL::PP Cbmul PDL::PP Cbscale PDL::PP Cconj PDL::PP Cbconj PDL::PP Cexp PDL::PP Cbexp PDL::PP Cmod PDL::PP Carg PDL::PP Cmod2  load_wisdom save_wisdom rfftw irfftw fftw ifftw
nfftw infftw nrfftw inrfftw fftwconv rfftwconv kernctr );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::FFTW ;




=head1 NAME

PDL::FFTW - PDL interface to the Fastest Fourier Transform in the West v2.x

=head1 DESCRIPTION

This is a means to interface PDL with the FFTW library. It's similar to
the standard FFT routine but it's usually faster and has support for
real transforms. It works well for the types of PDLs for
which was the library was compiled (otherwise it must do conversions).

=head1 SYNOPSIS

    use PDL::FFTW

    load_wisdom("file_name");

    out_cplx_pdl =  fftw(in_cplx_pdl);
    out_cplx_pdl = ifftw(in_cplx_pdl);

    out_cplx_pdl =  rfftw(in_real_pdl);
    out_real_pdl = irfftw(in_cplx_pdl);

    cplx_pdl = nfftw(cplx_pdl);
    cplx_pdl = infftw(cplx_pdl);

    cplx_pdl = Cmul(a_cplx_pdl, b_cplx_pdl);
    cplx_pdl = Cconj(a_cplx_pdl);
    real_pdl = Cmod(a_cplx_pdl); 
    real_pdl = Cmod2(a_cplx_pdl); 

=head1 FFTW documentation

Please refer to the FFTW documentation for a better understanding of
these functions.

Note that complex numbers are represented as piddles with leading
dimension size 2 (real/imaginary pairs).

=cut






=head1 FUNCTIONS



=cut





=head2 load_wisdom

=for ref

Loads the wisdom from a file for better FFTW performance.

The wisdom
is automatically saved when the program ends. It will be automagically
called when the variable C<$PDL::FFT::wisdom> is set to a file name.
For example, the following is a useful idiom to have in your F<.perldlrc>
file:

  $PDL::FFT::wisdom = "$ENV{HOME}/.fftwisdom"; # save fftw wisdom in this file

Explicit usage:

=for usage

  load_wisdom($fname);

=head2 fftw

=for ref 

calculate the complex FFT of a real piddle (complex input, complex output)

=for usage

   $pdl_cplx = fftw $pdl_cplx;

=head2 ifftw

=for ref 

Complex inverse FFT (complex input, complex output).

=for usage

   $pdl_cplx = ifftw $pdl_cplx;

=head2 nfftw

=for ref 

Complex inplace FFT (complex input, complex output).

=for usage

   $pdl_cplx = nfftw $pdl_cplx;

=head2 infftw

=for ref 

Complex inplace inverse FFT (complex input, complex output).

=for usage

   $pdl_cplx = infftw $pdl_cplx;

=head2 rfftw

=for ref 

Real FFT. For an input piddle of dimensions [n1,n2,...] the 
output is [2,(n1/2)+1,n2,...] (real input, complex output).

=for usage

  $pdl_cplx = fftw $pdl_real;

=head2 irfftw

=for ref 

Real inverse FFT. Have a look at rfftw to understand the format. USE
ONLY an even n1! (complex input, real output)

=for usage

  $pdl_real = ifftw $pdl_cplx;

=head2 nrfftw

=for ref 

Real inplace FFT. If you want a transformation on a piddle
with dimensions [n1,n2,....] you MUST pass in a piddle
with dimensions [2*(n1/2+1),n2,...] (real input, complex output).

Use with care due to dimension restrictions mentioned below.
For details check the html docs that come with the fftw library.

=for usage

  $pdl_cplx = nrfftw $pdl_real;

=head2 inrfftw

=for ref 

Real inplace inverse FFT. Have a look at nrfftw to understand the format. USE
ONLY an even first dimension size! (complex input, real output)

=for usage

  $pdl_real = infftw $pdl_cplx;

=cut





use PDL;
use PDL::ImageND qw/kernctr/;
use strict;

my ($wisdom_fname, $wisdom_loaded, %plan_cache, $datatype, $warn_conv);

#
# package vriables: $wisdom_fname, $wisdom_loaded, %plan_cache, $datatype, $warn_conv, 
#           $COMPILED_TYPE: (Type "double" or "float") that PDL::FFTW was compiled/linked to
#

$wisdom_loaded = 0;

$PDL::FFTW::COMPILED_TYPE = "double";

sub load_wisdom {
    $wisdom_fname = shift;
    
    if (!$wisdom_loaded) {
	my ($wisdom, $ok);
	$wisdom_loaded = 1;
	if (!open(TMPFILE,$wisdom_fname)) {
	    print STDERR "Warning: couldn't find wisdom file\n";
	    return;
	}
	$wisdom = <TMPFILE>;
	close(TMPFILE);
	$ok = PDL_fftw_import_wisdom_from_string($wisdom);
	if (!$ok) {
	    print STDERR "Warning: couldn't import wisdom\n";
	}
    }
}

sub save_wisdom {
  if ($wisdom_loaded) {
    my $wisdom = PDL_fftw_export_wisdom_to_string();

    if (!open(TMPFILE,">$wisdom_fname")) {
      print STDERR "Warning: couldn't write wisdom file\n";
      return;
    }
    print TMPFILE $wisdom;
    close(TMPFILE);
  }
}

sub BEGIN {
  my $HOME=$ENV{HOME};
  my $test_type = double 1;

  $datatype = $test_type->get_datatype;
  $warn_conv = 0;
#  if ( -e "$HOME/.wisdom" ) {
#    print STDERR "Autoloading wisdom\n";
#    load_wisdom("$HOME/.wisdom");
#  }
}

sub END {
  save_wisdom();
}

if (defined $PDL::FFT::wisdom) {
    load_wisdom($PDL::FFT::wisdom);
    print "loading wisdom from $PDL::FFT::wisdom\n" if $PDL::debug;
}

# real fftw
*PDL::rfftw = \&rfftw;
sub rfftw {
  my $in = PDL::Core::topdl(shift);
  my @dims = $in->dims;
  my @newdims;
  my ($out,$name,$i);

 
  if ($datatype != $in->get_datatype) {
    $in = convert $in, double;
    if ($warn_conv != 1) {
      print STDERR "PDL::FFTW Warning! doing conversion.\n";
      $warn_conv = 1;
    }
  }
  foreach $i (@dims) {
    unshift @newdims, $i;
  }
  $name="r_@{newdims}_f";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_rfftwnd_create_plan($pdldims,0,$wisdom_loaded);
  }
  $dims[0]= int($dims[0]/2)+1;
  unshift @dims, 2;
  $out = zeroes double,@dims;
  $in->make_physical;
  PDL_rfftwnd_one_real_to_complex($plan_cache{$name},$in,$out);
  return $out;
}

# this assumes even last input dimension!

*PDL::irfftw = \&irfftw;
sub irfftw {
  my $in = PDL::Core::topdl(shift);
  my @dims = $in->dims;
  my @newdims;
  my ($out,$name,$i);

  $i = shift @dims;
  if ($i != 2) {
     barf("Working only on complex numbers!");
  } 
  if ($datatype != $in->get_datatype) {
    $in = convert $in, double;
    if ($warn_conv != 1) {
      print STDERR "PDL::FFTW Warning! doing conversion.\n";
      $warn_conv = 1;
    }
  }
  $i= shift @dims;
  unshift @newdims, 2*($i-1);
  foreach $i (@dims) {
    unshift @newdims, $i;
  } 
  $name="r_@{newdims}_b";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_rfftwnd_create_plan($pdldims,1,$wisdom_loaded);
  }
  unshift @dims, 2*($i-1);
  $out = zeroes double,@dims;
  $in->make_physical;
  PDL_rfftwnd_one_complex_to_real($plan_cache{$name},$in,$out);
  return $out;
}

# real inplace fftw

*PDL::nrfftw = \&nrfftw;
sub nrfftw {
  my ($in)=@_;
  my @dims = $in->dims;
  my @newdims;
  my ($out,$name,$i,$ndim);

 
  if ($datatype != $in->get_datatype) {
	barf("Cannot do inplace fftw: compiled for double !");
  }
  foreach $i (@dims) {
    unshift @newdims, $i;
  }
  $ndim = $newdims[$#newdims] = 2*(int($newdims[$#newdims]/2) - 1);
  $name="nr_@{newdims}_f";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_rfftwnd_create_plan($pdldims,0,$wisdom_loaded+2);
  }
  $dims[0]= int($ndim/2)+1;
  unshift @dims, 2;
  $in->make_physical;
  PDL_inplace_rfftwnd_one_real_to_complex($plan_cache{$name},$in);
  $in->reshape(@dims);
  return $in;
}

# this assumes even last input dimension!

*PDL::inrfftw = \&inrfftw;
sub inrfftw {
  my ($in)=@_;
  my @dims = $in->dims;
  my @newdims;
  my ($out,$name,$i,$ndim);

  $i = shift @dims;
  if ($i != 2) {
     barf("Working only on complex numbers!");
  } 
  if ($datatype != $in->get_datatype) {
	barf("Cannot do inplace fftw: compiled for double !");
  }
  $i= shift @dims;
  $ndim =  2*($i-1);
  unshift @newdims, $ndim;
  foreach $i (@dims) {
    unshift @newdims, $i;
  } 
  $name="nr_@{newdims}_b";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_rfftwnd_create_plan($pdldims,1,$wisdom_loaded+2);
  }
  unshift @dims, 2*(int($ndim/2)+1);
  $in->make_physical;
  PDL_inplace_rfftwnd_one_complex_to_real($plan_cache{$name},$in);
  $in->reshape(@dims);
  return $in;
}

# complex fftw

*PDL::fftw = \&fftw;
sub fftw {
  my $in = PDL::Core::topdl(shift);
  my @dims = $in->dims;
  my @newdims;
  my ($out,$name,$i);

  if ($datatype != $in->get_datatype) {
    $in = convert $in, double;
    if ($warn_conv != 1) {
      print STDERR "PDL::FFTW Warning! doing conversion.\n";
      $warn_conv = 1;
    }
  }
  $i=shift @dims;
  if ($i!=2) {
    barf("It works only on complex!");
  }
  foreach $i (@dims) {
    unshift @newdims, $i;
  }
  $name="c_@{newdims}_f";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_fftwnd_create_plan($pdldims,0,$wisdom_loaded);
  }
  unshift @dims, 2;
  $out = zeroes double,@dims;
  $in->make_physical;
  PDL_fftwnd_one($plan_cache{$name},$in,$out);
  return $out;
}

*PDL::ifftw = \&ifftw;
sub ifftw {
  my $in = PDL::Core::topdl(shift);
  my @dims = $in->dims;
  my @newdims;
  my ($out,$name,$i);

  if ($datatype != $in->get_datatype) {
    $in = convert $in, double;
    if ($warn_conv != 1) {
      print STDERR "PDL::FFTW Warning! doing conversion.\n";
      $warn_conv = 1;
    }
  } 
  $i = shift @dims;
  if ($i != 2) {
     barf("Working only on complex numbers!");
  }
  foreach $i (@dims) {
    unshift @newdims, $i;
  } 
  $name="c_@{newdims}_b";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_fftwnd_create_plan($pdldims,1,$wisdom_loaded);
  }
  unshift @dims, 2;
  $out = zeroes double,@dims;
  $in->make_physical;
  PDL_fftwnd_one($plan_cache{$name},$in,$out);
  return $out;
}

# complex inplace fftw

*PDL::nfftw = \&nfftw;
sub nfftw {
  my ($in)=@_;
  my @dims = $in->dims;
  my @newdims;
  my ($name,$i);

  if ($datatype != $in->get_datatype) {
	barf("Cannot do inplace fftw: compiled for double !");
  } 
  $i=shift @dims;
  if ($i!=2) {
    barf("It works only on complex!");
  }
  foreach $i (@dims) {
    unshift @newdims, $i;
  }
  $name="n_@{newdims}_f";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_fftwnd_create_plan($pdldims,0,$wisdom_loaded+2);
  }
  $in->make_physical;
  PDL_inplace_fftwnd_one($plan_cache{$name},$in);
  return $in;
}

*PDL::infftw = \&infftw;
sub infftw {
  my ($in)=@_;
  my @dims = $in->dims;
  my @newdims;
  my ($out,$name,$i);

  if ($datatype != $in->get_datatype) {
	barf("Cannot do inplace fftw: compiled for double !");
  } 
  $i = shift @dims;
  if ($i != 2) {
     barf("Working only on complex numbers!");
  } 
  foreach $i (@dims) {
    unshift @newdims, $i;
  } 
  $name="n_@{newdims}_b";
  if ( !defined($plan_cache{$name}) ) {
    my $pdldims = long [@newdims];
    $plan_cache{$name} = PDL_fftwnd_create_plan($pdldims,1,$wisdom_loaded+2);
  }
  $in->make_physical;
  PDL_inplace_fftwnd_one($plan_cache{$name},$in);
  return $in;
}

=head2 rfftwconv

=for ref

ND convolution using real ffts from the FFTW library

=for example

  $conv = rfftwconv $im, kernctr $im, $k; # kernctr is from PDL::FFT

=cut

*PDL::rfftwconv = \&rfftwconv;
sub rfftwconv {
  my ($a,$b) = @_;
  my ($ca,$cb) = (rfftw($a), rfftw($b));
  my $cmul = Cmul($ca,$cb);
  my $ret = irfftw($cmul);
  my $mul = 1; for (0..$a->getndims-1) {$mul *= $a->getdim($_)}
  $ret /= $mul;
  return $ret;
}

=head2 fftwconv

=for ref

ND convolution using complex ffts from the FFTW library

Assumes real input!

=for example

  $conv = fftwconv $im, kernctr $im, $k; # kernctr is from PDL::FFT

=cut

*PDL::fftwconv = \&fftconv;
sub fftwconv {
  my ($a,$b) = @_;
  my ($ca,$cb) = (PDL->zeroes(2,$a->dims),PDL->zeroes(2,$b->dims));
  $ca->slice('(0)') .= $a;
  $cb->slice('(0)') .= $b;
  nfftw($ca); nfftw($cb);
  my $cmul = Cmul($ca,$cb);
  infftw $cmul;  # transfer back inplace
  # and return real part only
  my $ret = $cmul->slice('(0)')->sever;
  my $mul = 1; for (0..$a->getndims-1) {$mul *= $a->getdim($_)}
  $ret /= $mul;
  return $ret;
}





=head2 Cmul

=for sig

  Signature: (a(n); b(n); [o]c(n))

=for ref

Complex multiplication

=for usage

   $out_pdl_cplx = Cmul($a_pdl_cplx,$b_pdl_cplx);





=cut






*Cmul = \&PDL::Cmul;




=head2 Cscale

=for sig

  Signature: (a(n); b(); [o]c(n))

=for ref

Complex by real multiplation.

=for usage

  Cscale($a_pdl_cplx,$b_pdl_real);




=cut






*Cscale = \&PDL::Cscale;




=head2 Cdiv

=for sig

  Signature: (a(n); b(n); [o]c(n))

=for ref

Complex division.

=for usage

  $out_pdl_cplx = Cdiv($a_pdl_cplx,$b_pdl_cplx);





=cut






*Cdiv = \&PDL::Cdiv;




=head2 Cbmul

=for sig

  Signature: (a(n); b(n))

=for ref

Complex inplace multiplication.

=for usage

   Cbmul($a_pdl_cplx,$b_pdl_cplx);




=cut






*Cbmul = \&PDL::Cbmul;




=head2 Cbscale

=for sig

  Signature: (a(n); b())

=for ref

Complex inplace multiplaction by real.

=for usage

   Cbscale($a_pdl_cplx,$b_pdl_real);




=cut






*Cbscale = \&PDL::Cbscale;




=head2 Cconj

=for sig

  Signature: (a(n); [o]c(n))

=for ref

Complex conjugate.

=for usage

   $out_pdl_cplx = Cconj($a_pdl_cplx);




=cut






*Cconj = \&PDL::Cconj;




=head2 Cbconj

=for sig

  Signature: (a(n))

=for ref

Complex inplace conjugate.

=for usage

   Cbconj($a_pdl_cplx);




=cut






*Cbconj = \&PDL::Cbconj;




=head2 Cexp

=for sig

  Signature: (a(n); [o]c(n))

=for ref

Complex exponentation.

=for usage

   $out_pdl_cplx = Cexp($a_pdl_cplx);




=cut






*Cexp = \&PDL::Cexp;




=head2 Cbexp

=for sig

  Signature: (a(n))

=for ref

Complex inplace exponentation.

=for usage

   $out_pdl_cplx = Cexp($a_pdl_cplx);




=cut






*Cbexp = \&PDL::Cbexp;




=head2 Cmod

=for sig

  Signature: (a(n); [o]c())

=for ref

modulus of a complex piddle.

=for usage

  $out_pdl_real = Cmod($a_pdl_cplx);




=cut






*Cmod = \&PDL::Cmod;




=head2 Carg

=for sig

  Signature: (a(n); [o]c())

=for ref

argument of a complex number.

=for usage

   $out_pdl_real = Carg($a_pdl_cplx);




=cut






*Carg = \&PDL::Carg;




=head2 Cmod2

=for sig

  Signature: (a(n); [o]c())

=for ref

Returns squared modulus of a complex number.

=for usage

   $out_pdl_real = Cmod2($a_pdl_cplx);




=cut






*Cmod2 = \&PDL::Cmod2;


;

=head1 AUTHOR

Copyright (C) 1999 Christian Pellegrin, 2000 Christian Soeller.
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.

=cut




# Exit with OK status

1;

		   