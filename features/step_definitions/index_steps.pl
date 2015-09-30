use strict; use warnings;
 
use Test::More;
use Test::WWW::Mechanize::PSGI;
use HTTP::Request::Common;
use Pageboy::Test::Controller;
use Test::BDD::Cucumber::StepFile;

Given qr/^an app .*/, sub {
    S->{app} = my $app = Pageboy::Test::Controller->new;
    S->{mech} = Test::WWW::Mechanize::PSGI->new(
        app => $app->to_app,
    );
    # TODO, some fixtures
};

Given qr/no geolocation/, sub { 
    # TODO something here
};


When qr/I visit the landing page.*/, sub {
    S->{mech}->get_ok('/');
};

Then qr/I should see some events.*/, sub {
    my $data = S->{app}->view->data;
    ok scalar (@$data), 'There is some data';
};

Given qr/.*/, sub { fail 'step not defined' };
When  qr/.*/, sub { fail 'step not defined' };
Then  qr/.*/, sub { fail 'step not defined' };
