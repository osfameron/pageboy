package Pageboy::View::Plugin::NewEvent;
use Moose;

sub process {
    my ($self, $content, $data) = @_;

    if (my $result = $data->{posted}) {
        $content = $content->select('#new-event-dialog')->replace_content('');
        $content = $content->select('#new-event-notice')->replace_content(
            $result eq 'success' ? 'Posted!' : 'Failed!');
    }

    $content;
}

1;
