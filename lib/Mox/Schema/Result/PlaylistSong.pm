package Mox::Schema::Result::PlaylistSong;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Ordered Core /);
__PACKAGE__->table('playlist_song');
__PACKAGE__->add_columns(
    'playlist_song_id',
    {
        data_type => 'integer',
        is_auto_increment => 1,
        is_numeric => 1,
    },
    'playlist_id',
    {
        data_type => 'integer',
        is_numeric => 1,
        is_foreign_key => 1,
    },
    'song_id',
    {
        data_type => 'integer',
        is_numeric => 1,
        is_foreign_key => 1,
    },
    'position',
    {
        data_type  => 'integer',
        is_numeric => 1,
    },
);

__PACKAGE__->set_primary_key('playlist_song_id');
__PACKAGE__->add_unique_constraint( [qw/playlist_id song_id/] );
__PACKAGE__->resultset_class('Mox::Schema::ResultSet::PlaylistSong');
__PACKAGE__->position_column('position');
__PACKAGE__->grouping_column('playlist_id');

__PACKAGE__->belongs_to(
    'playlist',
    'Mox::Schema::Result::Playlist',
    'playlist_id'
);

__PACKAGE__->belongs_to(
    'song',
    'Mox::Schema::Result::Song',
    'song_id'
);

1;
