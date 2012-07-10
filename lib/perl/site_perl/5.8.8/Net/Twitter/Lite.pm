package Net::Twitter::Lite;
use 5.005;
use warnings;
use strict;

our $VERSION = '0.08006';
$VERSION = eval { $VERSION };

use Carp;
use URI::Escape;
use JSON::Any qw/XS JSON/;
use HTTP::Request::Common;
use Net::Twitter::Lite::Error;
use Encode qw/encode_utf8/;

my $json_handler = JSON::Any->new(utf8 => 1);

sub new {
    my ($class, %args) = @_;

    my $ssl   = delete $args{ssl};
    if ( $ssl ) {
        eval { require Crypt::SSLeay } && $Crypt::SSLeay::VERSION >= 0.5
            || croak "Crypt::SSLeay version 0.50 is required for SSL support";
    }

    my $netrc = delete $args{netrc};
    my $new = bless {
        apiurl     => 'http://api.twitter.com/1',
        apirealm   => 'Twitter API',
        $args{identica} ? ( apiurl => 'http://identi.ca/api' ) : (),
        searchurl  => 'http://search.twitter.com',
        useragent  => __PACKAGE__ . "/$VERSION (Perl)",
        clientname => __PACKAGE__,
        clientver  => $VERSION,
        clienturl  => 'http://search.cpan.org/dist/Net-Twitter-Lite/',
        source     => 'twitterpm',
        useragent_class => 'LWP::UserAgent',
        useragent_args  => {},
        oauth_urls => {
            request_token_url  => "http://twitter.com/oauth/request_token",
            authentication_url => "http://twitter.com/oauth/authenticate",
            authorization_url  => "http://twitter.com/oauth/authorize",
            access_token_url   => "http://twitter.com/oauth/access_token",
        },
        netrc_machine => 'api.twitter.com',
        %args
    }, $class;

    $new->{apiurl} =~ s/http/https/ if $ssl;

    # get username and password from .netrc
    if ( $netrc ) {
        eval { require Net::Netrc; 1 }
            || croak "Net::Netrc is required for the netrc option";

        my $host = $netrc eq '1' ? $new->{netrc_machine} : $netrc;
        my $nrc = Net::Netrc->lookup($host)
            || croak "No .netrc entry for $host";

        @{$new}{qw/username password/} = $nrc->lpa;
    }

    $new->{ua} ||= do {
        eval "use $new->{useragent_class}";
        croak $@ if $@;

        $new->{useragent_class}->new(%{$new->{useragent_args}});
    };

    $new->{ua}->agent($new->{useragent});
    $new->{ua}->default_header('X-Twitter-Client'         => $new->{clientname});
    $new->{ua}->default_header('X-Twitter-Client-Version' => $new->{clientver});
    $new->{ua}->default_header('X-Twitter-Client-URL'     => $new->{clienturl});
    $new->{ua}->env_proxy;

    $new->{_authenticator} = exists $new->{consumer_key}
                           ? '_oauth_authenticated_request'
                           : '_basic_authenticated_request';

    $new->credentials(@{$new}{qw/username password/})
        if exists $new->{username} && exists $new->{password};

    return $new;
}

sub credentials {
    my $self = shift;
    my ($username, $password) = @_;

    croak "exected a username and password" unless @_ == 2;
    croak "OAuth authentication is in use"  if exists $self->{consumer_key};

    $self->{username} = $username;
    $self->{password} = $password;

    my $uri = URI->new($self->{apiurl});
    my $netloc = join ':', $uri->host, $uri->port;

    $self->{ua}->credentials($netloc, $self->{apirealm}, $username, $password);
}

# This is a hack. Rather than making Net::OAuth an install requirement for
# Net::Twitter::Lite, require it at runtime if any OAuth methods are used.  It
# simply returns the string 'Net::OAuth' after successfully requiring
# Net::OAuth.
sub _oauth {
    my $self = shift;

    return $self->{_oauth} ||= do {
        eval "use Net::OAuth 0.16";
        croak "Install Net::OAuth 0.16 or later for OAuth support" if $@;

        eval '$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A';
        die $@ if $@;
        
        'Net::OAuth';
    };
}

# simple check to see if we have access tokens; does not check to see if they are valid
sub authorized {
    my $self = shift;

    return defined $self->{access_token} && $self->{access_token_secret};
}

# OAuth token accessors
for my $method ( qw/
            access_token
            access_token_secret
            request_token
            request_token_secret
        / ) {
    no strict 'refs';
    *{__PACKAGE__ . "::$method"} = sub {
        my $self = shift;
        
        $self->{$method} = shift if @_;
        return $self->{$method};
    };
}

# OAuth url accessors
for my $method ( qw/
            request_token_url
            authentication_url
            authorization_url
            access_token_url
        / ) {
    no strict 'refs';
    *{__PACKAGE__ . "::$method"} = sub {
        my $self = shift;

        $self->{oauth_urls}{$method} = shift if @_;
        return URI->new($self->{oauth_urls}{$method});
    };
}

# get the athorization or authentication url
sub _get_auth_url {
    my ($self, $which_url, %params ) = @_;

    $self->_request_request_token(%params);

    my $uri = $self->$which_url;
    $uri->query_form(oauth_token => $self->request_token);
    return $uri;
}

# get the authentication URL from Twitter
sub get_authentication_url { return shift->_get_auth_url(authentication_url => @_) }

# get the authorization URL from Twitter
sub get_authorization_url { return shift->_get_auth_url(authorization_url => @_) }

# common portion of all oauth requests
sub _make_oauth_request {
    my ($self, $type, %params) = @_;

    my $request = $self->_oauth->request($type)->new(
        version          => '1.0',
        consumer_key     => $self->{consumer_key},
        consumer_secret  => $self->{consumer_secret},
        request_method   => 'GET',
        signature_method => 'HMAC-SHA1',
        timestamp        => time,
        nonce            => time ^ $$ ^ int(rand 2**32),
        %params,
    );

    $request->sign;

    return $request;
}

# called by get_authorization_url to obtain request tokens
sub _request_request_token {
    my ($self, %params) = @_;

    my $uri = $self->request_token_url;
    $params{callback} ||= 'oob';
    my $request = $self->_make_oauth_request(
        'request token',
        request_url => $uri,
        %params,
    );

    my $res = $self->{ua}->get($request->to_url);
    die "GET $uri failed: ".$res->status_line
        unless $res->is_success;

    # reuse $uri to extract parameters from the response content
    $uri->query($res->content);
    my %res_param = $uri->query_form;

    $self->request_token($res_param{oauth_token});
    $self->request_token_secret($res_param{oauth_token_secret});
}

# exchange request tokens for access tokens; call with (verifier => $verifier)
sub request_access_token {
    my ($self, %params ) = @_;

    my $uri = $self->access_token_url;
    my $request = $self->_make_oauth_request(
        'access token',
        request_url => $uri,
        token       => $self->request_token,
        token_secret => $self->request_token_secret,
        %params, # verifier => $verifier
    );

    my $res = $self->{ua}->get($request->to_url);
    die "GET $uri failed: ".$res->status_line
        unless $res->is_success;

    # discard request tokens, they're no longer valid
    delete $self->{request_token};
    delete $self->{request_token_secret};

    # reuse $uri to extract parameters from content
    $uri->query($res->content);
    my %res_param = $uri->query_form;

    return (
        $self->access_token($res_param{oauth_token}),
        $self->access_token_secret($res_param{oauth_token_secret}),
        $res_param{user_id},
        $res_param{screen_name},
    );
}

# common call for both Basic Auth and OAuth
sub _authenticated_request {
    my $self = shift;

    my $authenticator = $self->{_authenticator};
    $self->$authenticator(@_);
}

sub _encode_args {
    my $args = shift;

    # Values need to be utf-8 encoded.  Because of a perl bug, exposed when
    # client code does "use utf8", keys must also be encoded as well.
    # see: http://www.perlmonks.org/?node_id=668987
    # and: http://perl5.git.perl.org/perl.git/commit/eaf7a4d2
    return { map { ref($_) ? $_ : encode_utf8 $_ } %$args };
}

sub _oauth_authenticated_request {
    my ($self, $http_method, $uri, $args, $authenticate) = @_;
    
    delete $args->{source}; # not necessary with OAuth requests

    my $is_multipart = grep { ref } %$args;

    my $msg;
    if ( $authenticate && $self->authorized ) {
        local $Net::OAuth::SKIP_UTF8_DOUBLE_ENCODE_CHECK = 1;

        my $request = $self->_make_oauth_request(
            'protected resource',
            request_url    => $uri,
            request_method => $http_method,
            token          => $self->access_token,
            token_secret   => $self->access_token_secret,
            extra_params   => $is_multipart ? {} : $args,
        );

        if ( $http_method eq 'GET' ) {
            $msg = GET($request->to_url);
        }
        elsif ( $http_method eq 'POST' ) {
            $msg = $is_multipart
                 ? POST($request->request_url,
                        Authorization => $request->to_authorization_header,
                        Content_Type  => 'form-data',
                        Content       => [ %$args ],
                   )
                 : POST($$uri, Content => $request->to_post_body)
                 ;
        }
        else {
            croak "unexpected http_method: $http_method";
        }
    }
    elsif ( $http_method eq 'GET' ) {
        $uri->query_form($args);
        $args = {};
        $msg = GET($uri);
    }
    elsif ( $http_method eq 'POST' ) {
        my $encoded_args = { %$args };
        _encode_args($encoded_args);
        $msg = $self->_mk_post_msg($uri, $args);
    }
    else {
        croak "unexpected http_method: $http_method";
    }

    return $self->{ua}->request($msg);
}

sub _basic_authenticated_request {
    my ($self, $http_method, $uri, $args, $authenticate) = @_;

    _encode_args($args);

    my $msg;
    if ( $http_method eq 'GET' ) {
        $uri->query_form($args);
        $msg = GET($uri);
    }
    elsif ( $http_method eq 'POST' ) {
        $msg = $self->_mk_post_msg($uri, $args);
    }

    if ( $authenticate && $self->{username} && $self->{password} ) {
        $msg->headers->authorization_basic(@{$self}{qw/username password/});
    }

    return $self->{ua}->request($msg);
}

sub _mk_post_msg {
    my ($self, $uri, $args) = @_;

    # if any of the arguments are (array) refs, use form-data
    return (grep { ref } values %$args)
         ? POST($uri, Content_Type => 'form-data', Content => [ %$args ])
         : POST($uri, $args);
}

my $api_def = [
    [ REST => [
        [ 'block_exists', {
            aliases     => [ qw// ],
            path        => 'blocks/exists/id',
            method      => 'GET',
            params      => [ qw/id user_id screen_name/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'blocking', {
            aliases     => [ qw// ],
            path        => 'blocks/blocking',
            method      => 'GET',
            params      => [ qw/page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'blocking_ids', {
            aliases     => [ qw// ],
            path        => 'blocks/blocking/ids',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'create_block', {
            aliases     => [ qw// ],
            path        => 'blocks/create/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'create_favorite', {
            aliases     => [ qw// ],
            path        => 'favorites/create/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'create_friend', {
            aliases     => [ qw/follow_new/ ],
            path        => 'friendships/create/id',
            method      => 'POST',
            params      => [ qw/id user_id screen_name follow/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'create_saved_search', {
            aliases     => [ qw// ],
            path        => 'saved_searches/create',
            method      => 'POST',
            params      => [ qw/query/ ],
            required    => [ qw/query/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'destroy_block', {
            aliases     => [ qw// ],
            path        => 'blocks/destroy/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'destroy_direct_message', {
            aliases     => [ qw// ],
            path        => 'direct_messages/destroy/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'destroy_favorite', {
            aliases     => [ qw// ],
            path        => 'favorites/destroy/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'destroy_friend', {
            aliases     => [ qw/unfollow/ ],
            path        => 'friendships/destroy/id',
            method      => 'POST',
            params      => [ qw/id user_id screen_name/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'destroy_saved_search', {
            aliases     => [ qw// ],
            path        => 'saved_searches/destroy/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'destroy_status', {
            aliases     => [ qw// ],
            path        => 'statuses/destroy/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'direct_messages', {
            aliases     => [ qw// ],
            path        => 'direct_messages',
            method      => 'GET',
            params      => [ qw/since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'disable_notifications', {
            aliases     => [ qw// ],
            path        => 'notifications/leave/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'downtime_schedule', {
            aliases     => [ qw// ],
            path        => 'help/downtime_schedule',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 1,
            authenticate => 1,
        } ],
        [ 'enable_notifications', {
            aliases     => [ qw// ],
            path        => 'notifications/follow/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'end_session', {
            aliases     => [ qw// ],
            path        => 'account/end_session',
            method      => 'POST',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'favorites', {
            aliases     => [ qw// ],
            path        => 'favorites/id',
            method      => 'GET',
            params      => [ qw/id page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'followers', {
            aliases     => [ qw// ],
            path        => 'statuses/followers/id',
            method      => 'GET',
            params      => [ qw/id user_id screen_name cursor/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'followers_ids', {
            aliases     => [ qw// ],
            path        => 'followers/ids/id',
            method      => 'GET',
            params      => [ qw/id user_id screen_name cursor/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'friends', {
            aliases     => [ qw/following/ ],
            path        => 'statuses/friends/id',
            method      => 'GET',
            params      => [ qw/id user_id screen_name cursor/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'friends_ids', {
            aliases     => [ qw/following_ids/ ],
            path        => 'friends/ids/id',
            method      => 'GET',
            params      => [ qw/id user_id screen_name cursor/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'friends_timeline', {
            aliases     => [ qw/following_timeline/ ],
            path        => 'statuses/friends_timeline',
            method      => 'GET',
            params      => [ qw/since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'friendship_exists', {
            aliases     => [ qw/relationship_exists follows/ ],
            path        => 'friendships/exists',
            method      => 'GET',
            params      => [ qw/user_a user_b/ ],
            required    => [ qw/user_a user_b/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'home_timeline', {
            aliases     => [ qw// ],
            path        => 'statuses/home_timeline',
            method      => 'GET',
            params      => [ qw/since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'mentions', {
            aliases     => [ qw/replies/ ],
            path        => 'statuses/replies',
            method      => 'GET',
            params      => [ qw/since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'new_direct_message', {
            aliases     => [ qw// ],
            path        => 'direct_messages/new',
            method      => 'POST',
            params      => [ qw/user text screen_name user_id/ ],
            required    => [ qw/user text/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'public_timeline', {
            aliases     => [ qw// ],
            path        => 'statuses/public_timeline',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'rate_limit_status', {
            aliases     => [ qw// ],
            path        => 'account/rate_limit_status',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'report_spam', {
            aliases     => [ qw// ],
            path        => 'report_spam',
            method      => 'POST',
            params      => [ qw/id user_id screen_name/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'retweet', {
            aliases     => [ qw// ],
            path        => 'statuses/retweet/id',
            method      => 'POST',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'retweeted_by_me', {
            aliases     => [ qw// ],
            path        => 'statuses/retweeted_by_me',
            method      => 'GET',
            params      => [ qw/since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'retweeted_of_me', {
            aliases     => [ qw// ],
            path        => 'statuses/retweeted_of_me',
            method      => 'GET',
            params      => [ qw/since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'retweeted_to_me', {
            aliases     => [ qw// ],
            path        => 'statuses/retweeted_to_me',
            method      => 'GET',
            params      => [ qw/since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'retweets', {
            aliases     => [ qw// ],
            path        => 'statuses/retweets/id',
            method      => 'GET',
            params      => [ qw/id count/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'saved_searches', {
            aliases     => [ qw// ],
            path        => 'saved_searches',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'sent_direct_messages', {
            aliases     => [ qw// ],
            path        => 'direct_messages/sent',
            method      => 'GET',
            params      => [ qw/since_id max_id page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'show_friendship', {
            aliases     => [ qw/show_relationship/ ],
            path        => 'friendships/show',
            method      => 'GET',
            params      => [ qw/source_id source_screen_name target_id target_id_name/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'show_saved_search', {
            aliases     => [ qw// ],
            path        => 'saved_searches/show/id',
            method      => 'GET',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'show_status', {
            aliases     => [ qw// ],
            path        => 'statuses/show/id',
            method      => 'GET',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'show_user', {
            aliases     => [ qw// ],
            path        => 'users/show/id',
            method      => 'GET',
            params      => [ qw/id/ ],
            required    => [ qw/id/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'test', {
            aliases     => [ qw// ],
            path        => 'help/test',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'trends_available', {
            aliases     => [ qw// ],
            path        => 'trends/available',
            method      => 'GET',
            params      => [ qw/lat long/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'trends_location', {
            aliases     => [ qw// ],
            path        => 'trends/location',
            method      => 'GET',
            params      => [ qw/woeid/ ],
            required    => [ qw/woeid/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'update', {
            aliases     => [ qw// ],
            path        => 'statuses/update',
            method      => 'POST',
            params      => [ qw/status lat long in_reply_to_status_id/ ],
            required    => [ qw/status/ ],
            add_source  => 1,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'update_delivery_device', {
            aliases     => [ qw// ],
            path        => 'account/update_delivery_device',
            method      => 'POST',
            params      => [ qw/device/ ],
            required    => [ qw/device/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'update_location', {
            aliases     => [ qw// ],
            path        => 'account/update_location',
            method      => 'POST',
            params      => [ qw/location/ ],
            required    => [ qw/location/ ],
            add_source  => 0,
            deprecated  => 1,
            authenticate => 1,
        } ],
        [ 'update_profile', {
            aliases     => [ qw// ],
            path        => 'account/update_profile',
            method      => 'POST',
            params      => [ qw/name email url location description/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'update_profile_background_image', {
            aliases     => [ qw// ],
            path        => 'account/update_profile_background_image',
            method      => 'POST',
            params      => [ qw/image/ ],
            required    => [ qw/image/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'update_profile_colors', {
            aliases     => [ qw// ],
            path        => 'account/update_profile_colors',
            method      => 'POST',
            params      => [ qw/profile_background_color profile_text_color profile_link_color profile_sidebar_fill_color profile_sidebar_border_color/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'update_profile_image', {
            aliases     => [ qw// ],
            path        => 'account/update_profile_image',
            method      => 'POST',
            params      => [ qw/image/ ],
            required    => [ qw/image/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'user_timeline', {
            aliases     => [ qw// ],
            path        => 'statuses/user_timeline/id',
            method      => 'GET',
            params      => [ qw/id user_id screen_name since_id max_id count page/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'users_search', {
            aliases     => [ qw/find_people search_users/ ],
            path        => 'users/search',
            method      => 'GET',
            params      => [ qw/q per_page page/ ],
            required    => [ qw/q/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
        [ 'verify_credentials', {
            aliases     => [ qw// ],
            path        => 'account/verify_credentials',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 1,
        } ],
    ] ],
    [ Search => [
        [ 'search', {
            aliases     => [ qw// ],
            path        => 'search',
            method      => 'GET',
            params      => [ qw/q callback lang rpp page since_id geocode show_user/ ],
            required    => [ qw/q/ ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 0,
        } ],
        [ 'trends', {
            aliases     => [ qw// ],
            path        => 'trends',
            method      => 'GET',
            params      => [ qw// ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 0,
        } ],
        [ 'trends_current', {
            aliases     => [ qw// ],
            path        => 'trends/current',
            method      => 'GET',
            params      => [ qw/exclude/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 0,
        } ],
        [ 'trends_daily', {
            aliases     => [ qw// ],
            path        => 'trends/daily',
            method      => 'GET',
            params      => [ qw/date exclude/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 0,
        } ],
        [ 'trends_weekly', {
            aliases     => [ qw// ],
            path        => 'trends/weekly',
            method      => 'GET',
            params      => [ qw/date exclude/ ],
            required    => [ qw// ],
            add_source  => 0,
            deprecated  => 0,
            authenticate => 0,
        } ],
    ] ],
];

my $with_url_arg = sub {
    my ($path, $args) = @_;

    if ( defined(my $id = delete $args->{id}) ) {
        $path .= uri_escape($id);
    }
    else {
        chop($path);
    }
    return $path;
};

while ( @$api_def ) {
    my $api = shift @$api_def;
    my $api_name = shift @$api;
    my $methods = shift @$api;

    my $url_attr = $api_name eq 'REST' ? 'apiurl' : 'searchurl';

    my $base_url = sub { shift->{$url_attr} };

    for my $method ( @$methods ) {
        my $name    = shift @$method;
        my %options = %{ shift @$method };

        my ($arg_names, $path) = @options{qw/required path/};
        $arg_names = $options{params} if @$arg_names == 0 && @{$options{params}} == 1;

        my $modify_path = $path =~ s,/id$,/, ? $with_url_arg : sub { $_[0] };

        my $code = sub {
            my $self = shift;

            # copy callers args since we may add ->{source}
            my $args = ref $_[-1] eq 'HASH' ? { %{pop @_} } : {};

            if ( @_ ) {
                @_ == @$arg_names || croak "$name expected @{[ scalar @$arg_names ]} args";
                @{$args}{@$arg_names} = @_;
            }
            $args->{source} ||= $self->{source} if $options{add_source};

            my $authenticate = exists $args->{authenticate}  ? delete $args->{authenticate}
                             : $options{authenticate}
                             ;

            my $local_path = $modify_path->($path, $args);
            
            my $uri = URI->new($base_url->($self) . "/$local_path.json");

            return $self->_parse_result(
                $self->_authenticated_request($options{method}, $uri, $args, $authenticate)
            );
        };

        no strict 'refs';
        *{__PACKAGE__ . "::$_"} = $code for $name, @{$options{aliases}};
    }
}

sub _from_json {
    my ($self, $json) = @_;

    return eval { $json_handler->from_json($json) };
}

sub _parse_result {
    my ($self, $res) = @_;

    # workaround for Laconica API returning bools as strings
    # (Fixed in Laconi.ca 0.7.4)
    my $content = $res->content;
    $content =~ s/^"(true|false)"$/$1/;

    my $obj = $self->_from_json($content);

    # Twitter sometimes returns an error with status code 200
    if ( $obj && ref $obj eq 'HASH' && exists $obj->{error} ) {
        die Net::Twitter::Lite::Error->new(twitter_error => $obj, http_response => $res);
    }

    return $obj if $res->is_success && defined $obj;

    my $error = Net::Twitter::Lite::Error->new(http_response => $res);
    $error->twitter_error($obj) if ref $obj;

    die $error;
}

1;

__END__

=head1 NAME

Net::Twitter::Lite - A perl interface to the Twitter API

=head1 VERSION

This document describes Net::Twitter::Lite version 0.08006

=head1 SYNOPSIS

  use Net::Twitter::Lite;

  my $nt = Net::Twitter::Lite->new(
      username => $user,
      password => $password
  );

  my $result = eval { $nt->update('Hello, world!') };

  eval {
      my $statuses = $nt->friends_timeline({ since_id => $high_water, count => 100 });
      for my $status ( @$statuses ) {
          print "$status->{created_at} <$status->{user}{screen_name}> $status->{text}\n";
      }
  };
  warn "$@\n" if $@;


=head1 DESCRIPTION

This module provides a perl interface to the Twitter APIs. It uses the same API definitions
as L<Net::Twitter>, but without the extra bells and whistles and without the additional dependencies.
Same great taste, less filling.


This module is related to, but is not part of the C<Net::Twitter>
distribution.  It's API methods and API method documentation are generated
from C<Net::Twitter>'s internals.  It exists for those who cannot, or prefer
not to install L<Moose> and its dependencies.

You should consider upgrading to C<Net::Twitter> for additional functionality,
finer grained control over features, full backwards compatibility with older
versions of C<Net::Twitter>, and additional error handling options.

=head1 CLIENT CODE CHANGES REQUIRED

The default C<apiurl> changed in version 0.08006.  The change should be
transparent to client code, unless you're using the C<netrc> option.  If so,
you'll need to either update the C<.netrc> entry and change the C<machine>
value from C<twitter.com> to C<api.twitter.com>, or set either the C<netrc>
or C<netrc_machine> options to C<twitter.com>.

    $nt = Net::Twitter::Lite->new(netrc_machine => 'twitter.com', netrc => 1);
    # -or-
    $nt = Net::Twitter::Lite->new(netrc => 'twitter.com');

=head1 IMPORTANT

Beginning with version 0.03, it is necessary for web applications using OAuth
authentication to pass the C<callback> parameter to C<get_authorization_url>.
In the absence of a callback parameter, when the user authorizes the
application a PIN number is displayed rather than redirecting the user back to
your site.

=head1 MIGRATING FROM NET::TWITTER 2.x

If you are migrating from Net::Twitter 2.12 (or an earlier version), you may
need to make some minor changes to your application code in order to user
Net::Twitter::Lite successfully.

The primary difference is in error handling.  Net::Twitter::Lite throws
exceptions on error.  It does not support the C<get_error>, C<http_code>, and
C<http_message> methods used in Net::Twitter 2.12 and prior versions.

Instead of

  # DON'T!
  my $friends = $nt->friends();
  if ( $friends ) {
      # process $friends
  }

wrap the API call in an eval block:

  # DO!
  my $friends = eval { $nt->friends() };
  if ( $friends ) {
      # process $friends
  }

Here's a much more complex example taken from application code using
Net::Twitter 2.12:

  # DON'T!
  my $friends = $nt->friends();
  if ( $friends ) {
      # process $friends
  }
  else {
      my $error = $nt->get_error;
      if ( ref $error ) {
          if ( ref($error) eq 'HASH' && exists $error->{error} ) {
              $error = $error->{error};
          }
          else {
              $error = 'Unexpected error type ' . ref($error);
          }
      }
      else {
          $error = $nt->http_code() . ": " . $nt->http_message;
      }
      warn "$error\n";
  }

The Net::Twitter::Lite equivalent is:

  # DO!
  eval {
      my $friends = $nt->friends();
      # process $friends
  };
  warn "$@\n" if $@;
  return;

In Net::Twitter::Lite, an error can always be treated as a string.  See
L<Net::Twitter::Lite::Error>.  The HTTP Status Code and HTTP Message are both
available.  Rather than accessing them via the Net::Twitter::Lite instance,
you access them via the Net::Twitter::Lite::Error instance thrown as an error.

For example:

  # DO!
  eval {
     my $friends = $nt->friends();
     # process $friends
  };
  if ( my $error = $@ ) {
      if ( blessed $error && $error->isa("Net::Twitter::Lite::Error)
           && $error->code() == 502 ) {
          $error = "Fail Whale!";
      }
      warn "$error\n";
  }

=head2 Unsupported Net::Twitter 2.12 options to C<new>

Net::Twitter::Lite does not support the following Net::Twitter 2.12 options to
C<new>.  It silently ignores them:

=over 4

=item no_fallback

If Net::Twitter::Lite is unable to create an instance of the class specified in
the C<useragent_class> option to C<new>, it dies, rather than falling back to
an LWP::UserAgent object.  You really don't want a failure to create the
C<useragent_class> you specified to go unnoticed.

=item twittervision

Net::Twitter::Lite does not support the TwitterVision API.  Use Net::Twitter,
instead, if you need it.

=item skip_arg_validation

Net::Twitter::Lite does not API parameter validation.  This is a feature.  If
Twitter adds a new option to an API method, you can use it immediately by
passing it in the HASH ref to the API call.

Net::Twitter::Lite relies on Twitter to validate its own parameters.  An
appropriate exception will be thrown if Twitter reports a parameter error.

=item die_on_validation

See L</skip_arg_validation>.  If Twitter returns an bad parameter error, an
appropriate exception will be thrown.

=item arrayref_on_error

This option allowed the following idiom in Net::Twitter 2.12:

  # DON'T!
  for my $friend ( @{ $nt->friends() } ) {
     # process $friend
  }

The equivalent Net::Twitter::Lite code is:

  # DO!
  eval {
      for my $friend ( @{ $nt->friends() } ) {
          # process $friend
      }
  };

=back

=head2 Unsupported Net::Twitter 2.12 methods

=over 4

=item clone

The C<clone> method was added to Net::Twitter 2.x to allow safe error handling
in an environment where concurrent requests are handled, for example, when
using LWP::UserAgent::POE as the C<useragent_class>.  Since Net::Twitter::Lite
throws exceptions instead of stashing them in the Net::Twitter::Lite instance,
it is safe in a current request environment, obviating the need for C<clone>.

=item get_error

=item http_code

=item http_message

These methods are replaced by Net::Twitter::Lite::Error.  An instance of that
class is thrown errors are encountered.

=back

=head1 METHODS AND ARGUMENTS

=over 4

=item new

This constructs a C<Net::Twitter::Lite> object.  It takes several named parameters,
all of them optional:

=over 4

=item username

This is the screen name or email used to authenticate with Twitter. Use this
option for Basic Authentication, only.

=item password

This is the password used to authenticate with Twitter. Use this option for
Basic Authentication, only.

=item consumer_key

A string containing the OAuth consumer key provided by Twitter when an application
is registered.  Use this option for OAuth authentication, only.

=item consumer_secret

A string containing the OAuth consumer secret. Use this option for OAuth authentication, only.
the C<OAuth> trait is included.

=item oauth_urls

A HASH ref of URLs to be used with OAuth authentication. Defaults to:

  {
      request_token_url => "http://twitter.com/oauth/request_token",
      authorization_url => "http://twitter.com/oauth/authorize",
      access_token_url  => "http://twitter.com/oauth/access_token",
  }

=item clientname

The value for the C<X-Twitter-Client-Name> HTTP header. It defaults to "Perl
Net::Twitter::Lite".

=item clientver

The value for the C<X-Twitter-Client-Version> HTTP header. It defaults to
current version of the C<Net::Twitter::Lite> module.

=item clienturl

The value for the C<X-Twitter-Client-URL> HTTP header. It defaults to the
search.cpan.org page for the C<Net::Twitter::Lite> distribution.

=item useragent_class

The C<LWP::UserAgent> compatible class used internally by C<Net::Twitter::Lite>.  It
defaults to "LWP::UserAgent".  For L<POE> based applications, consider using
"LWP::UserAgent::POE".

=item useragent_args

An HASH ref of arguments to pass to constructor of the class specified with
C<useragent_class>, above.  It defaults to {} (an empty HASH ref).

=item useragent

The value for C<User-Agent> HTTP header.  It defaults to
"Net::Twitter::Lite/0.08006 (Perl)".

=item source

The value used in the C<source> parameter of API method calls. It is currently
only used in the C<update> method in the REST API.  It defaults to
"twitterpm".  This results in the text "from Net::Twitter" rather than "from
web" for status messages posted from C<Net::Twitter::Lite> when displayed via the
Twitter web interface.  The value for this parameter is provided by Twitter
when a Twitter application is registered.  See
L<http://apiwiki.twitter.com/FAQ#HowdoIget%E2%80%9CfromMyApp%E2%80%9DappendedtoupdatessentfrommyAPIapplication>.

=item apiurl

The URL for the Twitter API. This defaults to "http://twitter.com".

=item identica

If set to 1 (or any value that evaluates to true), apiurl defaults to
"http://identi.ca/api".

=item ssl

If set to 1, an SSL connection will be used for all API calls. Defaults to 0.

=item netrc

(Optional) Sets the I<machine> key to look up in C<.netrc> to obtain
credentials. If set to 1, Net::Twitter::Lite will use the value of the C<netrc_machine>
option (below).

   # in .netrc
   machine api.twitter.com
     login YOUR_TWITTER_USER_NAME
     password YOUR_TWITTER_PASSWORD
   machine semifor.twitter.com
     login semifor
     password SUPERSECRET

   # in your perl program
   $nt = Net::Twitter::Lite->new(netrc => 1);
   $nt = Net::Twitter::Lite->new(netrc => 'semifor.twitter.com');

=item netrc_machine

(Optional) Sets the C<machine> entry to look up in C<.netrc> when C<<netrc => 1>>
is used.  Defaults to C<api.twitter.com>.

=back

=back

=head2 BASIC AUTHENTICATION METHODS

=over 4

=item credentials($username, $password)

Set the credentials for Basic Authentication.  This is helpful for managing
multiple accounts.

=back

=head2 OAUTH METHODS

=over 4

=item authorized

Whether the client has the necessary credentials to be authorized.

Note that the credentials may be wrong and so the request may fail.

=item request_access_token

Returns list including the access token, access token secret, user_id, and
screen_name for this user. Takes a HASH of arguments. The C<verifier> argument
is required.  See L</OAUTH EXAMPLES>.

The user must have authorized this app at the url given by C<get_authorization_url> first.

For desktop applications, the Twitter authorization page will present the user
with a PIN number.  Prompt the user for the PIN number, and pass it as the
C<verifier> argument to request_access_token.

Returns the access token and access token secret but also sets them internally
so that after calling this method, you can immediately call API methods
requiring authentication.

=item get_authorization_url(callback => $callback_url)

Get the URL used to authorize the user.  Returns a C<URI> object.  For web
applications, pass your applications callback URL as the C<callback> parameter.
No arguments are required for desktop applications (C<callback> defaults to
C<oob>, out-of-band).

=item get_authentication_url(callback => $callback_url)

Get the URL used to authenticate the user with "Sign in with Twitter"
authentication flow.  Returns a C<URI> object.  For web applications, pass your
applications callback URL as the C<callback> parameter.  No arguments are
required for desktop applications (C<callback> defaults to C<oob>, out-of-band).

=item access_token

Get or set the access token.

=item access_token_secret

Get or set the access token secret.

=item request_token

Get or set the request token.

=item request_token_secret

Get or set the request token secret.

=item access_token_url

Get or set the access_token URL.

=item authentication_url

Get or set the authentication URL.

=item authorization_url

Get or set the authorization URL.

=item request_token_url

Get or set the request_token URL.

=back

=head1 API METHODS AND ARGUMENTS

Most Twitter API methods take parameters.  All Net::Twitter::Lite API
methods will accept a HASH ref of named parameters as specified in the Twitter
API documentation.  For convenience, many Net::Twitter::Lite methods accept
simple positional arguments as documented, below.  The positional parameter
passing style is optional; you can always use the named parameters in a hash
ref if you prefer.

For example, the REST API method C<update> has one required parameter,
C<status>.  You can call C<update> with a HASH ref argument:

    $nt->update({ status => 'Hello world!' });

Or, you can use the convenient form:

    $nt->update('Hello world!');

The C<update> method also has an optional parameter, C<in_reply_to_status_id>.
To use it, you B<must> use the HASH ref form:

    $nt->update({ status => 'Hello world!', in_reply_to_status_id => $reply_to });

Convenience form is provided for the required parameters of all API methods.
So, these two calls are equivalent:

    $nt->friendship_exists({ user_a => $fred, user_b => $barney });
    $nt->friendship_exists($fred, $barney);

Many API methods have aliases.  You can use the API method name, or any of its
aliases, as you prefer.  For example, these calls are all equivalent:

    $nt->friendship_exists($fred, $barney);
    $nt->relationship_exists($fred, $barney);
    $nt->follows($fred, $barney);

Aliases support both the HASH ref and convenient forms:

    $nt->follows({ user_a => $fred, user_b => $barney });

Methods that support the C<page> parameter expect page numbers E<gt> 0.  Twitter silently
ignores invalid C<page> values.  So C<< { page => 0 } >> produces the same result
as C<< { page => 1 } >>.

In addition to the arguments specified for each API method described below, an
additional C<authenticate> parameter can be passed.  To request an
C<Authorization> header, pass C<< authenticated => 1 >>; to suppress an
authentication header, pass C<< authentication => 0 >>.  Even if requested, an
Authorization header will not be added if there are no user credentials
(username and password for Basic Authentication; access tokens for OAuth).

This is probably only useful for the L</rate_limit_status> method in the REST
API, since it returns different values for an authenticated and a
non-authenticated call.

=head1 REST API Methods

Several of these methods accept a user ID as the C<id> parameter.  The user ID
can be either a screen name, or the users numeric ID.  To disambiguate, use
the C<screen_name> or C<user_id> parameters, instead.

For example, These calls are equivalent:

    $nt->create_friend('perl_api');    # screen name
    $nt->create_friend(1564061);       # numeric ID
    $nt->create_friend({ id => 'perl_api' });
    $nt->create_friend({ screen_name => 'perl_api' });
    $nt->create_friend({ user_id     => 1564061 });

However user_id 911 and screen_name 911 are separate Twitter accounts.  These
calls are NOT equivalent:

    $nt->create_friend(911); # interpreted as screen name
    $nt->create_friend({ user_id => 911 }); # screen name: richellis

Whenever the C<id> parameter is required and C<user_id> and C<screen_name> are
also parameters, using any one of them satisfies the requirement.



=over 4

=item B<block_exists>

=item B<block_exists(id)>



=over 4

=item Parameters: id, user_id, screen_name

=item Required: id

=back

Returns if the authenticating user is blocking a target user. Will return the blocked user's
object if a block exists, and error with HTTP 404 response code otherwise.


Returns: BasicUser

=item B<blocking>

=item B<blocking(page)>



=over 4

=item Parameters: page

=item Required: I<none>

=back

Returns an array of user objects that the authenticating user is blocking.


Returns: ArrayRef[BasicUser]

=item B<blocking_ids>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Returns an array of numeric user ids the authenticating user is blocking.


Returns: ArrayRef[Int]

=item B<create_block>

=item B<create_block(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Blocks the user specified in the ID parameter as the authenticating user.
Returns the blocked user when successful.  You can find out more about
blocking in the Twitter Support Knowledge Base.


Returns: BasicUser

=item B<create_favorite>

=item B<create_favorite(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Favorites the status specified in the ID parameter as the
authenticating user.  Returns the favorite status when successful.


Returns: Status

=item B<create_friend>

=item B<create_friend(id)>


=item alias: follow_new


=over 4

=item Parameters: id, user_id, screen_name, follow

=item Required: id

=back

Befriends the user specified in the ID parameter as the authenticating user.
Returns the befriended user when successful.  Returns a string describing the
failure condition when unsuccessful.


Returns: BasicUser

=item B<create_saved_search>

=item B<create_saved_search(query)>



=over 4

=item Parameters: query

=item Required: query

=back

Creates a saved search for the authenticated user.


Returns: SavedSearch

=item B<destroy_block>

=item B<destroy_block(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Un-blocks the user specified in the ID parameter as the authenticating user.
Returns the un-blocked user when successful.


Returns: BasicUser

=item B<destroy_direct_message>

=item B<destroy_direct_message(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Destroys the direct message specified in the required ID parameter.
The authenticating user must be the recipient of the specified direct
message.


Returns: DirectMessage

=item B<destroy_favorite>

=item B<destroy_favorite(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Un-favorites the status specified in the ID parameter as the
authenticating user.  Returns the un-favorited status.


Returns: Status

=item B<destroy_friend>

=item B<destroy_friend(id)>


=item alias: unfollow


=over 4

=item Parameters: id, user_id, screen_name

=item Required: id

=back

Discontinues friendship with the user specified in the ID parameter as the
authenticating user.  Returns the un-friended user when successful.
Returns a string describing the failure condition when unsuccessful.


Returns: BasicUser

=item B<destroy_saved_search>

=item B<destroy_saved_search(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Destroys a saved search. The search, specified by C<id>, must be owned
by the authenticating user.


Returns: SavedSearch

=item B<destroy_status>

=item B<destroy_status(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Destroys the status specified by the required ID parameter.  The
authenticating user must be the author of the specified status.


Returns: Status

=item B<direct_messages>



=over 4

=item Parameters: since_id, max_id, count, page

=item Required: I<none>

=back

Returns a list of the 20 most recent direct messages sent to the authenticating
user including detailed information about the sending and recipient users.


Returns: ArrayRef[DirectMessage]

=item B<disable_notifications>

=item B<disable_notifications(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Disables notifications for updates from the specified user to the
authenticating user.  Returns the specified user when successful.


Returns: BasicUser

=item B<enable_notifications>

=item B<enable_notifications(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Enables notifications for updates from the specified user to the
authenticating user.  Returns the specified user when successful.


Returns: BasicUser

=item B<end_session>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Ends the session of the authenticating user, returning a null cookie.
Use this method to sign users out of client-facing applications like
widgets.


Returns: Error

=item B<favorites>



=over 4

=item Parameters: id, page

=item Required: I<none>

=back

Returns the 20 most recent favorite statuses for the authenticating
user or user specified by the ID parameter.


Returns: ArrayRef[Status]

=item B<followers>



=over 4

=item Parameters: id, user_id, screen_name, cursor

=item Required: I<none>

=back

Returns a reference to an array of the user's followers.  If C<id>, C<user_id>,
or C<screen_name> is not specified, the followers of the authenticating user are
returned.  The returned users are ordered from most recently followed to least
recently followed.

Use the optional C<cursor> parameter to retrieve users in pages of 100.  When
the C<cursor> parameter is used, the return value is a reference to a hash with
keys C<previous_cursor>, C<next_cursor>, and C<users>.  The value of C<users>
is a reference to an array of the user's friends. The result set isn't
guaranteed to be 100 every time as suspended users will be filtered out.  Set
the optional C<cursor> parameter to -1 to get the first page of users.  Set it
to the prior return's value of C<previous_cursor> or C<next_cursor> to page
forward or backwards.  When there are no prior pages, the value of
C<previous_cursor> will be 0.  When there are no subsequent pages, the value of
C<next_cursor> will be 0.


Returns: HashRef|ArrayRef[User]

=item B<followers_ids>

=item B<followers_ids(id)>



=over 4

=item Parameters: id, user_id, screen_name, cursor

=item Required: id

=back

Returns a reference to an array of numeric IDs for every user following the
specified user.

Use the optional C<cursor> parameter to retrieve IDs in pages of 5000.  When
the C<cursor> parameter is used, the return value is a reference to a hash with
keys C<previous_cursor>, C<next_cursor>, and C<ids>.  The value of C<ids> is a
reference to an array of IDS of the user's followers. Set the optional C<cursor>
parameter to -1 to get the first page of IDs.  Set it to the prior return's
value of C<previous_cursor> or C<next_cursor> to page forward or backwards.
When there are no prior pages, the value of C<previous_cursor> will be 0.  When
there are no subsequent pages, the value of C<next_cursor> will be 0.


Returns: HashRef|ArrayRef[Int]

=item B<friends>


=item alias: following


=over 4

=item Parameters: id, user_id, screen_name, cursor

=item Required: I<none>

=back

Returns a reference to an array of the user's friends.  If C<id>, C<user_id>,
or C<screen_name> is not specified, the friends of the authenticating user are
returned.  The returned users are ordered from most recently followed to least
recently followed.

Use the optional C<cursor> parameter to retrieve users in pages of 100.  When
the C<cursor> parameter is used, the return value is a reference to a hash with
keys C<previous_cursor>, C<next_cursor>, and C<users>.  The value of C<users>
is a reference to an array of the user's friends. The result set isn't
guaranteed to be 100 every time as suspended users will be filtered out.  Set
the optional C<cursor> parameter to -1 to get the first page of users.  Set it
to the prior return's value of C<previous_cursor> or C<next_cursor> to page
forward or backwards.  When there are no prior pages, the value of
C<previous_cursor> will be 0.  When there are no subsequent pages, the value of
C<next_cursor> will be 0.


Returns: Hashref|ArrayRef[User]

=item B<friends_ids>

=item B<friends_ids(id)>


=item alias: following_ids


=over 4

=item Parameters: id, user_id, screen_name, cursor

=item Required: id

=back

Returns a reference to an array of numeric IDs for every user followed the
specified user.

Use the optional C<cursor> parameter to retrieve IDs in pages of 5000.  When
the C<cursor> parameter is used, the return value is a reference to a hash with
keys C<previous_cursor>, C<next_cursor>, and C<ids>.  The value of C<ids> is a
reference to an array of IDS of the user's friends. Set the optional C<cursor>
parameter to -1 to get the first page of IDs.  Set it to the prior return's
value of C<previous_cursor> or C<next_cursor> to page forward or backwards.
When there are no prior pages, the value of C<previous_cursor> will be 0.  When
there are no subsequent pages, the value of C<next_cursor> will be 0.


Returns: HashRef|ArrayRef[Int]

=item B<friends_timeline>


=item alias: following_timeline


=over 4

=item Parameters: since_id, max_id, count, page

=item Required: I<none>

=back

Returns the 20 most recent statuses posted by the authenticating user
and that user's friends. This is the equivalent of /home on the Web.


Returns: ArrayRef[Status]

=item B<friendship_exists>

=item B<friendship_exists(user_a, user_b)>


=item alias: relationship_exists

=item alias: follows


=over 4

=item Parameters: user_a, user_b

=item Required: user_a, user_b

=back

Tests for the existence of friendship between two users. Will return true if
user_a follows user_b, otherwise will return false.


Returns: Bool

=item B<home_timeline>



=over 4

=item Parameters: since_id, max_id, count, page

=item Required: I<none>

=back

Returns the 20 most recent statuses, including retweets, posted by the
authenticating user and that user's friends. This is the equivalent of
/timeline/home on the Web.


Returns: ArrayRef[Status]

=item B<mentions>


=item alias: replies


=over 4

=item Parameters: since_id, max_id, count, page

=item Required: I<none>

=back

Returns the 20 most recent mentions (statuses containing @username) for the
authenticating user.


Returns: ArrayRef[Status]

=item B<new_direct_message>

=item B<new_direct_message(user, text)>



=over 4

=item Parameters: user, text, screen_name, user_id

=item Required: user, text

=back

Sends a new direct message to the specified user from the authenticating user.
Requires both the user and text parameters.  Returns the sent message when
successful.  In order to support numeric screen names, the C<screen_name> or
C<user_id> parameters may be used instead of C<user>.


Returns: DirectMessage

=item B<public_timeline>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Returns the 20 most recent statuses from non-protected users who have
set a custom user icon.  Does not require authentication.  Note that
the public timeline is cached for 60 seconds so requesting it more
often than that is a waste of resources.

If user credentials are provided, C<public_timeline> calls are authenticated,
so they count against the authenticated user's rate limit.  Use C<<
->public_timeline({ authenticate => 0 }) >> to make an unauthenticated call
which will count against the calling IP address' rate limit, instead.


Returns: ArrayRef[Status]

=item B<rate_limit_status>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Returns the remaining number of API requests available to the
authenticated user before the API limit is reached for the current hour.

Use C<< ->rate_limit_status({ authenticate => 0 }) >> to force an
unauthenticated call, which will return the status for the IP address rather
than the authenticated user. (Note: for a web application, this is the server's
IP address.)


Returns: RateLimitStatus

=item B<report_spam>

=item B<report_spam(id)>



=over 4

=item Parameters: id, user_id, screen_name

=item Required: id

=back

The user specified in the id is blocked by the authenticated user and reported as a spammer.


Returns: User

=item B<retweet>

=item B<retweet(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Retweets a tweet. Requires the id parameter of the tweet you are retweeting.
Returns the original tweet with retweet details embedded.


Returns: Status

=item B<retweeted_by_me>



=over 4

=item Parameters: since_id, max_id, count, page

=item Required: I<none>

=back

Returns the 20 most recent retweets posted by the authenticating user.


Returns: ArrayRef[Status]

=item B<retweeted_of_me>



=over 4

=item Parameters: since_id, max_id, count, page

=item Required: I<none>

=back

Returns the 20 most recent tweets of the authenticated user that have been
retweeted by others.


Returns: ArrayRef[Status]

=item B<retweeted_to_me>



=over 4

=item Parameters: since_id, max_id, count, page

=item Required: I<none>

=back

Returns the 20 most recent retweets posted by the authenticating user's friends.


Returns: ArrayRef[Status]

=item B<retweets>

=item B<retweets(id)>



=over 4

=item Parameters: id, count

=item Required: id

=back

Returns up to 100 of the first retweets of a given tweet.


Returns: Arrayref[Status]

=item B<saved_searches>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Returns the authenticated user's saved search queries.


Returns: ArrayRef[SavedSearch]

=item B<sent_direct_messages>



=over 4

=item Parameters: since_id, max_id, page

=item Required: I<none>

=back

Returns a list of the 20 most recent direct messages sent by the authenticating
user including detailed information about the sending and recipient users.


Returns: ArrayRef[DirectMessage]

=item B<show_friendship>

=item B<show_friendship(id)>


=item alias: show_relationship


=over 4

=item Parameters: source_id, source_screen_name, target_id, target_id_name

=item Required: id

=back

Returns detailed information about the relationship between two users.


Returns: Relationship

=item B<show_saved_search>

=item B<show_saved_search(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Retrieve the data for a saved search, by ID, owned by the authenticating user.


Returns: SavedSearch

=item B<show_status>

=item B<show_status(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Returns a single status, specified by the id parameter.  The
status's author will be returned inline.


Returns: Status

=item B<show_user>

=item B<show_user(id)>



=over 4

=item Parameters: id

=item Required: id

=back

Returns extended information of a given user, specified by ID or screen
name as per the required id parameter.  This information includes
design settings, so third party developers can theme their widgets
according to a given user's preferences. You must be properly
authenticated to request the page of a protected user.


Returns: ExtendedUser

=item B<test>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Returns the string "ok" status code.


Returns: Str

=item B<trends_available>



=over 4

=item Parameters: lat, long

=item Required: I<none>

=back

Returns the locations with trending topic information. The response is an
array of "locations" that encode the location's WOEID (a Yahoo!  Where On Earth
ID L<http://developer.yahoo.com/geo/geoplanet/>) and some other human-readable
information such as a the location's canonical name and country.

When the optional C<lat> and C<long> parameters are passed, the available trend
locations are sorted by distance from that location, nearest to farthest.

Use the WOEID returned in the location object to query trends for a specific
location.


Returns: ArrayRef[Location]

=item B<trends_location>

=item B<trends_location(woeid)>



=over 4

=item Parameters: woeid

=item Required: woeid

=back

Returns the top 10 trending topics for a specific location. The response is an
array of "trend" objects that encode the name of the trending topic, the query
parameter that can be used to search for the topic on Search, and the direct
URL that can be issued against Search.  This information is cached for five
minutes, and therefore users are discouraged from querying these endpoints
faster than once every five minutes.  Global trends information is also
available from this API by using a WOEID of 1.


Returns: ArrayRef[Trend]

=item B<update>

=item B<update(status)>



=over 4

=item Parameters: status, lat, long, in_reply_to_status_id

=item Required: status

=back

Updates the authenticating user's status.  Requires the status parameter
specified.  A status update with text identical to the authenticating
user's current status will be ignored.

The optional C<lat> and C<long> parameters add location data to the status for
a geo enabled account. They expect values in the ranges -90.0 to +90.0 and
-180.0 to +180.0 respectively.  They are ignored unless the user's
C<geo_enabled> field is true.


Returns: Status

=item B<update_delivery_device>

=item B<update_delivery_device(device)>



=over 4

=item Parameters: device

=item Required: device

=back

Sets which device Twitter delivers updates to for the authenticating
user.  Sending none as the device parameter will disable IM or SMS
updates.


Returns: BasicUser

=item B<update_profile>



=over 4

=item Parameters: name, email, url, location, description

=item Required: I<none>

=back

Sets values that users are able to set under the "Account" tab of their
settings page. Only the parameters specified will be updated; to only
update the "name" attribute, for example, only include that parameter
in your request.


Returns: ExtendedUser

=item B<update_profile_background_image>

=item B<update_profile_background_image(image)>



=over 4

=item Parameters: image

=item Required: image

=back

Updates the authenticating user's profile background image. The C<image>
parameter must be an arrayref with the same interpretation as the C<image>
parameter in the C<update_profile_image> method.  See that method's
documentation for details.


Returns: ExtendedUser

=item B<update_profile_colors>



=over 4

=item Parameters: profile_background_color, profile_text_color, profile_link_color, profile_sidebar_fill_color, profile_sidebar_border_color

=item Required: I<none>

=back

Sets one or more hex values that control the color scheme of the
authenticating user's profile page on twitter.com.  These values are
also returned in the /users/show API method.


Returns: ExtendedUser

=item B<update_profile_image>

=item B<update_profile_image(image)>



=over 4

=item Parameters: image

=item Required: image

=back

Updates the authenticating user's profile image.  The C<image> parameter is an
arrayref with the following interpretation:

  [ $file ]
  [ $file, $filename ]
  [ $file, $filename, Content_Type => $mime_type ]
  [ undef, $filename, Content_Type => $mime_type, Content => $raw_image_data ]

The first value of the array (C<$file>) is the name of a file to open.  The
second value (C<$filename>) is the name given to Twitter for the file.  If
C<$filename> is not provided, the basename portion of C<$file> is used.  If
C<$mime_type> is not provided, it will be provided automatically using
L<LWP::MediaTypes::guess_media_type()>.

C<$raw_image_data> can be provided, rather than opening a file, by passing
C<undef> as the first array value.


Returns: ExtendedUser

=item B<user_timeline>



=over 4

=item Parameters: id, user_id, screen_name, since_id, max_id, count, page

=item Required: I<none>

=back

Returns the 20 most recent statuses posted from the authenticating
user. It's also possible to request another user's timeline via the id
parameter. This is the equivalent of the Web /archive page for
your own user, or the profile page for a third party.


Returns: ArrayRef[Status]

=item B<users_search>

=item B<users_search(q)>


=item alias: find_people

=item alias: search_users


=over 4

=item Parameters: q, per_page, page

=item Required: q

=back

Run a search for users similar to Find People button on Twitter.com; the same
results returned by people search on Twitter.com will be returned by using this
API (about being listed in the People Search).  It is only possible to retrieve
the first 1000 matches from this API.


Returns: ArrayRef[Users]

=item B<verify_credentials>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Returns an HTTP 200 OK response code and a representation of the
requesting user if authentication was successful; returns a 401 status
code and an error message if not.  Use this method to test if supplied
user credentials are valid.


Returns: ExtendedUser


=back



=head1 Search API Methods



=over 4

=item B<search>

=item B<search(q)>



=over 4

=item Parameters: q, callback, lang, rpp, page, since_id, geocode, show_user

=item Required: q

=back

Returns a HASH reference with some meta-data about the query including the
C<next_page>, C<refresh_url>, and C<max_id>. The statuses are returned in
C<results>.  To iterate over the results, use something similar to:

    my $r = $nt->search($searh_term);
    for my $status ( @{$r->{results}} ) {
        print "$status->{text}\n";
    }


Returns: HashRef

=item B<trends>



=over 4

=item Parameters: I<none>

=item Required: I<none>

=back

Returns the top ten queries that are currently trending on Twitter.  The
response includes the time of the request, the name of each trending topic, and
the url to the Twitter Search results page for that topic.


Returns: ArrayRef[Query]

=item B<trends_current>

=item B<trends_current(exclude)>



=over 4

=item Parameters: exclude

=item Required: I<none>

=back

Returns the current top ten trending topics on Twitter.  The response includes
the time of the request, the name of each trending topic, and query used on
Twitter Search results page for that topic.


Returns: HashRef

=item B<trends_daily>



=over 4

=item Parameters: date, exclude

=item Required: I<none>

=back

Returns the top 20 trending topics for each hour in a given day.


Returns: HashRef

=item B<trends_weekly>



=over 4

=item Parameters: date, exclude

=item Required: I<none>

=back

Returns the top 30 trending topics for each day in a given week.


Returns: HashRef


=back



=head1 ERROR HANDLING

When C<Net::Twitter::Lite> encounters a Twitter API error or a network error, it
throws a C<Net::Twitter::Lite::Error> object.  You can catch and process these
exceptions by using C<eval> blocks and testing $@:

    eval {
        my $statuses = $nt->friends_timeline(); # this might die!

        for my $status ( @$statuses ) {
            #...
        }
    };
    if ( $@ ) {
        # friends_timeline encountered an error

        if ( blessed $@ && $@->isa('Net::Twitter::Lite::Error' ) {
            #... use the thrown error obj
            warn $@->error;
        }
        else {
            # something bad happened!
            die $@;
        }
    }

C<Net::Twitter::Lite::Error> stringifies to something reasonable, so if you don't need
detailed error information, you can simply treat $@ as a string:

    eval { $nt->update($status) };
    if ( $@ ) {
        warn "update failed because: $@\n";
    }


=head1 AUTHENTICATION

Net::Twitter::Lite currently supports both Basic Authentication and OAuth.  The
choice of authentication strategies is determined by the options passed to
C<new> or the use of the C<credentials> method.  An error will be thrown if
options for both strategies are provided.

=head2 BASIC AUTHENTICATION

To use Basic Authentication, pass the C<username> and C<password> options to
C<new>, or call C<credentials> to set them.  When Basic Authentication is used,
the C<Authorization> header is set on each authenticated API call.

=head2 OAUTH AUTHENTICATION

To use OAuth authentication, pass the C<consumer_key> and C<consumer_secret> options to new.

L<Net::OAuth::Simple> must be installed in order to use OAuth and an error will
be thrown if OAuth is attempted without it.  Net::Twitter::Lite does not
I<require> Net::OAuth::Simple, making OAuth an optional feature.

=head2 OAUTH EXAMPLES

See the C<examples> directory included in this distribution for full working
examples using OAuth.

Here's how to authorize users as a desktop app mode:

  use Net::Twitter::Lite;

  my $nt = Net::Twitter::Lite->new(
      consumer_key    => "YOUR-CONSUMER-KEY",
      consumer_secret => "YOUR-CONSUMER-SECRET",
  );

  # You'll save the token and secret in cookie, config file or session database
  my($access_token, $access_token_secret) = restore_tokens();
  if ($access_token && $access_token_secret) {
      $nt->access_token($access_token);
      $nt->access_token_secret($access_token_secret);
  }

  unless ( $nt->authorized ) {
      # The client is not yet authorized: Do it now
      print "Authorize this app at ", $nt->get_authorization_url, " and enter the PIN#\n";

      my $pin = <STDIN>; # wait for input
      chomp $pin;

      my($access_token, $access_token_secret, $user_id, $screen_name) =
          $nt->request_access_token(verifier => $pin);
      save_tokens($access_token, $access_token_secret); # if necessary
  }

  # Everything's ready

In a web application mode, you need to save the oauth_token and
oauth_token_secret somewhere when you redirect the user to the OAuth
authorization URL.

  sub twitter_authorize : Local {
      my($self, $c) = @_;

      my $nt = Net::Twitter::Lite->new(%param);
      my $url = $nt->get_authorization_url(callback => $callbackurl);

      $c->response->cookies->{oauth} = {
          value => {
              token => $nt->request_token,
              token_secret => $nt->request_token_secret,
          },
      };

      $c->response->redirect($url);
  }

And when the user returns back, you'll reset those request token and
secret to upgrade the request token to access token.

  sub twitter_auth_callback : Local {
      my($self, $c) = @_;

      my %cookie = $c->request->cookies->{oauth}->value;

      my $nt = Net::Twitter::Lite->new(%param);
      $nt->request_token($cookie{token});
      $nt->request_token_secret($cookie{token_secret});

      my($access_token, $access_token_secret, $user_id, $screen_name) =
          $nt->request_access_token;

      # Save $access_token and $access_token_secret in the database associated with $c->user
  }

Later on, you can retrieve and reset those access token and secret
before calling any Twitter API methods.

  sub make_tweet : Local {
      my($self, $c) = @_;

      my($access_token, $access_token_secret) = ...;

      my $nt = Net::Twitter::Lite->new(%param);
      $nt->access_token($access_token);
      $nt->access_token_secret($access_token_secret);

      # Now you can call any Net::Twitter::Lite API methods on $nt
      my $status = $c->req->param('status');
      my $res = $nt->update({ status => $status });
  }

=head1 SEE ALSO

=over 4

=item L<Net::Twitter::Lite::Error>

The C<Net::Twitter::Lite> exception object.

=item L<http://apiwiki.twitter.com/Twitter-API-Documentation>

This is the official Twitter API documentation. It describes the methods and their
parameters in more detail and may be more current than the documentation provided
with this module.

=item L<LWP::UserAgent::POE>

This LWP::UserAgent compatible class can be used in L<POE> based application
along with Net::Twitter::Lite to provide concurrent, non-blocking requests.

=back

=head1 SUPPORT

Please report bugs to C<bug-net-twitter@rt.cpan.org>, or through the web
interface at L<https://rt.cpan.org/Dist/Display.html?Queue=Net-Twitter>.

Join the Net::Twitter IRC channel at L<irc://irc.perl.org/net-twitter>.

Follow perl_api: L<http://twitter.com/perl_api>.

Track Net::Twitter::Lite development at L<http://github.com/semifor/net-twitter-lite>.

=head1 AUTHOR

Marc Mims <marc@questright.com>

=head1 LICENSE

Copyright (c) 2009 Marc Mims

The Twitter API itself, and the description text used in this module is:

Copyright (c) 2009 Twitter

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut


