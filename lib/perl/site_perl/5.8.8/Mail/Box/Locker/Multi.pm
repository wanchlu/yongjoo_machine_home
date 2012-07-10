# Copyrights 2001-2010 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.06.

use strict;

package Mail::Box::Locker::Multi;
use vars '$VERSION';
$VERSION = '2.094';

use base 'Mail::Box::Locker';

use Carp;


sub init($)
{   my ($self, $args) = @_;
    $self->SUPER::init($args);

    my @use
     = exists $args->{use} ? @{delete $args->{use}}
     : $^O =~ m/mswin/i    ? qw/    POSIX Flock/
     :                       qw/NFS POSIX Flock/;

    my (@lockers, @used);

    foreach my $method (@use)
    {   if(UNIVERSAL::isa($method, 'Mail::Box::Locker'))
        {   push @lockers, $method;
            (my $used = ref $method) =~ s/.*\:\://;
            push @used, $used;
            next;
        }

        my $locker = eval
        {   Mail::Box::Locker->new
              ( %$args
              , method  => $method
              , timeout => 1
              )
        };
        next unless defined $locker;

        push @lockers, $locker;
        push @used, $method;
    }

    $self->{MBLM_lockers} = \@lockers;
    $self->log(PROGRESS => "Multi-locking via @used.");
    $self;
}

#-------------------------------------------

sub name() {'MULTI'}

sub _try_lock($)
{   my $self     = shift;
    my @successes;

    foreach my $locker ($self->lockers)
    {
        unless($locker->lock)
        {   $_->unlock foreach @successes;
            return 0;
        }
        push @successes, $locker;
    }

    1;
}

sub unlock()
{   my $self = shift;
    return $self unless $self->{MBL_has_lock};

    $_->unlock foreach $self->lockers;
    delete $self->{MBL_has_lock};

    $self;
}

sub lock()
{   my $self  = shift;
    return 1 if $self->hasLock;

    my $end   = $self->{MBL_timeout} eq 'NOTIMEOUT' ? -1 : $self->{MBL_timeout};

    while(1)
    {   return $self->{MBL_has_lock} = 1
            if $self->_try_lock;

        last unless --$end;
        sleep 1;
    }

    return 0;
}

sub isLocked()
{   my $self     = shift;
    $self->_try_lock($self->filename) or return 0;
    $self->unlock;
    1;
}

#-------------------------------------------


sub lockers() { @{shift->{MBLM_lockers}} }

1;
