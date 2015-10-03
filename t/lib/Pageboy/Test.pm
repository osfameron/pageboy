package Pageboy::Test;

use OX;
extends 'Pageboy';
use MooseX::AttributeShortcuts;
use Pageboy::Model;
use Test::PostgreSQL;
use Pageboy::Test::Geo;

no warnings 'experimental::signatures';
use feature 'signatures';
use feature 'say';

has 'model' => (
    is => 'ro',
    default => sub {
        my $self = shift;
        $ENV{TEST_DB_DEPLOYED}++ if $ENV{TEST_DSN};
        my $dsn = $ENV{TEST_DSN} ||= do {
            say '# spinning up Postgres instance';
            $self->test_postgresql->dsn;
        };
        say "# DSN: $dsn";
        my $model = Pageboy::Model->new(
            dsn => $dsn,
        );

        my $db = $model->db;
        unless ($ENV{TEST_DB_DEPLOYED}++) {
            say '# Deploying test DB';
            $db->deploy;
        }

        $db->txn_begin;

        return $model;
    },
    infer => 0
);

has '+geo' => (
    default => sub { Pageboy::Test::Geo->new },
);

has test_postgresql => (
    is => 'lazy',
    # isa => Test::PostgreSQL
    default => sub {
        Test::PostgreSQL->new;
    }
);

sub teardown {
    my $self = shift;
    $self->model->db->txn_rollback;
}

1;
