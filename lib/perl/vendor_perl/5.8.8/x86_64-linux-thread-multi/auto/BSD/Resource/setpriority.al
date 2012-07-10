# NOTE: Derived from blib/lib/BSD/Resource.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package BSD::Resource;

#line 576 "blib/lib/BSD/Resource.pm (autosplit into blib/lib/auto/BSD/Resource/setpriority.al)"
sub setpriority (;$$$) {
    croak 'setpriority: use PRIO_..., not "PRIO_..."'
	if @_ && $_[0] =~ /^PRIO_/;
    _setpriority(@_);
}

# end of BSD::Resource::setpriority
1;
