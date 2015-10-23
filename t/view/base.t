use strict; use warnings;

no warnings 'experimental::signatures';
use feature 'signatures';

use Pageboy::Test::Controller;

use Test::More;
use Pageboy::View::Base;
use Mojo::DOM;
use Test::LongString;

my $base = Pageboy::View::Base->new();

sub get_dom {
    Mojo::DOM->new(<<'TEMPLATE');
<html>
    <h1>Page title</h1>
    <div id="template">
        <h2>Some Headline"</h2>
        <a href="http://www.example.com">source</a>
        <blockquote>Blah blah blah</blockquote>
    </div>
</html>
TEMPLATE
}

my @tolkien = (
    'h2' => q"Tolkien's annotated map of Middle-earth discovered inside copy of Lord of the Rings",
    'a' => [ attr => 'href', 'http://www.theguardian.com/books/2015/oct/23/jrr-tolkien-middle-earth-annotated-map-blackwells-lord-of-the-rings' ],
    'a' => 'Guardian Books',
    'blockquote' => q"Map goes on sale in Oxford for £60,000 after being found at Blackwell's Rare Books inside novel belonging to illustrator Pauline Baynes",
);

my @le_guin = (
    'h2' => q"David Mitchell on Earthsea - a rival to Tolkien and George RR Martin",
    'a' => [ attr => 'href', 'http://www.theguardian.com/books/2015/oct/23/david-mitchell-wizard-of-earthsea-tolkien-george-rr-martin' ],
    'a' => 'Guardian Books',
    'blockquote' => q"In A Wizard of Earthsea, published in 1968, Ursula K Le Guin created one of literature's most fully formed fantasy worlds. The author of Cloud Atlas and The Bone Clocks recalls how he fell under its spell",
);

subtest 'bind' => sub {
    my $dom = get_dom();

    $base->bind($dom, 'h1' => 'Today in books');
    $base->bind($dom->at('#template'), @tolkien);

    is_string "$dom", <<EXPECTED;
<html>
    <h1>Today in books</h1>
    <div id="template">
        <h2>Tolkien&#39;s annotated map of Middle-earth discovered inside copy of Lord of the Rings</h2>
        <a href="http://www.theguardian.com/books/2015/oct/23/jrr-tolkien-middle-earth-annotated-map-blackwells-lord-of-the-rings">Guardian Books</a>
        <blockquote>Map goes on sale in Oxford for £60,000 after being found at Blackwell&#39;s Rare Books inside novel belonging to illustrator Pauline Baynes</blockquote>
    </div>
</html>
EXPECTED
};

subtest 'repeat 0' => sub {
    my $dom = get_dom();
    my $repeat = sub ($node, $data) { $base->bind($node, @$data) };

    $base->repeat($dom->at('#template'), $repeat, []);
    is_string "$dom", <<EXPECTED;
<html>
    <h1>Page title</h1>
    
</html>
EXPECTED
};

subtest 'repeat 2' => sub {
    my $dom = get_dom();
    my $repeat = sub ($node, $data) { $base->bind($node, @$data) };

    $base->repeat($dom->at('#template'), $repeat, [\@tolkien, \@le_guin]);
    is_string "$dom", <<EXPECTED;
<html>
    <h1>Page title</h1>
    <div>
        <h2>Tolkien&#39;s annotated map of Middle-earth discovered inside copy of Lord of the Rings</h2>
        <a href="http://www.theguardian.com/books/2015/oct/23/jrr-tolkien-middle-earth-annotated-map-blackwells-lord-of-the-rings">Guardian Books</a>
        <blockquote>Map goes on sale in Oxford for £60,000 after being found at Blackwell&#39;s Rare Books inside novel belonging to illustrator Pauline Baynes</blockquote>
    </div><div>
        <h2>David Mitchell on Earthsea - a rival to Tolkien and George RR Martin</h2>
        <a href="http://www.theguardian.com/books/2015/oct/23/david-mitchell-wizard-of-earthsea-tolkien-george-rr-martin">Guardian Books</a>
        <blockquote>In A Wizard of Earthsea, published in 1968, Ursula K Le Guin created one of literature&#39;s most fully formed fantasy worlds. The author of Cloud Atlas and The Bone Clocks recalls how he fell under its spell</blockquote>
    </div>
</html>
EXPECTED
};

done_testing;
