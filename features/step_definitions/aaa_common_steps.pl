use strict; use warnings;

use Test::More;
use Test::WWW::Mechanize::PSGI;
use Pageboy::Test::Controller;

Before sub {
    S->{app} = my $app = Pageboy::Test->new;
    S->{mech} = Test::WWW::Mechanize::PSGI->new(
        app => $app->to_app,
    );
};
