
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Tests;

@EXPORT_OK  = qw( PDL::PP test_foop PDL::PP test_fsumover PDL::PP test_nsumover PDL::PP test_setdim PDL::PP test_fooseg PDL::PP test_fooflow1 PDL::PP test_fooflow2 PDL::PP test_fooflow3 );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Tests ;





=head1 NAME

PDL::Tests - tests for some PP features

=head1 SYNOPSIS

  use PDL::Tests;

  <test code>

=head1 DESCRIPTION

This module provides some PP defined test functions that are
supposed to test some features/bugs of PDL::PP.

Strictly speaking this module shouldn't be installed with a
'make install' but I haven't yet worked out how to do it.

=cut









*test_foop = \&PDL::test_foop;




*test_fsumover = \&PDL::test_fsumover;




*test_nsumover = \&PDL::test_nsumover;




*test_setdim = \&PDL::test_setdim;




*test_fooseg = \&PDL::test_fooseg;




*test_fooflow1 = \&PDL::test_fooflow1;




*test_fooflow2 = \&PDL::test_fooflow2;




*test_fooflow3 = \&PDL::test_fooflow3;


;



# Exit with OK status

1;

		   