package Pageboy::View;
use Moose;
use Path::Tiny;
use HTML::Zoom;
use Module::Pluggable sub_name => '_plugins';
use Module::Runtime 'require_module';
use String::CamelSnakeKebab 'kebab_case';

has container_html => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        $self->get_template('Container')->slurp;
    }
);

has container => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        HTML::Zoom->from_html($self->container_html);
    }
);

has plugins => (
    traits => ['Hash'],
    is => 'ro',
    isa => 'HashRef[Str]',
    default => sub {
        my $self = shift;
        my $class = ref $self;
        my @plugins = $self->_plugins;
        return +{
            map {
                my $plugin = $_;
                (my $key = $plugin)=~s/^${class}::Plugin:://;
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
    my ($self, $template) = @_;
    my $template_name = kebab_case($template);
    return path( 'templates', "${template_name}.html" );
}

sub render_html {
    my ($self, $plugin_name, $data) = @_;

    my $container = $self->container;

    if (my $plugin = $self->get_plugin($plugin_name)) {
        my $template = $self->get_template($plugin_name);
        my $content = HTML::Zoom->from_html($template->slurp);

        $content = $plugin->process($content, $data);

        $container = $container
            ->select('main')
            ->replace_content( $content );
    }

    return $container->to_html;
}


1;
