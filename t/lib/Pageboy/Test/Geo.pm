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

has lookup => (
    is => 'ro',
    traits => ['Hash'],
    default => sub {
        +{
            '130.88.98.239' => 'Manchester', # man.ac.uk
            '138.253.13.50' => 'Liverpool',  # liv.ac.uk
            '145.18.12.36'  => 'Amsterdam',  # uva.nl
        }
    },
    handles => {
        '_get_location_from_ip' => 'get',
    },
);

sub get_ip_from_request ($self, $r) {
    return $self->_ip;
}

sub get_location_from_ip ($self, $r) {
    my $ip = $self->get_ip_from_request($r)
        or return;

    return $self->_get_location_from_ip($ip);
}

1;
