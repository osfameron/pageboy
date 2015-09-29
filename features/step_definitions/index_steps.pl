use strict; use warnings;
 
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Pageboy::Test::Controller;
use Test::BDD::Cucumber::StepFile;

Given qr/^an app .*/, sub {
    S->{app} = Pageboy::Test::Controller->new;
    # TODO, some fixtures
};

Given qr/no geolocation/, sub { 
    # TODO something here
};

When qr/I visit the landing page.*/, sub {
    test_psgi S->{app}->to_app, sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        S->{res} = $res;
    };
};

Then qr/I should see some events.*/, sub {
    my $res = S->{res};
    ok $res->is_success, 'Request was successful';

    my $data = S->{app}->view->data;
    ok scalar (@$data), 'There is some data';
};
