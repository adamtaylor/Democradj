package Democradj;

use strict;
use warnings;
use LWP::UserAgent;
use Dancer;
use JSON;

get '/' => sub {
    template 'index';
};

get '/api/playlist' => sub {
    return [
        {
            0 => {
                src => 'http://www.youtube.com/watch?v=ZdUINbi4wSY',
                type => 'video/youtube'
            }
        },
        {
            0 => {
                src => 'http://www.youtube.com/watch?v=GW1NTN5vMyY',
                type => 'video/youtube'
            }
        },
        {
            0 => {
                src => 'http://www.youtube.com/watch?v=LA-lOywYGic',
                type => 'video/youtube'
            }
        },
        {
            0 => {
                src => '/api/playlist',
                type => 'text/json'
            },
        },
    ];
};

post '/search' => sub {
    my $query = params->{search};

    my $client = LWP::UserAgent->new;
    my $resp = $client->get( "https://gdata.youtube.com/feeds/api/videos?q=$query&orderby=rating&max-results=50&v=2&alt=json" );

    my @ret;
    if ( $resp->is_success ) {

        my $ref = decode_json $resp->content;

        foreach ( @{$ref->{feed}->{entry}} ) {
            my $url = $_->{'media$group'}->{'media$player'}->{'url'};
            my $title = $_->{'media$group'}->{'media$title'}->{'$t'};

            # Skip stuff that's probably not a song, e.g. Foo - Bar
            next if $title !~ /.*\s-\s.*/;
            # Skip stuff that doesn't include the searched phrase
            next if $title !~ /$query/i;

            push @ret, {
                url   => $url,
                title => $title,
            };
        }
    }

    return \@ret;;
};

dance;
