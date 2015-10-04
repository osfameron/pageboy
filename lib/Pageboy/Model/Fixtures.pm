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
        scheduled_datetime => [days => 2],
    });
    $self->create_event($model, {
        type => 'media',
        category => 'Article',
        source => 'Guardian',
        scheduled_datetime => [days => 3],
    });
}

sub create_event ($self, $app, $override) {
    my $app_time = $app->time;
    my $scheduled_datetime = $override->{scheduled_datetime}
        // [ days => 1 ];
    my ($unit, $count) = @$scheduled_datetime;
    my $event_time = $app_time->clone->add( $unit => $count );
    $override->{scheduled_datetime} = $event_time;

    $app->model->events->create({
        author => 'Owen Jones',
        author_photo => 'owen-jones-waterstones.jpeg',
        type => 'event',
        source => 'Waterstones',
        description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
        %$override,
    });
};

1;
