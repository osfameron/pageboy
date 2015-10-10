package Pageboy::Management::Cmd::DeployDB;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;
use Try::Tiny;

use feature 'say';

option setup_demo => (
    is => 'ro',
    doc => 'use sample data to deployment',
);

sub execute {
    my ( $self, $args, $chain ) = @_;

    my $app = $chain->[0]->app;

    try {
        my $db = $app->model->db;
        $db->deploy;
    }
    catch {
        say <<"DEPLOY_ERROR";
There was an error deploying the database.

    $@

You may need to run the following commands: 
    \$ sudo -u postgres createuser -d vagrant
    \$ createdb pageboy
DEPLOY_ERROR
    };

    if ($self->setup_demo) {
        say 'Setting up demo data';
        $app->setup_fixtures;
    }
}

1;
