# NOTE: Derived from blib/lib/BSD/Resource.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package BSD::Resource;

#line 565 "blib/lib/BSD/Resource.pm (autosplit into blib/lib/auto/BSD/Resource/getpriority.al)"
sub getpriority (;$$) {
    croak 'setpriority: use PRIO_..., not "PRIO_..."'
	if @_ && $_[0] =~ /^PRIO_/;
    _getpriority(@_);
}

# end of BSD::Resource::getpriority
1;
