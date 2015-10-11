package Pageboy::Form::NewEvent;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field author => (
    type => 'Text',
);

has_field type => (
    type => 'Select',
    options => [
        { value => 'event', label => 'Event' },
        { value => 'article', label => 'Article' },
        { value => 'podcast', label => 'Podcast' },
    ],
);

has_field location => (
    type => 'Text',
);

has_field description => (
    type => 'Text',
);

has_field source => (
    type => 'Text',
);

has_field scheduled_datetime => (
    type => 'Text',
);

1;
