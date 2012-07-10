# Copyrights 2001-2010 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.06.

use strict;
package Mail::Box::Dbx;
use vars '$VERSION';
$VERSION = '2.094';

use base 'Mail::Box::File';

use Mail::Box::Dbx::Message;
use Mail::Message::Head::Delayed;
use Mail::Message::Body::Delayed;

use Mail::Transport::Dbx 0.04;
use File::Basename 'dirname';


my $default_folder_dir    = '.';

sub init($)
{   my ($self, $args) = @_;
    $args->{folder}     ||= '=Folders.dbx';
    $args->{folderdir}  ||= $default_folder_dir;
    $args->{lock_type}  ||= 'NONE';

    $self->SUPER::init($args) or return;

    $self->log(WARNING => "Dbx folders are read-only.")
        if $self->writable;

    $self;
}


sub create($@) {  shift->notImplemented }


sub foundIn($@)
{   my $class = shift;
    my $name  = @_ % 2 ? shift : undef;
    my %args  = @_;

    $name   ||= $args{folder} or return;
    $name =~ m/\.dbx$/i;
}

sub writeMessages($) { shift->notImplemented }
sub appendMessages($) { shift->notImplemented }
sub type() { 'dbx' }

sub readMessages()
{   my ($self, %args) = @_;

    my @log      =  $self->logSettings;
    my @msgopts  =
     ( @log
     , folder     => $self
     , head_type  => $args{head_type}
     , field_type => $args{field_type}
     , trusted    => $args{trusted}
     );

    my $parser    = $self->parser
        or return;

    my $head_type = $self->{MB_head_delayed_type};
    my $body_type = $self->{MB_body_delayed_type};

    foreach my $record ($parser->emails)
    {   my $head    = $head_type->new(@log);

        my $message = $args{message_type}->new
          ( @msgopts
          , dbx_record => $record
          , head       => $head_type->new(@log)
          ) or next;

        $message->storeBody($body_type->new(@log, message => $message));
        $self->storeMessage($message);
    }

    $self;
}

sub updateMessages() { shift }

sub nameOfSubFolder($;$)
{   my $thing  = shift;
    my $name   = (shift). '.dbx';
    my $parent = @_ ? shift : ref $thing ? $thing->filename : undef;
    defined $parent ?  File::Spec->catfile(dirname($parent), $name) : $name;
}


sub listSubFolders(@)
{   my ($thingy, %args)  = @_;
    my $self       = ref $thingy ? $thingy : $thingy->new;
    my $skip_empty = $args{skip_empty} || 0;
    my $check      = $args{check}      || 0;

    my $parser     = $self->parser
       or return;

    my @subs       = map { $_->name } $parser->subfolders;

    if($args{check})
    {    my $dir   = dirname $self->filename;
         @subs     = grep { -f File::Spec->catfile($dir, $_.'.dbx') } @subs;
    }

    return @subs unless $skip_empty;

    my @filled;
    foreach my $sub (@subs)
    {   my $f = $self->openSubFolder($sub, lock_type => 'NONE');
        push @filled, $f if defined $f && scalar($f->messages);
    }
    @filled;
}

#-------------------------------------------


sub folderToFilename($$)
{   my ($thingy, $name, $folderdir) = @_;
    return $name if File::Spec->file_name_is_absolute($name);
    $name     =~ s#^=#$folderdir/#;
    $name;
}


sub parser()
{   my $self     = shift;
    return $self->{MBD_parser}
        if defined $self->{MBD_parser};

    my $filename = $self->filename;
    my $parser   = eval { Mail::Transport::Dbx->new($filename) };

    unless(defined $parser)
    {   $self->log(ERROR => "Cannot read dbx folder file $filename.");
        return undef;
    }

    $self->{MBD_parser} = $parser;
}

#-------------------------------------------


1;
