define(['jquery', 'knockout', 'knockout', 'knockout-sortable', 'knockout-file-bindings'], function ($, ko) {

    function Song(_id, _name, _file) {
        var self     = this;
        self.song_id = _id,
        self.name    = _name;
        self.file    = _file;
    }

    function viewModel(params) {
        var self = this;

        self.songs   = ko.observableArray([]);
        self.newName = ko.observable("");
        self.newFile = ko.observable({ base64String: ko.observable() });
        self.searchValue = ko.observable();
        self.filteredSongs = ko.pureComputed(function() {
            if(self.searchValue()) {
                return ko.utils.arrayFilter(
                        self.songs(),
                        function(item) {
                            if (item.name.toLowerCase().search(self.searchValue().toLowerCase()) !== -1) {
                                return true;
                            }
                        }
                    );
            }
            else {
                return self.songs();
            }
        });

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
                                function(item) { return new Song(item.song_id, item.name, item.file); }
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
                            self.songs.push( new Song(data.song_id, data.name, data.file) );
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
