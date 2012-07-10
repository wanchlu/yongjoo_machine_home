# Copyrights 2001-2011 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.07.

use strict;
package Mail::Box::Mbox::Message;
use vars '$VERSION';
$VERSION = '2.097';

use base 'Mail::Box::File::Message';


#-------------------------------------------

sub head(;$$)
{   my $self  = shift;
    return $self->SUPER::head unless @_;

    my ($head, $labels) = @_;
    $self->SUPER::head($head, $labels);

    $self->statusToLabels if $head && !$head->isDelayed;
    $head;
}

#-------------------------------------------

sub label(@)
{   my $self   = shift;
    $self->loadHead;    # be sure the status fields have been read
    my $return = $self->SUPER::label(@_);
    $return;
}

#-------------------------------------------

sub labels(@)
{   my $self   = shift;
    $self->loadHead;    # be sure the status fields have been read
    $self->SUPER::labels(@_);
}

#------------------------------------------

1;
