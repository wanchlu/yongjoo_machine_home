# Copyrights 2001-2011 by Mark Overmeer.
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.07.
use strict;
use warnings;

package Mail::Message::Field::Structured;
use vars '$VERSION';
$VERSION = '2.097';

use base 'Mail::Message::Field::Full';

use Mail::Message::Field::Attribute;


sub init($)
{   my ($self, $args) = @_;
    $self->{MMFS_attrs} = {};

    $self->SUPER::init($args);

    $self->datum($args->{datum})
        if defined $args->{datum};

    my $attr = $args->{attributes} || [];
    $attr    = [ %$attr ] if ref $attr eq 'HASH';

    while(@$attr)
    {   my $name = shift @$attr;
        if(ref $name) { $self->attribute($name) }
        else          { $self->attribute($name, shift @$attr) }
    }

    $self;
}

sub clone() { dclone(shift) }

#------------------------------------------


sub attribute($;$)
{   my ($self, $attr) = (shift, shift);
    my $name;
    if(ref $attr) { $name = $attr->name }
    elsif( !@_ )  { return $self->{MMFS_attrs}{lc $attr} }
    else
    {   $name = $attr;
        $attr = Mail::Message::Field::Attribute->new($name, @_);
    }

    delete $self->{MMFF_body};
    if(my $old =  $self->{MMFS_attrs}{$name})
    {   $old->mergeComponent($attr);
        return $old;
    }
    else
    {   $self->{MMFS_attrs}{$name} = $attr;
        return $attr;
    }
}


sub attributes() { values %{shift->{MMFS_attrs}} }

sub beautify() { delete shift->{MMFF_body} }


sub parse($)
{   my ($self, $string) = @_;
    my $datum = '';
    while(length $string && substr($string, 0, 1) ne ';')
    {   (undef, $string)  = $self->consumeComment($string);
        $datum .= $1 if $string =~ s/^([^;(]+)//;
    }
    $self->datum($datum);

    my $found = '';
    while($string =~ m/\S/)
    {   my $len = length $string;

        if($string =~ s/^\s*\;\s*// && length $found)
        {   my $attr = Mail::Message::Field::Attribute->new($found);
            $self->attribute($attr);
            $found = '';
        }

        (undef, $string) = $self->consumeComment($string);
        $string =~ s/^\n//;
        (my $text, $string) = $self->consumePhrase($string);
        $found .= $text if defined $text;

        if(length($string) == $len)
        {   # nothing consumed, remove character to avoid endless loop
            $string =~ s/^\s*\S//;
        }
    }

    if(length $found)
    {   my $attr = Mail::Message::Field::Attribute->new($found);
        $self->attribute($attr);
    }

    1;
}

sub produceBody()
{   my $self  = shift;
    my $attrs = $self->{MMFS_attrs};
    my $datum = $self->datum;

    join '; '
       , (defined $datum ? $datum : '')
       , map {$_->string} @{$attrs}{sort keys %$attrs};
}


sub datum(;$)
{   my $self = shift;
    @_ ? ($self->{MMFS_datum} = shift) : $self->{MMFS_datum};
}
*body = \&datum;

1;
