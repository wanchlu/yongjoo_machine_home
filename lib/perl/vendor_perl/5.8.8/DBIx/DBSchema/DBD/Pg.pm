package DBIx::DBSchema::DBD::Pg;

use strict;
use vars qw($VERSION @ISA %typemap);
use DBD::Pg 1.32;
use DBIx::DBSchema::DBD;

$VERSION = '0.12';
@ISA = qw(DBIx::DBSchema::DBD);

die "DBD::Pg version 1.32 or 1.41 (or later) required--".
    "this is only version $DBD::Pg::VERSION\n"
  if $DBD::Pg::VERSION != 1.32 && $DBD::Pg::VERSION < 1.41;

%typemap = (
  'BLOB'           => 'BYTEA',
  'LONG VARBINARY' => 'BYTEA',
  'TIMESTAMP'      => 'TIMESTAMP WITH TIME ZONE',
);

=head1 NAME

DBIx::DBSchema::DBD::Pg - PostgreSQL native driver for DBIx::DBSchema

=head1 SYNOPSIS

use DBI;
use DBIx::DBSchema;

$dbh = DBI->connect('dbi:Pg:dbname=database', 'user', 'pass');
$schema = new_native DBIx::DBSchema $dbh;

=head1 DESCRIPTION

This module implements a PostgreSQL-native driver for DBIx::DBSchema.

=cut

sub default_db_schema  { 'public'; }

sub columns {
  my($proto, $dbh, $table) = @_;
  my $sth = $dbh->prepare(<<END) or die $dbh->errstr;
    SELECT a.attname, t.typname, a.attlen, a.atttypmod, a.attnotnull,
           a.atthasdef, a.attnum
    FROM pg_class c, pg_attribute a, pg_type t
    WHERE c.relname = '$table'
      AND a.attnum > 0 AND a.attrelid = c.oid AND a.atttypid = t.oid
    ORDER BY a.attnum
END
  $sth->execute or die $sth->errstr;

  map {

    my $default = '';
    if ( $_->{atthasdef} ) {
      my $attnum = $_->{attnum};
      my $d_sth = $dbh->prepare(<<END) or die $dbh->errstr;
        SELECT substring(d.adsrc for 128) FROM pg_attrdef d, pg_class c
        WHERE c.relname = '$table' AND c.oid = d.adrelid AND d.adnum = $attnum
END
      $d_sth->execute or die $d_sth->errstr;

      $default = $d_sth->fetchrow_arrayref->[0];
    };

    my $len = '';
    if ( $_->{attlen} == -1 && $_->{atttypmod} != -1 
         && $_->{typname} ne 'text'                  ) {
      $len = $_->{atttypmod} - 4;
      if ( $_->{typname} eq 'numeric' ) {
        $len = ($len >> 16). ','. ($len & 0xffff);
      }
    }

    my $type = $_->{'typname'};
    $type = 'char' if $type eq 'bpchar';

    [
      $_->{'attname'},
      $type,
      ! $_->{'attnotnull'},
      $len,
      $default,
      ''  #local
    ];

  } @{ $sth->fetchall_arrayref({}) };
}

sub primary_key {
  my($proto, $dbh, $table) = @_;
  my $sth = $dbh->prepare(<<END) or die $dbh->errstr;
    SELECT a.attname, a.attnum
    FROM pg_class c, pg_attribute a, pg_type t
    WHERE c.relname = '${table}_pkey'
      AND a.attnum > 0 AND a.attrelid = c.oid AND a.atttypid = t.oid
END
  $sth->execute or die $sth->errstr;
  my $row = $sth->fetchrow_hashref or return '';
  $row->{'attname'};
}

sub unique {
  my($proto, $dbh, $table) = @_;
  my $gratuitous = { map { $_ => [ $proto->_index_fields($dbh, $_ ) ] }
      grep { $proto->_is_unique($dbh, $_ ) }
        $proto->_all_indices($dbh, $table)
  };
}

sub index {
  my($proto, $dbh, $table) = @_;
  my $gratuitous = { map { $_ => [ $proto->_index_fields($dbh, $_ ) ] }
      grep { ! $proto->_is_unique($dbh, $_ ) }
        $proto->_all_indices($dbh, $table)
  };
}

sub _all_indices {
  my($proto, $dbh, $table) = @_;
  my $sth = $dbh->prepare(<<END) or die $dbh->errstr;
    SELECT c2.relname
    FROM pg_class c, pg_class c2, pg_index i
    WHERE c.relname = '$table' AND c.oid = i.indrelid AND i.indexrelid = c2.oid
END
  $sth->execute or die $sth->errstr;
  map { $_->{'relname'} }
    grep { $_->{'relname'} !~ /_pkey$/ }
      @{ $sth->fetchall_arrayref({}) };
}

sub _index_fields {
  my($proto, $dbh, $index) = @_;
  my $sth = $dbh->prepare(<<END) or die $dbh->errstr;
    SELECT a.attname, a.attnum
    FROM pg_class c, pg_attribute a, pg_type t
    WHERE c.relname = '$index'
      AND a.attnum > 0 AND a.attrelid = c.oid AND a.atttypid = t.oid
    ORDER BY a.attnum
END
  $sth->execute or die $sth->errstr;
  map { $_->{'attname'} } @{ $sth->fetchall_arrayref({}) };
}

sub _is_unique {
  my($proto, $dbh, $index) = @_;
  my $sth = $dbh->prepare(<<END) or die $dbh->errstr;
    SELECT i.indisunique
    FROM pg_index i, pg_class c, pg_am a
    WHERE i.indexrelid = c.oid AND c.relname = '$index' AND c.relam = a.oid
END
  $sth->execute or die $sth->errstr;
  my $row = $sth->fetchrow_hashref or die 'guru meditation #420';
  $row->{'indisunique'};
}

sub add_column_callback {
  my( $proto, $dbh, $table, $column_obj ) = @_;
  my $name = $column_obj->name;

  my $pg_server_version = $dbh->{'pg_server_version'};
  my $warning = '';
  unless ( $pg_server_version =~ /\d/ ) {
    $warning = "WARNING: no pg_server_version!  Assuming >= 7.3\n";
    $pg_server_version = 70300;
  }

  my $hashref = { 'sql_after' => [], };

  if ( $column_obj->type =~ /^(\w*)SERIAL$/i ) {

    $hashref->{'effective_type'} = uc($1).'INT';

    #needs more work for old Pg?
      
    my $nextval;
    warn $warning if $warning;
    if ( $pg_server_version >= 70300 ) {
      $nextval = "nextval('public.${table}_${name}_seq'::text)";
    } else {
      $nextval = "nextval('${table}_${name}_seq'::text)";
    }

    push @{ $hashref->{'sql_after'} }, 
      "ALTER TABLE $table ALTER COLUMN $name SET DEFAULT $nextval",
      "CREATE SEQUENCE ${table}_${name}_seq",
      "UPDATE $table SET $name = $nextval WHERE $name IS NULL",
    ;

  }

  if ( ! $column_obj->null ) {
    $hashref->{'effective_null'} = 'NULL';

    warn $warning if $warning;
    if ( $pg_server_version >= 70300 ) {

      push @{ $hashref->{'sql_after'} },
        "ALTER TABLE $table ALTER $name SET NOT NULL";

    } else {

      push @{ $hashref->{'sql_after'} },
        "UPDATE pg_attribute SET attnotnull = TRUE ".
        " WHERE attname = '$name' ".
        " AND attrelid = ( SELECT oid FROM pg_class WHERE relname = '$table' )";

    }

  }

  $hashref;

}

sub alter_column_callback {
  my( $proto, $dbh, $table, $old_column, $new_column ) = @_;
  my $name = $old_column->name;

  my $pg_server_version = $dbh->{'pg_server_version'};
  my $warning = '';
  unless ( $pg_server_version =~ /\d/ ) {
    $warning = "WARNING: no pg_server_version!  Assuming >= 7.3\n";
    $pg_server_version = 70300;
  }

  my $hashref = {};

  # change nullability from NOT NULL to NULL
  if ( ! $old_column->null && $new_column->null ) {

    warn $warning if $warning;
    if ( $pg_server_version < 70300 ) {
      $hashref->{'sql_alter_null'} =
        "UPDATE pg_attribute SET attnotnull = FALSE
          WHERE attname = '$name'
            AND attrelid = ( SELECT oid FROM pg_class
                               WHERE relname = '$table'
                           )";
    }

  }

  # change nullability from NULL to NOT NULL...
  # this one could be more complicated, need to set a DEFAULT value and update
  # the table first...
  if ( $old_column->null && ! $new_column->null ) {

    warn $warning if $warning;
    if ( $pg_server_version < 70300 ) {
      $hashref->{'sql_alter_null'} =
        "UPDATE pg_attribute SET attnotnull = TRUE
           WHERE attname = '$name'
             AND attrelid = ( SELECT oid FROM pg_class
                                WHERE relname = '$table'
                            )";
    }

  }

  $hashref;

}

=head1 AUTHOR

Ivan Kohler <ivan-dbix-dbschema@420.am>

=head1 COPYRIGHT

Copyright (c) 2000 Ivan Kohler
Copyright (c) 2000 Mail Abuse Prevention System LLC
Copyright (c) 2007 Freeside Internet Services, Inc.
All rights reserved.
This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 BUGS

Yes.

columns doesn't return column default information.

=head1 SEE ALSO

L<DBIx::DBSchema>, L<DBIx::DBSchema::DBD>, L<DBI>, L<DBI::DBD>

=cut 

1;

