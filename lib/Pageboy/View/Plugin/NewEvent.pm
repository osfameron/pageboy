package Pageboy::View::Plugin::NewEvent;
use Moo;
extends 'Pageboy::View::Base';

sub process {
    my ($self, $content, $data) = @_;

    if (my $result = $data->{posted}) {
        my $message = $result eq 'success' ? 'Posted!' : 'Failed!';
        $self->bind($content,
            '#new-event-dialog' => ['remove'],
            '#new-event-notice' => $message
        );
    }
}

1;
