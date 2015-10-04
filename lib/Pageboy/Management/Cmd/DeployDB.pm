package Pageboy::Management::Cmd::DeployDB;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;

use feature 'say';

option setup_demo => (
    is => 'ro',
    doc => 'use sample data to deployment',
);

sub execute {
    my ( $self, $args, $chain ) = @_;

    my $app = $chain->[0]->app;

    my $db = $app->model->db;
    $db->deploy;

    if ($self->setup_demo) {
        say 'Setting up demo data';
        $app->setup_fixtures;
    }
}

1;
