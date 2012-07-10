package DBIx::DBSchema::DBD::mysql;

use strict;
use vars qw($VERSION @ISA %typemap);
use DBIx::DBSchema::DBD;

$VERSION = '0.06';
@ISA = qw(DBIx::DBSchema::DBD);

%typemap = (
  'TIMESTAMP'      => 'DATETIME',
  'SERIAL'         => 'INTEGER',
  'BIGSERIAL'      => 'BIGINT',
  'BOOL'           => 'TINYINT',
  'LONG VARBINARY' => 'LONGBLOB',
);

=head1 NAME

DBIx::DBSchema::DBD::mysql - MySQL native driver for DBIx::DBSchema

=head1 SYNOPSIS

use DBI;
use DBIx::DBSchema;

$dbh = DBI->connect('dbi:mysql:database', 'user', 'pass');
$schema = new_native DBIx::DBSchema $dbh;

=head1 DESCRIPTION

This module implements a MySQL-native driver for DBIx::DBSchema.

=cut
    use Data::Dumper;

sub columns {
  my($proto, $dbh, $table ) = @_;
  my $oldkhv=$dbh->{FetchHashKeyName};
  $dbh->{FetchHashKeyName}="NAME";
  my $sth = $dbh->prepare("SHOW COLUMNS FROM $table") or die $dbh->errstr;
  $sth->execute or die $sth->errstr;
  my @r = map {
    #warn Dumper($_);
    $_->{'Type'} =~ /^(\w+)\(?([^)]+)?\)?( \d+)?$/
      or die "Illegal type: ". $_->{'Type'}. "\n";
    my($type, $length) = ($1, $2);
    [
      $_->{'Field'},
      $type,
      ( $_->{'Null'} =~ /^YES$/i ? 'NULL' : '' ),
      $length,
      $_->{'Default'},
      $_->{'Extra'}
    ]
  } @{ $sth->fetchall_arrayref( {} ) };
  $dbh->{FetchHashKeyName}=$oldkhv;
  @r;
}

#sub primary_key {
#  my($proto, $dbh, $table ) = @_;
#  my $primary_key = '';
#  my $sth = $dbh->prepare("SHOW INDEX FROM $table")
#    or die $dbh->errstr;
#  $sth->execute or die $sth->errstr;
#  my @pkey = map { $_->{'Column_name'} } grep {
#    $_->{'Key_name'} eq "PRIMARY"
#  } @{ $sth->fetchall_arrayref( {} ) };
#  scalar(@pkey) ? $pkey[0] : '';
#}

sub primary_key {
  my($proto, $dbh, $table) = @_;
  my($pkey, $unique_href, $index_href) = $proto->_show_index($dbh, $table);
  $pkey;
}

sub unique {
  my($proto, $dbh, $table) = @_;
  my($pkey, $unique_href, $index_href) = $proto->_show_index($dbh, $table);
  $unique_href;
}

sub index {
  my($proto, $dbh, $table) = @_;
  my($pkey, $unique_href, $index_href) = $proto->_show_index($dbh, $table);
  $index_href;
}

sub _show_index {
  my($proto, $dbh, $table ) = @_;
  my $oldkhv=$dbh->{FetchHashKeyName};
  $dbh->{FetchHashKeyName}="NAME";
  my $sth = $dbh->prepare("SHOW INDEX FROM $table")
    or die $dbh->errstr;
  $sth->execute or die $sth->errstr;

  my $pkey = '';
  my(%index, %unique);
  foreach my $row ( @{ $sth->fetchall_arrayref({}) } ) {
    if ( $row->{'Key_name'} eq 'PRIMARY' ) {
      $pkey = $row->{'Column_name'};
    } elsif ( $row->{'Non_unique'} ) { #index
      push @{ $index{ $row->{'Key_name'} } }, $row->{'Column_name'};
    } else { #unique
      push @{ $unique{ $row->{'Key_name'} } }, $row->{'Column_name'};
    }
  }
  $dbh->{FetchHashKeyName}=$oldkhv;

  ( $pkey, \%unique, \%index );
}

sub column_callback {
  my( $proto, $dbh, $table, $column_obj ) = @_;

  my $hashref = { 'explicit_null' => 1, };

  $hashref->{'effective_local'} = 'AUTO_INCREMENT'
    if $column_obj->type =~ /^(\w*)SERIAL$/i;

  if ( $column_obj->default =~ /^(NOW)\(\)$/i
       && $column_obj->type =~ /^(TIMESTAMP|DATETIME)$/i ) {

    $hashref->{'effective_default'} = 'CURRENT_TIMESTAMP';
    $hashref->{'effective_type'} = 'TIMESTAMP';

  }

  $hashref;

}

sub alter_column_callback {
  my( $proto, $dbh, $table, $old_column, $new_column ) = @_;
  my $old_name = $old_column->name;
  my $new_def = $new_column->line($dbh);

# this would have been nice, but it appears to be doing too much...

#  return {} if $old_column->line($dbh) eq $new_column->line($dbh);
#
#  #{ 'sql_alter' => 
#  { 'sql_alter_null' => 
#      "ALTER TABLE $table CHANGE $old_name $new_def",
#  };

  return {} if $old_column->null eq $new_column->null;
  { 'sql_alter_null' => 
      "ALTER TABLE $table MODIFY $new_def",
  };


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

=head1 SEE ALSO

L<DBIx::DBSchema>, L<DBIx::DBSchema::DBD>, L<DBI>, L<DBI::DBD>

=cut 

1;

