#+##############################################################################
#                                                                              #
# File: Net/STOMP/Client/Protocol.pm                                           #
#                                                                              #
# Description: Protocol support for Net::STOMP::Client                         #
#                                                                              #
#-##############################################################################

#
# module definition
#

package Net::STOMP::Client::Protocol;
use strict;
use warnings;
our $VERSION  = "1.0";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.12 $ =~ /(\d+)\.(\d+)/);

#
# export control
#

use Exporter;
our(@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
@ISA = qw(Exporter);
@EXPORT = qw();
@EXPORT_OK = qw();
%EXPORT_TAGS = (
    "CONSTANTS" => [qw(
        ANY_VERSION
        FLAG_BODY_MANDATORY FLAG_BODY_FORBIDDEN FLAG_BODY_ANY FLAG_BODY_MASK
        FLAG_DIRECTION_C2S FLAG_DIRECTION_S2C FLAG_DIRECTION_ANY FLAG_DIRECTION_MASK
        FLAG_FIELD_OPTIONAL FLAG_FIELD_MANDATORY FLAG_FIELD_MASK 
        FLAG_TYPE_UNKNOWN FLAG_TYPE_BOOLEAN FLAG_TYPE_INTEGER FLAG_TYPE_LENGTH FLAG_TYPE_MASK
    )],
    "VARIABLES" => [qw(%CommandFlags %CommandCheck %FieldFlags %FieldCheck)],
);
Exporter::export_tags();

#
# used modules
#

use Net::STOMP::Client::Error;

#
# constants
#

use constant ANY_VERSION => "*";

use constant FLAG_BODY_MANDATORY  => 1;
use constant FLAG_BODY_FORBIDDEN  => 2;
use constant FLAG_BODY_ANY        => 3;
use constant FLAG_BODY_MASK
    => (FLAG_BODY_MANDATORY|FLAG_BODY_FORBIDDEN|FLAG_BODY_ANY);

use constant FLAG_DIRECTION_C2S   => 1 << 2;
use constant FLAG_DIRECTION_S2C   => 2 << 2;
use constant FLAG_DIRECTION_ANY   => 3 << 2;
use constant FLAG_DIRECTION_MASK
    => (FLAG_DIRECTION_C2S|FLAG_DIRECTION_S2C|FLAG_DIRECTION_ANY);

use constant FLAG_FIELD_OPTIONAL  => 1;
use constant FLAG_FIELD_MANDATORY => 2;
use constant FLAG_FIELD_MASK
    => (FLAG_FIELD_OPTIONAL|FLAG_FIELD_MANDATORY);

use constant FLAG_TYPE_UNKNOWN    => 0 << 2;
use constant FLAG_TYPE_BOOLEAN    => 1 << 2;
use constant FLAG_TYPE_INTEGER    => 2 << 2;
use constant FLAG_TYPE_LENGTH     => 3 << 2;
use constant FLAG_TYPE_MASK
    => (FLAG_TYPE_UNKNOWN|FLAG_TYPE_BOOLEAN|FLAG_TYPE_INTEGER|FLAG_TYPE_LENGTH);

#
# global variables
#

our(
    %CommandFlags,		# version x command => flags
    %CommandCheck,		# version x command => checking code
    %FieldFlags,		# version x command x filed => flags
    %FieldCheck,		# version x command x filed => checking regexp or code
);

#
# references:
#  - STOMP 1.0: http://stomp.codehaus.org/Protocol
#  - STOMP 1.1: http://stomp.github.com/stomp-specification-1.1.html
#

#
# known commands for both STOMP 1.0 and STOMP 1.1
#

# client -> server (only SEND can have a body)
foreach my $command (qw(CONNECT SEND SUBSCRIBE UNSUBSCRIBE
                        BEGIN COMMIT ABORT ACK DISCONNECT)) {
    $CommandFlags{ANY_VERSION()}{$command} =
	FLAG_DIRECTION_C2S |
        ($command =~ /^(SEND)$/ ? FLAG_BODY_ANY : FLAG_BODY_FORBIDDEN);
}

# server -> client (only MESSAGE and ERROR can have a body)
foreach my $command (qw(CONNECTED MESSAGE RECEIPT ERROR)) {
    $CommandFlags{ANY_VERSION()}{$command} =
	FLAG_DIRECTION_S2C |
        ($command =~ /^(MESSAGE|ERROR)$/ ? FLAG_BODY_ANY : FLAG_BODY_FORBIDDEN);
}

# STOMP 1.1 extensions
$CommandFlags{"1.1"}{NACK} = FLAG_DIRECTION_C2S | FLAG_BODY_FORBIDDEN;

#
# known fields for both STOMP 1.0 and STOMP 1.1
#

$FieldFlags{ANY_VERSION()}{CONNECT}{"login"}    = FLAG_FIELD_OPTIONAL;
$FieldFlags{ANY_VERSION()}{CONNECT}{"passcode"} = FLAG_FIELD_OPTIONAL;

$FieldFlags{ANY_VERSION()}{SEND}{"destination"} = FLAG_FIELD_MANDATORY;
$FieldFlags{ANY_VERSION()}{SEND}{"transaction"} = FLAG_FIELD_OPTIONAL;

$FieldFlags{ANY_VERSION()}{SUBSCRIBE}{"destination"} = FLAG_FIELD_MANDATORY;
# nota bene: ack can only contain some values, this is checked elsewhere
$FieldFlags{ANY_VERSION()}{SUBSCRIBE}{"ack"} = FLAG_FIELD_OPTIONAL;
# id is optional in 1.0 but mandatory in 1.1
$FieldFlags{"1.0"}{SUBSCRIBE}{"id"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{"1.1"}{SUBSCRIBE}{"id"} = FLAG_FIELD_MANDATORY;

# nota bene: in 1.0, either destination or id must be present
$FieldFlags{"1.0"}{UNSUBSCRIBE}{"destination"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{"1.0"}{UNSUBSCRIBE}{"id"} = FLAG_FIELD_OPTIONAL;
# however for 1.1, only id can be used and it is mandatory
$FieldFlags{"1.1"}{UNSUBSCRIBE}{"id"} = FLAG_FIELD_MANDATORY;

$FieldFlags{ANY_VERSION()}{BEGIN}{"transaction"} = FLAG_FIELD_MANDATORY;

$FieldFlags{ANY_VERSION()}{COMMIT}{"transaction"} = FLAG_FIELD_MANDATORY;

$FieldFlags{ANY_VERSION()}{ABORT}{"transaction"} = FLAG_FIELD_MANDATORY;

$FieldFlags{ANY_VERSION()}{ACK}{"message-id"}  = FLAG_FIELD_MANDATORY;
$FieldFlags{ANY_VERSION()}{ACK}{"transaction"} = FLAG_FIELD_OPTIONAL;

# DISCONNECT does not have any specific fields

$FieldFlags{ANY_VERSION()}{CONNECTED}{"session"} = FLAG_FIELD_OPTIONAL;

$FieldFlags{ANY_VERSION()}{MESSAGE}{"destination"}  = FLAG_FIELD_MANDATORY;
$FieldFlags{ANY_VERSION()}{MESSAGE}{"message-id"} = FLAG_FIELD_MANDATORY;
# subscription is optional in 1.0 but mandatory in 1.1
$FieldFlags{"1.0"}{MESSAGE}{"subscription"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{"1.1"}{MESSAGE}{"subscription"} = FLAG_FIELD_MANDATORY;

$FieldFlags{ANY_VERSION()}{RECEIPT}{"receipt-id"} = FLAG_FIELD_MANDATORY;

$FieldFlags{ANY_VERSION()}{ERROR}{"message"} = FLAG_FIELD_OPTIONAL;

#
# STOMP 1.1 extensions
#

$FieldFlags{"1.1"}{CONNECT}{"accept-version"} = FLAG_FIELD_MANDATORY;
$FieldFlags{"1.1"}{CONNECT}{"host"}           = FLAG_FIELD_MANDATORY;
$FieldFlags{"1.1"}{CONNECT}{"heart-beat"}     = FLAG_FIELD_OPTIONAL;

$FieldFlags{"1.1"}{CONNECTED}{"version"}    = FLAG_FIELD_MANDATORY;
$FieldFlags{"1.1"}{CONNECTED}{"server"}     = FLAG_FIELD_OPTIONAL;
$FieldFlags{"1.1"}{CONNECTED}{"heart-beat"} = FLAG_FIELD_OPTIONAL;

$FieldFlags{"1.1"}{ACK}{"subscription"} = FLAG_FIELD_MANDATORY;

$FieldFlags{"1.1"}{NACK}{"subscription"} = FLAG_FIELD_MANDATORY;
$FieldFlags{"1.1"}{NACK}{"message-id"}  = FLAG_FIELD_MANDATORY;
$FieldFlags{"1.1"}{NACK}{"transaction"} = FLAG_FIELD_OPTIONAL;

# since these are not explicitly flagged as forbidden in 1.0, we flag them all as optional...
foreach my $command (keys(%{ $FieldFlags{"1.1"} })) {
    foreach my $field (keys(%{ $FieldFlags{"1.1"}{$command} })) {
	$FieldFlags{ANY_VERSION()}{$command}{$field} ||= FLAG_FIELD_OPTIONAL;
    }
}

#
# standard STOMP 1.0 or 1.1 fields
#

foreach my $version (keys(%CommandFlags)) {
    foreach my $command (keys(%{ $CommandFlags{$version} })) {
	# any frame can have a content-type header
	$FieldFlags{$version}{$command}{"content-type"} = FLAG_FIELD_OPTIONAL;
	# any frame can have a content-length header which must be an integer
	$FieldFlags{$version}{$command}{"content-length"}
	    = FLAG_FIELD_OPTIONAL | FLAG_TYPE_LENGTH;
	# any client frame (except CONNECT) can have a receipt header
	next if ($CommandFlags{$version}{$command} & FLAG_DIRECTION_MASK)
	    == FLAG_DIRECTION_S2C;
	next if $command =~ /^(CONNECT)$/;
	$FieldFlags{$version}{$command}{"receipt"} = FLAG_FIELD_OPTIONAL;
    }
}

#
# STOMP JMS Bindings (http://stomp.codehaus.org/StompJMS)
#

$FieldFlags{ANY_VERSION()}{SUBSCRIBE}{"selector"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{ANY_VERSION()}{SUBSCRIBE}{"no-local"} = FLAG_FIELD_OPTIONAL | FLAG_TYPE_BOOLEAN;
$FieldFlags{ANY_VERSION()}{SUBSCRIBE}{"durable-subscriber-name"} = FLAG_FIELD_OPTIONAL;

#
# STOMP extensions for JMS message semantics (http://activemq.apache.org/stomp.html)
# plus JMSXUserID (http://activemq.apache.org/jmsxuserid.html)
#

foreach my $field (qw(correlation-id expires persistent priority reply-to type
                      JMSXGroupID JMSXGroupSeq JMSXUserID)) {
    my $type = FLAG_TYPE_UNKNOWN;
    $type = FLAG_TYPE_BOOLEAN if $field =~ /^(persistent)$/;
    $type = FLAG_TYPE_INTEGER if $field =~ /^(expires|priority)$/;
    $FieldFlags{ANY_VERSION()}{SEND}{$field}    = FLAG_FIELD_OPTIONAL | $type;
    $FieldFlags{ANY_VERSION()}{MESSAGE}{$field} = FLAG_FIELD_OPTIONAL | $type;
}

#
# ActiveMQ extensions to STOMP (http://activemq.apache.org/stomp.html)
#

$FieldFlags{ANY_VERSION()}{CONNECT}{"client-id"} = FLAG_FIELD_OPTIONAL;
foreach my $field (qw(dispatchAsync exclusive maximumPendingMessageLimit noLocal
		      prefetchSize priority retroactive subscriptionName)) {
    my $type = FLAG_TYPE_UNKNOWN;
    $type = FLAG_TYPE_BOOLEAN
        if $field =~ /^(dispatchAsync|exclusive|noLocal|retroactive)$/;
    $type = FLAG_TYPE_INTEGER
        if $field =~ /^(maximumPendingMessageLimit|prefetchSize|priority)$/;
    $FieldFlags{ANY_VERSION()}{SUBSCRIBE}{$field} = FLAG_FIELD_OPTIONAL | $type;
}

#
# ActiveMQ extensions for advisory messages (http://activemq.apache.org/advisory-message.html)
#

foreach my $field (qw(originBrokerId originBrokerName originBrokerURL orignalMessageId
		      consumerCount producerCount consumerId producerId usageName)) {
    $FieldFlags{ANY_VERSION()}{MESSAGE}{$field} = FLAG_FIELD_OPTIONAL;
}

#
# RabbitMQ extensions to STOMP (http://dev.rabbitmq.com/wiki/StompGateway)
#

$FieldFlags{ANY_VERSION()}{SUBSCRIBE}{"exchange"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{ANY_VERSION()}{SUBSCRIBE}{"routing_key"} = FLAG_FIELD_OPTIONAL;

#
# other undocumented headers :-(
#

$FieldFlags{ANY_VERSION()}{MESSAGE}{"receipt"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{ANY_VERSION()}{MESSAGE}{"redelivered"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{ANY_VERSION()}{MESSAGE}{"timestamp"} = FLAG_FIELD_OPTIONAL;
$FieldFlags{ANY_VERSION()}{MESSAGE}{"JMSXMessageCounter"} = FLAG_FIELD_OPTIONAL;

#
# additional checking specifications
#

$CommandCheck{"1.0"}{UNSUBSCRIBE} = sub ($$$) {
    my($command, $headers, $body) = @_;

    # either destination or id must be given
    unless ($headers->{destination} or $headers->{id}) {
	Net::STOMP::Client::Error::report("%s: missing header key for %s: destination or id",
					  "Net::STOMP::Client::Protocol::check", $command);
	return();
    }
    return(1);
};

$FieldCheck{"1.0"}{SUBSCRIBE}{"ack"} = qr/^(auto|client)$/;
$FieldCheck{"1.1"}{SUBSCRIBE}{"ack"} = qr/^(auto|client|client-individual)$/;

$FieldCheck{"1.1"}{CONNECT}{"heart-beat"} = qr/^\d+,\d+$/;
$FieldCheck{"1.1"}{CONNECTED}{"heart-beat"} = qr/^\d+,\d+$/;

1;

__END__

=head1 NAME

Net::STOMP::Client::Protocol - Protocol support for Net::STOMP::Client

=head1 DESCRIPTION

This module provides protocol support for Net::STOMP::Client. It
contains global variables defining how STOMP frames should look like.

It is used internally by Net::STOMP::Client::Frame and is not expected
to be used elsewhere.

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2010-2011
