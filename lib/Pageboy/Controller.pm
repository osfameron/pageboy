package Pageboy::Controller;
use Moose;

has view => (
    is => 'ro',
);

sub index {
    my ($self, $r) = @_;

    my @data = (
        {
            author => { name => 'Owen Jones', slug => 'owen-jones', photo => 'owen-jones-waterstones.jpeg' },
            type => 'event',
            location => { name => 'Liverpool', slug => 'liverpool' },
            source => { name => 'Waterstones', slug => 'waterstones' },
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            date => '7 Apr 2015',
        },
        {
            author => { name => 'Owen Jones', slug => 'owen-jones', photo => 'owen-jones-waterstones.jpeg' },
            type => 'media',
            category => { name => 'Podcast', slug => 'podcast' },
            source => { name => 'Guardian', slug => 'guardian' },
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            date => '7 Apr 2015',
        },
        {
            author => { name => 'Owen Jones', slug => 'owen-jones', photo => 'owen-jones-waterstones.jpeg' },
            type => 'media',
            category => { name => 'Article', slug => 'article' },
            source => { name => 'Guardian', slug => 'guardian' },
            description => 'Voice of the left and author of Chavs, Owen Jones will discuss his new paperback, and our Book of the Month, The Establishment.',
            date => '7 Apr 2015',
        },
    );

    return $self->view->render_html('index.html', \@data);
}

1;
