
package File::MimeInfo::Magic;

use strict;
use Carp;
use Fcntl 'SEEK_SET';
use File::BaseDir qw/xdg_data_files/;
require File::MimeInfo;
require Exporter;

BEGIN {
	no strict "refs";
	for (qw/extensions describe globs inodetype default/) {
		*{$_} = \&{"File::MimeInfo::$_"};
	}
}

our @ISA = qw(Exporter File::MimeInfo);
our @EXPORT = qw(mimetype);
our @EXPORT_OK = qw(extensions describe globs inodetype magic);
our $VERSION = '0.14';
our $DEBUG;

our (@magic_80, @magic, $max_buffer);
# @magic_80 and @magic are used to store the parse tree of magic data
# @magic_80 contains magic rules with priority 80 and higher, @magic the rest
# $max_buffer contains the maximum number of chars to be buffered from a non-seekable
# filehandle in order to do magic mimetyping

_rehash(); # initialize data

# use Data::Dumper;
# print Dumper \@magic_80, \@magic;

sub mimetype {
	my $file = pop; 
	croak 'subroutine "mimetype" needs a filename as argument' unless defined $file;

	return magic($file) || default($file) if ref $file;
	return &File::MimeInfo::mimetype($file) unless -s $file and -r _;
	
	my ($mimet, $fh);
	return $mimet if $mimet = inodetype($file);
	
	($mimet, $fh) = _magic($file, \@magic_80); # high priority rules
	return $mimet if $mimet;

	return $mimet if $mimet = globs($file);

	($mimet, $fh) = _magic($fh, \@magic); # lower priority rules
	close $fh unless ref $file;

	return $mimet if $mimet;
	return default($file);
}

sub magic {
	my $file = pop;
	croak 'subroutine "magic" needs a filename as argument' unless defined $file;
	return undef unless ref($file) || -s $file;
	print STDERR "> Checking all magic rules\n" if $DEBUG;
	
	my ($mimet, $fh) = _magic($file, \@magic_80, \@magic);
	close $fh unless ref $file;

	return $mimet;
}

sub _magic {
	my ($file, @rules) = @_;
	
	my $fh;
	unless (ref $file) {
		open $fh, '<', $file || return undef;
		binmode $fh;
	}
	else { $fh = $file }

	for my $type (map @$_, @rules) {
		for (2..$#$type) {
			next unless _check_rule($$type[$_], $fh, 0);
			close $fh unless ref $file;
			return ($$type[1], $fh);
		}
	}
	return (undef, $fh);
}

sub _check_rule {
	my ($ref, $fh, $lev) = @_;
	my $line;

	if (ref $fh eq 'GLOB') {
		seek($fh, $$ref[1][0], SEEK_SET);
		read($fh, $line, $$ref[1][1]);
	}
	else { # allowing for IO::Something
		$fh->seek($$ref[1][0], SEEK_SET);
		$fh->read($line, $$ref[1][1]);
	}
	return undef unless $line =~ $$ref[2];

	my $succes;
	unless ($$ref[3]) { $succes++ }
	else { # mask stuff
		my $v = $2 & $$ref[3][1];
		$succes++ if $v eq $$ref[3][0];
	}
	print STDERR	'>', '>'x$lev, ' Value "', _escape_bytes($2),
			'" at offset ', $$ref[1][0]+length($1),
			" matches line $$ref[0]\n"
		if $succes && $DEBUG;

	return undef unless $succes;
	if ($#$ref > 3) {
		for (4..$#$ref) { # recurs
			$succes = _check_rule($$ref[$_], $fh, $lev+1);
			last if $succes;
		}
	}
	print STDERR "> Failed nested rules\n" if $DEBUG && !($lev || $succes);
	return $succes;
}

sub rehash { 
	&File::MimeInfo::rehash();
	&_rehash();
}

sub _rehash {
	($max_buffer, @magic_80, @magic) = (32); # clear data
	my @magicfiles = @File::MimeInfo::DIRS
		? ( grep {-e $_ && -r $_} map "$_/magic", @File::MimeInfo::DIRS )
		: ( reverse xdg_data_files('mime/magic')                        );
	my @done;
	for my $file (@magicfiles) {
		next if grep {$file eq $_} @done;
		_hash_magic($file);
		push @done, $file;
	}
	@magic = sort {$$b[0] <=> $$a[0]} @magic;
	while ($magic[0][0] >= 80) {
		push @magic_80, shift @magic;
	}
}

sub _hash_magic {
	my $file = shift;

	open MAGIC, '<', $file || croak "Could not open file '$file' for reading";
	binmode MAGIC;
	<MAGIC> eq "MIME-Magic\x00\n"
		or carp "Magic file '$file' doesn't seem to be a magic file";
	my $line = 1;
	while (<MAGIC>) { 
		$line++;

		if (/^\[(\d+):(.*?)\]\n$/) {
			push @magic, [$1,$2];
			next;
		}

		s/^(\d*)>(\d+)=(.{2})//s || carp "$file line $line skipped\n" && next;
		my ($i, $o, $l) = ($1, $2, unpack 'n', $3); # indent, offset, value length
		while (length($_) <= $l) {
			$_ .= <MAGIC>;
			$line++;
		}

		my $v = substr $_, 0, $l, ''; # value

		/^(?:&(.{$l}))?(?:~(\d+))?(?:\+(\d+))?\n$/s 
			|| carp "$file line $line skipped\n" && next;
		my ($m, $w, $r) = ($1, $2, $3 || 0); # mask, word size, range
		# the word size is given for big endian to little endian conversion
		# dunno whether we need to do that in perl

		my $end = $o + $l + $r;
		$max_buffer = $end if $max_buffer < $end;
		my $ref = $i ? _find_branch($i) : $magic[-1];
		my $reg = '^'
			. ( $r ? "(.{0,$r}?)" : '()' )
			. ( $m ? "(.{$l})" : '('.quotemeta($v).')' ) ;
		push @$ref, [
			$line,
			[$o, $end],
			qr/$reg/sm,
			$m ? [$v, $m] : 0
		];
	}
	close MAGIC;
}

sub _find_branch {
	my $i = shift;
	my $ref = $magic[-1];
	for (1..$i) { $ref = $$ref[-1] }
	return $ref;
}

sub _escape_bytes {
	my $string = shift;
	if ($string =~ /[\x00-\x1F\xF7]/) {
		$string = join '', map {
			my $o = ord($_);
			($o < 32)   ? '^' . chr($o + 64) :
			($o == 127) ? '^?'               : $_ ;
		} split '', $string;
	}
	return $string;
}

1;

__END__

=head1 NAME

File::MimeInfo::Magic - Determine file type with magic

=head1 SYNOPSIS

	use File::MimeInfo::Magic;
	my $mime_type = mimetype($file);

=head1 DESCRIPTION

This module inherits from L<File::MimeInfo>, it is transparant
to its functions but adds support for the freedesktop magic file.

=head1 EXPORT

The method C<mimetype> is exported by default. The methods C<magic>, 
C<inodetype>, C<globs> and C<describe> can be exported on demand.

=head1 METHODS

See also L<File::MimeInfo> for methods that are inherited.

=over 4

=item C<mimetype($file)>

Returns a mime-type string for C<$file>, returns undef on failure.

This method bundles C<inodetype()>, C<globs()> and C<magic()>.

Magic rules with an priority of 80 and higher are checked before
C<globs()> is called, all other magic rules afterwards.

If this doesn't work the file is read and the mime-type defaults
to 'text/plain' or to 'application/octet-stream' when the first ten chars
of the file match ascii control chars (white spaces excluded).
If the file doesn't exist or isn't readable C<undef> is returned.

If C<$file> is an object reference only C<magic> and the default method
are used.

=item C<magic($file)>

Returns a mime-type string for C<$file> based on the magic rules, 
returns undef on failure.

C<$file> can be an object reference, in that case it is supposed to have a 
C<seek()> and a C<read()> method. 
This allows you for example to determine the mimetype of data in memory
by using L<IO::Scalar>.

=item C<rehash()>

Rehash the data files. Glob and magic 
information is preparsed when this method is called.

If you want to by-pass the XDG basedir system you can specify your database
directories by setting C<@File::MimeInfo::DIRS>. But normally it is better to
change the XDG basedir environment variables.

=back

=head1 SEE ALSO

L<File::MimeInfo>

=head1 BUGS

Please mail the author when you encounter any bugs.

Most likely to cause bugs is the fact that I partially used line based parsing
while the source data is binary and can contain newlines on strange places.
I tested with the 0.11 version of the database and found no problems, but I
can think of configurations that can cause problems.

=head1 AUTHOR

Jaap Karssenberg || Pardus [Larus] E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2003 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

