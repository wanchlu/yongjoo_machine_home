package TAP::Harness::Archive;

use warnings;
use strict;
use base 'TAP::Harness';
use Cwd            ();
use File::Basename ();
use File::Temp     ();
use File::Spec     ();
use File::Path     ();
use File::Find     ();
use Archive::Tar   ();
use TAP::Parser    ();
use YAML::Tiny     ();

=head1 NAME

TAP::Harness::Archive - Create an archive of TAP test results

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

    use TAP::Harness::Archive;
    my $harness = TAP::Harness::Archive->new(\%args);
    $harness->runtests(@tests);

=head1 DESCRIPTIO

This module is a direct subclass of L<TAP::Harness> and behaves
in exactly the same way except for one detail. In addition to
outputting a running progress of the tests and an ending summary
it can also capture all of the raw TAP from the individual test
files or streams into an archive file (C<.tar> or C<.tar.gz>).

=head1 METHODS

All methods are exactly the same as our base L<TAP::Harness> except
for the following.

=head2 new

In addition to the options that L<TAP::Harness> allow to this method,
we also allow the following:

=over

=item archive

This is the name of the archive file to generate. We use L<Archive::Tar>
in the background so we only support C<.tar> and C<.tar.gz> archive
file formats.

=back

=cut

my (%ARCHIVE_TYPES, @ARCHIVE_EXTENSIONS);
BEGIN {
    %ARCHIVE_TYPES = (
        'tar'    => 'tar',
        'tar.gz' => 'tar.gz',
        'tgz'    => 'tar.gz',
    );
    @ARCHIVE_EXTENSIONS = map { ".$_" } keys %ARCHIVE_TYPES;
}

sub new {
    my ($class, $args) = @_;
    $args ||= {};
    my $archive = delete $args->{archive};
    $class->_croak("You must provide the name of the archive to create!")
      unless $archive;

    my $format = $class->_get_archive_format_from_filename($archive);
    $class->_croak("Archive is not a known format type!")
      unless $format && $ARCHIVE_TYPES{$format};

    my $self = $class->SUPER::new($args);
    $self->{__archive_file}    = $archive;
    $self->{__archive_format}  = $format;
    $self->{__archive_tempdir} = File::Temp::tempdir();
    return $self;
}

sub _get_archive_format_from_filename {
    my ($self, $filename) = @_;

    # try to guess it if we don't have one
    my (undef, undef, $suffix) = File::Basename::fileparse($filename, @ARCHIVE_EXTENSIONS);
    $suffix =~ s/^\.//;
    return $ARCHIVE_TYPES{$suffix};
}

=head2 runtests

Takes the same arguments as L<TAP::Harness>'s version and returns the
same thing (a L<TAP::Parser::Aggregator> object). The only difference
is that in addition to the normal test running and progress output
we also create the TAP Archive when it's all done.

=cut

sub runtests {
    my ($self, @files) = @_;

    # tell TAP::Harness to put the raw tap someplace we can find it later
    my $dir = $self->{__archive_tempdir};
    $ENV{PERL_TEST_HARNESS_DUMP_TAP} = $dir;

    # get some meta information about this run
    my %meta = (
        file_order => \@files,
        start_time => time(),
    );

    my $aggregator = $self->SUPER::runtests(@files);

    $meta{stop_time} = time();

    # create the YAML meta file
    my $yaml = YAML::Tiny->new();
    $yaml->[0] = \%meta;
    $yaml->write(File::Spec->catfile($dir, 'meta.yml'))
      or $self->_croak("Could not write data to meta.yml: " . $yaml->errstr);

    # go into the dir so that we can reference files
    # relatively and put them in the archive that way
    my $cwd = Cwd::getcwd();
    chdir($dir) or $self->_croak("Could not change to directory $dir: $!");

    my $output_file = $self->{__archive_file};
    unless(File::Spec->file_name_is_absolute($output_file)) {
        $output_file = File::Spec->catfile($cwd, $output_file);
    }

    # now create the archive
    my $archive = Archive::Tar->new();
    $archive->add_files($self->_get_all_files);
    $archive->write($output_file, $self->{__archive_format} eq 'tar.gz') or die $archive->errstr;

    print "\nTAP Archive created at $output_file\n" unless $self->verbosity < -1;

    # be nice and clean up
    File::Path::rmtree($dir);
    chdir($cwd) or $self->_croak("Could not return to directory $cwd: $!");

    return $aggregator;
}

sub _get_all_files {
    my ($self, $dir) = @_;
    $dir ||= $self->{__archive_tempdir};
    my @files;
    File::Find::find(
        {
            no_chdir => 1,
            wanted   => sub {
                return if /^\./;
                return if -d;
                push(@files, File::Spec->abs2rel($_, $dir));
            },
        },
        $dir
    );
    return @files;
}

=head2 aggregator_from_archive

This class method will return a L<TAP::Parser::Aggregator> object
when given a TAP Archive to open and parse. It's pretty much the reverse
of creating a TAP Archive from using C<new> and C<runtests>.

It takes a hash of arguments which are as follows:

=over

=item archive

The path to the archive file.
This is required.

=item parser_callbacks

This is a hash ref containing callbacks for the L<TAP::Parser> objects
that are created while parsing the TAP files. See the L<TAP::Parser>
documentation for details about these callbacks.

=item made_parser_callback

This callback is executed every time a new L<TAP::Parser> object
is created. It will be passed the new parser object and the name
of the file to be parsed.

=item meta_yaml_callback

This is a subroutine that will be called if we find and parse a YAML
file containing meta information about the test run in the archive.
The structure of the YAML file will be passed in as an argument.

=back

    my $aggregator = TAP::Harness::Archive->aggregator_from_archive(
        {
            archive          => 'my_tests.tar.gz',
            parser_callbacks => {
                plan    => sub { warn "Nice to see you plan ahead..." },
                unknown => sub { warn "Your TAP is bad!" },
            },
        }
    );

=cut

sub aggregator_from_archive {
    my ($class, $args) = @_;

    my $file = $args->{archive}
      or $class->_croak("You must provide the path to the archive!");

    # extract the files out into a temporary directory
    my $dir = File::Temp::tempdir();
    my $cwd = Cwd::getcwd();
    chdir($dir) or $class->_croak("Could not change to directory $dir: $!");
    my @files;

    my $archive = Archive::Tar->new();
    $archive->extract_archive($file);
    my @tap_files;

    # do we have a .yml file in the archive?
    my ($yaml_file) = glob('*.yml');
    if($yaml_file) {

        # parse it into a structure
        my $meta = YAML::Tiny->new()->read($yaml_file);
        die "Could not read YAML $yaml_file: " . YAML::Tiny->errstr if YAML::Tiny->errstr;

        if($args->{meta_yaml_callback}) {
            $args->{meta_yaml_callback}->($meta);
        }
        $meta = $meta->[0];

        if($meta->{file_order} && ref $meta->{file_order} eq 'ARRAY') {
            foreach my $file (@{$meta->{file_order}}) {
                push(@tap_files, $file) if -e $file;
            }
        }
    }

    # if we didn't get the files from the YAML file, just find them all
    unless(@tap_files) {
        @tap_files = grep { $_ !~ /\.yml$/ } $class->_get_all_files($dir);
    }

    # now create the aggregator
    my $aggregator = TAP::Parser::Aggregator->new();
    foreach my $tap_file (@tap_files) {
        open(my $fh, $tap_file) or die "Could not open $tap_file for reading: $!";
        my $parser = TAP::Parser->new({source => $fh, callbacks => $args->{parser_callbacks}});
        if($args->{made_parser_callback}) {
            $args->{made_parser_callback}->($parser, $tap_file);
        }
        $parser->run;
        $aggregator->add($tap_file, $parser);
    }

    # be nice and clean up
    File::Path::rmtree($dir);
    chdir($cwd) or $class->_croak("Could not return to directory $cwd: $!");

    return $aggregator;
}

=head1 AUTHOR

Michael Peters, C<< <mpeters at plusthree.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-tap-harness-archive at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=TAP-Harness-Archive>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TAP::Harness::Archive

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/TAP-Harness-Archive>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/TAP-Harness-Archive>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=TAP-Harness-Archive>

=item * Search CPAN

L<http://search.cpan.org/dist/TAP-Harness-Archive>

=back

=head1 ACKNOWLEDGEMENTS

=over

=item * A big thanks to Plus Three, LP (L<http://www.plusthree.com>) for sponsoring my work on this module and other open source pursuits.

=item * Andy Armstrong

=back

=head1 COPYRIGHT & LICENSE

Copyright 2007 Michael Peters, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of TAP::Harness::Archive
