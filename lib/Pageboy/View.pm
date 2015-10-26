package Pageboy::View;
use Moo;
use MooX::HandlesVia;
use Path::Tiny;
use Mojo::DOM;
use Module::Pluggable sub_name => '_plugins';
use Module::Runtime 'require_module';
use String::CamelSnakeKebab 'kebab_case';

has plugins => (
    handles_via => 'Hash',
    # traits => ['Hash'],
    is => 'ro',
    # isa => 'HashRef[Str]',
    default => sub {
        my $self = shift;
        my @plugins = $self->_plugins;
        return +{
            map {
                my $plugin = $_;
                (my $key = $plugin)=~s/^.*::Plugin:://;
                ($key => $plugin);
            }
            @plugins
        }
    },
    handles => {
        '_get_plugin' => 'get',
    },
);

sub get_plugin {
    my ($self, $plugin_name) = @_;
    if (my $plugin = $self->_get_plugin($plugin_name)) {
        require_module($plugin);
        $plugin->new;
    }
}

sub get_template {
    my ($self, @path) = @_;
    my @template_path = (
        'templates',
        map { kebab_case($_) }
        map { split m{/}, $_ }
        @path
    );
    $template_path[-1] .= '.html';
    my $template = path( @template_path );
    return $template->exists ? $template : ();
}

sub get_template_object {
    my ($self, @path) = @_;
    my $template = $self->get_template(@path);
    return $template ? Mojo::DOM->new($template->slurp) : ();
}

sub render_html {
    my ($self, $plugin_name, $data) = @_;

    if (my $plugin = $self->get_plugin($plugin_name)) {

        my $container = $self->get_template_object(
            $plugin->get_container_path);

        my $content = $self->get_template_object(
            $plugin->get_template_path);

        $content->find('include')->map(sub {
            $_->replace( $self->get_template_object($_->attr('template')) );
        });

        $plugin->process($content, $data) if $data; # mutates $content

        $container
            ->at('main')
            ->content( $content );

        return "$container";
    }
    else {
        # possibly search for a static file?
        die "No plugin found for '$plugin_name'";
    }
}

1;
