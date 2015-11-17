package Mox::Schema::Result::Song;
use parent qw/ DBIx::Class::Core /;

use strict;
use warnings;

__PACKAGE__->load_components(qw/ InflateColumn::FS Core /);
__PACKAGE__->table('song');

__PACKAGE__->add_column(
    song_id => {
        data_type   => 'integer',
        is_nullable => 0
    },
    name => {
        data_type   => 'varchar',
        is_nullable => 0,
    },
    file => {
        data_type    => 'varchar',
        is_fs_column => 1,
        #fs_column_path => '/tmp', # we set this value in config
    },
);

__PACKAGE__->set_primary_key(qw/ song_id /);
__PACKAGE__->add_unique_constraint( [qw/ name /] );
__PACKAGE__->resultset_class('Mox::Schema::ResultSet::Song');

__PACKAGE__->has_many(
    'playlist_songs',
    'Mox::Schema::Result::PlaylistSong',
    'song_id',
);

__PACKAGE__->many_to_many(
    'playlists',
    'playlist_songs',
    'playlist',
);

1;
