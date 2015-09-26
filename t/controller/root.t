use strict; use warnings;

use Pageboy::Test::Controller;

use Test::More;
use Plack::Test;
use HTTP::Request::Common;

use Data::Dumper;

my $app = Pageboy::Test::Controller->new;

test_psgi $app->to_app, sub {
    my $cb = shift;
    my $res = $cb->(GET '/');

    is $res->content, ''; # sanity check that mock suppresses view output

    is $app->view->template, 'index.html';
    is_deeply $app->view->data,
    [
        {
            author => { name => 'Owen Jones', slug => 'owen-jones', photo => 'owen-jones-waterstones.jpeg' },
            type => 'event',
            location => { name => 'Liverpool', slug => 'liverpool' },
            source => { name => 'Waterstones', slug => 'waterstones' },
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            date => '7 Apr 2015',
        },
        {
            author => { name => 'Owen Jones', slug => 'owen-jones', photo => 'owen-jones-waterstones.jpeg' },
            type => 'media',
            category => { name => 'Podcast', slug => 'podcast' },
            source => { name => 'Guardian', slug => 'guardian' },
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            date => '7 Apr 2015',
        },
        {
            author => { name => 'Owen Jones', slug => 'owen-jones', photo => 'owen-jones-waterstones.jpeg' },
            type => 'media',
            category => { name => 'Article', slug => 'article' },
            source => { name => 'Guardian', slug => 'guardian' },
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            date => '7 Apr 2015',
        },
    ];
};

done_testing;