#!/usr/bin/perl
# contributed from Paul Lindner <lindner@itu.int>

=head1 NAME

WWW::Search::NULL - class for searching any web site

=head1 SYNOPSIS

    require WWW::Search;
    $search = new WWW::Search('Null');

=head1 DESCRIPTION

This class is a specialization of WWW::Search that only returns an
error message.

This class exports no public interface; all interaction should be done
through WWW::Search objects.

This modules is really a hack for systems that want to include
indices that have no corresponding WWW::Search module (like UNIONS)

=head1 AUTHOR

C<WWW::Search::Null> is written by Paul Lindner, <lindner@itu.int>

=head1 COPYRIGHT

Copyright (c) 1998 by the United Nations Administrative Committee 
on Coordination (ACC)

All rights reserved.

=cut

package WWW::Search::Null;

use strict;
use warnings;

use base 'WWW::Search';

use Carp ();
use WWW::SearchResult;

my($debug) = 0;

#private
sub native_setup_search
  {
  my($self, $native_query, $native_opt) = @_;
  my($native_url);
  $self->{_next_to_retrieve} = 0;
  $self->{_base_url} = $self->{_next_url} = $native_url;
  } # native_setup_search

# private
sub native_retrieve_some
  {
  my ($self) = @_;
  # Null search just returns an error..
  return undef if (!defined($self->{_next_url}));
  if (defined($how) && ($how =~ /(phrase|boolean)/))
    {
    my $response = new HTTP::Response(500,
                                      "This search engine is not supported, Please try searching it manually.");
    $self->{response} = $response;
    return(undef);
    } # if
  } # native_retrieve_some

1;

__END__

