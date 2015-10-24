package Pageboy::Management::Cmd::Test;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;

has test_app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        $self->command_chain->[0]->test_app;
    },
);

option features => (
    is => 'ro',
);

option no_db => (
    is => 'ro',
);

sub execute {
    my ( $self, $args ) = @_;

    local $ENV{TEST_DSN} = $self->test_app->model->dsn
        unless $self->no_db;

    if ($self->features) {
        require App::pherkin;
        App::pherkin->new->run(@$args);
    }
    elsif (@$args and -f $args->[-1]) {
        
        system( 'perl',
            '-Ilib',          # add ./lib
            '-It/lib',        # add ./t/lib
            @$args,
        );
    }
    else {
        # TODO: use App::ForkProve (but gives odd test failures)
        # $ENV{PERL_FORKPROVE_IGNORE} = 'no-preload';
        use App::Prove;
        my $ap = App::Prove->new;

        $ap->process_args(
            '-l',           # add ./lib
            '-It/lib',      # add ./t/lib
            # '-MPreload',    # pre-load common modules for speed
            '-r',           # run recursively
            @ARGV,
        );
        my $result = $ap->run;
        my $exit = $result ? 0 : 1;
        exit $exit;
    }
}

1;
