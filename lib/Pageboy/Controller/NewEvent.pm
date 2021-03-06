package Pageboy::Controller::NewEvent;
use Moose;
use MooseX::AttributeShortcuts;
extends 'Pageboy::Controller';

use Pageboy::Form::NewEvent;

no warnings 'experimental::signatures';
use feature 'signatures';

has form => (
    is => 'lazy',
    default => sub {
        Pageboy::Form::NewEvent->new;
    },
);

sub get ($self, $r) {
    return {}
}

sub post ($self, $r) {
    my $params = $r->parameters;
    my $result = $self->form->run( params => $params );
    my %data;
    if ($result->validated) {
        $data{posted} = 'success';
        my $event = $self->model->create_event(
            $result->value
        );
    }
    else {
        $data{posted} = 'failure';
    }
    return \%data;
}

1;
