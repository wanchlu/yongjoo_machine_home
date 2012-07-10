# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 385 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/get_secret_keys.al)"
sub get_secret_keys ( $@ )
{
    my ( $self, @key_ids ) = @_;
    
    return $self->get_keys( commands     => [ '--list-secret-keys' ],
			    command_args => [ @key_ids ],
			  );
}

# end of GnuPG::Interface::get_secret_keys
1;
