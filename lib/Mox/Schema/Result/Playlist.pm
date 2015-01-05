package Mox::Schema::Result::Playlist;
use parent qw/ DBIx::Class::Core /;

use strict;
use warnings;

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('playlist');

__PACKAGE__->add_column(
    playlist_id => {
        data_type   => 'integer',
        is_nullable => 0
    },
    name => {
        data_type   => 'varchar',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/ playlist_id /);
__PACKAGE__->add_unique_constraint( [qw/ name /] );
__PACKAGE__->resultset_class('Mox::Schema::ResultSet::Playlist');

1;
