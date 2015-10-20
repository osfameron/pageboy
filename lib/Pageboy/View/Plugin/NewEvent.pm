package Pageboy::View::Plugin::NewEvent;
use Moose;

sub process {
    my ($self, $content, $data) = @_;

    if (my $result = $data->{posted}) {
        $content->at('#new-event-dialog')->content('');
        $content->at('#new-event-notice')->content(
            $result eq 'success' ? 'Posted!' : 'Failed!');
    }
}

1;
