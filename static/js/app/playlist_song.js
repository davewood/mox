define(['jquery', 'knockout', 'knockout-sortable'], function ($, ko) {

    function PlaylistSong(_id, _name) {
        var self         = this;
        self.playlist_song_id = _id;
        self.name        = ko.observable(_name);
    }

    function viewModel(params) {
        var self = this;

        self.playlist_id    = params.playlist_id;
        self.playlist_songs = ko.observableArray([]);

        self.load = function() {
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
        self.create = function(newSong, new_index) {
            $.ajax({
                url: '/rest/playlist_songs',
                type: 'PUT',
                data: { playlist_id: self.playlist_id, song_id: newSong.song_id, position: new_index+1 },
                success: function(data) {
                            newSong.playlist_song_id = data.playlist_song_id;
                         },
                error: function() {
                           self.playlist_songs.remove(newSong);
                       }
            });
        };
        self.remove = function() {
            $.ajax({
                url: '/rest/playlist_songs/' + this.playlist_song_id,
                type: 'DELETE',
                context: this,
                success: function(data) { self.playlist_songs.remove(this); },
            });
        };
        self.move = function(old_index, new_index) {
            var moved_item = self.playlist_songs()[old_index];
            $.ajax({
                url: '/rest/playlist_songs/' + moved_item.playlist_song_id + '/move',
                type: 'POST',
                data: { position: new_index+1 },
            });
        };

        self.load();
    }

    return viewModel;
});
