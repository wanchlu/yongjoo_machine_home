# NOTE: Derived from blib/lib/GnuPG/Interface.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package GnuPG::Interface;

#line 407 "blib/lib/GnuPG/Interface.pm (autosplit into blib/lib/auto/GnuPG/Interface/get_keys.al)"
sub get_keys
{
    my ( $self, %args ) = @_;
    
    my $saved_options = $self->options();
    my $new_options   = $self->options->copy();
    $self->options( $new_options );
    $self->options->push_extra_args( '--with-colons',
				     '--with-fingerprint',
				     '--with-fingerprint',
				   );
    
    my $stdin  = IO::Handle->new();
    my $stdout = IO::Handle->new();
    
    my $handles = GnuPG::Handles->new( stdin  => $stdin,
				       stdout => $stdout,
				     );
    
    my $pid = $self->wrap_call( handles => $handles,
				%args,
			      );
    
    my @returned_keys;
    my $current_key;
    my $current_signed_item;
    my $current_fingerprinted_key;
    
    require GnuPG::PublicKey;
    require GnuPG::SecretKey;
    require GnuPG::SubKey; 
    require GnuPG::Fingerprint;
    require GnuPG::UserId; 
    require GnuPG::Signature;
    
    while ( <$stdout> )
    {
	my $line = $_;
	chomp $line;
	my @fields = split ':', $line;
	next unless @fields > 3;
	
	my $record_type = $fields[0];
	
	if ( $record_type eq 'pub' or $record_type eq 'sec' )
	{
	    push @returned_keys, $current_key
	      if $current_key;
	    
	    my ( $user_id_validity, $key_length, $algo_num, $hex_key_id,
		 $creation_date_string, $expiration_date_string,
		 $local_id, $owner_trust, $user_id_string )
	      = @fields[1..$#fields];
	    
	    $current_key = $current_fingerprinted_key
	      = $record_type eq 'pub'
		? GnuPG::PublicKey->new()
		  : GnuPG::SecretKey->new();
	    
	    $current_key->hash_init
	      ( length                 => $key_length,
		algo_num               => $algo_num,
		hex_id                 => $hex_key_id,
		local_id               => $local_id,
		owner_trust            => $owner_trust,
		creation_date_string   => $creation_date_string,
		expiration_date_string => $expiration_date_string,
	      );
	    
	    $current_signed_item = GnuPG::UserId->new
	      ( validity   => $user_id_validity,
		as_string  => $user_id_string,
	      );
	    
	    $current_key->push_user_ids( $current_signed_item );
	}
	elsif ( $record_type eq 'fpr' )
	{
	    my $hex = $fields[9];
	    my $f = GnuPG::Fingerprint->new( as_hex_string => $hex );
	    $current_fingerprinted_key->fingerprint( $f );
	}
	elsif ( $record_type eq 'sig' )
	{
	    my ( $algo_num, $hex_key_id,
		 $signature_date_string, $user_id_string )
	      = @fields[3..5,9];
	    
	    my $signature = GnuPG::Signature->new
	      ( algo_num        => $algo_num,
		hex_id          => $hex_key_id,
		date_string     => $signature_date_string,
		user_id_string  => $user_id_string,
	      );
	    
	    if ( $current_signed_item->isa( 'GnuPG::UserId' ) )
	    {
		$current_signed_item->push_signatures( $signature );
	    }
	    elsif ( $current_signed_item->isa( 'GnuPG::SubKey' ) )
	    {
		$current_signed_item->signature( $signature );
	    }
	    else
	    {
		warn "do not know how to handle signature line: $line\n";
	    }
	}
	elsif ( $record_type eq 'uid' )
	{
	    my ( $validity, $user_id_string ) = @fields[1,9];
	    
	    $current_signed_item = GnuPG::UserId->new
	      ( validity  => $validity,
		as_string => $user_id_string,
	      );
	    
	    $current_key->push_user_ids( $current_signed_item );
	}
	elsif ( $record_type eq 'sub' or $record_type eq 'ssb' )
	{
	    my ( $validity, $key_length, $algo_num, $hex_id,
		 $creation_date_string, $expiration_date_string,
		 $local_id )
	      = @fields[1..7];
	    
	    $current_signed_item = $current_fingerprinted_key
	      = GnuPG::SubKey->new
		( validity               => $validity,
		  length                 => $key_length,
		  algo_num               => $algo_num,
		  hex_id                 => $hex_id,
		  creation_date_string   => $creation_date_string,
		  expiration_date_string => $expiration_date_string,
		  local_id               => $local_id,
		);
	    
	    $current_key->push_subkeys( $current_signed_item );
	}
	elsif ( $record_type ne 'tru' )
	{
	    warn "unknown record type $record_type"; 
	}
    }
    
    waitpid $pid, 0;
    
    push @returned_keys, $current_key
      if $current_key;
    
    $self->options( $saved_options );
    
    return @returned_keys;
}

# end of GnuPG::Interface::get_keys
1;
