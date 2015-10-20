package Pageboy::View::Role::Events;
use Moose::Role;

sub process_events {
    my ($self, $content, $data) = @_;

    my $article_node = $content->at('article');
    my $article_template = $article_node->to_string;
    my $last_date;
    my @articles = map {
        my $datum = $_;
        my $article = Mojo::DOM->new($article_template);
        $article->attr(class => $datum->{type});

        my $is_event = $datum->{type} eq 'event';
        for my $breadcrumb ('author', $is_event ? 'location' : 'category') {
            my $node = $article->at("a.$breadcrumb");
            my $value = $datum->{$breadcrumb};
            if ($value) {
                $node->content($value->{name})
                    ->attr(href => sprintf '/%s/%s',
                        $breadcrumb, $datum->{$breadcrumb}{slug});
            }
            else {
                $node->remove;
            }
        }
        my $date = $datum->{date};
        $article->at('time')->attr(datetime => $date->strftime('%F'));
        $article->at('.month')->content( $date->strftime('%b') );
        $article->at('.day--number')->content( $date->strftime('%d') );
        $article->at('.day--name')->content( $date->strftime('%a') );
        $article->at('.year')->content( $date->strftime('%Y') );
        if ($last_date && ($last_date == $date)) {
            $article->at('time')->attr(style => 'visibility: hidden');
        }
        $last_date = $date;
        $article;
    } @$data;

    $article_node->replace( join '', @articles );
}

1;
