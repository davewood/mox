define(['jquery', 'knockout'], function ($, ko) {

    function Playlist(_id, _name) {
        var self         = this;
        self.playlist_id = _id,
        self.name        = ko.observable(_name);
        self.dirty       = ko.observable(false);
        self.name.subscribe(function(newName) { self.dirty(true) });
        self.save = function() {
            $.ajax({
                url: '/rest/playlists/' + self.playlist_id,
                type: 'POST',
                data: { name: self.name },
                success: function(data) { self.dirty(false); },
            });
        };
    }

    function viewModel(params) {
        var self = this;

        self.playlists = ko.observableArray([]);
        self.newName   = ko.observable("");

        // Operations
        self.load = function() {
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
                            self.newName("");
                         },
            });
        };
        self.remove = function() {
            $.ajax({
                url: '/rest/playlists/' + this.playlist_id,
                type: 'DELETE',
                context: this,
                success: function(data) { self.playlists.remove(this); },
            });
        };

        self.load();
    }

    return viewModel;
});
