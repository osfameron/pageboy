use strict; use warnings;
 
use Test::More;
use Test::WWW::Mechanize::PSGI;
use HTTP::Request::Common;
use Pageboy::Test::Controller;
use Test::BDD::Cucumber::StepFile;

Before sub {
    S->{app} = my $app = Pageboy::Test::Controller->new;
    S->{mech} = Test::WWW::Mechanize::PSGI->new(
        app => $app->to_app,
    );
};

Given qr/^some events.*/, sub {
    S->{app}->model->setup_fixtures;
};

Given qr/^some upcoming events in*/, sub {
    my $model = S->{app}->model;
    my $fixtures = $model->fixtures;
    for my $datum (@{ C->data }) {
        my $location = $datum->{location};
        # my $area = AREAS->{$location} or die "No such area: $location";
        $fixtures->create_event($model, {
            location => $location,
        });
    }
};

Given qr/I am in (?<location>\w+)/, sub { 
    S->{location} = $+{location};
};

When qr/I visit the landing page.*/, sub {
    my $url = S->{location} ?
        sprintf '/?location=%s', S->{location}
        : '/';
    S->{mech}->get_ok($url);
};

Then qr/I should see (?<count>\d+) events.*/, sub {
    my $data = S->{app}->view->data;
    is scalar (@$data), $+{count}, 'Correct number of events';
};

Given qr/(.*)/, sub { fail "step not defined $1" };
When  qr/(.*)/, sub { fail "step not defined $1" };
Then  qr/(.*)/, sub { fail "step not defined $1" };

After sub {
    S->{app}->teardown;
};
