use 5.020;
package Pageboy::Controller;
use Moose;

no warnings 'experimental::signatures';
use feature 'signatures';

has view => (
    is => 'ro',
);

has model => (
    is => 'ro',
);

has geo => (
    is => 'ro',
);

has time => (
    is    => 'ro',
);

sub index ($self, $r) {

    my $location = $r->param('location');
    $location //= $self->geo->get_location_from_ip($r);

    my $params = {
        scheduled_after => $self->time,
        $location ? ( location => $location ) : (),
    };

    my $data = $self->model->list_events($params);

    return $self->render($data);
}

sub render ($self, $data) {
    return $self->view->render_html('index.html', $data);
}

1;
