package Pageboy::View::Plugin::Index;
use Moose;

sub process {
    my ($self, $content, $data) = @_;

    my $last_date = '';
    $content->select('article')->repeat([
        map {
            my $data = $_;
            sub {
                my $z = $_->select('article')->set_attribute(class => $data->{type});

                my $is_event = $data->{type} eq 'event';
                for my $breadcrumb ('author', $is_event ? 'location' : 'category') {
                    $z = $z
                      ->select("a.$breadcrumb")->replace_content($data->{$breadcrumb}{name})
                      ->then->set_attribute(href => (sprintf '/%s/%s',
                        $breadcrumb, $data->{$breadcrumb}{slug}))
                }
                my $date = $data->{date};
                $z = $z->select('time')
                    ->set_attribute(datetime => $date->strftime('%F'))
                    ->select('.month')->replace_content( $date->strftime('%b') )
                    ->select('.day--number')->replace_content( $date->strftime('%d') )
                    ->select('.day--name')->replace_content( $date->strftime('%a') )
                    ->select('.year')->replace_content( $date->strftime('%Y') );
                if ($last_date && ($last_date == $date)) {
                    $z = $z->select('time')->set_attribute(style => 'visibility: hidden');
                }
                $last_date = $date;
                $z;
            }
        } @$data,
    ])
}

1;
