package Pageboy::Management;

use Pageboy;

use Moo;
use MooX::Cmd;
use MooX::Options;
use Module::Load;

has app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        Pageboy->new;
    },
);

has test_app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        load lib => 't/lib';
        my $test_class = 'Pageboy::Test::Controller';
        load $test_class;
        $test_class->new;
    },
);

sub execute {
    my $self = shift;
    unshift @ARGV, '--help';
    $self->new_with_cmd->execute;
}

1;
