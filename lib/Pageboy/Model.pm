package Pageboy::Model;

use Moose;
use MooseX::AttributeShortcuts;

use Pageboy::Schema;

has dsn => (
    is => 'lazy',
    # isa => 'Str',
    default => 'dbi:Pg:dbname=pageboy',
);

has connect_info => (
    is => 'lazy',
    # isa => 'ArrayRef',
    default => sub { [ shift->dsn ] },
);

has db => (
    is => 'lazy',
    default => sub {
        Pageboy::Schema->connect(@{ shift->connect_info });
    }
);

1;
