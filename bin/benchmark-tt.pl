use strict; use warnings;
use lib 'lib';
use Template;
use Pageboy::View;
use Test::More;
use Test::LongString;
use DateTime;
use Benchmark 'cmpthese';

my $data = {
    status => 'ok',
    author => 'Margaret Atwood',
    description => 'Blah blah blah',
    twitter => 'MargaretAtwood',
    events => [
        {
            type => 'event',
            description => 'Blah blah blah blah',
            author => {
                slug => 'margaret-atwood',
                name => 'Margaret Atwood',
                photo => 'http://example.com/foo.jpg',
            },
            location => {
                slug => 'salford',
                name => 'Salford',
            },
            date => DateTime->today,
        }
    ]
};


sub process_tt {
    my $tt = Template->new({ INCLUDE_PATH => 'templates/benchmark/' });
    my $output;
    $tt->process('author.tt', $data, \$output) or die $tt->error;
    $output;
}
sub process_mojo {
    my $view = Pageboy::View->new;
    return $view->render_html('Author', $data);
}

my $tt = process_tt;
my $md = process_mojo;
$tt =~s{</li>}{}g;
$tt =~s{[ /\n]*}{}g;
$tt =~s{'}{"}g;
$md =~s{</li>}{}g;
$md =~s{[ /\n]*}{}g;
$md =~s{'}{"}g;

is_string $tt, $md;
done_testing;

cmpthese(1000, {
        tt => \&process_tt,
        mojo => \&process_mojo,
    });
