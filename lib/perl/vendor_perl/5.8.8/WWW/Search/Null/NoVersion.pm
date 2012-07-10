# $Id: NoVersion.pm,v 1.4 2007/11/12 01:13:50 Daddy Exp $

=head1 NAME

WWW::Search::Null::NoVersion - class for testing WWW::Search

=head1 SYNOPSIS

  use WWW::Search;
  my $oSearch = new WWW::Search('Null::NoVersion');

=head1 DESCRIPTION

This class is a specialization of WWW::Search that has no $VERSION.

This module is for testing the WWW::Search module.

=head1 AUTHOR

Martin Thurn <mthurn@cpan.org>

=cut

package WWW::Search::Null::NoVersion;

use strict;
use warnings;

use base 'WWW::Search';
our $MAINTAINER = q{Martin Thurn <mthurn@cpan.org>};

1;

__END__

