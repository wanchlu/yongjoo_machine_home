# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 701 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/test_default_key_passphrase.al)"
sub test_default_key_passphrase()
{
    my ( $self ) = @_;
    
    # We can't do something like let the user pass
    # in a passphrase handle because we don't exist
    # anymore after the user runs off with the
    # attachments
    croak 'No passphrase defined to test!'
      unless defined $self->passphrase();
    
    my $stdin       = IO::Handle->new();
    my $stdout      = IO::Handle->new();
    my $stderr      = IO::Handle->new();
    my $status      = IO::Handle->new();
    
    my $handles = GnuPG::Handles->new
      ( stdin    => $stdin,
	stdout   => $stdout,
	stderr   => $stderr,
	status   => $status );
    
    # save this setting since we need to be in non-interactive mode
    my $saved_meta_interactive_option = $self->options->meta_interactive();
    $self->options->clear_meta_interactive();
    
    my $pid = $self->sign( handles => $handles );
    
    close $stdin;
    
    # restore this setting to its original setting
    $self->options->meta_interactive( $saved_meta_interactive_option );
    
    # all we realy want to check is the status fh
    while ( <$status> )
    {
	if ( /^\[GNUPG:\]\s*GOOD_PASSPHRASE/ )
	{
	    waitpid $pid, 0;
	    return 1;
	}
    }
    
    # If we didn't catch the regexp above, we'll assume
    # that the passphrase was incorrect
    waitpid $pid, 0;
    return 0;
}

1;

##############################################################


1;
# end of GnuPG::Interface::test_default_key_passphrase
