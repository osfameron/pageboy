package Pageboy::Management::Cmd::Design;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;

extends 'Pageboy::Management::Cmd::RunServer';

has psgi => (
    is => 'ro',
    default => 'pageboy-design.psgi',
);

1;
