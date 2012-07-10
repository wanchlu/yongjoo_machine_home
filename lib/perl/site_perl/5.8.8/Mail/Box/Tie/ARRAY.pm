# Copyrights 2001-2010 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.06.

use strict;
package Mail::Box::Tie::ARRAY;
use vars '$VERSION';
$VERSION = '2.094';


use Carp;


sub TIEARRAY(@)
{   my ($class, $folder) = @_;
    croak "No folder specified to tie to."
        unless ref $folder && $folder->isa('Mail::Box');

    bless { MBT_folder => $folder }, $class;
}

#-------------------------------------------


sub FETCH($)
{   my ($self, $index) = @_;
    my $msg = $self->{MBT_folder}->message($index);
    $msg->isDeleted ? undef : $msg;
}

#-------------------------------------------


sub STORE($$)
{   my ($self, $index, $msg) = @_;
    my $folder = $self->{MBT_folder};

    croak "Cannot simply replace messages in a folder: use delete old, then push new."
        unless $index == $folder->messages;

    $folder->addMessages($msg);
    $msg;
}

#-------------------------------------------


sub FETCHSIZE()  { scalar shift->{MBT_folder}->messages }

#-------------------------------------------


sub PUSH(@)
{   my $folder = shift->{MBT_folder};
    $folder->addMessages(@_);
    scalar $folder->messages;
}
 

#-------------------------------------------


sub DELETE($) { shift->{MBT_folder}->message(shift)->delete }

#-------------------------------------------


sub STORESIZE($)
{   my $folder = shift->{MBT_folder};
    my $length = shift;
    $folder->message($_) foreach $length..$folder->messages;
    $length;
}

# DESTROY is implemented in Mail::Box

#-------------------------------------------


1;
