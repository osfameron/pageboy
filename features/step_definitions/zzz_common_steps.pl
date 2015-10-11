use strict; use warnings;

use Test::More;
use Test::WWW::Mechanize::PSGI;
use Pageboy::Test::Controller;

Given qr/(.*)/, sub { fail "step not defined $1" };
When  qr/(.*)/, sub { fail "step not defined $1" };
Then  qr/(.*)/, sub { fail "step not defined $1" };

After sub {
    S->{app}->teardown;
};
