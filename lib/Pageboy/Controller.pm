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

sub render ($self, $r, $data) {
    my $template = $self->get_template;
    my $output = $self->view->render_html($template, $data);
    return $r->new_response(
        status => 200,
        content => $output,
    )->finalize;
}


1;
