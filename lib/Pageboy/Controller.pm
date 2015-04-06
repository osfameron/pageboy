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
        $content = $fn->($content);
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
    return $self->render_html('index.html'); # no fn
}

1;
