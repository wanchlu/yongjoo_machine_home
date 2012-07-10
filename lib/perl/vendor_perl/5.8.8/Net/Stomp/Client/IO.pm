#+##############################################################################
#                                                                              #
# File: Net/STOMP/Client/IO.pm                                                 #
#                                                                              #
# Description: Input/Output support for Net::STOMP::Client                     #
#                                                                              #
#-##############################################################################

#
# module definition
#

package Net::STOMP::Client::IO;
use strict;
use warnings;
our $VERSION  = "1.0";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.20 $ =~ /(\d+)\.(\d+)/);

#
# Object Oriented definition
#

use Net::STOMP::Client::OO;
our(@ISA) = qw(Net::STOMP::Client::OO);
Net::STOMP::Client::OO::methods(qw(
    _socket _select _error _incoming_buffer _outgoing_buffer _last_read _last_write
));

#
# used modules
#

use Net::STOMP::Client::Debug;
use Net::STOMP::Client::Error;
use IO::Select;
use Time::HiRes qw();
use UNIVERSAL qw();

#
# constants
#

use constant MAX_CHUNK => 8192;

#
# constructor
#

sub new : method {
    my($class, $socket) = @_;
    my($self, $select);

    unless ($socket and UNIVERSAL::isa($socket, "IO::Socket")) {
	Net::STOMP::Client::Error::report("Net::STOMP::Client::IO->new(): missing socket");
	return();
    }
    $self = $class->SUPER::new(_socket => $socket);
    $select = IO::Select->new();
    $select->add($socket);
    $self->_select($select);
    $self->_incoming_buffer("");
    $self->_outgoing_buffer("");
    return($self);
}

#
# destructor to nicely shutdown+close the socket
#
# reference: http://www.perlmonks.org/?node=108244
#

sub DESTROY {
    my($self) = @_;
    my($socket, $ignored);

    $socket = $self->_socket();
    if ($socket) {
	if (ref($socket) eq "IO::Socket::INET") {
	    # this is a plain INET socket: we call shutdown() without checking
	    # if it fails as there is not much that can be done about it...
	    $ignored = shutdown($socket, 2);
	} else {
	    # this must be an IO::Socket::SSL object so it is better not
	    # to call shutdown(), see IO::Socket::SSL's man page for more info
	}
	# the following will cleanly auto-close the socket
	$self->_socket(undef);
    }
}

#
# write data from outgoing buffer to socket
#

sub _buf2sock : method {
    my($self, %option) = @_;
    my($towrite, $maxtime, $chunk, $written, $count, $remaining);

    # we cannot write anything if the socket is in error
    return() if $self->_error();
    # find out how much we should write
    $towrite = length($self->{_outgoing_buffer});
    $towrite = $option{size} if $option{size} and $option{size} < $towrite;
    return(0) unless $towrite > 0;
    # timer starts now
    $maxtime = Time::HiRes::time() + $option{timeout} if $option{timeout};
    # use select() to check if we can write something
    return(0) unless $self->_select()->can_write($option{timeout});
    # try to write, in a loop, until we are done
    $written = 0;
    while (1) {
	# write one chunk
	$chunk = $towrite;
	$chunk = MAX_CHUNK if $chunk > MAX_CHUNK;
	$count = syswrite($self->_socket(), $self->{_outgoing_buffer}, $chunk);
	unless (defined($count)) {
	    $self->_error("cannot syswrite(): $!");
	    return();
	}
	# update where we are
	if ($count) {
	    $self->_last_write(Time::HiRes::time());
	    $written += $count;
	    $towrite -= $count;
	    substr($self->{_outgoing_buffer}, 0, $count) = "";
	}
	# stop if enough has been written
	last if $towrite <= 0;
	# check where we are with timing
	if (not defined($option{timeout})) {
	    # timeout = undef => blocking
	    last unless $self->_select()->can_write();
	} elsif ($option{timeout}) {
	    # timeout <> 0 => try once more if not too late
	    $remaining = $maxtime - Time::HiRes::time();
	    last if $remaining <= 0;
	    last unless $self->_select()->can_write($remaining);
	} else {
	    # timeout = 0 => non-blocking
	    last unless $self->_select()->can_write(0);
	}
    }
    # return what has been written
    return($written);
}

#
# read data from socket to incoming buffer
#

sub _sock2buf : method {
    my($self, %option) = @_;
    my($toread, $maxtime, $chunk, $read, $count, $remaining);

    # we cannot read anything if the socket is in error
    return() if $self->_error();
    # find out how much we should read
    if ($option{size}) {
	$toread = $option{size};
	return(0) unless $toread > 0;
    }
    # timer starts now
    $maxtime = Time::HiRes::time() + $option{timeout} if $option{timeout};
    # use select() to check if we can read something
    return(0) unless $self->_select()->can_read($option{timeout});
    # try to read, in a loop, until we are done
    $read = 0;
    while (1) {
	# read one chunk
	$chunk = $option{size} ? $toread : MAX_CHUNK;
	$chunk = MAX_CHUNK if $chunk > MAX_CHUNK;
	$count = sysread($self->_socket(), $self->{_incoming_buffer}, $chunk,
			 length($self->{_incoming_buffer}));
	unless (defined($count)) {
	    $self->_error("cannot sysread(): $!");
	    return();
	}
	unless ($count) {
	    $self->_error("cannot sysread(): EOF");
	    last if $read;
	    return();
	}
	# update where we are
	$self->_last_read(Time::HiRes::time());
	$read   += $count;
	$toread -= $count if $option{size};
	# stop if enough has been read
	if ($option{size}) {
	    last if $toread <= 0;
	} else {
	    # no minimum size given, we stop as soon we read any data
	    last;
	}
	# check where we are with timing
	if (not defined($option{timeout})) {
	    # timeout = undef => blocking
	    last unless $self->_select()->can_read();
	} elsif ($option{timeout}) {
	    # timeout <> 0 => try once more if not too late
	    $remaining = $maxtime - Time::HiRes::time();
	    last if $remaining <= 0;
	    last unless $self->_select()->can_read($remaining);
	} else {
	    # timeout = 0 => non-blocking
	    last unless $self->_select()->can_read(0);
	}
    }
    # return what has been read
    return($read);
}

#
# try to send the given data
#

sub send_data : method {
    my($self, $buffer, $timeout) = @_;
    my($me, $result);

    $me = "Net::STOMP::Client::IO::send_data()";
    $self->{_outgoing_buffer} .= $buffer;
    $result = $self->_buf2sock(timeout => $timeout);
    unless (defined($result)) {
	Net::STOMP::Client::Error::report("%s: %s", $me, $self->_error());
	return();
    }
    if (length($self->{_outgoing_buffer})) {
	Net::STOMP::Client::Error::report("%s: could not send all data!", $me);
	return();
    }
    Net::STOMP::Client::Debug::report(Net::STOMP::Client::Debug::IO,
				      "  sent %d bytes", $result);
    return($result);
}

#
# try to receive as much data as possible
#
# note: we suck all the available data since we do not know when to stop as we
# have no a priori knowledge on the size of the next frame; this should not be
# a problem in practice
#

sub receive_data : method {
    my($self, $timeout) = @_;
    my($me, $result, $count);

    $me = "Net::STOMP::Client::IO::receive_data()";
    $result = $self->_sock2buf(timeout => $timeout);
    unless (defined($result)) {
	Net::STOMP::Client::Error::report("%s: %s", $me, $self->_error());
	return();
    }
    if ($result) {
	# we did receive some data, try to get more without blocking
	$count = $self->_sock2buf(timeout => 0);
	while ($count) {
	    $result += $count;
	    $count = $self->_sock2buf(timeout => 0);
	}
    }
    Net::STOMP::Client::Debug::report(Net::STOMP::Client::Debug::IO,
				      "  received %d bytes", $result);
    return($result);
}

1;

__END__

=head1 NAME

Net::STOMP::Client::IO - Input/Output support for Net::STOMP::Client

=head1 DESCRIPTION

This module provides Input/Output support for Net::STOMP::Client.

It is used internally by Net::STOMP::Client and is not expected to be
used elsewhere.

=head1 FUNCTIONS

This module provides the following functions and methods:

=over

=item new(SOCKET)

create a new Net::STOMP::Client::IO object

=item send_data(BUFFER[, TIMEOUT])

send the data in the given buffer to the socket

=item receive_data([TIMEOUT])

receive data from the socket and put in the internal buffer

=back

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2010-2011
