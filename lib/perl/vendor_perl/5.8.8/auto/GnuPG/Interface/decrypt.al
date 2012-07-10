# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 649 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/decrypt.al)"
sub decrypt( $% )
{
    my ( $self, %args ) = @_;
    return $self->wrap_call( %args,
			     commands => [ '--decrypt' ] );
}

# end of GnuPG::Interface::decrypt
1;
