# $Id: DondeEstan.pm 2741 2009-10-11 18:53:43Z rcaputo $

package POE::Test::DondeEstan;

use warnings;
use strict;

use File::Spec;

# It's a pun on Marco Polo, the swimming game, and Marco A. Manzo,
# this cool dude I know.  Hi, Marco!

sub marco {
	my @aqui = File::Spec->splitdir(__FILE__);
	pop @aqui;
	return File::Spec->catdir(@aqui);
}

1;
