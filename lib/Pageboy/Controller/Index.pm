package Pageboy::Controller::Index;
use Moose;
extends 'Pageboy::Controller';

no warnings 'experimental::signatures';
use feature 'signatures';

sub get ($self, $r) {
    my $location = $r->param('location');
    $location //= $self->geo->get_location_from_ip($r);

    my $params = {
        scheduled_after => $self->time,
        $location ? ( location => $location ) : (),
    };

    $self->model->list_events($params);
}

1;
