package Pageboy::Management::Cmd::DeployDB;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;

use feature 'say';

option setup_fixtures => (
    is => 'ro',
    doc => 'use test fixtures to deployment',
);

sub execute {
    my ( $self, $args, $chain ) = @_;

    my $app = $chain->[0]->app;

    my $db = $app->model->db;
    $db->deploy;

    if ($self->setup_fixtures) {
        say 'Setting up fixtures';
        # The functions to add fixtures are in the test module
        my $test_app = $chain->[0]->test_app;
        $test_app->test_app->setup_fixtures($db);
        say 'You can run tests against this with:';
        say '    bin/manage test --use-main-db';
    }
}

1;
