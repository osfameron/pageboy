use strict; use warnings;
 
use Test::More;
use HTTP::Request::Common;
use Test::BDD::Cucumber::StepFile;
use String::Trim;

Given qr/^an author/, sub {
    my %data = map {
        $_->{field} => $_->{value}
    } @{ C->data };

    my $app = S->{app};
    my $model = $app->model;
    my $fixtures = $model->fixtures;

    $fixtures->create_author($app, \%data);
};

When qr/I visit the author page for (?<author>.*)\s*$/, sub {
    my $url = sprintf '/author?author=%s', $+{author};
    S->{mech}->get_ok($url);
};
