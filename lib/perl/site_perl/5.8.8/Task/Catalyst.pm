use strict;
use warnings;

package Task::Catalyst;
our $VERSION = '4.00';
# ABSTRACT: All you need to start with Catalyst


1;

__END__
=pod

=head1 NAME

Task::Catalyst - All you need to start with Catalyst

=head1 VERSION

version 4.00

=head1 SYNOPSIS

C<perl -MCPAN -e 'install Task::Catalyst'>

=head1 DESCRIPTION

Installs everything you need to write serious Catalyst applications.

=head1 TASK CONTENTS

=head2 Core Modules

=head3 Catalyst 5.80

=head3 Catalyst::Devel 1.26

=head3 Catalyst::Manual 5.80

=head2 Recommended Models

=head3 Catalyst::Model::Adaptor

=head3 Catalyst::Model::DBIC::Schema

=head2 Recommended Views

=head3 Catalyst::View::TT

=head3 Catalyst::View::Email

=head2 Recommended Components

=head3 Catalyst::Controller::ActionRole

=head3 CatalystX::Component::Traits

=head3 CatalystX::SimpleLogin

=head3 Catalyst::Action::REST

=head3 Catalyst::Component::InstancePerContext

=head2 Session Support

=head3 Catalyst::Plugin::Session

=head3 Catalyst::Plugin::Session::State::Cookie

=head3 Catalyst::Plugin::Session::Store::BerkeleyDB

=head3 Catalyst::Plugin::Session::Store::DBIC

=head2 Authentication and Authorization

=head3 Catalyst::Plugin::Authentication

=head3 Catalyst::Authentication::Store::DBIx::Class

=head3 Catalyst::Authentication::Credential::HTTP

=head3 Catalyst::ActionRole::ACL

=head2 Recommended Plugins

=head3 Catalyst::Plugin::Static::Simple

=head3 Catalyst::Plugin::Unicode::Encoding

=head3 Catalyst::Plugin::I18N

=head3 Catalyst::Plugin::ConfigLoader

=head2 Testing, Debugging and Profiling

=head3 Test::WWW::Mechanize::Catalyst

=head3 Catalyst::Plugin::StackTrace

=head3 CatalystX::REPL

=head3 CatalystX::LeakChecker

=head3 CatalystX::Profile

=head2 Deployment

=head3 FCGI

=head3 FCGI::ProcManager

=head3 Catalyst::Engine::HTTP::Prefork

=head3 Catalyst::Engine::PSGI

=head3 local::lib

=head1 AUTHOR

  Florian Ragwitz <rafl@debian.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

