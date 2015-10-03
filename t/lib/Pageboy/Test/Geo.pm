package Pageboy::Test::Geo;

use Moose;
use MooseX::AttributeShortcuts;

no warnings 'experimental::signatures';
use feature 'signatures';

extends 'Pageboy::Geo';

# override the parent class's function with a simple getter
has _ip => (
    is => 'rw',
    default => '127.0.0.1',
    writer => 'set_ip',
);

sub get_ip_from_request ($self, $r) {
    return $self->_ip;
}

1;
