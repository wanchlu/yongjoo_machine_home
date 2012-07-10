# NOTE: Derived from lib/Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 1120 "lib/Image/Size.pm (autosplit into blib/lib/auto/Image/Size/swfmxsize.al)"
# swfmxsize: determine size of compressed ShockWave/Flash MX files. Adapted
# from code sent by Victor Kuriashkin <victor@yasp.com>
sub swfmxsize
{
    require Compress::Zlib;

    my ($image) = @_;
    my $header = &$read_in($image, 1058);
    my $ver = _bin2int(unpack 'B8', substr($header, 3, 1));

    my ($d, $status) = Compress::Zlib::inflateInit();
    $header = $d->inflate(substr($header, 8, 1024));

    my $bs = unpack 'B133', substr($header, 0, 9);
    my $bits = _bin2int(substr($bs, 0, 5));
    my $x = int(_bin2int(substr($bs, 5+$bits, $bits))/20);
    my $y = int(_bin2int(substr($bs, 5+$bits*3, $bits))/20);

    return ($x, $y, 'CWS');
}

1;
# end of Image::Size::swfmxsize
