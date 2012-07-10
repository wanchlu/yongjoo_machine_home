# Copyrights 2001-2011 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.07.

package Mail::Box::POP3s;
use vars '$VERSION';
$VERSION = '2.097';

use base 'Mail::Box::POP3';

use strict;
use warnings;


sub init($)
{   my ($self, $args) = @_;
    $args->{server_port} ||= 995;
    $self->SUPER::init($args);
    $self;
}

sub type() {'pop3s'}

#-------------------------------------------


sub popClient(%)
{   my $self = shift;
    $self->SUPER::popClient(@_, use_ssl => 1);
}

1;
