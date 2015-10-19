use strict; use warnings;
 
use Test::More;
use HTTP::Request::Common;
use Test::BDD::Cucumber::StepFile;
use String::Trim;

Given qr/^some events(?: in)?/, sub {
    my $app = S->{app};
    my $model = $app->model;
    my $fixtures = $model->fixtures;

    for my $datum (@{ C->data }) {
        if (my $when = delete $datum->{when}) {
            my ($count, $unit) = split /\s+/, trim( $when );
            $datum->{scheduled_datetime} = [$unit, $count];
        }
        $fixtures->create_event($app, $datum);
    }
};

Given qr/^some events$/, sub {
    S->{app}->setup_fixtures;
};

Given qr/I have selected (?<location>\w+) as my location$/, sub { 
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
    my $data = S->{app}->view->data->{events};
    is scalar (@$data), $+{count}, 'Correct number of events';
};
