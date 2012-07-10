# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 585 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/list_secret_keys.al)"
sub list_secret_keys
{
    my ( $self, %args ) = @_;
    return $self->wrap_call( %args,
			     commands => [ '--list-secret-keys' ],
			   );
}

# end of GnuPG::Interface::list_secret_keys
1;
