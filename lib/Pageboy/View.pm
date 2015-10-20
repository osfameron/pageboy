package Pageboy::View;
use Moose;
use Path::Tiny;
use Mojo::DOM;
use Module::Pluggable sub_name => '_plugins';
use Module::Runtime 'require_module';
use String::CamelSnakeKebab 'kebab_case';

has container => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        $self->get_template_object('Container');
    }
);

has plugins => (
    traits => ['Hash'],
    is => 'ro',
    isa => 'HashRef[Str]',
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
    my ($self, $plugin) = @_;
    my $template_name = kebab_case($plugin);
    my $template = path( 'templates', "${template_name}.html" );
    return $template->exists ? $template : ();
}

sub get_template_object {
    my ($self, $plugin) = @_;
    my $template = $self->get_template($plugin);
    return $template ? Mojo::DOM->new($template->slurp) : ();
}

sub render_html {
    my ($self, $plugin_name, $data) = @_;

    my $container = $self->container;

    my $content = $self->get_template_object($plugin_name);
    if ($content) {

        $content->find('include')->map(sub {
            $_->replace( $self->get_template_object($_->attr('template')) );
        });

        if (my $plugin = $self->get_plugin($plugin_name)) {
            $plugin->process($content, $data); # mutates $content
        }

        $container
            ->at('main')
            ->content( $content );
    }

    return "$container";
}

1;
