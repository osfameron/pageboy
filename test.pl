use strict; use warnings;
use Geo::IP;
use Data::Dumper;
my $gi = Geo::IP->new(GEOIP_MEMORY_CACHE);
# my $record = $gi->record_by_addr('80.68.93.60');
my $record = $gi->record_by_addr('82.40.19.60');
print Dumper($record);
