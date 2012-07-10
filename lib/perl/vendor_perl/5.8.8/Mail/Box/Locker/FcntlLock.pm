# Copyrights 2001-2011 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.07.

use strict;

package Mail::Box::Locker::FcntlLock;
use vars '$VERSION';
$VERSION = '2.097';

use base 'Mail::Box::Locker';

use Fcntl;
use IO::File;
use Errno   qw/EAGAIN/;
use File::FcntlLock;



sub init($)
{   my ($self, $args) = @_;
    $args->{file} = $args->{posix_file} if $args->{posix_file};
    $self->SUPER::init($args);
}

sub name() {'FcntlLock'}

sub _try_lock($)
{   my ($self, $file) = @_;
    my $fl = File::FcntlLock->new;
    $fl->l_pid($!+0);
    $fl->l_type(F_WRLCK);
    $? = $fl->lock($file, F_SETLK);
    $?==0;
}

sub _unlock($)
{   my ($self, $file) = @_;
    my $fl = File::FcntlLock->new;
    $fl->l_type(F_UNLCK);
    $fl->lock($file, F_SETLK);
    delete $self->{MBL_has_lock};
    $self;
}


sub lock()
{   my $self   = shift;

    if($self->hasLock)
    {   my $folder = $self->folder;
        $self->log(WARNING => "Folder $folder already lockf'd");
        return 1;
    }

    my $filename = $self->filename;

    my $file   = IO::File->new($filename, 'r+');
    unless(defined $file)
    {   my $folder = $self->folder;
        $self->log(ERROR =>
           "Unable to open FcntlLock lock file $filename for $folder: $!");
        return 0;
    }

    my $end = $self->{MBL_timeout} eq 'NOTIMEOUT' ? -1 : $self->{MBL_timeout};

    while(1)
    {   if($self->_try_lock($file))
        {   $self->{MBL_has_lock}    = 1;
            $self->{MBLF_filehandle} = $file;
            return 1;
        }

        unless($!==EAGAIN)
        {   $self->log(ERROR =>
            "Will never get a FcntlLock lock on $filename for $self->{MBL_folder}: $!");
            last;
        }

        last unless --$end;
        sleep 1;
    }

    return 0;
}


sub isLocked()
{   my $self     = shift;
    my $filename = $self->filename;

    my $file     = IO::File->new($filename, "r");
    unless($file)
    {   $self->log(ERROR =>
               "Unable to check lock file $filename for $self->{MBL_folder}: $!");
        return 0;
    }

    $self->_try_lock($file)==0 or return 0;
    $self->_unlock($file);
    $file->close;
    1;
}

sub unlock()
{   my $self = shift;

    $self->_unlock(delete $self->{MBLF_filehandle})
       if $self->hasLock;

    $self;
}

1;
