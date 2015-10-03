package Pageboy::Model::Fixtures;

use Moose;
use MooseX::AttributeShortcuts;

no warnings 'experimental::signatures';
use feature 'signatures';

sub setup_fixtures ($self, $model) {
    $self->create_event($model, {
        type => 'event',
        location => 'Liverpool',
        source => 'Waterstones',
    });
    $self->create_event($model, {
        type => 'media',
        category => 'Podcast',
        source => 'Guardian',
    });
    $self->create_event($model, {
        type => 'media',
        category => 'Article',
        source => 'Guardian',
    });
}

sub create_event ($self, $model, $override) {
    $model->events->create({
        author => 'Owen Jones',
        author_photo => 'owen-jones-waterstones.jpeg',
        type => 'event',
        source => 'Waterstones',
        description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
        scheduled_datetime => '2015-04-07',
        %$override,
    });
};

1;
