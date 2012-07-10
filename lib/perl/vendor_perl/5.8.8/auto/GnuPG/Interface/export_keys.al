# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 676 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/export_keys.al)"
sub export_keys( $% )
{
    my ( $self, %args ) = @_;
    return $self->wrap_call( %args,
			     commands => [ '--export' ] );
}

# end of GnuPG::Interface::export_keys
1;
