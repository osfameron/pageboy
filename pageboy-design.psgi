use strict; use warnings;
use Plack::Builder;
use Plack::Request;
use lib 'lib';
use Pageboy::View;
use Path::Tiny;
use Mojo::DOM;
use String::CamelSnakeKebab 'upper_camel_case';

sub file_list {
    my $path = path(@_);
    return unless $path->is_dir;
    my $iterator = $path->iterator;
    my @list;
    while (my $path = $iterator->() ) {
        push @list, $path;
    }
    return @list;
}
 
builder {
    enable "Plack::Middleware::Static",
        path => qr{^/(images|js|css)/}, root => './web/';

    sub {
        my $env = shift;
        my $req = Plack::Request->new($env);

        my $path = $req->path_info;
        $path=~s{^/}{};

        my $content = do {
            if ($path) {
                my $data_file = $req->parameters->{data};
                my $data = $data_file && do $data_file;
                die $@ if $@;
                Pageboy::View->new->render_html($path, $data);
            }
            else {
                my @pages = 
                    sort { $a->{plugin} cmp $b->{plugin} }
                    map {
                        my $path = my $plugin = $_->stringify;

                        $plugin =~s{^templates/pages/}{};
                        $plugin =~s{.html$}{};
                        $plugin = upper_camel_case($plugin);

                        my @data = grep /\.data$/,
                            file_list( 't/view/fixtures', $plugin );

                        {
                            href => "/$plugin",
                            plugin => $plugin,
                            path => $path,
                            data => \@data,
                        };
                    
                    }
                    grep /\.html$/,
                    file_list( 'templates/pages/' );

                Pageboy::View->new->render_html('Design', \@pages);

            }
        };

        my $res = $req->new_response(200, { 'Content-type' => 'text/html'}, $content);
        $res->finalize;
    }
}
