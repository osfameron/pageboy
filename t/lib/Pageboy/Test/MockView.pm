package Pageboy::Test::MockView;
use Moose;
extends 'Pageboy::View';

has r => (
    is => 'rw',
);

has template => (
    is => 'rw',
);

has data => (
    is => 'rw',
);

sub render_html {
    my ($self, $template, $data) = @_;
    $self->template($template);
    $self->data($data);
    return '';
}

1;
