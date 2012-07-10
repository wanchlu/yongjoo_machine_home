# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 575 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/list_sigs.al)"
sub list_sigs
{
    my ( $self, %args ) = @_;
    return $self->wrap_call( %args,
			     commands => [ '--list-sigs' ],
			   );
}

# end of GnuPG::Interface::list_sigs
1;
