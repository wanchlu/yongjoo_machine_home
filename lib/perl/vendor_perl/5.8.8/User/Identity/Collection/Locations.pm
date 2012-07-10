# Copyrights 2003,2004,2007 by Mark Overmeer <perl@overmeer.net>.
# For other contributors see Changes.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 0.99.
package User::Identity::Collection::Locations;
use vars '$VERSION';
$VERSION = '0.91';
use base 'User::Identity::Collection';

use strict;
use warnings;

use User::Identity::Location;

use Carp qw/croak/;


sub new(@)
{   my $class = shift;
    $class->SUPER::new(locations => @_);
}

sub init($)
{   my ($self, $args) = @_;
    $args->{item_type} ||= 'User::Identity::Location';

    $self->SUPER::init($args);

    $self;
}

sub type() { 'whereabouts' }

1;

