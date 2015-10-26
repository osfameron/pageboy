package Pageboy::View::Plugin::Author;
use Moo;
extends 'Pageboy::View::Base';
with 'Pageboy::View::Role::Events';

sub process {
    my ($self, $content, $data) = @_;

    my $author = $data->{author};

    if ($data->{status} eq 'ok') {
        $self->bind($content,
            '.author-name'        => $author,
            '.author-twitter'     => '@' . $data->{twitter},
            '.author-twitter'     => [attr => 'href', 'https://twitter.com/' . $data->{twitter}],
            '.author-description' => $data->{description},
        );
        $self->process_events($content, $data->{events});
    }
    else {
        $self->bind($content,
            '#author-content' => ['remove'],
            '#author-notice' => sprintf 'No author found called "%s"', $author,
        );
    }
}

1;
