# NOTE: Derived from blib/lib/BSD/Resource.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package BSD::Resource;

#line 571 "blib/lib/BSD/Resource.pm (autosplit into blib/lib/auto/BSD/Resource/setrlimit.al)"
sub setrlimit ($$$) {
    croak 'setrlimit: use RLIMIT_..., not "RLIMIT_..."' if $_[0] =~ /^RLIMIT_/;
    _setrlimit($_[0], $_[1], $_[2]);
}

# end of BSD::Resource::setrlimit
1;
