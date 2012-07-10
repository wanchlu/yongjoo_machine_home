# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 622 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/clearsign.al)"
sub clearsign( $% )
{
    my ( $self, %args ) = @_;
    return $self->wrap_call( %args,,
			     commands => [ '--clearsign' ] );
}

# end of GnuPG::Interface::clearsign
1;
