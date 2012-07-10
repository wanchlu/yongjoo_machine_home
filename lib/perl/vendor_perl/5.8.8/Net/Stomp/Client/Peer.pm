#+##############################################################################
#                                                                              #
# File: Net/STOMP/Client/Peer.pm                                               #
#                                                                              #
# Description: Peer support for Net::STOMP::Client                             #
#                                                                              #
#-##############################################################################

#
# module definition
#

package Net::STOMP::Client::Peer;
use strict;
use warnings;
our $VERSION  = "1.0";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.3 $ =~ /(\d+)\.(\d+)/);

#
# Object Oriented definition
#

use Net::STOMP::Client::OO;
our(@ISA) = qw(Net::STOMP::Client::OO);
Net::STOMP::Client::OO::methods(qw(proto host port addr));

#
# additional methods
#

sub uri : method {
    my($self) = @_;

    return(sprintf("%s://%s:%s", $self->proto(), $self->host(), $self->port()));
}

1;

__END__

=head1 NAME

Net::STOMP::Client::Peer - Peer support for Net::STOMP::Client

=head1 SYNOPSIS

  use Net::STOMP::Client;
  $stomp = Net::STOMP::Client->new(host => "127.0.0.1", port => 61613);
  ...
  $peer = $stomp->peer();
  if ($peer) {
      # we are indeed connected to a STOMP server
      printf("server uri is %s\n", $peer->uri());
  }

=head1 DESCRIPTION

This module provides peer support for Net::STOMP::Client.

It is used to keep track of information about the STOMP server
Net::STOMP::Client is connected to.

=head1 METHODS

This module provides the following methods to get information:

=over

=item proto()

protocol

=item host()

host name or address

=item port()

port name or number

=item addr()

host numerical IP address

=item uri()

URI in the form C<PROTO://HOST:PORT>

=back

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2010-2011
