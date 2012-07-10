package HTML::Strip;

use 5.006;
use warnings;
use strict;

use Carp qw( carp croak );

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use HTML::Strip ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
                                  ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '1.06';

bootstrap HTML::Strip $VERSION;

# Preloaded methods go here.

my $_html_entities_p = eval 'require HTML::Entities';

my %defaults = (
                striptags	=> [qw( title
                                        style
                                        script
                                        applet )],
                emit_spaces	=> 1,
                decode_entities	=> 1,
               );

sub new {
  my $class = shift;
  my $obj = create();
  bless $obj, $class;

  my %args = (%defaults, @_);
  while( my ($key, $value) = each %args ) {
    my $method = "set_${key}";
    if( $obj->can($method) ) {
      $obj->$method($value);
    } else {
      carp "Invalid setting '$key'";
    }
  }
  return $obj;
}

sub set_striptags {
  my ($self, @tags) = @_;
  if( ref($tags[0]) eq 'ARRAY' ) {
    $self->set_striptags_ref( $tags[0] );
  } else {
    $self->set_striptags_ref( \@tags );
  }
}

sub parse {
  my ($self, $text) = @_;
  my $stripped = $self->strip_html( $text );
  if( $self->decode_entities && $_html_entities_p ) {
    $stripped = HTML::Entities::decode($stripped);
  }
  return $stripped;
}

sub eof {
  my $self = shift;
  $self->reset();
}

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

HTML::Strip - Perl extension for stripping HTML markup from text.

=head1 SYNOPSIS

  use HTML::Strip;

  my $hs = HTML::Strip->new();

  my $clean_text = $hs->parse( $raw_html );
  $hs->eof;

=head1 DESCRIPTION

This module simply strips HTML-like markup from text in a very quick
and brutal manner. It could quite easily be used to strip XML or SGML
from text as well; but removing HTML markup is a much more common
problem, hence this module lives in the HTML:: namespace.

It is written in XS, and thus about five times quicker than using
regular expressions for the same task.

It does I<not> do any syntax checking (if you want that, use
L<HTML::Parser>), instead it merely applies the following rules:

=over 4

=item 1

Anything that looks like a tag, or group of tags will be replaced with
a single space character. Tags are considered to be anything that
starts with a C<E<lt>> and ends with a C<E<gt>>; with the caveat that a
C<E<gt>> character may appear in either of the following without
ending the tag:

=over 4

=item Quote

Quotes are considered to start with either a C<'> or a C<"> character,
and end with a matching character I<not> preceded by an even number or
escaping slashes (i.e. C<\"> does not end the quote but C<\\\\"> does).

=item Comment

If the tag starts with an exclamation mark, it is assumed to be a
declaration or a comment. Within such tags, C<E<gt>> characters do not
end the tag if they appear within pairs of double dashes (e.g. C<E<lt>!--
E<lt>a href="old.htm"E<gt>old pageE<lt>/aE<gt> --E<gt>> would be
stripped completely).

=back

=item 2

Anything the appears within so-called I<strip tags> is stripped as
well. By default, these tags are C<title>, C<script>, C<style> and
C<applet>.

=back

HTML::Strip maintains state between calls, so you can parse a document
in chunks should you wish. If one chunk ends half-way through a tag,
quote, comment, or whatever; it will remember this, and expect the
next call to parse to start with the remains of said tag.

If this is not going to be the case, be sure to call $hs->eof()
between calls to $hs->parse().

=head2 METHODS

=item new()

Constructor. Can optionally take a hash of settings (with keys
corresponsing to the C<set_> methods below).

For example, the following is a valid constructor:

 my $hs = HTML::Strip->new(
                           striptags   => [ 'script', 'iframe' ],
                           emit_spaces => 0
                          );

=item parse()

Takes a string as an argument, returns it stripped of HTML.

=item eof()

Resets the current state information, ready to parse a new block of HTML.

=item clear_striptags()

Clears the current set of strip tags.

=item add_striptag()

Adds the string passed as an argument to the current set of strip tags.

=item set_striptags()

Takes a reference to an array of strings, which replace the current
set of strip tags.

=item set_emit_spaces()

Takes a boolean value. If set to false, HTML::Strip will not attempt
any conversion of tags into spaces. Set to true by default.

=item set_decode_entities()

Takes a boolean value. If set to false, HTML::Strip will decode HTML
entities. Set to true by default.

=head2 LIMITATIONS

=over 4

=item Whitespace

Despite only outputting one space character per group of tags, and
avoiding doing so when tags are bordered by spaces or the start or
end of strings, HTML::Strip can often output more than desired; such
as with the following HTML:

 <h1> HTML::Strip </h1> <p> <em> <strong> fast, and brutal </strong> </em> </p>

Which gives the following output:

C<E<nbsp>HTML::StripE<nbsp>E<nbsp>E<nbsp>E<nbsp>fast, and brutalE<nbsp>E<nbsp>E<nbsp>>

Thus, you may want to post-filter the output of HTML::Strip to remove
excess whitespace (for example, using C<tr/ / /s;>).
(This has been improved since previous releases, but is still an issue)

=item HTML Entities

HTML::Strip will only attempt decoding of HTML entities if
L<HTML::Entities> is installed.

=head2 EXPORT

None by default.

=head1 AUTHOR

Alex Bowley E<lt>kilinrax@cpan.orgE<gt>

=head1 SEE ALSO

L<perl>, L<HTML::Parser>, L<HTML::Entities>

=cut
