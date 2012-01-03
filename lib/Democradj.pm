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
                src => 'http://www.youtube.com/watch?v=lj39bxQC_VU',
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
            push @ret, {
                url   => $_->{'media$group'}->{'media$player'}->{'url'},
                title => $_->{'media$group'}->{'media$title'}->{'$t'},
            };
        }
    }

    return \@ret;;
};

dance;
