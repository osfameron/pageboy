package Pageboy::Controller::Author;
use Moose;
extends 'Pageboy::Controller';

no warnings 'experimental::signatures';
use feature 'signatures';

sub get ($self, $r) {
    my $author_name = $r->param('author');
    my $author_object = $self->model->find_author($author_name);

    if ($author_object) {
        my $events = $self->model->list_events({ author => $author_name });

        return {
            status => 'ok',
            author => $author_name,
            description => $author_object->description,
            twitter => $author_object->twitter,
            events => $events,
        }
    }
    else {
        return {
            status => 'fail',
            author => $author_name,
        }
    }
}

1;
