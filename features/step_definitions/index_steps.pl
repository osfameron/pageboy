use strict; use warnings;
 
use Test::More;
use Test::WWW::Mechanize::PSGI;
use HTTP::Request::Common;
use Pageboy::Test::Controller;
use Test::BDD::Cucumber::StepFile;
use String::Trim;

Before sub {
    S->{app} = my $app = Pageboy::Test::Controller->new;
    S->{mech} = Test::WWW::Mechanize::PSGI->new(
        app => $app->to_app,
    );
};

Given qr/^some events in*/, sub {
    my $app = S->{app};
    my $model = $app->model;
    my $fixtures = $model->fixtures;

    for my $datum (@{ C->data }) {

        my $location = $datum->{location};
        my ($count, $unit) = split /\s+/, trim( $datum->{when} );

        $fixtures->create_event($app, {
            location => $location,
            scheduled_datetime => [$unit, $count]
        });
    }
};

Given qr/^some events$/, sub {
    S->{app}->setup_fixtures;
};

Given qr/I am in (?<location>\w+)$/, sub { 
    my $location = S->{location} = $+{location};
};

Given qr/I am in (?<location>\w+) \(based on my IP address\)/, sub { 
    my $location = $+{location};
    my $ip = {
        Manchester => '130.88.98.239', # man.ac.uk
        Liverpool  => '138.253.13.50', # liv.ac.uk
        Amsterdam  => '145.18.12.36',  # uva.nl
    }->{$location}
        or die "No IP address stored for $location";

    S->{app}->geo->set_ip($ip)
};

Given qr/I have an invalid or local IP address/, sub {
    S->{app}->geo->set_ip('127.0.0.1')
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
