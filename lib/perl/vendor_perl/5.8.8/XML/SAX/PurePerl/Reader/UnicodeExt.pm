# $Id: UnicodeExt.pm,v 1.4 2003/07/30 13:39:23 matt Exp $

package XML::SAX::PurePerl::Reader;
use strict;

use Encode;

sub set_raw_stream {
    my ($fh) = @_;
    binmode($fh, ":bytes");
}

sub switch_encoding_stream {
    my ($fh, $encoding) = @_;
    binmode($fh, ":encoding($encoding)");
}

sub switch_encoding_string {
    $_[0] = Encode::decode($_[1], $_[0]);
}

1;

