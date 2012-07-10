# script: test_esearchhandler.t
# functionality: Test Bio's ESearchHandler against a reference XML parser 

use strict;
use warnings;
use Test::More tests => 6;
use XML::Parser::PerlSAX;
use Clair::Bio::EUtils::ESearchHandler;
use FindBin;

my $doc = "$FindBin::Bin/input/esearchhandler/ESearch.xml";

my @eidlist = ( 16881078, 16881077, 16881074, 16881038, 16881031, 16880988, 16880979, 16880955, 16880943, 16880941, 16880828, 16880809, 16880795, 16880794, 16880793, 16880792, 16880791, 16880790, 16880789, 16880788 );
my $ecount = 9074;
my $eretmax = 20;
my $eretstart = 0;
my $equerykey = 1;
my $ewebenv = '0RzvzWJFkod9XeS088A6h8wyCBWc2efqy2U8HhDmYs0Kxt-LurDl5v@2B5F4F854D15AD50_0024SID';

my $handler = new Clair::Bio::EUtils::ESearchHandler;
my $parser = new XML::Parser::PerlSAX( Handler => $handler );
$parser->parse(Source => { SystemId => $doc });

ok(eq_set(\@eidlist, $handler->{IdList}), "IdList");
is($handler->{Count}, $ecount, "Count");
is($handler->{RetMax}, $eretmax, "RetMax");
is($handler->{RetStart}, $eretstart, "RetStart");
is($handler->{QueryKey}, $equerykey, "QueryKey");
is($handler->{WebEnv}, $ewebenv, "WebEnv");
