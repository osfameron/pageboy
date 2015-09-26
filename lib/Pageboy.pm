package Pageboy;
use OX;

has root => (
    is    => 'ro',
    isa   => 'Pageboy::Controller',
    infer => 1,
    dependencies => ['view'],
);

has view => (
    is    => 'ro',
    isa   => 'Pageboy::View',
    infer => 1,
);

router as {
    route '/' => 'root.index';

    wrap 'Plack::Middleware::Static' => (
        path => literal(sub { m{^/images/} }),
        root => literal('./web/'),
    );
};

1;