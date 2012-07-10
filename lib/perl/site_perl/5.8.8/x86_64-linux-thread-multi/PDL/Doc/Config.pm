# automatically built from Config.pm.PL
# don't modify, all changes will be lost !!!!
package PDL::Doc::Config;

$PDL::Doc::pager = '/usr/bin/less -isr';
$PDL::Doc::pager = $ENV{PAGER} if defined $ENV{PAGER};
$PDL::Doc::DefaultFile = '/usr/share/man/man1';

1;

