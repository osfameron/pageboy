package Pageboy::View::Role::Events;
use Moo::Role;

sub process_events {
    my ($self, $content, $data) = @_;

    my $last_date;
    $self->repeat(
        $content->at('article'),
        sub {
            my ($article, $datum) = @_;

            my $is_event = $datum->{type} eq 'event';
            my $date = $datum->{date};

            $self->bind($article,
                ':root' => [attr => 'class', $datum->{type}],

                'p' => $datum->{description},
                'img' => [attr => 'src', $datum->{author}{photo}],

                ( map {
                    my $selector = "a.$_";
                    if (my $breadcrumb = $datum->{$_}) {
                        ( $selector => $breadcrumb->{name},
                          $selector =>
                            [attr => 'href', sprintf '/%s/%s',
                             $_, $breadcrumb->{slug}] );
                    }
                    else {
                        ( $selector => ['remove'] );
                    }
                } 'author', $is_event ? 'location' : 'category' ),

                'time' => [ attr => 'datetime', $date->strftime('%F') ],
                '.month' => $date->strftime('%b'),
                '.day--number' => $date->strftime('%d'),
                '.day--name' => $date->strftime('%a'),
                '.year' => $date->strftime('%Y'),
                ($last_date && ($last_date == $date)) ?
                    ('time' => [attr => 'style', 'visibility: hidden']) : (),
            );
            $last_date = $date;
        },
        $data,
    );
}

1;
