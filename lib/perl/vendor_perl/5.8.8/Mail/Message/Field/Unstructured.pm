# Copyrights 2001-2011 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.07.
use strict;
use warnings;

package Mail::Message::Field::Unstructured;
use vars '$VERSION';
$VERSION = '2.097';

use base 'Mail::Message::Field::Full';


sub init($)
{   my ($self, $args) = @_;

    if($args->{body} && ($args->{encoding} || $args->{charset}))
    {   $args->{body} = $self->encode($args->{body}, %$args);
    }

    $self->SUPER::init($args) or return;

    $self->log(WARNING=>"Attributes are not supported for unstructured fields")
        if defined $args->{attributes};

    $self->log(WARNING => "No extras for unstructured fields")
        if defined $args->{extra};

    $self;
}


1;
