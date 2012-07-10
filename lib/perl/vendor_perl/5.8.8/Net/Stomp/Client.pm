#+##############################################################################
#                                                                              #
# File: Net/STOMP/Client.pm                                                    #
#                                                                              #
# Description: STOMP object oriented client module                             #
#                                                                              #
#-##############################################################################

#
# module definition
#

package Net::STOMP::Client;
use strict;
use warnings;
our $VERSION  = "1.0";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.82 $ =~ /(\d+)\.(\d+)/);

#
# used modules
#

use IO::Socket::INET;
use List::Util qw(max shuffle);
use Time::HiRes qw();
use Net::STOMP::Client::Debug;
use Net::STOMP::Client::Error;
use Net::STOMP::Client::Frame;
use Net::STOMP::Client::IO;
use Net::STOMP::Client::Peer;
use Net::STOMP::Client::Protocol qw(FLAG_DIRECTION_C2S FLAG_DIRECTION_S2C);

#
# Object Oriented definition
#

use Net::STOMP::Client::OO;
our(@ISA) = qw(Net::STOMP::Client::OO);
Net::STOMP::Client::OO::methods(qw(
    uri host port timeout sockopts callbacks peer session
    client_heart_beat server_heart_beat
    _io _id _serial _receipts _version
));

#
# global variables
#

our(
    %Callback,			# default callbacks for the class
);

#+++############################################################################
#                                                                              #
# low-level API                                                                #
#                                                                              #
#---############################################################################

#
# return which timeout to use for the given operation
#

sub _timeout : method {
    my($self, $operation) = @_;
    my($timeout);

    $timeout = $self->timeout();
    if ($timeout) {
	if (ref($timeout) eq "HASH") {
	    # hash timeout specified -> use it as is
	} else {
	    # scalar timeout specified -> backward compatibility
	    $timeout = {
		connect   => $timeout,
		connected => $timeout,
		send      => undef,
	    };
	}
    } else {
	# no timeout specified -> use hard-coded defaults
	$timeout = {
	    connect   => undef,
	    connected => 10,
	    send      => undef,
	};
    }
    unless ($operation =~ /^(connect|connected|send)$/) {
	Net::STOMP::Client::Error::repor("%s: unexpected timeout operation: %s",
					 "Net::STOMP::Client", $operation);
	return();
    }
    return($timeout->{$operation});
}

#
# try to connect to the server (socket level only)
#

sub _new_socket ($$$$%) {
    my($me, $proto, $host, $port, %sockopts) = @_;
    my($socket);

    # initial checks
    $sockopts{Proto} = "tcp"; # yes, even SSL is TCP...
    $sockopts{PeerAddr} = $host;
    $sockopts{PeerPort} = $port;
    # from now on, the errors are non-fatal and checked by the caller...
    local $Net::STOMP::Client::Error::Die = 0;
    # try to connect
    if ($proto =~ /\b(ssl)\b/) {
	# with SSL
	unless ($INC{"IO/Socket/SSL.pm"}) {
	    eval { require IO::Socket::SSL };
	    if ($@) {
		Net::STOMP::Client::Error::report("%s: cannot load IO::Socket::SSL: %s",
						  $me, $@);
		return();
	    }
	}
	$socket = IO::Socket::SSL->new(%sockopts);
	unless ($socket) {
	    Net::STOMP::Client::Error::report("%s: cannot SSL connect to %s:%d: %s",
				      $me, $sockopts{PeerAddr}, $sockopts{PeerPort},
				      IO::Socket::SSL::errstr());
	    return();
	}
    } else {
	# with TCP
	$socket = IO::Socket::INET->new(%sockopts);
	unless ($socket) {
	    Net::STOMP::Client::Error::report("%s: cannot connect to %s:%d: %s",
				      $me, $sockopts{PeerAddr}, $sockopts{PeerPort}, $!);
	    return();
	}
	unless (binmode($socket)) {
	    Net::STOMP::Client::Error::report("%s: cannot binmode(socket): %s", $me, $!);
	    return();
	}
    }
    # so far so good...
    return($socket);
}

#
# check and handle the uri option
#
# see: http://activemq.apache.org/failover-transport-reference.html
#

sub _handle_uri ($$) {
    my($me, $string) = @_;
    my(@uris, $uri, $path, $fh, $line, @list, @peers);

    @uris = ($string);
    while (@uris) {
	$uri = shift(@uris);
	if ($uri =~ /^file:(.+)$/) {
	    # list of uris stored in a file, one per line
	    @list = ();
	    $path = $1;
	    unless (open($fh, "<", $path)) {
		Net::STOMP::Client::Error::report("%s: cannot open %s: %s", $me, $path, $!);
		return();
	    }
	    while (defined($line = <$fh>)) {
		$line =~ s/\#.*//;
		$line =~ s/\s+//g;
		push(@list, $line) if length($line);
	    }
	    unless (close($fh)) {
		Net::STOMP::Client::Error::report("%s: cannot close %s: %s", $me, $path, $!);
		return();
	    }
	    unshift(@uris, @list);
	} elsif ($uri =~ /^failover:(\/\/)?\(([\w\.\-\:\/\,]+)\)(\?[\w\=\-\&]+)?$/) {
	    # failover with options (only "randomize" is supported)
	    @list = split(/,/, $2);
	    @list = shuffle(@list) unless $3 and $3 =~ /\b(randomize=false)\b/;
	    unshift(@uris, @list);
	} elsif ($uri =~ /^failover:([\w\.\-\:\/\,]+)$/) {
	    # failover without options (randomized by default)
	    @list = split(/,/, $1);
	    unshift(@uris, shuffle(@list));
	} elsif ($uri =~ /^(tcp|ssl|stomp|stomp\+ssl):\/\/([\w\.\-]+):(\d+)\/?$/) {
	    # well-formed uri
	    push(@peers, Net::STOMP::Client::Peer->new(
		proto => $1,
		host  => $2,
		port  => $3,
	    ));
	} else {
	    Net::STOMP::Client::Error::report("%s: unexpected server uri: %s", $me, $string);
	    return();
	}
    }
    unless (@peers) {
	Net::STOMP::Client::Error::report("%s: empty server uri: %s", $me, $string);
	return();
    }
    return(@peers);
}

#
# check the version option
#

sub _check_version ($$) {
    my($me, $version) = @_;
    my(@list);

    if (defined($version)) {
	if (ref($version) eq "ARRAY") {
	    @list = sort(@$version);
	} else {
	    @list = ($version);
	}
    } else {
	# default versions to use
	@list = qw(1.0 1.1);
    }
    unless (@list) {
	Net::STOMP::Client::Error::report("%s: empty list of STOMP versions given", $me);
	return();
    }
    foreach $version (@list) {
	unless ($version =~ /^1\.[01]$/) {
	    Net::STOMP::Client::Error::report("%s: unsupported STOMP version: %s",
					      $me, $version);
	    return();
	}
    }
    # modify the given version argument
    $_[1] = \@list;
    return(1);
}

#
# create a new Net::STOMP::Client object and connect to the server (socket level only)
#

sub new : method {
    my($class, %data) = @_;
    my($me, $self, %sockopts, $timeout, @uris, $uri, @peers, $peer, $socket, $io, $version);

    $me = "Net::STOMP::Client->new()";
    $version = delete($data{version});
    $self = $class->SUPER::new(%data);
    _check_version($me, $version) or return();
    $self->_version($version);
    %sockopts = %{ $self->sockopts() } if $self->sockopts();
    $sockopts{SSL_use_cert} = 1 if $sockopts{SSL_cert_file} or $sockopts{SSL_key_file};
    unless (exists($sockopts{Timeout})) {
	$timeout = $self->_timeout("connect");
	$sockopts{Timeout} = $timeout if $timeout;
    }
    if ($self->uri()) {
	if ($self->host()) {
	    Net::STOMP::Client::Error::report("%s: unexpected server host: %s",
					      $me, $self->host());
	    return();
	}
	if ($self->port()) {
	    Net::STOMP::Client::Error::report("%s: unexpected server port: %s",
					      $me, $self->port());
	    return();
	}
	@peers = _handle_uri($me, $self->uri());
	return() unless @peers;
	# use by default a shorter timeout in case we use failover...
	if (@peers > 1 and not $sockopts{Timeout}) {
	    # it makes no sense to block with failover!
	    $sockopts{Timeout} = 3;
	}
    } else {
	unless ($self->host()) {
	    Net::STOMP::Client::Error::report("%s: missing server host", $me);
	    return();
	}
	unless ($self->port()) {
	    Net::STOMP::Client::Error::report("%s: missing server port", $me);
	    return();
	}
	@peers = (Net::STOMP::Client::Peer->new(
	    proto => grep(/^SSL_/, keys(%sockopts)) ? "ssl" : "tcp",
	    host  => $self->host(),
	    port  => $self->port(),
	));
    }
    foreach $peer (@peers) {
	$socket = _new_socket($me, $peer->proto(), $peer->host(), $peer->port(), %sockopts);
	if ($socket) {
	    # keep track of the peer we are connected to
	    $peer->addr($socket->peerhost()); # real peer address
	    $self->peer($peer);
	    last;
	}
    }
    unless ($socket) {
	Net::STOMP::Client::Error::report("%s", $Net::STOMP::Client::Error::Message);
	return();
    }
    # final setup steps
    if ($self->uri()) {
	# keep track of the peer this way too...
	$peer = $self->peer();
	$self->host($peer->host());
	$self->port($peer->port());
    }
    $io = Net::STOMP::Client::IO->new($socket) or return();
    $self->_io($io);
    unless ($self =~ /\(0x(\w+)\)/) {
	Net::STOMP::Client::Error::report("%s: unexpected Perl object: %s", $me, $self);
	return();
    }
    $self->_id(sprintf("%s-%x-%x-%x", $1, time(), $$, int(rand(65536))));
    $self->_serial(0);
    $self->_receipts({});
    $self->callbacks({});
    return($self);
}

#
# try to send one frame (the frame is always checked, this is currently a feature)
#
# if the frame has a "receipt" header, its value will be remembered to be used
# later in _default_receipt_callback() and/or wait_for_receipts()
#

sub send_frame : method {
    my($self, $frame, $timeout) = @_;
    my($done, $receipt);

    # check that the object is usable
    Net::STOMP::Client::Error::report("lost connection")
	unless $self->_io();
    # handle global send timeout
    $timeout = $self->_timeout("send") unless defined($timeout);
    if (ref($frame)) {
	# always check the sent frame
	$frame->check(
	    version   => $self->version(),
	    direction => FLAG_DIRECTION_C2S,
	) or return();
	# keep track of receipts
	$receipt = $frame->header("receipt");
	$self->_receipts()->{$receipt}++ if $receipt;
	# encode the frame and send it
	$frame->debug(" sending") if $Net::STOMP::Client::Debug::Flags;
	$done = $self->_io()->send_data($frame->_encode($self->version()), $timeout);
    } else {
	# handle the special NOOP frame
	$done = $self->_io()->send_data($frame, $timeout);
    }
    return($done) unless $done;
    return($frame);
}

#
# try to receive one frame (the frame is always checked, this is currently a feature)
#

sub receive_frame : method {
    my($self, $timeout) = @_;
    my($version, $buffer, $done, $frame);

    # check that the object is usable
    Net::STOMP::Client::Error::report("lost connection")
	unless $self->_io();
    # first try to use the current buffer
    $version = $self->version();
    $buffer = $self->_io()->_incoming_buffer();
    $frame = Net::STOMP::Client::Frame::_decode($buffer, $version);
    return() unless defined($frame);
    unless ($frame) {
	# not enough data in buffer for a complete frame
	$done = $self->_io()->receive_data($timeout);
	return($done) unless $done;
	$buffer = $self->_io()->_incoming_buffer();
	# try once more with new buffer
	$frame = Net::STOMP::Client::Frame::_decode($buffer, $version);
	return() unless defined($frame);
	unless ($frame) {
	    # update the buffer (which may have changed)
	    $self->_io()->_incoming_buffer($buffer);
	    return(0);
	}
    }
    # update the buffer (which must have changed)
    $self->_io()->_incoming_buffer($buffer);
    # always check the received frame
    $frame->check(
	version   => $self->version(),
	direction => FLAG_DIRECTION_S2C,
    ) or return();
    # so far so good
    $frame->debug(" received") if $Net::STOMP::Client::Debug::Flags;
    return($frame);
}

#
# wait for new frames and dispatch them (see POD for more information)
#

sub wait_for_frames : method {
    my($self, %option) = @_;
    my($callback, $timeout, $limit, $timeleft, $frame, $result, $now);

    $callback = $option{callback};
    $timeout = $option{timeout};
    if (defined($timeout)) {
	$limit = Time::HiRes::time() + $timeout;
	$timeleft = $timeout;
    }
    while (1) {
	$frame = $self->receive_frame($timeleft);
	return() unless defined($frame);
	if ($frame) {
	    # we always call first the per-command callback
	    $result = $self->dispatch_frame($frame);
	    return() unless defined($result);
	    if ($callback) {
		# user callback: we stop if callback returns error or true or if once
		$result = $callback->($self, $frame);
		return($result) if not defined($result) or $result or $option{once};
	    } else {
		# no user callback: we stop on the first frame and return it
		return($frame);
	    }
	}
	# we check if we exceeded the timeout
	if (defined($timeout)) {
	    $now = Time::HiRes::time();
	    return(0) if $now >= $limit;
	    $timeleft = $limit - $now;
	}
    }
    # not reached...
    die("ooops!");
}

#
# wait for all receipts to be received
#

sub wait_for_receipts : method {
    my($self, %option) = @_;
    my($callback);

    return(0) unless $self->receipts();
    $option{callback} = sub { return($self->receipts() == 0) };
    return($self->wait_for_frames(%option));
}

#
# return the socket used
#

sub socket : method {
    my($self) = @_;

    return($self->_io()->_socket());
}

#
# return the negotiated protocol version (or undef if not negotiated yet)
#

sub version : method {
    my($self) = @_;
    my($version);

    $version = $self->_version();
    return($version) unless ref($version);
    return(undef);
}
#
# return a universal pseudo-unique id to be used in receipts and transactions
#

sub uuid : method {
    my($self) = @_;

    $self->_serial($self->_serial() + 1);
    return(sprintf("%s-%x", $self->_id(), $self->_serial()));
}

#
# return the list of not-yet-received receipts
#

sub receipts : method {
    my($self) = @_;

    return(keys(%{ $self->_receipts() }));
}

#
# return the last time we received data
#

sub last_received : method {
    my($self) = @_;

    return($self->_io() ? $self->_io()->_last_read() : undef);
}

#
# return the last time we sent data
#

sub last_sent : method {
    my($self) = @_;

    return($self->_io() ? $self->_io()->_last_write() : undef);
}

#
# object destructor
#

sub DESTROY {
    my($self) = @_;

    # try to disconnect gracefully if possible
    $self->disconnect() if $self->session() and $self->_io();
}

#+++############################################################################
#                                                                              #
# callback handling                                                            #
#                                                                              #
#---############################################################################

#
# user-friendly accessors for the callbacks
#

sub _any_callback : method {
    my($self, $command, $callback) = @_;
    my($callbacks);

    $callbacks = $self->callbacks() || {};
    return($callbacks->{$command})
	unless $callback;
    $callbacks->{$command} = $callback;
    $self->callbacks($callbacks);
    return($callback);
}

sub connected_callback : method {
    my($self, $callback) = @_;

    return($self->_any_callback("CONNECTED", $callback));
}

sub error_callback : method {
    my($self, $callback) = @_;

    return($self->_any_callback("ERROR", $callback));
}

sub message_callback : method {
    my($self, $callback) = @_;

    return($self->_any_callback("MESSAGE", $callback));
}

sub receipt_callback : method {
    my($self, $callback) = @_;

    return($self->_any_callback("RECEIPT", $callback));
}

#
# report an error about an unexpected server frame received
#

sub _unexpected_frame ($$) {
    my($frame, $info) = @_;

    $info ||= "?";
    Net::STOMP::Client::Error::report("unexpected %s frame received: %s",
				      $frame->command(), $info);
}

#
# default CONNECTED frame callback: keep track of the negotiated
# protocol version as well as the session identifier
#

sub _default_connected_callback ($$) {
    my($self, $frame) = @_;
    my($value);

    # STOMP 1.1: handle version negotiation
    $value = $frame->header("version");
    if ($value) {
	if (grep($_ eq $value, @{ $self->_version() })) {
	    $self->_version($value);
	} else {
	    _unexpected_frame($frame, "unexpected STOMP version: $value");
	    return();
	}
    } else {
	$value = "1.0";
	if (grep($_ eq $value, @{ $self->_version() })) {
	    $self->_version($value);
	} else {
	    _unexpected_frame($frame, "server only supports STOMP $value");
	    return();
	}
    }
    # STOMP 1.1: handle heart-beat negotiation
    $value = $frame->header("heart-beat");
    if ($value) {
	if ($value =~ /^(\d+),(\d+)$/) {
	    if ($self->client_heart_beat() and $2) {
		# negotiated
		$self->client_heart_beat(max($self->client_heart_beat(), $2 / 1000.0));
	    } else {
		# disabled
		$self->client_heart_beat(0);
	    }
	    if ($self->server_heart_beat() and $1) {
		# negotiated
		$self->server_heart_beat(max($self->server_heart_beat(), $1 / 1000.0));
	    } else {
		# disabled
		$self->server_heart_beat(0);
	    }
	} else {
	    _unexpected_frame($frame, "unexpected heart-beat setting: $value");
	    return();
	}
    } else {
	# missing value -> disable
	$self->client_heart_beat(0);
	$self->server_heart_beat(0);
    }
    # keep track of session id too
    unless ($self->session()) {
	$self->session($frame->header("session"));
	return($self);
    }
    _unexpected_frame($frame, $frame->header("session"));
    return();
}
$Callback{CONNECTED} = \&_default_connected_callback;

#
# default ERROR frame callback: report the error using Net::STOMP::Client::Error::report()
#

sub _default_error_callback ($$) {
    my($self, $frame) = @_;

    _unexpected_frame($frame, $frame->header("message"));
    return();
}
$Callback{ERROR} = \&_default_error_callback;

#
# default MESSAGE frame callback: complain (this must be overwritten by the caller)
#

sub _default_message_callback ($$) {
    my($self, $frame) = @_;

    _unexpected_frame($frame, $frame->header("message-id"));
    return();
}
$Callback{MESSAGE} = \&_default_message_callback;

#
# default RECEIPT frame callback: keep track of received receipts
#
# note: the send_frame() method keeps track of sent receipts
#

sub _default_receipt_callback ($$) {
    my($self, $frame) = @_;
    my($receipts, $id);

    $receipts = $self->_receipts();
    $id = $frame->header("receipt-id");
    if ($receipts and $id and $receipts->{$id}) {
	# good: this is an expected receipt
	delete($receipts->{$id});
	return($self);
    }
    _unexpected_frame($frame, $id);
    return();
}
$Callback{RECEIPT} = \&_default_receipt_callback;

#
# dispatch one received frame, calling the appropriate callback
# (either user supplied or per-class default)
#

sub dispatch_frame : method {
    my($self, $frame) = @_;
    my($command, $callbacks, $callback);

    $command = $frame->command();
    $callbacks = $self->callbacks() || {};
    $callback = $callbacks->{$command} || $Callback{$command};
    unless ($callback) {
	_unexpected_frame($frame, "unexpected command");
	return();
    }
    return($callback->($self, $frame));
}

#+++############################################################################
#                                                                              #
# high-level API (each method matches a client command)                        #
#                                                                              #
#---############################################################################

#
# check the method invocation for the high-level API (except connect)
#

sub _check_invocation : method {
    my($self, $argc) = @_;
    my($caller);

    $caller = (caller(1))[3];
    $caller =~ s/^(.+)::/$1->/;
    # debug
    Net::STOMP::Client::Debug::report(Net::STOMP::Client::Debug::API, "%s()", $caller);
    # must be called with a hash
    unless ($argc % 2) {
	Net::STOMP::Client::Error::report("%s(): wrong invocation", $caller);
	return();
    }
    # must be called after connection
    unless ($self->session()) {
	Net::STOMP::Client::Error::report("%s(): not connected", $caller);
	return();
    }
    # so far so good
    return($self);
}

#
# connect to server
#

sub connect : method {
    my($self, %option) = @_;
    my($me, $frame, $timeout, @list, $session);

    $me = "Net::STOMP::Client->connect()";
    # debug
    Net::STOMP::Client::Debug::report(Net::STOMP::Client::Debug::API, "%s", $me);
    # must be called with a hash
    unless (scalar(@_) % 2) {
	Net::STOMP::Client::Error::report("%s: wrong invocation", $me);
	return();
    }
    # must be called before connection
    if ($self->session()) {
	Net::STOMP::Client::Error::report("%s: already connected with session: %s",
					  $me, $self->session());
	return();
    }
    # so far so good
    $timeout = delete($option{timeout});
    if (grep($_ eq "1.1", @{ $self->_version() })) {
	# supply additional STOMP 1.1 headers
	$option{"accept-version"} = join(",", @{ $self->_version() })
	    unless defined($option{"accept-version"});
	$option{host} = $self->host()
	    unless defined($option{host});
	unless (defined($option{"heart-beat"})) {
	    @list = ();
	    # the protocol expects values in milliseconds...
	    push(@list, int(($self->client_heart_beat() || 0) * 1000.0 + 0.5));
	    push(@list, int(($self->server_heart_beat() || 0) * 1000.0 + 0.5));
	    $option{"heart-beat"} = join(",", @list)
		unless "@list" eq "0 0";
	}
    }
    $frame = Net::STOMP::Client::Frame->new(
	command => "CONNECT",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    $session = $self->wait_for_frames(
	callback => sub { return($self->session()) },
	timeout  => $self->_timeout("connected"),
    );
    return($self) if $session;
    Net::STOMP::Client::Error::report("Net::STOMP::Client->connect(): %s",
				      "no CONNECTED frame received");
    return();
}

#
# disconnect from server
#

sub disconnect : method {
    my($self, %option) = @_;
    my($frame, $timeout);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # send a DISCONNECT frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "DISCONNECT",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    # additional bookkeeping
    $self->session("");
    $self->peer(undef);
    $self->_io(undef);
    return($self);
}

#
# subscribe to something
#

sub subscribe : method {
    my($self, %option) = @_;
    my($frame, $timeout);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # send a SUBSCRIBE frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "SUBSCRIBE",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# unsubscribe from something
#

sub unsubscribe : method {
    my($self, %option) = @_;
    my($frame, $timeout);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # send an UNSUBSCRIBE frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "UNSUBSCRIBE",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# send a message somewhere
#

sub send : method {
    my($self, %option) = @_;
    my($frame, $timeout, $body);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    $body = delete($option{body});
    # send a SEND frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "SEND",
	headers => \%option,
    );
    $frame->body($body) if defined($body);
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# acknowledge the reception of a message
#

sub ack : method {
    my($self, %option) = @_;
    my($frame, $timeout, $value);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # we can optionally give a MESSAGE frame here
    if ($option{frame}) {
	# we are careful in case the frame is not a MESSAGE frame...
	$value = $option{frame}->header("message-id");
	$option{"message-id"} = $value if defined($value);
	$value = $option{frame}->header("subscription");
	$option{"subscription"} = $value if defined($value);
	delete($option{frame});
    }
    # send an ACK frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "ACK",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# acknowledge the rejection of a message
#

sub nack : method {
    my($self, %option) = @_;
    my($frame, $timeout, $value);

    $self->_check_invocation(scalar(@_)) or return();
    if ($self->version() eq "1.0") {
	Net::STOMP::Client::Error::report("Net::STOMP::Client->nack(): %s %s",
					  "not supported for STOMP", $self->version());
	return();
    }
    $timeout = delete($option{timeout});
    # we can optionally give a MESSAGE frame here
    if ($option{frame}) {
	# we are careful in case the frame is not a MESSAGE frame...
	$value = $option{frame}->header("message-id");
	$option{"message-id"} = $value if defined($value);
	$value = $option{frame}->header("subscription");
	$option{"subscription"} = $value if defined($value);
	delete($option{frame});
    }
    # send an NACK frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "NACK",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# begin/start a transaction
#

sub begin : method {
    my($self, %option) = @_;
    my($frame, $timeout);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # send a BEGIN frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "BEGIN",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# commit a transaction
#

sub commit : method {
    my($self, %option) = @_;
    my($frame, $timeout);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # send a COMMIT frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "COMMIT",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# abort/rollback a transaction
#

sub abort : method {
    my($self, %option) = @_;
    my($frame, $timeout);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # send an ABORT frame
    $frame = Net::STOMP::Client::Frame->new(
	command => "ABORT",
	headers => \%option,
    );
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# send an empty/noop frame (= a single newline byte)
#

sub noop : method {
    my($self, %option) = @_;
    my($frame, $timeout);

    $self->_check_invocation(scalar(@_)) or return();
    $timeout = delete($option{timeout});
    # there is no NOOP frame (yet) so we simply send a newline
    $frame = "\n";
    $self->send_frame($frame, $timeout) or return();
    return($self);
}

#
# idem but only if needed wrt heart-beat settings
#

sub beat : method {
    my($self, %option) = @_;
    my($delta, $sent);

    $self->_check_invocation(scalar(@_)) or return();
    # check if client heart-beats are expected
    $delta = $self->client_heart_beat();
    return($self) unless $delta;
    # check the last time we sent data
    $sent = $self->last_sent();
    return($self) if Time::HiRes::time() - $sent < $delta / 2;
    # send a noop frame
    return($self->noop(%option));
}

1;

__END__

=head1 NAME

Net::STOMP::Client - STOMP object oriented client module

=head1 SYNOPSIS

  #
  # simple producer
  #

  use Net::STOMP::Client;

  $stomp = Net::STOMP::Client->new(host => "127.0.0.1", port => 61613);
  $stomp->connect(login => "guest", passcode => "guest");
  $stomp->send(destination => "/queue/test", body => "hello world!");
  $stomp->disconnect();

  #
  # consumer with client side acknowledgment
  #

  use Net::STOMP::Client;

  $stomp = Net::STOMP::Client->new(host => "127.0.0.1", port => 61613);
  $stomp->connect(login => "guest", passcode => "guest");
  # declare a callback to be called for each received message frame
  $stomp->message_callback(sub {
      my($self, $frame) = @_;

      $self->ack(frame => $frame);
      printf("received: %s\n", $frame->body());
      return($self);
  });
  # subscribe to the given queue
  $stomp->subscribe(destination => "/queue/test", ack => "client");
  # wait for a specified message frame
  $stomp->wait_for_frames(callback => sub {
      my($self, $frame) = @_;

      if ($frame->command() eq "MESSAGE") {
          # stop waiting for new frames if body is "quit"
          return(1) if $frame->body() eq "quit";
      }
      # continue to wait for more frames
      return(0);
  });
  $stomp->unsubscribe(destination => "/queue/test");
  $stomp->disconnect();

=head1 DESCRIPTION

This module provides an object oriented client interface to interact
with servers supporting STOMP (Streaming Text Orientated Messaging
Protocol). It supports the major features of modern messaging brokers:
SSL, asynchronous I/O, receipts and transactions.

=head1 CONSTRUCTOR

The new() method can be used to create a Net::STOMP::Client object that will
later be used to interact with a server. The following attributes are
supported:

=over

=item C<version>

the STOMP version to use (string) or versions to use (reference to a
list of strings); this defaults to the list of all supported versions

=item C<uri>

the Uniform Resource Identifier (URI) specifying where the STOMP
service is and how to connect to it, this can be for instance
C<tcp://msg01:6163> or something more complex such as
C<failover:(ssl://msg01:6162,tcp://msg01:6163)>

=item C<host>

the server name or IP address

=item C<port>

the port number of the STOMP service

=item C<timeout>

the maximum time (in seconds) for various operations, see the L</"TIMEOUTS">
section for more information

=item C<sockopts>

arbitrary socket options (as a hash reference) that will be passed to
IO::Socket::INET->new() or IO::Socket::SSL->new()

=item C<callbacks>

a hash of code references that will be called on each received frame

=item C<client_heart_beat>

the desired client-side heart-beat setting, see the L</"HEART-BEATING">
section for more information

=item C<server_heart_beat>

the desired server-side heart-beat setting, see the L</"HEART-BEATING">
section for more information

=back

Upon object creation, a TCP connection is made to the server but no
data (i.e. STOMP frame) is exchanged.

=head1 SSL

When creating an object with Net::STOMP::Client->new(), if you supply some
socket options (via C<sockopts>) with a name starting with C<SSL_>,
or if you supply a URI (via C<uri>) with a scheme containg C<ssl>,
L<IO::Socket::SSL> will be used to create the socket instead of
L<IO::Socket::INET> and the communication with the server will then
go through SSL.

Here are the most commonly used SSL socket options:

=over

=item SSL_ca_path

path to a directory containing several trusted certificates as
separate files as well as an index of the certificates

=item SSL_key_file

path of your RSA private key

=item SSL_cert_file

path of your certificate

=item SSL_passwd_cb

subroutine that should return the password required to decrypt your
private key

=back

For more information, see L<IO::Socket::SSL>.

=head1 TIMEOUTS

By default, when sending STOMP frames, the module waits until the
frame indeed has been sent (from the socket point of view). In case
the server is stuck or unusable, the module can therefore hang.

When creating the Net::STOMP::Client object, you can pass a C<timeout>
attribute to better control how certain operations handle timeouts.

This attribute should contain a reference to hash with the following
keys:

=over

=item connect

TCP-level timeout that will be given to the underlying
L<IO::Socket::INET> or L<IO::Socket::SSL> object (default: none)

=item connected

timeout used while waiting for the initial CONNECTED frame from the
broker (default: 10)

=item send

timeout used while trying to send any frame (default: none)

=back

All values are in seconds. No timeout means wait until the operation
succeeds.

As a shortcut, the C<timeout> attribute can also be a scalar. In this
case, only the C<connect> and C<connected> operations use this value.

=head1 STOMP METHODS

With a Net::STOMP::Client object, the following methods can be used to
interact with the server. They match one-to-one the different commands
that a client frame can hold:

=over

=item connect()

connect to server

=item disconnect()

disconnect from server

=item subscribe()

subscribe to something

=item unsubscribe()

unsubscribe from something

=item send()

send a message somewhere

=item ack()

acknowledge the reception of a message

=item nack()

acknowledge the rejection of a message
(STOMP 1.1 only)

=item begin()

begin/start a transaction

=item commit()

commit a transaction

=item abort()

abort/rollback a transaction

=back

All these methods can receive options that will be passed directly as
frame headers. For instance:

  $stomp->subscribe(
      destination => "/queue/test",
      ack         => "client",
  );

Some methods also support other options:

=over

=item send()

C<body>: holds the body of the message to be sent

=item ack()

C<frame>: holds the MESSAGE frame object to ACK

=item nack()

C<frame>: holds the MESSAGE frame object to NACK

=back

Finally, all methods support a C<timeout> option that will be given to
the send_frame() method called internally to send the crafted frame.

=head1 OTHER METHODS

In addition to the STOMP methods, the following ones are also available:

=over

=item new(OPTIONS)

return a new Net::STOMP::Client object

=item peer()

return a Net::STOMP::Client::Peer object containing information about
the connected STOMP server

=item socket()

return the file handle of the socket connecting the client and the server

=item session()

return the session identifier if connected or undef otherwise

=item version()

return the STOMP version that has been negotiated between the client
and the server or undef if the negotiation did not take place yet

=item uuid()

return a universal pseudo-unique identifier to be used for instance in
receipts and transactions

=item receipts()

return the list of not-yet-received receipts, see the L</"RECEIPTS">
section for more information

=item wait_for_frames()

wait for frames coming from the server, see the next section for more
information

=item wait_for_receipts()

wait for all receipts to be received, using wait_for_frames() underneath

=item noop([timeout => TIMEOUT])

send an empty/noop frame i.e. a single newline byte, using
send_frame() underneath

=back

=head1 CALLBACKS

Since STOMP is asynchronous (for instance, C<MESSAGE> frames could be
sent by the server at any time), Net::STOMP::Client uses callbacks to handle
frames. There are in fact two levels of callbacks.

First, there are per-command callbacks that will be called each time a
frame is handled (via the internal method dispatch_frame()). Net::STOMP::Client
implements default callbacks that should be sufficient for all frames
except C<MESSAGE> frames, which should really be handled by the coder.
These callbacks should return undef on error, something else on success.

Here is an example with a callback counting the messages received:

  $stomp->message_callback(sub {
      my($self, $frame) = @_;

      $MessageCount++;
      return($self);
  });

Here are the methods that can be used to get or set these per-command
callbacks:

=over

=item connected_callback([SUBREF])

=item error_callback([SUBREF])

=item message_callback([SUBREF])

=item receipt_callback([SUBREF])

=back

These callbacks are somehow global and it is good practice not to
change them during a session. If you do not need a global message
callback, you can supply the dummy:

  $stomp->message_callback(sub { return(1) });

Then, the wait_for_frames() method takes an optional callback argument
holding some code to be called for each received frame, after the
per-command callback has been called. This can be seen as a local
callback, only valid for the call to wait_for_frames(). This callback
must return undef on error, false if more frames are expected or true
if wait_for_frames() can now stop waiting for new frames and return.

Here are all the options that can be given to wait_for_frames():

=over

=item callback

code to be called for each received frame (see above)

=item timeout

time to wait before giving up, undef means wait forever, this is the
default

=item once

wait only for one frame, within the given timeout

=back

The return value of wait_for_frames() can be: undef in case of error,
false if no suitable frame has been received, the received frame if
there is no user callback or the user callback return value otherwise.

=head1 RECEIPTS

Net::STOMP::Client has built-in support for receipts.

Each time a frame is sent, its C<receipt> header (if supplied) is
remembered.

Each time a C<RECEIPT> frame is received from the server, the
corresponding receipt is ticked off.

The receipts() method can be used to get the list of outstanding
receipts.

The wait_for_receipts() method can be used to wait for all missing
receipts.

Here is sample code to send two messages with receipts and then wait
for both acknowledgments to come back from the server within ten
seconds:

  $stomp->send(
      destination => "/queue/test1",
      body        => "message 1",
      receipt     => $stomp->uuid(),
  );
  $stomp->send(
      destination => "/queue/test2",
      body        => "message 2",
      receipt     => $stomp->uuid(),
  );
  $stomp->wait_for_receipts(timeout => 10);
  die("Not all receipts received!\n") if $stomp->receipts();

=head1 TRANSACTIONS

Here is an example using transactions:

  # create a unique transaction id
  $tid = $stomp->uuid();
  # begin the transaction
  $stomp->begin(transaction => $tid);
  # send two messages as part of this transaction
  $stomp->send(
      destination => "/queue/test1",
      body        => "message 1",
      transaction => $tid,
  );
  $stomp->send(
      destination => "/queue/test2",
      body        => "message 2",
      transaction => $tid,
  );
  # commit the transaction
  $stomp->commit(transaction => $tid);

=head1 HEART-BEATING

STOMP 1.1 defines how each end of a STOMP connection can check if the
other end is alive. To support heart-beating, this module provides the
following methods:

=over

=item last_received()

return the time at which data was last received, i.e. read from the
network socket

=item last_sent()

return the time at which data was last sent, i.e. written to the
network socket

=item client_heart_beat()

(after having received the CONNECTED frame) return the negotiated
client-side heart-beat setting

=item server_heart_beat()

(after having received the CONNECTED frame) return the negotiated
server-side heart-beat setting

=item beat([timeout => TIMEOUT])

send a noop frame (using the noop() method) unless the last sent time
is recent enough with regard to the client heart-beat setting

=back

For consistency with other Perl modules (for instance Time::HiRes),
time is always expressed as a fractional number of seconds.

To use heart-beating, the client must specify the desired
C<client_heart_beat> and/or C<server_heart_beat> attributes when
invoking the new() method. Then, once the CONNECTED frame has been
received, it can get the negotiated values with the methods above.

To prove that it is alive, the client just needs to call the beat()
method.

To check if the server is alive, the client just needs to compare
what is returned by the last_received() and server_heart_beat() methods.

=head1 LOW-LEVEL API

It should be enough to use the high-level API and use, for instance,
the send() method to create a MESSAGE frame and send it in one go.

If you need lower level interaction, you can manipulate frames with
the Net::STOMP::Client::Frame module.

You can also use:

=over

=item $stomp->dispatch_frame(FRAME)

dispatch one received frame by calling the appropriate callback

=item $stomp->send_frame(FRAME, TIMEOUT)

try to send the given frame object within the given TIMEOUT, or
forever if the TIMEOUT is undef

=item $stomp->receive_frame(TIMEOUT)

try to receive a frame within the given TIMEOUT, or forever if the
TIMEOUT is undef

=back

=head1 COMPATIBILITY

This module implements the versions C<1.0> (see
L<http://stomp.github.com/stomp-specification-1.0.html>) and C<1.1>
(see L<http://stomp.github.com/stomp-specification-1.1.html>) of the
protocol as well as well known extensions for JMS, AMQP, ActiveMQ and
RabbitMQ.

It has been successfully tested against both ActiveMQ and RabbitMQ
brokers.

=head1 SEE ALSO

L<IO::Socket::INET>,
L<IO::Socket::SSL>,
L<Net::STOMP::Client::Error>,
L<Net::STOMP::Client::Frame>,
L<Net::STOMP::Client::Peer>,
L<Time::HiRes>.

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2010-2011
