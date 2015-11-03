define(['jquery', 'knockout'], function ($, ko) {

    function PlaylistSong(initialId, initialName) {
        var self         = this;
        self.playlist_song_id = initialId,
        self.name        = ko.observable(initialName);
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
                                function(item) { return new PlaylistSong(item.playlist_song_id, item.name); }
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
                            self.playlist_songs.push( new PlaylistSong(data.playlist_song_id, data.name) );
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
