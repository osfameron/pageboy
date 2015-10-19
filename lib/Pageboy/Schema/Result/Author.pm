use strict; use warnings;
package Pageboy::Schema::Result::Author;

use DBIx::Class::Candy
    -autotable => v1,
    -components => [qw/ TimeStamp InflateColumn::DateTime /];
 
primary_column id => {
  data_type => 'int',
    is_auto_increment => 1,
};

column author => {
    data_type => 'varchar',
    size => 256,
    is_nullable => 0,
};

column author_photo => {
    data_type => 'varchar',
    size => 256,
    is_nullable => 1,
};

column description => {
    data_type => 'text',
    is_nullable => 0,
};

column twitter => {
    data_type => 'text',
    is_nullable => 0,
};

column created_datetime => {
    data_type => 'datetime',
    set_on_create => 1,
    is_nullable => 1,
};

1;
