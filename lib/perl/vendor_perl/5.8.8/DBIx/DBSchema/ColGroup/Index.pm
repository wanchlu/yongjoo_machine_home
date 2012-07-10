package DBIx::DBSchema::ColGroup::Index;

use strict;
use vars qw(@ISA);
use DBIx::DBSchema::ColGroup;

@ISA=qw(DBIx::DBSchema::ColGroup);

=head1 NAME

DBIx::DBSchema::ColGroup::Index - Index column group object

=head1 SYNOPSIS

  use DBIx::DBSchema::ColGroup::Index;

    # see DBIx::DBSchema::ColGroup methods

=head1 DESCRIPTION

This class is deprecated and included for backwards-compatibility only.
See L<DBIx::DBSchema::Index> for the current class used to store unique
and non-unique indices.

DBIx::DBSchema::ColGroup::Index objects represent the (non-unique) indices of a
database table (L<DBIx::DBSchema::Table>).  DBIx::DBSchema::ColGroup::Index
inherits from DBIx::DBSchema::ColGroup.

=head1 SEE ALSO

L<DBIx::DBSchema::ColGroup>, L<DBIx::DBSchema::ColGroup::Unique>,
L<DBIx::DBSchema::Table>, L<DBIx::DBSchema>, L<FS::Record>

=cut

1;

