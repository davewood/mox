define(['jquery', 'knockout', 'knockout-sortable'], function ($, ko) {

    function PlaylistSong(_id, _name, _pos) {
        var self         = this;
        self.playlist_song_id = _id;
        self.position    = _pos;
        self.name        = ko.observable(_name);
    }

    function viewModel(params) {
        var self = this;

        self.playlist_id    = params.playlist_id;
        self.playlist_songs = ko.observableArray([]);
        self.newSongId      = ko.observable("");

        self.loadPlaylistSongs = function() {
            $.ajax({
                url: '/rest/playlist_songs/',
                type: 'GET',
                data: { playlist_id: self.playlist_id },
                success: function(data) {
                            var mappedPlaylistSongs = $.map(
                                data,
                                function(item) { return new PlaylistSong(item.playlist_song_id, item.name, item.position); }
                            );
                            self.playlist_songs(mappedPlaylistSongs);
                         }
            });
        };
        self.create = function() {
            $.ajax({
                url: '/rest/playlist_songs',
                type: 'PUT',
                data: { playlist_id: self.playlist_id, song_id: self.newSongId },
                success: function(data) {
                            self.playlist_songs.push( new PlaylistSong(data.playlist_song_id, data.name, data.position) );
                         },
            });
        };
        self.removePlaylistSong = function() {
            $.ajax({
                url: '/rest/playlist_songs/' + this.playlist_song_id,
                type: 'DELETE',
                context: this,
                success: function(data) { self.playlist_songs.remove(this); },
            });
        };

        self.loadPlaylistSongs();
    }

    return viewModel;
});
