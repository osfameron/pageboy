package Pageboy::Model::Fixtures;

use Moose;
use MooseX::AttributeShortcuts;

no warnings 'experimental::signatures';
use feature 'signatures';

sub setup_fixtures ($self, $model) {
    $model->events->populate([
        {
            author => 'Owen Jones',
            author_photo => 'owen-jones-waterstones.jpeg',
            type => 'event',
            location => 'Liverpool',
            source => 'Waterstones',
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            scheduled_datetime => '2015-04-07',
        },
        {
            author => 'Owen Jones',
            author_photo => 'owen-jones-waterstones.jpeg',
            type => 'media',
            category => 'Podcast',
            source => 'Guardian',
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            scheduled_datetime => '2015-04-07',
        },
        {
            author => 'Owen Jones',
            author_photo => 'owen-jones-waterstones.jpeg',
            type => 'media',
            category => 'Article',
            source => 'Guardian',
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            scheduled_datetime => '2015-04-07',
        },
    ]);
}

1;
