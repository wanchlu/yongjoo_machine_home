# Copyrights 2003,2004,2007 by Mark Overmeer <perl@overmeer.net>.
# For other contributors see Changes.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 0.99.

package User::Identity::Archive;
use vars '$VERSION';
$VERSION = '0.91';
use base 'User::Identity::Item';

use strict;
use warnings;


sub type { "archive" }


sub init($)
{   my ($self, $args) = @_;
    $self->SUPER::init($args) or return;

    if(my $from = delete $args->{from})
    {   $self->from($from) or return;
    }

    $self;
}

#-----------------------------------------


1;

