package Pageboy::View::Plugin::Author;
use Moose;
with 'Pageboy::View::Role::Events';

sub process {
    my ($self, $content, $data) = @_;

    my $author = $data->{author};

    if ($data->{status} eq 'ok') {
        $content->at('.author-name')->content($author);
        $content->at('.author-twitter')->content($data->{twitter});
        $content->at('.author-description')->content($data->{description});
        $self->process_events($content, $data->{events});
    }
    else {
        $content->at('#author-content')->content('');
        $content->at('#author-notice')->content(
            sprintf 'No author found called "%s"', $author);
    }
}

1;
