package Pageboy::Geo;

use Moose;
use MooseX::AttributeShortcuts;
use GeoIP2::Database::Reader;

no warnings 'experimental::signatures';
use feature 'signatures';

has geoip2 => (
    is => 'lazy',
    default => sub {
        GeoIP2::Database::Reader->new(
            file    => 'data/GeoLite2-City.mmdb',
            locales => [ 'en' ],
        );
    },
);

sub get_ip_from_request ($self, $r) {
    return $r->address;
}

sub get_location_from_ip ($self, $r) {
    my $ip = $self->get_ip_from_request($r)
        or return;

    # suppress 'The IP address you provided (x.x.x.x) is not a public IP
    # address' errors in development, and perhaps in the wild
    my $city = eval { $self->geoip2->city( ip => $ip ) }
        or return;
    return $city->city->name;
}

1;
