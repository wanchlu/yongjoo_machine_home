package DateTime::Format::IBeat;

use strict;
use warnings;
use Carp qw( croak );

use DateTime;

use vars qw($VERSION);
$VERSION = '0.161';

my $ratio = 1000.0 / 86400.0;

sub _beat_convert
{
    my $beats = shift;
    my $dt = shift;
    $beats /= $ratio;

    $dt ||= DateTime->now( time_zone => '+0100' )->set(
	hour => 0,
	minute => 0,
	second => 0,
    );

    $dt->add( seconds => $beats );

    return $dt->set_time_zone( 'UTC' );
}

sub _date_convert
{
    my ($day, $month, $year) = @_;
    my $dt = DateTime->new(
	time_zone => '+0100',
	year => $year + 2000,
	month => $month,
	day => $day
    )->set_time_zone( 'UTC' );

    return $dt;
}

my $beat_RE = qr/ @? (\d{1,3}) /x;
my $date_RE = qr/ @? d? (\d\d) \. (\d\d) \. (\d\d) /x;

sub _get_beats
{
    my ( $string ) = @_;
    croak "Could not parse time!" unless defined $string
        and $string =~ m/^ $beat_RE $/x;
    return $1;
}

sub _get_days
{
    my ( $string ) = @_;
    croak "Could not parse date!" unless defined $string
        and $string =~ /^ $date_RE $/x;
    return ( $1, $2, $3 );
}

sub parse_time
{
    my ( $class, $string ) = @_;
    return _beat_convert( _get_beats( $string ) );
}

sub parse_date
{
    my ( $class, $string ) = @_;
    return _date_convert( _get_days( $string ) );
}

sub parse_datetime
{
    my ( $class, $string ) = @_;
    croak "Could not parse datetime!" unless defined $string;
    my ( $date, $time ) = split /\s+/, $string, 2;

    return _beat_convert( _get_beats( $time ),
        _date_convert( _get_days( $date ) ) );
}

sub format_time
{
    my $class = shift;
    my $dt = $_[0]->clone->set_time_zone( '+0100' );
    my ($hour, $min, $sec) = map { $dt->$_ } qw( hour minute second );
    my $beats = $ratio * ( 3600 * $hour + 60 * $min + $sec );
    return sprintf "@%03d", $beats;
}

sub format_date
{
    my $class = shift;
    my $dt = $_[0]->clone->set_time_zone( '+0100' );
    return $dt->strftime('@d%d.%m.%y');
}

sub format_datetime
{
    my $s = shift;
    my $c = shift;
    return $s->format_date($c).' '.$s->format_time($c);
}

1;

__END__

=head1 NAME

DateTime::Format::IBeat - Format times in .beat notation

=head1 DESCRIPTION

    No Time Zones
    
    No Geographical Borders
    
    How long is a Swatch .beat? In short, we have divided up the virtual and
    real day into 1000 I<beats>. One Swatch beat is the equivalent of 1
    minute 26.4 seconds. That means that 12 noon in the old time system is
    the equivalent of @500 Swatch .beats.
    
    Okay, so how can a surfer in New York, or a passenger on a transatlantic
    flight know when it is @500 Swatch .beats in Central Europe for example?
    How can the New York surfer make a date for a chat with his cyber friend
    in Rome? Easy, Internet Time is the same all over the world.

    How is this possible? We are not just creating a new way of measuring
    time, we are also creating a new meridian in Biel, Switzerland, home of
    Swatch.

    Biel MeanTime (BMT) is the universal reference for Internet Time. A day
    in Internet Time begins at midnight BMT (@000 Swatch .beats) (Central
    European Wintertime). The meridian is marked for all to see on the
    facade of the Swatch International Headquarters on Jakob-Staempfli
    Street, Biel, Switzerland. So, it is the same time all over the world,
    be it night or day, the era of time zones has disappeared.

    The BMT meridian was inaugurated on 23 October 1998 in the presence of
    Nicholas Negroponte, founder and director of the Massachusetts Institute
    of Technology`s Media Laboratory.

    - http://www.swatch.com/itime_tools/itime.php

=head1 PARSING METHODS

=head2 parse_time

Parses a .beat time and returns a DateTime object.
The object uses the current date for its date and will have
UTC set as its timezone. Feel free to use 'set' to convert
to your local time.

    my $first = DateTime::Format::IBeat->parse_time( '@765' );
    print $first->datetime; # 2003-04-01T17:21:36

    $first->set_time_zone( "Australia/Sydney" );
    print $first->datetime; # 2003-04-02T03:21:36

B<Note> that the leading @ is optional. Also, if using direct strings,
and leading @s, be careful to not have it interpolate it as an array by
accident.

=head2 parse_date

Parses an .beat date and returns a C<DateTime> object representing that date.

     my $dt = DateTime::Format::IBeat->parse_date('@d01.04.03');
     print $dt->ymd('.'); # "2003.04.01"

Note: this assumes the number of .beats elapsed in the day to be 0, thus
it will appear to be returning the day before. If you display a full
time with it, you will find it's at UTC rather than BMT (+0100), thus
11pm the day before. The important thing to remember is that it is an
accurate conversion to the usual notation, despite appearances.

=head2 parse_datetime

Parses an ibeat datetime string and returns a C<DateTime> object representing
that datetime.

    my $dt = DateTime::Format::IBeat->parse_datetime(
	'@d01.04.03 @765');
    print $dt->datetime; # "2003-04-01T17:21:36"

=head1 FORMATTING METHODS

=head2 format_time

Given a DateTime object, returns a string representating that time
in ibeats.

=head2 format_date

Given a DateTime object, returns a string representating that date.

=head2 format_datetime

Given a Datetime object, returns a string representating that
date and time in .beats format.

=head1 THANKS

The original author of this module was Iain Truskett (SPOON). Since
his tragically early death, the module has been maintained by Earle 
Martin (EMARTIN), who would like to dedicate it to his memory.

Iain wished to thank:

=over 4

=item * Dave Rolsky (DROLSKY) for kickstarting the DateTime project.

=item * Swatch, for coming up with this mad format.

=item * Jerub, from opn, who wrote the python original, from which I retain no code. D'oh.

=back

Here is a list of people and their CPAN id, extracted from various
places.  These people have either submitted patches or suggestions,
or their bug reports or comments have inspired the appropriate
patches.  Corrections, additions, deletions welcome:

=over 4

=item * Dave Rolsky (DROLSKY)

=back

=head1 SUPPORT

You can log bug reports via the CPAN RT system on the web:

    http://rt.cpan.org/

This makes it much easier for me to track things and thus means
your problem is less likely to be neglected.

=head1 LICENCE AND COPYRIGHT

Copyright (c) Iain Truskett, 2003. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The full text of the licences can be found in the F<Artistic> and
F<COPYING> files included with this module.

=head1 AUTHOR

The late Iain Truskett (SPOON) created this module. It is currently
maintained by Earle Martin (EMARTIN), who would like to dedicate it
to his memory.

=head1 SEE ALSO

=over 4

=item * L<DateTime>

=item * The C<datetime@perl.org> mailing list

=item * L<http://datetime.perl.org/>

=back

=cut