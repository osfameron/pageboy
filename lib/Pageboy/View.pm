package Pageboy::View;
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
    my ($self, $template, $data) = @_;
    my $container = $self->container;
    my $content = HTML::Zoom->from_html(path($template)->slurp);
    my $fn = $self->render_root_fn($data);
    $content = $content->apply($fn);

    my $html = $container
        ->select('main')
        ->replace_content( $content )
        ->to_html;
}

sub render_root_fn {
    my ($self, $data) = @_;
    return sub {
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
                    my $date = $data->{date};
                    $z = $z->select('time')
                        ->set_attribute(datetime => $date->strftime('%F'))
                        ->select('.month')->replace_content( $date->strftime('%b') )
                        ->select('.day--number')->replace_content( $date->strftime('%d') )
                        ->select('.day--name')->replace_content( $date->strftime('%a') )
                        ->select('.year')->replace_content( $date->strftime('%Y') );
                    if ($last_date && ($last_date == $date)) {
                        $z = $z->select('time')->set_attribute(style => 'visibility: hidden');
                    }
                    $last_date = $date;
                    $z;
                }
            } @$data,
        ])
    };
}

1;
