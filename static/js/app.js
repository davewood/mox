requirejs.config({
    baseUrl: 'js/lib',
    paths: { 'app': '../app' },
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
