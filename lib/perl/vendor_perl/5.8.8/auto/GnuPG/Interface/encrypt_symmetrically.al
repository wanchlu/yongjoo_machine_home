# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 604 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/encrypt_symmetrically.al)"
sub encrypt_symmetrically( $% )
{
    my ( $self, %args ) = @_;
    return $self->wrap_call( %args,
			     commands => [ '--symmetric' ] );
}

# end of GnuPG::Interface::encrypt_symmetrically
1;
