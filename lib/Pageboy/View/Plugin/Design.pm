package Pageboy::View::Plugin::Design;
use Moo;
extends 'Pageboy::View::Base';
with 'Pageboy::View::Role::Events';

sub get_container_path {
    'container-design'
}

sub process {
    my ($self, $content, $data) = @_;

    $self->repeat($content->at('li.template'), sub {
        my ($li, $data) = @_;
        $self->bind($li,
            'a' => [attr => 'href', $data->{href}],
            '.path' => $data->{path},
            '.plugin' => $data->{plugin},
        );
        $self->repeat($li->at('.data'), sub {
            my ($node, $data2) = @_;
            my $href = $data->{href} . '?data=' . $data2;
            $self->bind($node,
                'a' => [attr => 'href', $href],
                'a' => "$data2",
            );
        }, $data->{data});
    }, $data);
}

1;
