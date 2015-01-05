$(document).ready(function(){

    function Playlist(initialId, initialName) {
        var self         = this;
        self.playlist_id = initialId,
        self.name        = ko.observable(initialName);
        self.dirty       = ko.observable(false);
        self.error       = ko.observable("");
        self.name.subscribe(function(newName) { self.dirty(true) });
        self.save = function() {
            $.ajax({
                url: '/rest/playlists/' + self.playlist_id,
                type: 'POST',
                data: { name: self.name },
                success: function(data) { self.dirty(false); self.error('') },
                error: function(xhr) { self.error(xhr.responseText) },
            });
        };
    }

    function PlaylistsViewModel() {
        var self = this;

        self.playlists = ko.observableArray([]);
        self.newName   = ko.observable("");
        self.newError  = ko.observable("");

        // Operations
        self.loadPlaylists = function() {
            $.ajax({
                url: '/rest/playlists',
                type: 'GET',
                success: function(data) {
                            var mappedPlaylists = $.map(
                                data,
                                function(item) { return new Playlist(item.playlist_id, item.name); }
                            );
                            self.playlists(mappedPlaylists);
                         }
            });
        };
        self.create = function() {
            $.ajax({
                url: '/rest/playlists',
                type: 'PUT',
                data: { name: self.newName },
                success: function(data) {
                            self.playlists.push( new Playlist(data.playlist_id, data.name) );
                            self.newError("")
                         },
                error: function(xhr) { self.newError(xhr.responseText) }
            });
        };
        self.removePlaylist = function() {
            $.ajax({
                url: '/rest/playlists/' + this.playlist_id,
                type: 'DELETE',
                context: this,
                success: function(data) { self.playlists.remove(this); },
                error: function(xhr) { this.error(xhr.responseText) }
            });
        };

        self.loadPlaylists();
    }

    ko.applyBindings(new PlaylistsViewModel());
});
