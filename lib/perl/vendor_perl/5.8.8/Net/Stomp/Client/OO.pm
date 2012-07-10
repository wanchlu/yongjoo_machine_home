#+##############################################################################
#                                                                              #
# File: Net/STOMP/Client/OO.pm                                                 #
#                                                                              #
# Description: Object Oriented support for Net::STOMP::Client                  #
#                                                                              #
#-##############################################################################

#
# module definition
#

package Net::STOMP::Client::OO;
use strict;
use warnings;
our $VERSION  = "1.0";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.14 $ =~ /(\d+)\.(\d+)/);

#
# used modules
#

use UNIVERSAL qw();

#
# declare the valid fields/methods that the derived class supports
#

sub methods (@) {
    my(@names) = @_;
    my($class, $name, $sub);

    $class = caller();
    foreach $name (@names) {
	# check the method name
	die("*** invalid method name: $name\n")
	    unless $name =~ /^_?[a-z]+(_[a-z]+)*$/;
	# build the accessor method
	$sub = sub {
	    if (@_ == 1) {
		return($_[0]{$name});
	    } elsif (@_ == 2) {
		$_[0]{$name} = $_[1];
		return($_[0]);
	    }
	    die("*** ${class}->${name}(): invalid invocation\n");
	};
	# hook it to the symbol table
	no strict "refs";
	*{"${class}::${name}"} = $sub;
    }
}

#
# inheritable constructor
#

sub new : method {
    my($class, %data) = @_;
    my($self, $key);

    die("*** ${class}->new(): invalid invocation\n")
	unless @_ % 2;
    foreach $key (keys(%data)) {
	die("*** ${class}->new(): unexpected method: $key\n")
	    unless $key =~ /^_?[a-z]+(_[a-z]+)*$/ and UNIVERSAL::can($class, $key);
    }
    $self = \%data;
    bless($self, $class);
    return($self);
}

1;

__END__

=head1 NAME

Net::STOMP::Client::OO - Object Oriented support for Net::STOMP::Client

=head1 DESCRIPTION

This module provides Object Oriented support for Net::STOMP::Client.

It implements dual-purpose accessors that can be used to get or set a
given object attribute. For instance:

  # get the frame body
  $body = $frame->body();

  # set the frame body
  $frame->body("...some text...");

It also implements flexible object constructors. For instance:

  $frame = Net::STOMP::Client::Frame->new(
      command => "MESSAGE",
      body    => "...some text...",
  );

is equivalent to:

  $frame = Net::STOMP::Client::Frame->new();
  $frame->command("MESSAGE");
  $frame->body("...some text...");

=head1 FUNCTIONS

This module provides the following functions and methods:

=over

=item methods(NAMES)

this function is used to declare the list of known attributes/methods
for the current class

=item new([OPTIONS])

this method implements the inheritable constructor described above

=back

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2010-2011
