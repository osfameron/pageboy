package Pageboy::RouteBuilder;
use Moose;
use namespace::autoclean;
extends 'OX::RouteBuilder::HTTPMethod';

=head1 NAME

Pageboy::RouteBuilder - call HTTPMethod + render

=cut

use Try::Tiny;

sub compile_routes {
    my $self = shift;
    my ($app) = @_;

    my $spec = $self->route_spec;
    my $params = $self->params;

    my ($defaults, $validations) = $self->extract_defaults_and_validations($params);
    $defaults = { %$spec, %$defaults };

    my $target = sub {
        my ($req) = @_;

        my $match = $req->mapping;
        my $a = $match->{action};

        my $err;
        my $s = try { $app->fetch($a) } catch { ($err) = split "\n"; undef };
        return [
            500,
            [],
            ["Cannot resolve $a in " . blessed($app) . ": $err"]
        ] unless $s;

        my $component = $s->get;
        my $method = lc($req->method);

        if ($component->can($method)) {
            return $component->render(
                $req, $component->$method(@_)
            );
        }
        elsif ($component->can('any')) {
            return $component->render(
                $req, $component->any(@_)
            );
        }
        else {
            return [
                500,
                [],
                ["Component $component has no method $method"]
            ];
        }
    };

    return {
        path        => $self->path,
        defaults    => $defaults,
        target      => $target,
        validations => $validations,
    };
}

__PACKAGE__->meta->make_immutable;

1;
