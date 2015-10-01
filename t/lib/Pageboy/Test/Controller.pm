package Pageboy::Test::Controller;
use OX;
extends 'Pageboy::Test';

=head1 NAME

Pageboy::Test::Controller - testing subclass that suppresses view output

=head1 SYNOPSIS

Stealing one of the good ideas in Rails testing -- suppress the output
so that instead of being tempted to scrape your own HTML output, you
check the data structure instead.  Substitutes the view class with a
Pageboy::Test::MockView which simply stores the template and arguments
to be checked by test.

=cut

has '+view' => (
    isa => 'Pageboy::Test::MockView',
    lifecycle => 'Singleton', # prevent it getting cleared after request
);

1;
