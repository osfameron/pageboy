package Pageboy::Test::MockView;
use Moose;
extends 'Pageboy::View';

has clear => (
    is => 'ro',
);

has r => (
    is => 'rw',
);

has template => (
    is => 'rw',
);

has data => (
    is => 'rw',
);

around render_html  => sub {
    my ($orig, $self, $plugin_name, $data) = @_;
    $self->template($plugin_name);
    $self->data($data);

    if ($self->clear) {
        return '';
    }
    else {
        $self->$orig($plugin_name, $data);
    }
};

1;
