#+##############################################################################
#                                                                              #
# File: Net/STOMP/Client/Error.pm                                              #
#                                                                              #
# Description: Error support for Net::STOMP::Client                            #
#                                                                              #
#-##############################################################################

#
# module definition
#

package Net::STOMP::Client::Error;
use strict;
use warnings;
our $VERSION  = "1.0";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.9 $ =~ /(\d+)\.(\d+)/);

#
# global variables
#

our(
    $Message,			# last error message reported
    $Die,			# true if error messages should trigger die()
);

$Die = 1; # by default errors are fatal

#
# report an error message
#

sub report ($@) {
    my($format, @arguments) = @_;

    $Message = sprintf($format, @arguments);
    $Message =~ s/\s+$//;
    die("*** $Message\n") if $Die;
}

1;

__END__

=head1 NAME

Net::STOMP::Client::Error - Error support for Net::STOMP::Client

=head1 DESCRIPTION

This module provides error support for Net::STOMP::Client.

All the functions and methods that can fail use this module to report
errors (using Net::STOMP::Client::Error::report()) and then they
return an undefined value. They also try to return true on success but
this is not always possible as sometimes zero is a possible return
value.

By default, errors are fatal and get reported via die().

If $Net::STOMP::Client::Error::Die is false, die() is not used and it
is up to the caller to check the returned value to detect an error (by
checking if the returned value is defined). The caller can then
retrieve the last error message which is always stored in
$Net::STOMP::Client::Error::Message.

=head1 FUNCTIONS

This module provides the following functions:

=over

=item report(FORMAT[, ARGUMENTS])

format the error message using sprintf() and store the result in
$Net::STOMP::Client::Error::Message; if
$Net::STOMP::Client::Error::Die is true, use die() to report the error

=back

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2010-2011
