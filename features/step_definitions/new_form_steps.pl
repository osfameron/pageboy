use strict; use warnings;

use Test::More;
use HTTP::Request::Common;
use Test::BDD::Cucumber::StepFile;

Given qr/there are no events in the database/, sub {
    is S->{app}->model->events->count, 0;
};

When qr/I visit the new event page/, sub {
    my $url = '/new-event';
    S->{mech}->get_ok($url);
    S->{mech}->content_contains('Author Name');
};

When qr/I post the form with the data/, sub {
    my %data = map {
        $_->{field} => $_->{value}
    } @{ C->data };
    my $form_number = delete $data{form_number} || 1;

    S->{mech}->submit_form_ok({
        form_number => $form_number,
        fields => \%data,
        }, 'posted form');
};

Then qr/I should see a success message/, sub {
    S->{mech}->content_contains('Posted!', 'Received a success message');
};

Then qr/there should be (\d+) events? in the database/, sub {
    is S->{app}->model->events->count, $1;
};
