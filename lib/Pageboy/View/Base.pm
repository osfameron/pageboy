package Pageboy::View::Base;
use Moo;
use Mojo::DOM;
use Storable 'dclone';
use List::Pairwise 'mapp';

sub get_container_path {
    'container'
}

sub get_template_path {
    my $self = shift;
    (my $key = ref $self)=~s/^.*::Plugin:://;
    return ('pages', $key);
}

sub bind {
    my ($self, $content, @data) = @_;
    mapp {
        my $node = $content->at($a)
            or return;
        if (ref $b) {
            $node->tap(@$b);
        }
        else {
            $node->content($b);
        }
    } @data;
}

sub repeat {
    my ($self, $content, $cb, $data) = @_;

    my $template = Mojo::DOM->new($content);
    my $root = $template->at(':root');
    delete $root->attr->{id};

    my $new_content = Mojo::DOM->new('');

    for my $datum (@$data) {
        my $node = dclone($template);
        $cb->($node, $datum);
        $new_content->append_content($node);
    }
    $content->replace($new_content);
}

1;
