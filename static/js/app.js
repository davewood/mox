requirejs.config({
    paths: {
        app: 'app',
        Sortable: '../bower_components/Sortable/Sortable',
        'knockout-sortable': '../bower_components/Sortable/knockout-sortable',
        bootstrap: '../bower_components/bootstrap/dist/js/bootstrap',
        jquery: '../bower_components/jquery/dist/jquery',
        text: '../bower_components/text/text',
        knockout: '../bower_components/knockout/dist/knockout',
        notifyjs: '../bower_components/notifyjs/dist/notify',
        'knockout-file-bindings': '../bower_components/knockout-file-bindings/knockout-file-bindings',
        howler: '../bower_components/howler.js/howler'
    },
    packages: [

    ],
    shim: {
        notifyjs: {
            deps: [
                'jquery'
            ]
        }
    }
});

require(['jquery', 'knockout', 'notifyjs'], function( $, ko ) {
    "use strict";

    $(document).ready(function(){

        // if true causes bug when
        // 1) adding song to playlist
        // 2) deleting playlist_song
        // 3) adding same song again
        //ko.options.deferUpdates = true;

        $( document ).ajaxError(function( event, xhr, settings, thrownError ) {
            $.notify(xhr.responseText, "error");
        });

        ko.components.register('mox-songs', {
            viewModel: { require: 'app/song' },
            template:  { require: 'text!app/song.html' }
        });
        ko.components.register('mox-playlist-songs', {
            viewModel: { require: 'app/playlist_song' },
            template:  { require: 'text!app/playlist_song.html' }
        });
        ko.components.register('mox-playlists', {
            viewModel: { require: 'app/playlist' },
            template:  { require: 'text!app/playlist.html' }
        });

        function AppViewModel() {
            var self = this;
            self.active_playlist_id = ko.observable();
        }
        ko.applyBindings(new AppViewModel());
    });

});
