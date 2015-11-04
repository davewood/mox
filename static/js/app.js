requirejs.config({
    paths: {
        app: 'app',
        Sortable: '../bower_components/Sortable/Sortable',
        'knockout-sortable': '../bower_components/knockout-sortable/build/knockout-sortable.min',
        bootstrap: '../bower_components/bootstrap/dist/js/bootstrap',
        jquery: '../bower_components/jquery/dist/jquery',
        notify: '../bower_components/notify.js/notify',
        text: '../bower_components/text/text',
        knockout: '../bower_components/knockout/dist/knockout',
    },
    packages: [

    ],
    shim: {

    }
});

require(['jquery', 'knockout', 'notify'], function( $, ko ) {
    "use strict";

    $(document).ready(function(){

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

        ko.applyBindings();
    });

});
