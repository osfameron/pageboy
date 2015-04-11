package Pageboy::Controller;
use Moose;
use Path::Tiny;
use HTML::Zoom;

has container_html => (
    is => 'ro',
    lazy => 1,
    default => sub {
        path('container.html')->slurp
    }
);

has container => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        HTML::Zoom->from_html($self->container_html);
    }
);

sub render_html {
    my ($self, $template, $fn) = @_;
    my $container = $self->container;
    my $content = HTML::Zoom->from_html(path($template)->slurp);
    if ($fn) {
        $content = $content->apply($fn);
    }
    my $html = $container
        ->select('main')
        ->replace_content( $content )
        ->to_html;
}

sub respond_html {
    my ($self, $r, $template, $fn) = @_;
    my $html = $self->render_html($template, $fn);
    my $res = $r->new_response([200]);
    $res->content_type('text/html');
    $res->content($html);
    return $res;
}

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
    return $self->render_html('index.html', sub {
        my $last_date = '';
        $_->select('article')->repeat([
            map {
                my $data = $_;
                sub {
                    my $z = $_->select('article')->set_attribute(class => $data->{type});

                    my $is_event = $data->{type} eq 'event';
                    for my $breadcrumb ('author', $is_event ? 'location' : 'category') {
                        $z = $z
                          ->select("a.$breadcrumb")->replace_content($data->{$breadcrumb}{name})
                          ->then->set_attribute(href => (sprintf '/%s/%s',
                            $breadcrumb, $data->{$breadcrumb}{slug}))
                    }
                    if ($last_date eq $data->{date}) {
                        $z = $z->select('time')->set_attribute(style => 'visibility: hidden');
                    }
                    $last_date = $data->{date};
                    $z;
                }
            } @data,
        ])
    });
}

1;
