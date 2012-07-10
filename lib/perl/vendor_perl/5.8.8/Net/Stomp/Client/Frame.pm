#+##############################################################################
#                                                                              #
# File: Net/STOMP/Client/Frame.pm                                              #
#                                                                              #
# Description: Frame support for Net::STOMP::Client                            #
#                                                                              #
#-##############################################################################

#
# module definition
#

package Net::STOMP::Client::Frame;
use strict;
use warnings;
our $VERSION  = "1.0";
our $REVISION = sprintf("%d.%02d", q$Revision: 1.41 $ =~ /(\d+)\.(\d+)/);

#
# Object Oriented definition
#

use Net::STOMP::Client::OO;
our(@ISA) = qw(Net::STOMP::Client::OO);
Net::STOMP::Client::OO::methods(qw(command headers body));

#
# used modules
#

use Encode qw();
use Net::STOMP::Client::Debug;
use Net::STOMP::Client::Error;
use Net::STOMP::Client::Protocol qw(:CONSTANTS :VARIABLES);

#
# global variables
#

our(
    $DebugBodyLength, # the maximum length of body that will be printed
    $UTF8Header,      # true if header should be UTF-8 encoded/decoded
    $BodyEncode,      # true if body encoding/decoding should be dealt with
    $StrictEncode,    # true if encoding/decoding should be strict
    $CheckLevel,      # level of checking performed by the check() method
    $CommandRE,       # regular expression matching a command
    $HeaderNameRE,    # regular expression matching a header name
    %_EncMap,         # map to backslash-encode some characters in the header
    %_DecMap,         # map to backslash-decode some characters in the header
);

$DebugBodyLength = 256;
$CheckLevel = 2;
$CommandRE = q/[A-Z]{2,16}/;
$HeaderNameRE = q/[_a-zA-Z0-9\-\.]+/;
%_EncMap = ("\n" => "\\n", ":" => "\\c", "\\" => "\\\\");
%_DecMap = reverse(%_EncMap);

#+++############################################################################
#                                                                              #
# basic frame support                                                          #
#                                                                              #
#---############################################################################

#
# convenient header access method (get only)
#

sub header : method {
    my($self, $key) = @_;
    my($headers);

    $headers = $self->headers();
    return() unless $headers;
    return($headers->{$key});
}

#
# guess the encoding to use from the content type
#

sub _encoding ($) {
    my($type) = @_;

    return() unless $type;
    return("UTF-8") if $type =~ /^text\/[\w\-]+$/;
    return($1) if ";$type;" =~ /\;\s*charset=\"?([\w\-]+)\"?\s*\;/;
    return();
}

#
# decode the given string and return a complete frame object, if possible
#
# side effect: in case a frame is successfully found, the given string is
# _modified_ to remove the corresponding encoded frame
#
# return zero if no complete frame is found and undef on error
#

sub _decode ($$) {
    my($string, $version) = @_;
    my($me, $fb, $index, $command, $length, $temp, $headers, $line, $body, $frame);
    my($key, $value, $errors);

    $me = "Net::STOMP::Client::Frame::_decode()";
    $fb = $StrictEncode ? Encode::FB_CROAK : Encode::FB_DEFAULT;
    # newlines are accepted by STOMP as "line noise" to be ignored outside frames
    if ($string =~ /^(\n+)/) {
	# we strip leading newlines
	substr($_[0], 0, length($1)) = "";
	$string = $_[0];
    }
    # look for command
    $index = index($string, "\n", 1);
    return(0) unless $index >= 0;
    # at this point we know we should have at least the command
    # argh! some servers send a spurious newline after the final NULL byte so we
    # may see it at the beginning of the next frame, i.e. here...
    unless ($string =~ /^($CommandRE)\n/o) {
	Net::STOMP::Client::Error::report("%s: invalid or missing command", $me);
	return();
    }
    $command = $1;
    $length = length($command);

    # look for headers
    $index = index($string, "\n\n", $length);
    return(0) unless $index >= 0;
    # at this point we know we should have at least the headers
    $headers = {};
    if ($index > $length) {
	$temp = substr($string, $length + 1, $index - $length - 1);
	# optionally handle UTF-8 header decoding
	if ($UTF8Header or
	    (not defined($UTF8Header) and defined($version) and $version eq "1.1")) {
	    $temp = Encode::decode("UTF-8", $temp, $fb);
	}
	if ($version and $version eq "1.1") {
	    # STOMP 1.1 behavior:
	    #  - header names and values can contain any OCTET except \n or :
	    #  - space is significant in the header
	    #  - "only the first header entry should be used"
	    #  - handle backslash escaping
	    foreach $line (split(/\n/, $temp)) {
		unless ($line =~ /^([^:]+):([^:]*)$/o) {
		    Net::STOMP::Client::Error::report("%s: invalid header: %s", $me, $line);
		    return();
		}
		($key, $value, $errors) = ($1, $2, 0);
		$key   =~ s/(\\.)/$_DecMap{$1}||$errors++/eg;
		$value =~ s/(\\.)/$_DecMap{$1}||$errors++/eg;
		if ($errors) {
		    Net::STOMP::Client::Error::report("%s: invalid header: %s", $me, $line);
		    return();
		}
		$headers->{$key} = $value unless exists($headers->{$key});
	    }
	} else {
	    # STOMP 1.0 behavior:
	    #  - we arbitrarily restrict the header name as a safeguard
	    #  - space is not significant in the header
	    #  - last header wins (not specified explicitly but reasonable default)
	    foreach $line (split(/\n/, $temp)) {
		unless ($line =~ /^($HeaderNameRE)\s*:\s*(.*?)\s*$/o) {
		    Net::STOMP::Client::Error::report("%s: invalid header: %s", $me, $line);
		    return();
		}
		$headers->{$1} = $2;
	    }
	}
    }

    # look for body
    $length = $headers->{"content-length"};
    if (defined($length) and $length =~ /^\d+$/) {
	return(0) unless length($string) >= $index + $length + 3;
	unless (substr($string, $index+2+$length, 1) eq "\0") {
	    Net::STOMP::Client::Error::report("%s: missing NULL byte", $me);
	    return();
	}
    } else {
	$length = index($string, "\0", $index + 2) - $index - 2;
	return(0) unless $length >= 0;
    }
    # at this point we know we should have at least the body
    $body = substr($string, $index + 2, $length);

    # optionally handle body decoding
    if ($BodyEncode or
	(not defined($BodyEncode) and defined($version) and $version eq "1.1")) {
	$temp = _encoding($headers->{"content-type"});
	$body = Encode::decode($temp, $body, $fb) if $temp;
    }

    # build the frame and truncate the given string
    $frame = Net::STOMP::Client::Frame->new(
        command => $command,
	headers => $headers,
	body    => $body,
    );
    substr($_[0], 0, $index + $length + 3) = "";
    # we check immediately for a spurious trailing newline...
    substr($_[0], 0, 1) = "" if length($_[0]) and substr($_[0], 0, 1) eq "\n";

    # so far so good ;-)
    return($frame);
}

#
# encode the given frame object
#

sub _encode : method {
    my($self, $version) = @_;
    my($string, $headers, $body, $fb, $content_length, $key, $value);

    # setup
    $headers = $self->headers();
    $headers = {} unless defined($headers);
    $body = $self->body();
    $body = "" unless defined($body);
    $fb = $StrictEncode ? Encode::FB_CROAK : Encode::FB_DEFAULT;

    # optionally handle body encoding (before content-length handling)
    if ($BodyEncode or
	(not defined($BodyEncode) and defined($version) and $version eq "1.1")) {
	$string = _encoding($headers->{"content-type"});
	$body = Encode::encode($string, $body, $fb) if $string;
    }

    # handle the content-length header
    if (defined($headers->{"content-length"})) {
	# content-length defined: we use it unless it is the empty string
	$content_length = $headers->{"content-length"}
	    unless $headers->{"content-length"} eq "";
    } else {
	# content-length not defined (default behavior): we set it
	# but only if the body is not empty
	$content_length = length($body)
	    unless $body eq "";
    }

    # encode the command and header
    $string = $self->command() . "\n";
    while (($key, $value) = each(%$headers)) {
	next if $key eq "content-length";
	if ($version and $version eq "1.1") {
	    # handle backslash escaping
	    $key   =~ s/([\x0a\x3a\x5c])/$_EncMap{$1}/eg;
	    $value =~ s/([\x0a\x3a\x5c])/$_EncMap{$1}/eg;
	}
	$string .= $key . ":" . $value . "\n";
    }
    if (defined($content_length)) {
	$string .= "content-length:" . $content_length . "\n";
    }

    # optionally handle UTF-8 header encoding
    if ($UTF8Header or
	(not defined($UTF8Header) and defined($version) and $version eq "1.1")) {
	$string = Encode::encode("UTF-8", $string, $fb);
    }

    return("$string\n$body\0");
}

#
# debug the given frame
#

sub debug : method {
    my($self, $what) = @_;
    my($headers, $key, $body, $length, $offset, $line, $ascii, $index, $char);

    if (Net::STOMP::Client::Debug::enabled(Net::STOMP::Client::Debug::FRAME)) {
	$what = "seen" unless $what;
	Net::STOMP::Client::Debug::report(-1, "%s %s frame", $what, $self->command());
    }
    if (Net::STOMP::Client::Debug::enabled(Net::STOMP::Client::Debug::HEADER)) {
	$headers = $self->headers();
	$headers = {} unless defined($headers);
	foreach $key (keys(%$headers)) {
	    Net::STOMP::Client::Debug::report(-1, "  H %s:%s", $key, $headers->{$key});
	}
    }
    if (Net::STOMP::Client::Debug::enabled(Net::STOMP::Client::Debug::BODY)) {
	$body = $self->body();
	$body = "" unless defined($body);
	$length = length($body);
	if ($DebugBodyLength and $length > $DebugBodyLength) {
	    substr($body, $DebugBodyLength) = "";
	    $length = $DebugBodyLength;
	}
	$offset = 0;
	while ($length > 0) {
	    $line = sprintf("%04x", $offset);
	    $ascii = "";
	    foreach $index (0 .. 15) {
		$char = $index < $length ? ord(substr($body, $index, 1)) : undef;
		$line .= " " if ($index & 3) == 0;
		$line .= defined($char) ? sprintf("%02x", $char) : "  ";
		$ascii .= " " if ($index & 3) == 0;
		$ascii .= defined($char) ?
		    sprintf("%c", (0x20 <= $char && $char <= 0x7e) ? $char : 0x2e) : " ";
	    }
	    Net::STOMP::Client::Debug::report(-1, "  B %s %s", $line, $ascii);
	    $offset += 16;
	    $length -= 16;
	    substr($body, 0, 16) = "";
	}
    }
}

#+++############################################################################
#                                                                              #
# frame checking                                                               #
#                                                                              #
#---############################################################################

sub check : method {
    my($self, %option) = @_;
    my($me, $command, $headers, $body, $key, $value, $flags, $type, $check);

    # setup
    return($self) unless $CheckLevel > 0;
    $me = "Net::STOMP::Client::Frame->check()";

    # check the command (basic)
    $command = $self->command();
    unless (defined($command)) {
	Net::STOMP::Client::Error::report("%s: missing command", $me);
	return();
    }
    unless ($command =~ /^($CommandRE)$/o) {
	Net::STOMP::Client::Error::report("%s: invalid command: %s", $me, $command);
	return();
    }

    # check the headers (basic)
    $headers = $self->headers();
    if (defined($headers)) {
	unless (ref($headers) eq "HASH") {
	    Net::STOMP::Client::Error::report("%s: invalid headers: %s", $me, $headers);
	    return();
	}
	foreach $key (keys(%$headers)) {
	    # this is arbitrary but it's used as a safeguard...
	    unless ($key =~ /^($HeaderNameRE)$/o) {
		Net::STOMP::Client::Error::report("%s: invalid header key: %s", $me, $key);
		return();
	    }
	    unless (defined($headers->{$key})) {
		Net::STOMP::Client::Error::report("%s: missing header value: %s", $me, $key);
		return();
	    }
	}
    } else {
	$headers = {};
    }

    # this is all for level 1...
    return($self) unless $CheckLevel > 1;

    # check the command (must be known)
    if (defined($option{version})) {
	$flags = $CommandFlags{$option{version}}{$command} ||
	    $CommandFlags{ANY_VERSION()}{$command};
    } else {
	$flags = $CommandFlags{ANY_VERSION()}{$command};
    }
    unless ($flags) {
	Net::STOMP::Client::Error::report("%s: unknown command: %s", $me, $command);
	return();
    }

    # check that the command matches the direction
    if ($option{direction}) {
	unless (($flags & FLAG_DIRECTION_MASK) == $option{direction}) {
	    Net::STOMP::Client::Error::report("%s: unexpected command: %s", $me, $command);
	    return();
	}
    }

    # check the body (must match the expectations)
    $body = $self->body();
    $body = "" unless defined($body);
    if (length($body)) {
	if (($flags & FLAG_BODY_MASK) == FLAG_BODY_FORBIDDEN) {
	    Net::STOMP::Client::Error::report("%s: unexpected body for %s", $me, $command);
	    return();
	}
    } else {
	if (($flags & FLAG_BODY_MASK) == FLAG_BODY_MANDATORY) {
	    Net::STOMP::Client::Error::report("%s: missing body for %s", $me, $command);
	    return();
	}
    }

    # check the headers (all required keys must be present)
    foreach my $v ($option{version}, ANY_VERSION) {
	next unless defined($v) and $FieldFlags{$v} and $FieldFlags{$v}{$command};
	while (($key, $flags) = each(%{ $FieldFlags{$v}{$command} })) {
	    next unless ($flags & FLAG_FIELD_MASK) == FLAG_FIELD_MANDATORY;
	    unless (exists($headers->{$key})) {
		Net::STOMP::Client::Error::report("%s: missing header key for %s: %s",
						  $me, $command, $key);
		return();
	    }
	}
    }

    # check the headers (keys must be known, values must match expectations)
    while (($key, $value) = each(%$headers)) {
	if (defined($option{version})) {
	    $flags = $FieldFlags{$option{version}}{$command}{$key} ||
		$FieldFlags{ANY_VERSION()}{$command}{$key};
	    $check = $FieldCheck{$option{version}}{$command}{$key} ||
		$FieldCheck{ANY_VERSION()}{$command}{$key};
	} else {
	    $flags = $FieldFlags{ANY_VERSION()}{$command}{$key};
	    $check = $FieldCheck{ANY_VERSION()}{$command}{$key};
	}
	unless ($flags) {
	    # complain only if level high enough and not a message or an error
	    if ($CheckLevel > 2 and not $command =~ /^(SEND|MESSAGE|ERROR)$/) {
		Net::STOMP::Client::Error::report("%s: unexpected header key for %s: %s",
						  $me, $command, $key);
		return();
	    }
	    next;
	}
	if ($check) {
	    if (ref($check) eq "Regexp") {
		goto bad_value unless $value =~ $check;
	    } elsif (ref($check) eq "CODE") {
		goto bad_value unless $check->($command, $key, $value);
	    } else {
		Net::STOMP::Client::Error::report("%s: unexpected check for %s.%s: %s",
						  $me, $command, $key, $check);
		return();
	    }
	}
	$type = $flags & FLAG_TYPE_MASK;
	next if $type == FLAG_TYPE_UNKNOWN;
	if ($type == FLAG_TYPE_BOOLEAN) {
	    next if $value =~ /^(true|false)$/;
	} elsif ($type == FLAG_TYPE_INTEGER) {
	    next if $value =~ /^\d+$/;
	} elsif ($type == FLAG_TYPE_LENGTH) {
	    next if $value =~ /^\d*$/;
	} else {
	    Net::STOMP::Client::Error::report("%s: unexpected type for %s.%s: %d",
					      $me, $command, $key, $type);
	    return();
	}
	# so far so bad...
      bad_value:
	Net::STOMP::Client::Error::report("%s: unexpected header key value for %s.%s: %s",
					  $me, $command, $key, $value);
	return();
    }

    # additional checks at command level
    if (defined($option{version})) {
	$check = $CommandCheck{$option{version}}{$command} ||
	    $CommandCheck{ANY_VERSION()}{$command};
    } else {
	$check = $CommandCheck{ANY_VERSION()}{$command};
    }
    if ($check) {
	$check->($command, $headers, $body) or return();
    }

    # so far so good
    return($self);
}

1;

__END__

=head1 NAME

Net::STOMP::Client::Frame - Frame support for Net::STOMP::Client

=head1 SYNOPSIS

  use Net::STOMP::Client::Frame;

  # create a connection frame
  $frame = Net::STOMP::Client::Frame->new(
      command => "CONNECT",
      headers => {
          login    => "guest",
          passcode => "guest",
      },
  );

  # get the command
  $cmd = $frame->command();

  # set the body
  $frame->body("...some data...");

  # directly get a header field
  $msgid = $frame->header("message-id");

=head1 DESCRIPTION

This module provides an object oriented interface to manipulate STOMP frames.

A frame object has the following attributes: C<command>, C<headers>
and C<body>. The C<headers> must be a reference to a hash of header
key/value pairs.

=head1 FUNCTIONS

This module provides the following methods:

=over

=item check()

check that the frame is well-formed, see below for more information

=item header(NAME)

return the value associated with the given name in the header

=item debug([TAG])

if debugging is enabled, dump a frame object on STDERR; for the body,
at most $Net::STOMP::Client::Frame::DebugBodyLength bytes will be
printed

=back

=head1 CONTENT LENGTH

The "content-length" header is special because it is used to indicate
the length of the body but also the JMS type of the message in
ActiveMQ as per L<http://activemq.apache.org/stomp.html>.

If you do not supply a "content-length" header, following the protocol
recommendations, a "content-length" header will be added if the frame
has a body.

If you do supply a numerical "content-length" header, it will be used
as is. Warning: this may give unexpected results if the supplied value
does not match the body length. Use only with caution!

Finally, if you supply an empty string as the "content-length" header,
it will not be sent, even if the frame has a body. This can be used to
mark a message as being a TextMessage for ActiveMQ. Here is an example
of this:

  $stomp->send(
      "destination"    => "/queue/test",
      "body"           => "hello world!",
      "content-length" => "",
  );

=head1 ENCODING

The STOMP 1.0 specification does not define which encoding should be
used to serialize frames. So, by default, this module assumes that
what has been given by the user or by the server is a ready-to-use
sequence of bytes and it does not perform any further encoding or
decoding.

However, for convenience, three global variables can be used to control
encoding/decoding.

If $Net::STOMP::Client::Frame::UTF8Header is set to true, the module
will use UTF-8 to encode/decode the header part of the frame.

The STOMP 1.1 specification states that UTF-8 encoding should always
be used for the header. So, for STOMP 1.1 connections,
$Net::STOMP::Client::Frame::UTF8Header defaults to true.

If $Net::STOMP::Client::Frame::BodyEncode is set to true, the module
will use the C<content-type> header to decide when and how to
encode/decode the body part of the frame.

The STOMP 1.1 specification states that the C<content-type> header
defines when and how the body is encoded/decoded. So, for STOMP 1.1
connections, $Net::STOMP::Client::Frame::BodyEncode defaults to true.
As a consequence, if you use STOMP 1.1 and supply an already encoded
body, you should set $Net::STOMP::Client::Frame::BodyEncode to false
to prevent double encoding.

If $Net::STOMP::Client::Frame::StrictEncode is true, all
encoding/decoding operations will be stricter and will report a fatal
error when given malformed input. This is done by using the
Encode::FB_CROAK flag instead of the default Encode::FB_DEFAULT.

N.B.: Perl's standard Encode module is used for all encoding/decoding
operations.

=head1 COMPLIANCE

STOMP 1.0 has several ambiguities and this module does its best to
work "as expected" in these gray areas.

STOMP 1.1 is much better specified and this module should be fully
compliant with the STOMP 1.1 specification with two exceptions:

=over

=item invalid encoding

by default, this module is permissive and allows malformed encoded
data (this is the same default as the Encode module itself); to be
strict, set $Net::STOMP::Client::Frame::StrictEncode to true (as
explained above)

=item header keys

by default, this module allows only "reasonable" header keys, made of
alphanumerical characters (along with C<_>, C<-> and C<.>); to be able
to use any header key (like the specification allows), set
$Net::STOMP::Client::Frame::HeaderNameRE to C<q/[\d\D]+/>.

=back

So, to sum up, here is what you can add to your code to get strict
STOMP 1.1 compliance:

  $Net::STOMP::Client::Frame::StrictEncode = 1;
  $Net::STOMP::Client::Frame::HeaderNameRE = q/[\d\D]+/;

=head1 FRAME CHECKING

Net::STOMP::Client calls the check() method for every frame about to
be sent and for every received frame.

The check() method verifies that the frame is well-formed. For
instance, it must contain a C<command> made of uppercase letters.

The global variable $Net::STOMP::Client::Frame::CheckLevel controls
the amount of checking that is performed. The default value is 2.

=over

=item 0

nothing is checked

=item 1

=over

=item *

the frame must have a good looking command

=item *

the header keys must be good looking and their value must be defined

=back

=item 2

=over

=item *

the level 1 checks are performed

=item *

the frame must have a known command

=item *

the presence/absence of the body is checked; for instance, body is not
expected for a "CONNECT" frame

=item *

the presence of mandatory keys (e.g. "message-id" for a "MESSAGE"
frame) is checked

=item *

for known header keys, their value must be good looking (e.g. the
"timestamp" value must be an integer)

=back

=item 3

=over

=item *

the level 2 checks are performed

=item *

all header keys must be known/expected

=back

=back

A violation of any of these checks trigger an error in the check()
method.

=head1 SEE ALSO

L<Net::STOMP::Client::Debug>,
L<Encode>.

=head1 AUTHOR

Lionel Cons L<http://cern.ch/lionel.cons>

Copyright CERN 2010-2011
