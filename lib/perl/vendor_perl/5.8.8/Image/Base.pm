package Image::Base ;    # Documented at the __END__

# $Id: Base.pm,v 1.8 2000/05/25 20:45:54 root Exp $

use strict ;

use vars qw( $VERSION ) ;
$VERSION = '1.07' ;

use Carp qw( croak ) ;
use Symbol () ;

# All the supplied methods are expected to be inherited by subclasses; some
# will be adequate, some will need to be overridden and some *must* be
# overridden.

### Private methods 
#
# _get          object
# _set          object

sub _get { # Object method
    my $self  = shift ;
#    my $class = ref( $self ) || $self ;
   
    $self->{shift()} ;
}


sub _set { # Object method
    my $self  = shift ;
#    my $class = ref( $self ) || $self ;
    
    my $field = shift ;

    $self->{$field} = shift ;
}


sub DESTROY {
    ; # Save's time
}


### Public methods


sub new   { croak __PACKAGE__ .  "::new() must be overridden" }
sub xy    { croak __PACKAGE__ .   "::xy() must be overridden" }
sub load  { croak __PACKAGE__ . "::load() must be overridden" }
sub save  { croak __PACKAGE__ . "::save() must be overridden" }
sub set   { croak __PACKAGE__ .  "::set() must be overridden" }


sub get { # Object method 
    my $self  = shift ;
#    my $class = ref( $self ) || $self ;
  
    my @result ;

    push @result, $self->_get( shift() ) while @_ ;

    wantarray ? @result : shift @result ;
}


sub new_from_image { # Object method 
    my $self     = shift ; # Must be an image to copy
    my $class    = ref( $self ) || $self ;
    my $newclass = shift ; # Class of target taken from class or object

    croak "new_from_image() cannot read $class" unless $self->can( 'xy' ) ;

    my( $width, $height ) = $self->get( -width, -height ) ;

    # If $newclass was an object reference we inherit its characteristics
    # except for width/height and any arguments we've supplied.
    my $obj = $newclass->new( @_, -width => $width, -height => $height ) ;

    croak "new_from_image() cannot convert to " . ref $obj unless $obj->can( 'xy' ) ;

    for( my $x = 0 ; $x < $width ; $x++ ) {
        for( my $y = 0 ; $y < $height ; $y++ ) {
            $obj->xy( $x, $y, $self->xy( $x, $y ) ) ;
        }
    }

    $obj ;
}


sub line { # Object method 
    my $self  = shift ; 
#    my $class = ref( $self ) || $self ;
    
    my( $x0, $y0, $x1, $y1, $colour ) = @_ ;

    if( $x0 == $x1 ) {
        ( $y0, $y1 ) = ( $y1, $y0 ) if $y0 > $y1 ;

        for( my $y = $y0 ; $y <= $y1 ; $y++ ) {
            $self->xy( $x0, $y, $colour ) ;
        }
    }
    else {
        # Line algorithm from Computer Graphics Principles and Practice.
        ( $x0, $y0, $x1, $y1 ) = ( $x1, $y1, $x0, $y0 ) if $x0 > $x1 ; 

        my $dy = $y1 - $y0 ;
        my $dx = $x1 - $x0 ;
        my $m  = $dx == 0 ? $dy : $dy / $dx ;
        my $y  = $y0 ;

        for( my $x = $x0 ; $x <= $x1 ; $x++ ) {
            $self->xy( $x, int $y, $colour ) ;
            $y += $m ;
        }
    }
}


sub ellipse { # Object method 
    my $self  = shift ; 
#    my $class = ref( $self ) || $self ;

    my( $x0, $y0, $x1, $y1, $colour ) = @_ ;

    ( $x0, $y0, $x1, $y1 ) = ( $x1, $y1, $x0, $y0 ) if $x0 > $x1 ; 
 
    my $ox = $x1 > $x0 ? ( ( $x1 - $x0 ) / 2 ) + $x0 : 
                         ( ( $x0 - $x1 ) / 2 ) + $x1 ;
    my $oy = $y1 > $y0 ? ( ( $y1 - $y0 ) / 2 ) + $y0 : 
                         ( ( $y0 - $y1 ) / 2 ) + $y1 ;
    my $a  = abs( $x1 - $x0 ) / 2 ; 
    my $b  = abs( $y1 - $y0 ) / 2 ; 
    my $aa = $a ** 2 ;
    my $bb = $b ** 2 ;

    # Midpoint ellipse algorithm from Computer Graphics Principles and Practice.
    my $x  = 0 ;
    my $y  = $b ;
    my $d1 = $bb - ( $aa * $b ) + ( $aa / 4 ) ;
    $self->_ellipse_point( $ox, $oy, $x, $y, $colour ) ;

    while( ( $aa * ( $y - 0.5 ) ) > ( $bb * ( $x + 1 ) ) ) {
        if( $d1 < 0 ) {
            $d1 += ( $bb * ( ( 2 * $x ) + 3 ) ) ;
            ++$x ;
        }
        else {
            $d1 += ( ( $bb * ( (  2 * $x ) + 3 ) ) +
                     ( $aa * ( ( -2 * $y ) + 2 ) ) ) ;
            ++$x ;
            --$y ;
        }
        $self->_ellipse_point( $ox, $oy, $x, $y, $colour ) ;
    }

    my $d2 = ( $bb * ( ( $x + 0.5 ) ** 2 ) ) + 
             ( $aa * ( ( $y - 1 )   ** 2 ) ) -
             ( $aa * $bb ) ;
    
    while( $y > 0 ) {
        if( $d2 < 0 ) {
            $d2 += ( $bb * ( (  2 * $x ) + 2 ) ) +
                   ( $aa * ( ( -2 * $y ) + 3 ) ) ;
            ++$x ;
            --$y ;
        }
        else {
            $d2 += ( $aa * ( ( -2 * $y ) + 3 ) ) ;
            --$y ;
        }
        $self->_ellipse_point( $ox, $oy, $x, $y, $colour ) ;
    }
}


sub _ellipse_point { # Object method 
    my $self  = shift ; 
#    my $class = ref( $self ) || $self ;

    my( $ox, $oy, $rx, $ry, $colour ) = @_ ;

    $self->xy( $ox + $rx, $oy + $ry, $colour ) ;
    $self->xy( $ox - $rx, $oy - $ry, $colour ) ;
    $self->xy( $ox + $rx, $oy - $ry, $colour ) ;
    $self->xy( $ox - $rx, $oy + $ry, $colour ) ;
}


sub rectangle { # Object method 
    my $self  = shift ; 
#    my $class = ref( $self ) || $self ;

    my( $x0, $y0, $x1, $y1, $colour, $fill ) = @_ ;

    if( defined $fill and $fill ) {
        $self->_filled_rectangle( $x0, $y0, $x1, $y1, $colour ) ;
    }
    else {
        # A rectangle is simply four lines...
        $self->line( $x0, $y0, $x1, $y0, $colour ) ;
        $self->line( $x1, $y0, $x1, $y1, $colour ) ;
        $self->line( $x1, $y1, $x0, $y1, $colour ) ;
        $self->line( $x0, $y1, $x0, $y0, $colour ) ;
    }
}


sub _filled_rectangle { # Object method 
    my $self  = shift ; 
#    my $class = ref( $self ) || $self ;

    my( $x0, $y0, $x1, $y1, $colour ) = @_ ;

    ( $y0, $y1 ) = ( $y1, $y0 ) if $y0 > $y1 ;

    for( my $y = $y0 ; $y <= $y1 ; $y++ ) {
        $self->line( $x0, $y, $x1, $y, $colour ) ; 
    }
}


1 ;


__END__

=head1 NAME

Image::Base - base class for loading, manipulating and saving images.

=head1 SYNOPSIS

This class should not be used directly. Known inheritors are Image::Xbm and
Image::Xpm.

    use Image::Xpm ;

    my $i = Image::Xpm->new( -file => 'test.xpm' ) ;
    $i->line( 1, 1, 3, 7, 'red' ) ;
    $i->ellipse( 3, 3, 6, 7, '#ff00cc' ) ;
    $i->rectangle( 4, 2, 9, 8, 'blue' ) ;

If you want to create your own algorithms to manipulate images in terms of
(x,y,colour) then you could extend this class (without changing the file),
like this:

    # Filename: mylibrary.pl
    package Image::Base ; # Switch to this class to build on it.
    
    sub mytransform {
        my $self  = shift ;
        my $class = ref( $self ) || $self ;

        # Perform your transformation here; might be drawing a line or filling
        # a rectangle or whatever... getting/setting pixels using $self->xy().
    }

    package main ; # Switch back to the default package.

Now if you C<require> mylibrary.pl after you've C<use>d Image::Xpm or any
other Image::Base inheriting classes then all these classes will inherit your
C<mytransform()> method.

=head1 DESCRIPTION

=head2 new_from_image()

    my $bitmap = Image::Xbm->new( -file => 'bitmap.xbm' ) ;
    my $pixmap = $bitmap->new_from_image( 'Image::Xpm', -cpp => 1 ) ;
    $pixmap->save( 'pixmap.xpm' ) ;

Note that the above will only work if you've installed Image::Xbm and
Image::Xpm, but will work correctly for any image object that inherits from
Image::Base and respects its API.

You can use this method to transform an image to another image of the same
type but with some different characteristics, e.g.

    my $p = Image::Xpm->new( -file => 'test1.xpm' ) ;
    my $q = $p->new_from_image( ref $p, -cpp => 2, -file => 'test2.xpm' ) ;
    $q->save ;

=head2 line()

    $i->line( $x0, $y0, $x1, $y1, $colour ) ;

Draw a line from point ($x0,$y0) to point ($x1,$y1) in colour $colour.

=head2 ellipse()

    $i->ellipse( $x0, $y0, $x1, $y1, $colour ) ;

Draw an oval enclosed by the rectangle whose top left is ($x0,$y0) and bottom
right is ($x1,$y1) using a line colour of $colour.

=head2 rectangle()

    $i->rectangle( $x0, $y0, $x1, $y1, $colour, $fill ) ;

Draw a rectangle whose top left is ($x0,$y0) and bottom right is ($x1,$y1)
using a line colour of $colour. If C<$fill> is true then the rectangle will be
filled.

=head2 new()

Virtual - must be overridden.

Recommend that it at least supports C<-file> (filename), C<-width> and
C<-height>.

=head2 new_from_serialised()

Not implemented. Recommended for inheritors. Should accept a string serialised
using serialise() and return an object (reference).

=head2 serialise()

Not implemented. Recommended for inheritors. Should return a string
representation (ideally compressed).

=head2 get()
     
    my $width = $i->get( -width ) ;
    my( $hotx, $hoty ) = $i->get( -hotx, -hoty ) ;

Get any of the object's attributes. Multiple attributes may be requested in a
single call.

See C<xy> get/set colours of the image itself.

=head2 set()

Virtual - must be overridden.

Set any of the object's attributes. Multiple attributes may be set in a single
call; some attributes are read-only.

See C<xy> get/set colours of the image itself.

=head2 xy()

Virtual - must be overridden. Expected to provide the following functionality:

    $i->xy( 4, 11, '#123454' ) ;    # Set the colour at point 4,11
    my $v = $i->xy( 9, 17 ) ;       # Get the colour at point 9,17

Get/set colours using x, y coordinates; coordinates start at 0. 

When called to set the colour the value returned is class specific; when
called to get the colour the value returned is the colour name, e.g. 'blue' or
'#f0f0f0', etc, e.g.

    $colour = xy( $x, $y ) ;  # e.g. #123456 
    xy( $x, $y, $colour ) ;   # Return value is class specific

We don't normally pick up the return value when setting the colour.

=head2 load()

Virtual - must be overridden. Expected to provide the following functionality:

    $i->load ;
    $i->load( 'test.xpm' ) ;

Load the image whose name is given, or if none is given load the image whose
name is in the C<-file> attribute.

=head2 save()

Virtual - must be overridden. Expected to provide the following functionality:

    $i->save ;
    $i->save( 'test.xpm' ) ;

Save the image using the name given, or if none is given save the image using
the name in the C<-file> attribute. The image is saved in xpm format.

=head1 CHANGES

2000/05/05

Added some basic drawing methods. Minor documentation changes.


2000/05/04

Created. 


=head1 AUTHOR

Mark Summerfield. I can be contacted as <summer@perlpress.com> -
please include the word 'imagebase' in the subject line.

=head1 COPYRIGHT

Copyright (c) Mark Summerfield 2000. All Rights Reserved.

This module may be used/distributed/modified under the LGPL. 

=cut

