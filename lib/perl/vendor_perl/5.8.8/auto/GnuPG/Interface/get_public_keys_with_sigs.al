# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 396 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/get_public_keys_with_sigs.al)"
sub get_public_keys_with_sigs ( $@ )
{
    my ( $self, @key_ids ) = @_;

    return $self->get_keys( commands     => [ '--list-sigs' ],
			    command_args => [ @key_ids ],
			  );
}

# end of GnuPG::Interface::get_public_keys_with_sigs
1;
