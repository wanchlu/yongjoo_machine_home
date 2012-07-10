# Copyrights 2002-2003,2007-2008 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.05.
package Hash::Case::Lower;
use vars '$VERSION';
$VERSION = '1.006';

use base 'Hash::Case';

use strict;
use Carp;


sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::native_init($args);

    croak "No options possible for ".__PACKAGE__
        if keys %$args;

    $self;
}

sub FETCH($)  { $_[0]->{lc $_[1]} }
sub STORE($$) { $_[0]->{lc $_[1]} = $_[2] }
sub EXISTS($) { exists $_[0]->{lc $_[1]} }
sub DELETE($) { delete $_[0]->{lc $_[1]} }

1;
