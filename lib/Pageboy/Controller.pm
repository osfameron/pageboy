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

sub index ($self, $r) {

    my $location = $r->param('location');
    my $params = $location ? { location => $location } : undef;

    my $data = $self->model->list_events($params);

    return $self->render($data);
}

sub render ($self, $data) {
    return $self->view->render_html('index.html', $data);
}

1;
