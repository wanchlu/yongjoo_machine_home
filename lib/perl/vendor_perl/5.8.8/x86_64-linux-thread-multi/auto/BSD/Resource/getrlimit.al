# NOTE: Derived from blib/lib/BSD/Resource.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package BSD::Resource;

#line 540 "blib/lib/BSD/Resource.pm (autosplit into blib/lib/auto/BSD/Resource/getrlimit.al)"
sub getrlimit ($) {
    croak 'getrlimit: use RLIMIT_..., not "RLIMIT_..."' if $_[0] =~ /^RLIMIT_/;
    my @rlimit = _getrlimit($_[0]);

    if (wantarray) {
	@rlimit;
    } else {
	my $rlimit = {};
	my $key;

	for $key (qw(soft hard)) {
	    $rlimit->{$key} = shift(@rlimit);
	}

	bless $rlimit;
    }
}

# end of BSD::Resource::getrlimit
1;
