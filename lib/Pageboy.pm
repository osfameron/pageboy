package Pageboy;
use OX;
use DateTime;
use String::CamelSnakeKebab 'upper_camel_case';

for my $controller (qw{ index }) {
    my $controller_subclass =
        sprintf 'Pageboy::Controller::%s',
            upper_camel_case($controller);
    has $controller => (
        is    => 'ro',
        isa   => $controller_subclass,
        infer => 1,
        lifecycle => 'Request',
        dependencies => ['view', 'model', 'geo', 'time'],
    );
}

has view => (
    is    => 'ro',
    isa   => 'Pageboy::View',
    infer => 1,
);

has model => (
    is    => 'ro',
    isa   => 'Pageboy::Model',
    infer => 1,
);

has geo => (
    is    => 'ro',
    isa   => 'Pageboy::Geo',
    infer => 1,
);

has time => (
    is    => 'ro',
    lifecycle => 'Request',
    builder => '_time_builder',
);

sub _time_builder {
    DateTime->now;
}

sub setup_fixtures {
    my $self = shift;
    $self->model->fixtures->setup_fixtures($self);
}

router as {
    route '/' => 'index.handle';

    wrap 'Plack::Middleware::Static' => (
        path => literal(sub { m{^/images/} }),
        root => literal('./web/'),
    );
};

1;
