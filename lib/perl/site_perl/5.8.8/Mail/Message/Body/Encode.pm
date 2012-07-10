# Copyrights 2001-2010 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.06.

use strict;
use warnings;

package Mail::Message::Body;
use vars '$VERSION';
$VERSION = '2.094';

use base 'Mail::Reporter';

use Carp;

use MIME::Types;
use File::Basename 'basename';
use Encode         'find_encoding';

# http://www.iana.org/assignments/character-sets
use Encode::Alias;
define_alias(qr/^unicode-?1-?1-?utf-?([78])$/i => '"UTF-$1"');  # rfc1642

my $mime_types;


sub encode(@)
{   my ($self, %args) = @_;

    # simplify the arguments

    my $type_from = $self->type;
    my $type_to   = $args{mime_type} || $type_from->clone;
    $type_to = Mail::Message::Field->new('Content-Type' => $type_to)
        unless ref $type_to;

    my $transfer = $args{transfer_encoding} || $self->transferEncoding->clone;
    $transfer    = Mail::Message::Field->new('Content-Transfer-Encoding'
        => $transfer) unless ref $transfer;

    my ($char_was, $char_to) = ('', '');
    if($type_from =~ m!^text/!i)
    {   $char_was = $type_from->attribute('charset') || 'us-ascii';
        $char_to  = $type_to->attribute('charset');

        my $charset = delete $args{charset};

        if(!$char_to || $char_to eq 'PERL')
        {    $char_to = $charset || ($char_was eq 'PERL' ? 'utf-8' : $char_was);
             $type_to->attribute(charset => $char_to);
        }
    }

    my $trans_was = lc $self->transferEncoding;
    my $trans_to  = lc $transfer;

    #
    # The only translations implemented now is content transfer encoding.
    #

    return $self
        if   $trans_was eq   $trans_to
        && lc $char_was eq lc $char_to;

    my $bodytype  = $args{result_type} || ref $self;

    my $decoded;
    if($trans_was eq 'none')
    {   $decoded = $self;
    }
    elsif(my $decoder = $self->getTransferEncHandler($trans_was))
    {   $decoded = $decoder->decode($self, result_type => $bodytype) }
    else
    {   $self->log(WARNING =>
           "No decoder defined for transfer encoding $trans_was.");
        return $self;
    }

    my $recoded = $decoded;
    if(lc($char_was) eq lc($char_to)) { ; }
    elsif($char_was eq 'PERL')   
    {   if(my $recoder = find_encoding $char_to)
        {   $recoded = $bodytype->new
              ( based_on  => $decoded
              , data      => $recoder->encode($decoded->string)
              , mime_type => $type_to);
        }
        else
        {   $self->log(WARNING => "Charset `$char_to' is not known.") }
    }
    elsif($char_to eq 'PERL')
    {   if(my $recoder = find_encoding $char_was)
        {   $recoded = $bodytype->new
              ( based_on  => $decoded
              , data      => $recoder->decode($decoded->string)
              , mime_type => $type_to);
        }
        else
        {   $self->log(WARNING => "Charset `$char_was' is not known.") }
    }
    else
    {   my $from = find_encoding $char_was;
        my $to   = find_encoding $char_to;
        if(!$from)
        {   $self->log(WARNING => "Charset `$char_was' is not known.");
        }
        elsif(!$to)
        {   $self->log(WARNING => "Charset `$char_to' is not known.");
        }
        else
        {   $recoded = $bodytype->new
              ( based_on  => $decoded
              , data      => $to->encode($from->decode($decoded))
              , mime_type => $type_to);
        }
    }

    my $trans;
    if($trans_to ne 'none')
    {   $trans = $self->getTransferEncHandler($trans_to)
           or $self->log(WARNING =>
               "No encoder defined for transfer encoding `$trans_to'.");
    }

    my $encoded = defined $trans
      ? $trans->encode($recoded, result_type => $bodytype)
      : $recoded;
    $encoded;
}

#------------------------------------------


sub check()
{   my $self     = shift;
    return $self if $self->checked;
    my $eol      = $self->eol;

    my $encoding = $self->transferEncoding->body;
    return $self->eol($eol)
       if $encoding eq 'none';

    my $encoder  = $self->getTransferEncHandler($encoding);

    my $checked
      = $encoder
      ? $encoder->check($self)->eol($eol)
      : $self->eol($eol);

    $checked->checked(1);
    $checked;
}

#------------------------------------------


sub encoded()
{   my $self = shift;

    $mime_types ||= MIME::Types->new;
    my $mime    = $mime_types->type($self->type->body);

    my $charset = $self->charset || '';
    my $enc_was = $self->transferEncoding;
    my $enc     = $enc_was;
    $enc        = defined $mime ? $mime->encoding : 'base64'
        if $enc eq 'none';

    # we could (expensively) try to autodetect character-set used,
    # but everything is a subset of utf-8.
    my $new_charset
       = (!$mime || $mime !~ m!^text/!i)   ? ''
       : (!$charset || $charset eq 'PERL') ? 'utf-8'
       :                                     $charset;

    return $self->check
        if $enc_was ne 'none' && $charset eq $new_charset;

    $self->encode
      ( transfer_encoding => $enc
      , charset           => $new_charset
      );
}

#------------------------------------------


sub unify($)
{   my ($self, $body) = @_;
    return $self if $self==$body;

    my $mime     = $self->type;
    my $transfer = $self->transferEncoding;

    my $encoded  = $body->encode
     ( mime_type         => $mime
     , transfer_encoding => $transfer
     );

    # Encode makes the best of it, but is it good enough?

    my $newmime     = $encoded->type;
    return unless $newmime  eq $mime;
    return unless $transfer eq $encoded->transferEncoding;
    $encoded;
}

#------------------------------------------


sub isBinary()
{   my $self = shift;
    $mime_types ||= MIME::Types->new(only_complete => 1);
    my $type = $self->type                    or return 1;
    my $mime = $mime_types->type($type->body) or return 1;
    $mime->isBinary;
}
 
#------------------------------------------


sub isText() { not shift->isBinary }

#------------------------------------------


sub dispositionFilename(;$)
{   my $self = shift;
    my $raw;

    my $field;
    if($field = $self->disposition)
    {   $raw  = $field->attribute('filename')
             || $field->attribute('file')
             || $field->attribute('name');
    }

    if(!defined $raw && ($field = $self->type))
    {   $raw  = $field->attribute('filename')
             || $field->attribute('file')
             || $field->attribute('name');
    }

    return $raw unless @_;

    my $dir      = shift;
    my $filename = '';
    if(defined $raw)
    {   $filename = basename $raw;
        $filename =~ s/[^\w.-]//;
    }

    unless(length $filename)
    {   my $ext    = ($self->mimeType->extensions)[0] || 'raw';
        my $unique;
        for($unique = 'part-0'; 1; $unique++)
        {   my $out = File::Spec->catfile($dir, "$unique.$ext");
            open IN, "<", $out or last;  # does not exist: can use it
            close IN;
        }
        $filename = "$unique.$ext";
    }

    File::Spec->catfile($dir, $filename);
}

#------------------------------------------


my %transfer_encoder_classes =
 ( base64  => 'Mail::Message::TransferEnc::Base64'
 , binary  => 'Mail::Message::TransferEnc::Binary'
 , '8bit'  => 'Mail::Message::TransferEnc::EightBit'
 , 'quoted-printable' => 'Mail::Message::TransferEnc::QuotedPrint'
 , '7bit'  => 'Mail::Message::TransferEnc::SevenBit'
 );

my %transfer_encoders;   # they are reused.

sub getTransferEncHandler($)
{   my ($self, $type) = @_;

    return $transfer_encoders{$type}
        if exists $transfer_encoders{$type};   # they are reused.

    my $class = $transfer_encoder_classes{$type};
    return unless $class;

    eval "require $class";
    confess "Cannot load $class: $@\n" if $@;

    $transfer_encoders{$type} = $class->new;
}

#------------------------------------------


sub addTransferEncHandler($$)
{   my ($this, $name, $what) = @_;

    my $class;
    if(ref $what)
    {   $transfer_encoders{$name} = $what;
        $class = ref $what;
    }
    else
    {   delete $transfer_encoders{$name};
        $class = $what;
    }

    $transfer_encoder_classes{$name} = $class;
    $this;
}

1;
