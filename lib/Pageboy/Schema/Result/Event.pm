use strict; use warnings;
package Pageboy::Schema::Result::Event;

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
}; # we'll calculate slug for now

column author_photo => {
    data_type => 'varchar',
    size => 256,
    is_nullable => 1,
};

column description => {
    data_type => 'text',
    is_nullable => 0,
};

column type => {
    # should be enum/join:  event / media
    data_type => 'varchar',
    size => 32,
    is_nullable => 0,
};

column category => { 
    # should be enum/join:  Article, Podcast, etc.
    data_type => 'varchar', 
    size => 32,
    is_nullable => 1,
};

column source => { 
    # should be join:  Waterstones, Guardian etc.
    data_type => 'varchar', 
    size => 32,
    is_nullable => 0,
};

column location => { 
    # should be join:  Liverpool etc.
    data_type => 'varchar', 
    size => 32,
    is_nullable => 1,
};

column scheduled_datetime => {
    data_type => 'datetime',
    is_nullable => 1,
};

column created_datetime => {
    data_type => 'datetime',
    set_on_create => 1,
    is_nullable => 1,
};

1;
