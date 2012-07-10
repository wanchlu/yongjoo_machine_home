#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2007-2009 -- leonerd@leonerd.org.uk

package Socket::GetAddrInfo;

use strict;
use warnings;

use Exporter;
use DynaLoader;

use Carp;
use Scalar::Util qw( dualvar );

my %errstr;

BEGIN {
   our @ISA = qw( Exporter );
   our $VERSION = "0.12";

   our @EXPORT = qw(
      getaddrinfo
      getnameinfo
   );

   push @ISA, qw( DynaLoader ); # Must be last so we can pop it if necessary

   if( not $ENV{NO_GETADDRINFO_XS} and eval { __PACKAGE__->DynaLoader::bootstrap( $VERSION ); 1 } ) {
      # Do nothing
   }
   else {
      # Not a DynaLoader any more
      pop @ISA;

      *getaddrinfo = \&fake_getaddrinfo;
      *getnameinfo = \&fake_getnameinfo;

      require Socket;
      require constant;

      # These numbers borrowed from GNU libc's implementation, but since
      # they're only used by our emulation, it doesn't matter if the real
      # platform's values differ
      my %constants = (
          AI_PASSIVE     => 1,
          AI_CANONNAME   => 2,
          AI_NUMERICHOST => 4,

          EAI_BADFLAGS   => -1,
          EAI_NONAME     => -2,
          EAI_NODATA     => -5,
          EAI_FAMILY     => -6,
          EAI_SERVICE    => -8,

          NI_NUMERICHOST => 1,
          NI_NUMERICSERV => 2,
          NI_NAMEREQD    => 8,
          NI_DGRAM       => 16,
      );

      import constant $_ => $constants{$_} for keys %constants;
      push @EXPORT, $_ for keys %constants;

      %errstr = (
         # These strings from RFC 2553
         EAI_BADFLAGS()   => "invalid value for ai_flags",
         EAI_NONAME()     => "nodename nor servname provided, or not known",
         EAI_NODATA()     => "no address associated with nodename",
         EAI_FAMILY()     => "ai_family not supported",
         EAI_SERVICE()    => "servname not supported for ai_socktype",
      );
   }
}

=head1 NAME

C<Socket::GetAddrInfo> - RFC 2553's C<getaddrinfo> and C<getnameinfo>
functions.

=head1 SYNOPSIS

 use Socket qw( SOCK_STREAM );
 use Socket::GetAddrInfo qw( :newapi getaddrinfo getnameinfo );
 use IO::Socket;

 my $sock;

 my %hints = ( socktype => SOCK_STREAM );
 my ( $err, @res ) = getaddrinfo( "www.google.com", "www", \%hints );

 die "Cannot resolve name - $err" if $err;

 while( my $ai = shift @res ) {

    $sock = IO::Socket->new();
    $sock->socket( $ai->{family}, $ai->{socktype}, $ai->{protocol} ) or
       undef $sock, next;

    $sock->connect( $ai->{addr} ) or undef $sock, next;

    last;
 }

 if( $sock ) {
    my ( $err, $host, $service ) = getnameinfo( $sock->peername );
    print "Connected to $host:$service\n" if !$err;
 }

=head1 DESCRIPTION

The RFC 2553 functions C<getaddrinfo> and C<getnameinfo> provide an abstracted
way to convert between a pair of host name/service name and socket addresses,
or vice versa. C<getaddrinfo> converts names into a set of arguments to pass
to the C<socket()> and C<connect()> syscalls, and C<getnameinfo> converts a
socket address back into its host name/service name pair.

These functions provide a useful interface for performing either of these name
resolution operation, without having to deal with IPv4/IPv6 transparency, or
whether the underlying host can support IPv6 at all, or other such issues.
However, not all platforms can support the underlying calls at the C layer,
which means a dilema for authors wishing to write forward-compatible code.
Either to support these functions, and cause the code not to work on older
platforms, or stick to the older "legacy" resolvers such as
C<gethostbyname()>, which means the code becomes more portable.

This module attempts to solve this problem, by detecting at compiletime
whether the underlying OS will support these functions, and only compiling the
XS code if it can. At runtime, when the module is loaded, if the XS
implementation is not available, emulations of the functions using the legacy
resolver functions instead. The emulations support the same interface as the
real functions, and behave as close as is resonably possible to emulate using
the legacy resolvers. See below for details on the limits of this emulation.

=cut

sub import
{
   my $class = shift;
   my %symbols = map { $_ => 1 } @_;

   if( delete $symbols{':newapi'} ) {
      # Caller wants the new API functions - do nothing
   }
   else {
      # Caller wants the Socket6 backward compatible API functions instead
      delete $symbols{':Socket6api'} or carp <<EOF;
Importing Socket::GetAddrInfo without ':newapi' or ':Socket6api' tag.
Defaults to :Socket6api currently but default will change in a future version.
EOF

      my $callerpkg = caller;

      no strict 'refs';
      *{"${callerpkg}::getaddrinfo"} = \&Socket6_getaddrinfo if delete $symbols{getaddrinfo};
      *{"${callerpkg}::getnameinfo"} = \&Socket6_getnameinfo if delete $symbols{getnameinfo};
   }

   return unless keys %symbols;

   local $Exporter::ExportLevel = $Exporter::ExportLevel + 1;
   $class->SUPER::import( keys %symbols );
}

=head1 FUNCTIONS

The functions in this module are provided in one of two API styles, selectable
at the time they are imported into the caller, by the use of the following
tags:

 use Socket::GetAddrInfo qw( :newapi getaddrinfo );

 use Socket::GetAddrInfo qw( :Socket6api getaddrinfo );

The choice is implemented by importing different functions into the caller,
which means different importing packages may choose different API styles. It
is recommended that new code import the C<:newapi> style to take advantage of
neater argument / return results, and error reporting. The C<:Socket6api>
style is provided as backward-compatibility for code that wants to use
C<Socket6>.

If neither style is selected, then this module will provide a Socket6-like API
to be compatible with earlier versions of C<Socket::GetAddrInfo>. This
behaviour will change in a later version of the module - make sure to always
specify the required API type.

=cut

=head2 ( $err, @res ) = getaddrinfo( $host, $service, $hints )

When given both host and service, this function attempts to resolve the host
name to a set of network addresses, and the service name into a protocol and
port number, and then returns a list of address structures suitable to
connect() to it.

When given just a host name, this function attempts to resolve it to a set of
network addresses, and then returns a list of these addresses in the returned
structures.

When given just a service name, this function attempts to resolve it to a
protocol and port number, and then returns a list of address structures that
represent it suitable to bind() to.

When given neither name, it generates an error.

The optional C<$hints> parameter can be passed a HASH reference to indicate
how the results are generated. It may contain any of the following four
fields:

=over 8

=item flags => INT

A bitfield containing C<AI_*> constants

=item family => INT

Restrict to only generating addresses in this address family

=item socktype => INT

Restrict to only generating addresses of this socket type

=item protocol => INT

Restrict to only generating addresses for this protocol

=back

Errors are indicated by the C<$err> value returned; which will be non-zero in
numeric context, and contain a string error message as a string. The value can
be compared against any of the C<EAI_*> constants to determine what the error
is.

If no error occurs, C<@res> will contain HASH references, each representing
one address. It will contain the following five fields:

=over 8

=item family => INT

The address family (e.g. AF_INET)

=item socktype => INT

The socket type (e.g. SOCK_STREAM)

=item protocol => INT

The protocol (e.g. IPPROTO_TCP)

=item addr => STRING

The address in a packed string (such as would be returned by pack_sockaddr_in)

=item canonname => STRING

The canonical name for the host if the C<AI_CANONNAME> flag was provided, or
C<undef> otherwise.

=back

=head2 ( $err, $host, $service ) = getnameinfo( $addr, $flags )

This function attempts to resolve the given socket address into a pair of host
and service names.

The optional C<$flags> parameter is a bitfield containing C<NI_*> constants.

Errors are indicated by the C<$err> value returned; which will be non-zero in
numeric context, and contain a string error message as a string. The value can
be compared against any of the C<EAI_*> constants to determine what the error
is.

=cut

=head1 SOCKET6 COMPATIBILITY FUNCTIONS

=head2 @res = getaddrinfo( $host, $service, $family, $socktype, $protocol, $flags )

This version of the API takes the hints values as separate ordered parameters.
Unspecified parameters should be passed as C<0>.

If successful, this function returns a flat list of values, five for each
returned address structure. Each group of five elements will contain, in
order, the C<family>, C<socktype>, C<protocol>, C<addr> and C<canonname>
values of the address structure.

If unsuccessful, it will return a single value, containing the string error
message. To remain compatible with the C<Socket6> interface, this value does
not have the error integer part.

=cut

sub Socket6_getaddrinfo
{
   @_ >= 2 and @_ <= 6 or 
      croak "Usage: getaddrinfo(host, service, family=0, socktype=0, protocol=0, flags=0)";

   my ( $host, $service, $family, $socktype, $protocol, $flags ) = @_;

   my ( $err, @res ) = getaddrinfo( $host, $service, {
      flags    => $flags    || 0,
      family   => $family   || 0,
      socktype => $socktype || 0,
      protocol => $protocol || 0,
   } );

   return "$err" if $err;
   return map { $_->{family}, $_->{socktype}, $_->{protocol}, $_->{addr}, $_->{canonname} } @res;
}

=head2 ( $host, $service ) = getnameinfo( $addr, $flags )

This version of the API returns only the host name and service name, if
successfully resolved. On error, it will return an empty list. To remain
compatible with the C<Socket6> interface, no error information will be
supplied.

=cut

sub Socket6_getnameinfo
{
   @_ >= 1 and @_ <= 2 or
      croak "Usage: getnameinfo(addr, flags=0)";

   my ( $addr, $flags ) = @_;

   my ( $err, $host, $service ) = getnameinfo( $addr, $flags );

   return () if $err;
   return ( $host, $service );
}

# Borrowed from Regexp::Common::net
my $REGEXP_IPv4_DECIMAL = qr/25[0-5]|2[0-4][0-9]|1?[0-9][0-9]{1,2}/;
my $REGEXP_IPv4_DOTTEDQUAD = qr/$REGEXP_IPv4_DECIMAL\.$REGEXP_IPv4_DECIMAL\.$REGEXP_IPv4_DECIMAL\.$REGEXP_IPv4_DECIMAL/;

sub fake_makeerr
{
   my ( $errno ) = @_;
   my $errstr = $errno == 0 ? "" : ( $errstr{$errno} || $errno );
   return dualvar( $errno, $errstr );
}

=head1 LIMITS OF EMULATION

These emulations are not a complete replacement of the real functions, because
they only support IPv4 (the C<AF_INET> socket family).

=cut

=head2 getaddrinfo

=over 4

=item *

If C<$family> is supplied, it must be C<AF_INET>. Any other value will result
in an error thrown by C<croak>.

=item *

The only supported C<$flags> values are C<AI_PASSIVE>, C<AI_CANONNAME>, and
C<AI_NUMERICHOST>.

=back

=cut

sub fake_getaddrinfo
{
   my ( $node, $service, $hints ) = @_;
   
   $node = "" unless defined $node;

   $service = "" unless defined $service;

   my ( $family, $socktype, $protocol, $flags ) = @$hints{qw( family socktype protocol flags )};

   $family ||= Socket::AF_INET(); # 0 == AF_UNSPEC, which we want too
   $family == Socket::AF_INET() or return fake_makeerr( EAI_FAMILY );

   $socktype ||= 0;

   $protocol ||= 0;

   $flags ||= 0;

   my $flag_passive     = $flags & AI_PASSIVE();     $flags &= ~AI_PASSIVE();
   my $flag_canonname   = $flags & AI_CANONNAME();   $flags &= ~AI_CANONNAME();
   my $flag_numerichost = $flags & AI_NUMERICHOST(); $flags &= ~AI_NUMERICHOST();

   $flags == 0 or return fake_makeerr( EAI_BADFLAGS );

   $node eq "" and $service eq "" and return fake_makeerr( EAI_NONAME );

   my $canonname;
   my @addrs;
   if( $node ne "" ) {
      return fake_makeerr( EAI_NONAME ) if( $flag_numerichost and $node !~ m/^$REGEXP_IPv4_DOTTEDQUAD$/ );
      ( $canonname, undef, undef, undef, @addrs ) = gethostbyname( $node );
      defined $canonname or return fake_makeerr( EAI_NONAME );

      undef $canonname unless $flag_canonname;
   }
   else {
      $addrs[0] = $flag_passive ? Socket::inet_aton( "0.0.0.0" )
                                : Socket::inet_aton( "127.0.0.1" );
   }

   my @ports; # Actually ARRAYrefs of [ socktype, protocol, port ]
   my $protname = "";
   if( $protocol ) {
      $protname = getprotobynumber( $protocol );
   }

   if( $service ne "" and $service !~ m/^\d+$/ ) {
      getservbyname( $service, $protname ) or return fake_makeerr( EAI_SERVICE );
   }

   foreach my $this_socktype ( Socket::SOCK_STREAM(), Socket::SOCK_DGRAM(), Socket::SOCK_RAW() ) {
      next if $socktype and $this_socktype != $socktype;

      my $this_protname = "raw";
      $this_socktype == Socket::SOCK_STREAM() and $this_protname = "tcp";
      $this_socktype == Socket::SOCK_DGRAM()  and $this_protname = "udp";

      next if $protname and $this_protname ne $protname;

      my $port;
      if( $service ne "" ) {
         if( $service =~ m/^\d+$/ ) {
            $port = "$service";
         }
         else {
            ( undef, undef, $port, $this_protname ) = getservbyname( $service, $this_protname );
            next unless defined $port;
         }
      }
      else {
         $port = 0;
      }

      push @ports, [ $this_socktype, scalar getprotobyname( $this_protname ) || 0, $port ];
   }

   my @ret;
   foreach my $addr ( @addrs ) {
      foreach my $portspec ( @ports ) {
         my ( $socktype, $protocol, $port ) = @$portspec;
         push @ret, { 
            family    => $family,
            socktype  => $socktype,
            protocol  => $protocol,
            addr      => Socket::pack_sockaddr_in( $port, $addr ),
            canonname => $canonname,
         };
      }
   }

   return ( fake_makeerr( 0 ), @ret );
}

=head2 getnameinfo

=over 4

=item *

If the sockaddr family of C<$addr> is anything other than C<AF_INET>, an error
will be thrown with C<croak>.

=item *

The only supported C<$flags> values are C<NI_NUMERICHOST>, C<NI_NUMERICSERV>,
C<NI_NAMEREQD> and C<NI_DGRAM>.

=back

=cut

sub fake_getnameinfo
{
   my ( $addr, $flags ) = @_;

   my ( $port, $inetaddr );
   eval { ( $port, $inetaddr ) = Socket::unpack_sockaddr_in( $addr ) }
      or return fake_makeerr( EAI_FAMILY );

   my $family = Socket::AF_INET();

   $flags ||= 0;

   my $flag_numerichost = $flags & NI_NUMERICHOST(); $flags &= ~NI_NUMERICHOST();
   my $flag_numericserv = $flags & NI_NUMERICSERV(); $flags &= ~NI_NUMERICSERV();
   my $flag_namereqd    = $flags & NI_NAMEREQD();    $flags &= ~NI_NAMEREQD();
   my $flag_dgram       = $flags & NI_DGRAM()   ;    $flags &= ~NI_DGRAM();

   $flags == 0 or return fake_makeerr( EAI_BADFLAGS );

   my $node;
   if( $flag_numerichost ) {
      $node = Socket::inet_ntoa( $inetaddr );
   }
   else {
      $node = gethostbyaddr( $inetaddr, $family );
      if( !defined $node ) {
         return fake_makeerr( EAI_NONAME ) if $flag_namereqd;
         $node = Socket::inet_ntoa( $inetaddr );
      }
   }

   my $service;
   if( $flag_numericserv ) {
      $service = "$port";
   }
   else {
      my $protname = $flag_dgram ? "udp" : "";
      $service = getservbyport( $port, $protname );
      if( !defined $service ) {
         $service = "$port";
      }
   }

   return ( fake_makeerr( 0 ), $node, $service );
}

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 BUGS

=over 4

=item *

At the time of writing, there are no test reports from the C<MSWin32> platform
either PASS or FAIL. I suspect the code will not currently work as it stands
on that platform, but it should be fairly easy to fix, as C<Socket6> is known
to work there. Patches welcomed. :)

=back

=head1 SEE ALSO

=over 4

=item *

L<RFC 2553|http://tools.ietf.org/html/rfc2553> - Basic Socket Interface
Extensions for IPv6

=back

=head1 AUTHOR

Paul Evans <leonerd@leonerd.org.uk>
