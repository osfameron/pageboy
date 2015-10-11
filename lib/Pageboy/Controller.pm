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

sub get_template ($self) {
    my $class = ref $self;
    my $base = __PACKAGE__;
    return $class =~ s/^${base}:://r;
}

sub render ($self, $data) {
    my $template = $self->get_template;
    return $self->view->render_html($template, $data);
}

sub handle ($self, $r) {
    my $data = $self->handle_request($r);
    return $self->render($data);
}

1;
