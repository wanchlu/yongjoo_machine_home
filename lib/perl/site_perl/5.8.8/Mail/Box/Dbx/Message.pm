# Copyrights 2001-2010 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.06.

use strict;
use warnings;

package Mail::Box::Dbx::Message;
use vars '$VERSION';
$VERSION = '2.094';

use base 'Mail::Box::File::Message';

use Carp;
use File::Copy qw/move/;

use Mail::Message::Body::String;
use Mail::Message::Head::Partial;


sub init($)
{   my ($self, $args) = @_;

    my $dbx = $args->{dbx_record};
    unless(defined $dbx)
    {   $self->log(ERROR => 'Dbx record required to create the message.');
        return;
    }
    push @{$args->{labels}}, (seen => $dbx->is_seen);

    $self->SUPER::init($args);

    $self->{MBDM_dbx}          = $dbx;
    $self->{MBDM_account_name} = $args->{account_name} || $dbx->oe_account_name;
    $self->{MBDM_account_nr}   = $args->{account_nr}   || $dbx->oe_account_num;
    $self;
}

#-------------------------------------------

sub loadHead()
{   my $self     = shift;
    my $head     = $self->head;
    return $head unless $head->isDelayed;

    $self->loadBody;
    $self->head;
}

#-------------------------------------------

sub loadBody()
{   my $self     = shift;

    my $body     = $self->body;
    return $body unless $body->isDelayed;

    my $dbx      = $self->dbxRecord or return;
    unless(defined $dbx)
    {   $self->log(ERROR => 'Unable to read delayed message.');
        return;
    }

    my $head;
    if(my $text = $dbx->as_string)
    {   my $message = Mail::Message->read($text);
        $head    = $message->head;
        $head->modified(0);
        $body    = $message->body;
    }
    else
    {   # of course, it is not a complete head :(  probably, we need a
        # new object...  put for now, make it simple.
        $head     = Mail::Message::Head::Partial->new;
        my $ff = 'Mail::Message::Field::Fast';

        $head->addNoRealize($ff->new(Subject => $dbx->subject));
        $head->addNoRealize($ff->new('Message-ID' => $dbx->msgid));
        $head->addNoRealize($ff->new('X-Dbx-Account-Name'=>$self->accountName));
        $head->addNoRealize($ff->new('X-Dbx-Account-Nr'=> $self->accountNr));

        if(my $parents = $dbx->parents_ids)
        {   $head->addNoRealize($ff->new(References => $parents));
        }

        # I know this is not the right date, but at least it is something.
        $head->addNoRealize($ff->new(Date => $ff->toDate($dbx->rcvd_gmtime)));

        if(my $send_addr = $dbx->sender_address)
        {   my $sender = Mail::Address->new($dbx->sender_name, $send_addr);
            # This should be stored in Sender, because From can have
            # more than one address,.... however... this is Outlook.
            $head->addNoRealize($ff->new(From => $send_addr));
        }

        if(my $to_addr = $dbx->recip_address)
        {   my $to     =  Mail::Address->new($dbx->recip_name, $to_addr);
            # Also not correct to put it in To: Delivered-To is the
            # right choice.  But it is nice to have a To field...
            $head->addNoRealize($ff->new(To => $to));
        }

        $body = Mail::Message::Body::String->new(data => << 'NOBODY');
 * The contents of this message was not received

NOBODY
    }

    $self->head($head);
    $self->storeBody($body);

    $self->log(PROGRESS => 'Loaded delayed message.');
    $self;
}

#-------------------------------------------


sub dbxRecord() { shift->{MBDM_dbx} }

#-------------------------------------------


sub accountName() { shift->{MBDM_account_name} }

#-------------------------------------------


sub accountNr() { shift->{MBDM_account_nr} }

#-------------------------------------------

1;
