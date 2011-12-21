package Democradj;

use strict;
use warnings;
use Dancer;

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

dance;
