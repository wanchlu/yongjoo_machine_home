
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::IO::Storable;

@EXPORT_OK  = qw( );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::IO::Storable ;









=head1 NAME

PDL::IO::Storable - helper functions to make PDL usable with Storable

=head1 SYNOPSIS

  use Storable;
  use PDL::IO::Storable;
  $hash = {
            'foo' => 42,
            'bar' => zeroes(23,45),
          };
  store $hash, 'perlhash.dat';

=head1 DESCRIPTION

C<Storable> implements object persistence for Perl data structures
that can (in principle) contain arbitrary Perl objects. Complicated
objects must supply their own methods to be serialized and thawed.
This module implements the relevant methods to be able to store
and retrieve piddles via Storable.

=head1 FUNCTIONS

=cut




use Carp;

{ package PDL;
# routines to make PDL work with Storable >= 1.03
sub pdlpack {
  my ($pdl) = @_;
  my $hdr = pack 'i*', $pdl->get_datatype, $pdl->getndims, $pdl->dims;
  my $dref = $pdl->get_dataref;
  return $hdr.$$dref; # header followed by dataref
  # note that this packing is not network transparent !!!!!
  # likely to break when moving stored piddles across
  # different architectures
  # probably need to store endianness and type info with it
  # type should be saved by name! the type codes could change depending
  # on the PDL version
}

sub pdlunpack {
  use Config ();
  my ($pdl,$pack) = @_;
  my $stride = $Config::Config{intsize};
  my ($type,$ndims) = unpack 'i2', $pack;
  my @dims = $ndims > 0 ? unpack 'i*', substr $pack, 2*$stride,
     $ndims*$stride : ();
  print "thawing PDL, Dims: [",join(',',@dims),"]\n" if $PDL::verbose;
  $pdl->make_null; # make this a real piddle -- this is the tricky bit!
  $pdl->set_datatype($type);
  $pdl->setdims([@dims]);
  my $dref = $pdl->get_dataref;
  $$dref = substr $pack, (2+$ndims)*$stride;
  $pdl->upd_data;
  return $pdl;
}

sub STORABLE_freeze {
  my ($self, $cloning) = @_;
  return if $cloning;         # Regular default serialization
  return UNIVERSAL::isa($self, "HASH") ? ("",{%$self}) # hash ref -> Storable
    : (pdlpack $self); # pack the piddle into a long string
}

sub STORABLE_thaw {
  my ($pdl,$cloning,$serial,$hashref) = @_;
  # print "in STORABLE_thaw\n";
  return if $cloning;
  my $class = ref $pdl;
  if (defined $hashref) {
    croak "serial data with hashref!" unless !defined $serial ||
      $serial eq "";
    for (keys %$hashref) { $pdl->{$_} = $hashref->{$_} }
  } else {
    # all the magic is happening in pdlunpack
    $pdl->pdlunpack($serial); # unpack our serial into this sv
  }
}

# have these as PDL methods

=head2 store

=for ref

store a piddle using L<Storable|Storable>

=for example

  $a = random 12,10;
  $a->store('myfile');

=cut

=head2 freeze

=for ref

freeze a piddle using L<Storable|Storable>

=for example

  $a = random 12,10;
  $frozen = $a->freeze;

=cut

sub store  { require Storable; Storable::store(@_) }
sub freeze { require Storable; Storable::freeze(@_) }
}

=head1 BUGS

The packed piddles are I<not> stored in a network transparent
way. As a result expect problems when moving C<Storable> data
containing piddles across computers.

This could be fixed by amending the methods C<pdlpack> and
C<pdlunpack> appropriately. If you want this functionality
feel free to submit patches.

If you want to move piddle data
across platforms I recommend L<PDL::NetCDF|PDL::NetCDF> as
an excellent (and IMHO superior) workaround.

=head1 AUTHOR

Copyright (C) 2002 Christian Soeller <c.soeller@auckland.ac.nz>
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.

=cut




;



# Exit with OK status

1;

		   