package Pageboy::Management;

use Moo;
use MooX::Cmd;
use MooX::Options;
use Module::Load;

has app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        load 'Pageboy';
        Pageboy->new;
    },
);

has test_app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        load lib => 't/lib';
        my $test_class = 'Pageboy::Test';
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
