package Text::Quoted;
our $VERSION = "2.02";
use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(extract);

use Text::Autoformat();    # Provides the Hang package, heh, heh.

=head1 NAME

Text::Quoted - Extract the structure of a quoted mail message

=head1 SYNOPSIS

    use Text::Quoted;
    my $structure = extract($text);

=head1 DESCRIPTION

C<Text::Quoted> examines the structure of some text which may contain
multiple different levels of quoting, and turns the text into a nested
data structure. 

The structure is an array reference containing hash references for each
paragraph belonging to the same author. Each level of quoting recursively
adds another list reference. So for instance, this:

    > foo
    > # Bar
    > baz

    quux

turns into:

    [
      [
        { text => 'foo', quoter => '>', raw => '> foo' },
        [ 
            { text => 'Bar', quoter => '> #', raw => '> # Bar' } 
        ],
        { text => 'baz', quoter => '>', raw => '> baz' }
      ],

      { empty => 1 },
      { text => 'quux', quoter => '', raw => 'quux' }
    ];

This also tells you about what's in the hash references: C<raw> is the
paragraph of text as it appeared in the original input; C<text> is what
it looked like when we stripped off the quotation characters, and C<quoter>
is the quotation string.

=cut

sub extract {
    my $text  = shift;
    my @paras = classify($text);
    my @needed;
    for my $p (@paras) {
        push @needed, { map { $_ => $p->{$_} } qw(raw empty text quoter) };
    }

    return organize( "", @needed );
}

=head1 CREDITS

Most of the heavy lifting is done by a modified version of Damian Conway's
C<Text::Autoformat>.

=head1 COPYRIGHT

Copyright (C) 2002-2003 Kasei Limited
Copyright (C) 2003-2004 Simon Cozens
Copyright (C) 2004 Best Practical Solutions, LLC

This software is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

sub organize {
    my $top_level = shift;
    my @todo      = @_;
    my @ret;

    # Recursively form a data structure which reflects the quoting
    # structure of the list.
    while (@todo) {
        my $line = shift @todo;
        if ( defn( $line->{quoter} ) eq defn($top_level) ) {

            # Just append lines at "my" level.
            push @ret, $line
              if exists $line->{quoter}
              or exists $line->{empty};
        }
        elsif ( defn( $line->{quoter} ) =~ /^\Q$top_level\E.+/ ) {

            # Find all the lines at a quoting level "below" me.
            my $newquoter = find_below( $top_level, $line, @todo );
            my @next = $line;
            push @next, shift @todo while defined $todo[0]->{quoter}
              and $todo[0]->{quoter} =~ /^\Q$newquoter/;

            # Find the 
            # And pass them on to organize()!
            #print "Trying to organise the following lines over $newquoter:\n";
            #print $_->{raw}."\n" for @next;
            #print "!-!-!-\n";
            push @ret, organize( $newquoter, @next );
        } #  else { die "bugger! I had $top_level, but now I have $line->{raw}\n"; }
    }
    return \@ret;
}

# Given, say:
#   X
#   > > hello
#   > foo bar
#   Stuff
#
# After "X", we're moving to another level of quoting - but which one?
# Naively, you'd pick out the prefix of the next line, "> >", but this
# is incorrect - "> >" is actually a "sub-quote" of ">". This routine
# works out which is the next level below us.

sub find_below {
    my ( $top_level, @stuff ) = @_;

    #print "## Looking for the next level of quoting after $top_level\n";
    #print "## We have:\n";
    #print "## $_->{raw}\n" for @stuff;

    my @prefices = sort { length $a <=> length $b } map { $_->{quoter} } @stuff;

    # Find the prefices, shortest first.

    # return $prefices[0] if $prefices[0] eq $prefices[-1];

    for (@prefices) {

        # And return the first one which is "below" where we are right
        # now but is a proper subset of the next line. 
        next unless $_;
        if ( $_ =~ /^\Q$top_level\E.+/ and $stuff[0]->{quoter} =~ /^\Q$_\E/ ) {

            #print "## We decided on $_\n";
            return $_;
        }
    }
    die "Can't happen";
}

# Everything below this point is essentially Text::Autoformat.

# BITS OF A TEXT LINE

my $quotechar  = qq{[!#%=|:]};
my $quotechunk = qq{(?:$quotechar(?!\\w)|\\w*>+)};
my $quoter     = qq{(?:(?i)(?:$quotechunk(?:[ \\t]*$quotechunk)*))};

my $separator = q/(?:[-_]{2,}|[=#*]{3,}|[+~]{4,})/;

sub defn($) { return $_[0] if (defined $_[0]); return "" }

sub classify {
    my $text = shift;
    $text = "" unless defined $text;
    # If the user passes in a null string, we really want to end up with _something_

    # DETABIFY
    my @rawlines = split /\n/, $text;
    use Text::Tabs;
    @rawlines = expand(@rawlines);


    # PARSE EACH LINE

    my $pre = 0;
    my @lines;
    foreach (@rawlines) {
        push @lines, { raw => $_};
        s/\A([ \t]*)($quoter?)([ \t]*)//;
        $lines[-1]{presig} = $lines[-1]{prespace} = defn $1;
        $lines[-1]{presig} .= $lines[-1]{quoter}     = defn $2;
        $lines[-1]{presig} .= $lines[-1]{quotespace} = defn $3;
        $lines[-1]{hang} = defn( Hang->new($_) );

        s/([ \t]*)(.*?)(\s*)$//;
        $lines[-1]{hangspace} = defn $1;
        $lines[-1]{text}      = defn $2;
        $lines[-1]{empty}     = $lines[-1]{hang}->empty() && $2 !~ /\S/;
        $lines[-1]{separator} = $lines[-1]{text} =~ /^$separator$/;
    }

    # SUBDIVIDE DOCUMENT INTO COHERENT SUBSECTIONS

    my @chunks;
    push @chunks, [ shift @lines ];
    foreach my $line (@lines) {
        if ( $line->{separator}
            || $line->{quoter} ne $chunks[-1][-1]->{quoter}
            || $line->{empty}
            || @chunks && $chunks[-1][-1]->{empty} )
        {
            push @chunks, [$line];
        }
        else {
            push @{ $chunks[-1] }, $line;
        }
    }

    # REDIVIDE INTO PARAGRAPHS

    my @paras;
    foreach my $chunk (@chunks) {
        my $first = 1;
        my $firstfrom;
        foreach my $line ( @{$chunk} ) {
            if ( $first
                || $line->{quoter} ne $paras[-1]->{quoter}
                || $paras[-1]->{separator} )
            {
                push @paras, $line;
                $first     = 0;
		# We get warnings from undefined raw and text values if we don't supply alternates
                $firstfrom = length( $line->{raw} ||'' ) - length( $line->{text} || '');
            }
            else {
                my $extraspace =
                  length( $line->{raw} ) - length( $line->{text} ) - $firstfrom;
                $paras[-1]->{text} .= "\n" . q{ } x $extraspace . $line->{text};
                $paras[-1]->{raw} .= "\n" . $line->{raw};
            }
        }
    }

    my $remainder = "";

    # ALIGN QUOTERS
    # DETERMINE HANGING MARKER TYPE (BULLET, ALPHA, ROMAN, ETC.)

    my %sigs;
    my $lastquoted   = 0;
    my $lastprespace = 0;
    for my $i ( 0 .. $#paras ) {
        my $para = $paras[$i];
        if ( $para->{quoter} ) {
            if ($lastquoted) { $para->{prespace} = $lastprespace }
            else { $lastquoted = 1; $lastprespace = $para->{prespace} }
        }
        else {
            $lastquoted = 0;
        }
    }

    # Reapply hangs
    for (@paras) {
        next unless my $hang = $_->{hang};
        next unless $hang->stringify;
        $_->{text} = $hang->stringify . " " . $_->{text};
    }
    return @paras;
}

sub val { return "" }
1;
