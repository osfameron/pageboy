package Pageboy::View::Plugin::Index;
use Moose;
extends 'Pageboy::View::Base';
with 'Pageboy::View::Role::Events';

sub process {
    my ($self, $content, $data) = @_;
    $self->process_events($content, $data->{events});
}

1;
