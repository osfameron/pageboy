use strict; use warnings;
 
use Test::More;
use Test::BDD::Cucumber::Loader;
use Test::BDD::Cucumber::Harness::TestBuilder;
 
my $harness = Test::BDD::Cucumber::Harness::TestBuilder->new(
    {
        fail_skip => 1
    }
);
 
for my $directory ( 'features/' ) {
    my ( $executor, @features ) = Test::BDD::Cucumber::Loader->load($directory);
    die "No features found" unless @features;
    $executor->execute( $_, $harness ) for @features;
}
 
done_testing;
