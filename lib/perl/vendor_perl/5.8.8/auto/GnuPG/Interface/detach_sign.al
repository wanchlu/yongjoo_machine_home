# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 630 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/detach_sign.al)"
sub detach_sign( $% )
{
    my ( $self, %args ) = @_;
    return $self->wrap_call( %args,
			     commands => [ '--detach-sign' ] );
}

# end of GnuPG::Interface::detach_sign
1;
