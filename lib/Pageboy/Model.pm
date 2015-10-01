use 5.020;
package Pageboy::Model;

use Moose;
use MooseX::AttributeShortcuts;

no warnings 'experimental::signatures';
use feature 'signatures';

use Pageboy::Schema;
use Pageboy::Model::Fixtures;

has dsn => (
    is => 'lazy',
    # isa => 'Str',
    default => 'dbi:Pg:dbname=pageboy',
);

has connect_info => (
    is => 'lazy',
    # isa => 'ArrayRef',
    default => sub { [ shift->dsn ] },
);

has db => (
    is => 'lazy',
    default => sub {
        Pageboy::Schema->connect(@{ shift->connect_info });
    }
);

has fixtures => (
    is => 'lazy',
    default => sub {
        Pageboy::Model::Fixtures->new();
    }
);

sub events ($self) {
    $self->db->resultset('Event');
}

sub list_events ($self) {
    return [
        map {
            +{
                do {
                    my (undef, $author) = $self->make_name_and_slug($_, 'author');
                    $author->{photo} = $_->author_photo;
                    (author => $author);
                },
                type => $_->type,
                $self->make_name_and_slug($_, 'location'),
                $self->make_name_and_slug($_, 'category'),
                $self->make_name_and_slug($_, 'source'),
                description => $_->description,
                date => '7 Apr 2015',
            }
        } $self->events->all
    ]
}

sub make_name_and_slug ($self, $record, $field) {
    my $value = $record->$field or return;
    return ($field => {
        name => $value,
        slug => $self->slugify($value),
    });
}


sub slugify ($self, $text) {
    $text =~s/\s+/-/g;
    return lc $text;
}

sub setup_fixtures ($self) {
    $self->fixtures->setup_fixtures($self);
}

1;
