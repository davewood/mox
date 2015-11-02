$(document).ready(function(){
    "use strict";

    $( document ).ajaxError(function( event, xhr, settings, thrownError ) {
        $.notify(xhr.responseText, "error");
    });

    function Song(initialId, initialName) {
        var self         = this;
        self.song_id     = initialId,
        self.name        = ko.observable(initialName);
        self.dirty       = ko.observable(false);
        self.name.subscribe(function(newName) { self.dirty(true) });
        self.save = function() {
            $.ajax({
                url: '/rest/songs/' + self.song_id,
                type: 'POST',
                data: { name: self.name },
                success: function(data) { self.dirty(false); },
            });
        };
    }

    ko.components.register('mox-songs', {
        viewModel: function(params) {
            var self = this;

            self.songs       = ko.observableArray([]);
            self.newName     = ko.observable("");

            self.loadSongs = function() {
                $.ajax({
                    url: '/rest/songs',
                    type: 'GET',
                    success: function(data) {
                                var mappedSongs = $.map(
                                    data,
                                    function(item) { return new Song(item.song_id, item.name); }
                                );
                                self.songs(mappedSongs);
                             }
                });
            };
            self.create = function() {
                $.ajax({
                    url: '/rest/songs',
                    type: 'PUT',
                    data: { name: self.newName },
                    success: function(data) {
                                self.songs.push( new Song(data.song_id, data.name) );
                                self.newName("");
                             },
                });
            };
            self.removeSong = function() {
                $.ajax({
                    url: '/rest/songs/' + this.song_id,
                    type: 'DELETE',
                    context: this,
                    success: function(data) { self.songs.remove(this); },
                });
            };

            self.loadSongs();
        },
        template:
               '<table class="table table-condensed">'
             +   '<thead>'
             +     '<tr>'
             +       '<th>Name</th>'
             +       '<th>Save</th>'
             +       '<th>Delete</th>'
             +     '</tr>'
             +   '</thead>'
             +   '<tbody data-bind="foreach: songs">'
             +     '<tr>'
             +         '<td><input data-bind="value: name, valueUpdate: \'afterkeydown\'" /></td>'
             +         '<td><button class="btn btn-default btn-xs" data-bind="enable: dirty, click: save">'
             +           '<span class="glyphicon glyphicon-save"></span>'
             +         '</button></td>'
             +         '<td><button class="btn btn-default btn-xs" data-bind="click: $component.removeSong">'
             +           '<span class="glyphicon glyphicon-remove"></span>'
             +         '</button></td>'
             +     '</tr>'
             +   '</tbody>'
             + '</table>'
             + '<input data-bind="value: newName, valueUpdate: \'afterkeydown\'" placeholder="new song name" /></td>'
             + '<button class="btn btn-default btn-xs" data-bind="click: create, enable: newName().length >= 3">create</button>'
    });

    function PlaylistSong(initialId, initialName) {
        var self         = this;
        self.playlist_song_id = initialId,
        self.name        = ko.observable(initialName);
    }

    ko.components.register('mox-playlist-songs', {
        viewModel: function(params) {
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
        },
        template:
               '<table class="table table-condensed">'
             +   '<thead>'
             +     '<tr>'
             +       '<th>Name</th>'
             +       '<th>Delete</th>'
             +     '</tr>'
             +   '</thead>'
             +   '<tbody data-bind="foreach: playlist_songs">'
             +     '<tr>'
             +         '<td><a data-bind="text: name"></a></td>'
             +         '<td><button class="btn btn-default btn-xs" data-bind="click: $component.removePlaylistSong">remove</button></td>'
             +     '</tr>'
             +   '</tbody>'
             + '</table>'
             + '<input data-bind="value: newSongId, valueUpdate: \'afterkeydown\'" placeholder="new SongId" /></td>'
             + '<button class="btn btn-default btn-xs" data-bind="click: create, enable: newSongId().length >= 1">create</button>'
    });

    function Playlist(initialId, initialName) {
        var self         = this;
        self.playlist_id = initialId,
        self.name        = ko.observable(initialName);
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

    ko.components.register('mox-playlists', {
        viewModel: function(params) {
            var self = this;

            self.playlists = ko.observableArray([]);
            self.newName   = ko.observable("");

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
                                self.newName("");
                             },
                });
            };
            self.removePlaylist = function() {
                $.ajax({
                    url: '/rest/playlists/' + this.playlist_id,
                    type: 'DELETE',
                    context: this,
                    success: function(data) { self.playlists.remove(this); },
                });
            };

            self.loadPlaylists();
        },
        template:
               '<table class="table table-condensed">'
             +   '<thead>'
             +     '<tr>'
             +       '<th>Name</th>'
             +       '<th>Save</th>'
             +       '<th>Delete</th>'
             +     '</tr>'
             +   '</thead>'
             +   '<tbody data-bind="foreach: playlists">'
             +     '<tr>'
             +         '<td><input data-bind="value: name, valueUpdate: \'afterkeydown\'" /></td>'
             +         '<td><button class="btn btn-default btn-xs" data-bind="enable: dirty, click: save">save</button></td>'
             +         '<td><button class="btn btn-default btn-xs" data-bind="click: $component.removePlaylist">remove</button></td>'
             +         '<td><mox-playlist-songs params="playlist_id: playlist_id"></mox-playlist-songs></td>'
             +     '</tr>'
             +   '</tbody>'
             + '</table>'
             + '<input data-bind="value: newName, valueUpdate: \'afterkeydown\'" placeholder="new playlist name" /></td>'
             + '<button class="btn btn-default btn-xs" data-bind="click: create, enable: newName().length >= 3">create</button>'
    });

    function MoxViewModel() {}
    ko.applyBindings(new MoxViewModel());
});
