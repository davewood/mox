define(['jquery', 'knockout', 'knockout-sortable', 'knockout-file-bindings'], function ($, ko) {

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

    function viewModel(params) {
        var self = this;

        self.songs   = ko.observableArray([]);
        self.newName = ko.observable("");
        self.newFile = ko.observable({ base64String: ko.observable() });

        self.newSongReady = ko.pureComputed(function() {
            return self.newName().length > 3 && self.newFile().file();
        });
        self.clearNewSong = function() {
            self.newName("");
            self.newFile().clear();
        };
        self.load = function() {
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
                data: { name: self.newName, file: self.newFile().base64String() },
                success: function(data) {
                            self.songs.push( new Song(data.song_id, data.name) );
                            self.clearNewSong();
                         },
            });
        };
        self.remove = function() {
            $.ajax({
                url: '/rest/songs/' + this.song_id,
                type: 'DELETE',
                context: this,
                success: function(data) { self.songs.remove(this); },
            });
        };

        self.load();
    };

    return viewModel;
});
