package Mox::Web;
use OX;
use OX::RouteBuilder::REST;
use Mox::Schema;

has connect_info => ( is => 'ro', isa => 'HashRef', required => 1 );
has fs_path      => ( is => 'ro', isa => 'Str',     required => 1 );
has model => (
    is           => 'ro',
    isa          => 'Mox::Schema',
    dependencies => [qw/ connect_info fs_path /],
    lifecycle    => 'Singleton',
    block        => sub {
        my $s = shift;
        my $connect_info = $s->param('connect_info');
        my $fs_path      = $s->param('fs_path');
        my $schema       = Mox::Schema->connect($connect_info);
        $schema->source('Song')->column_info('file')->{fs_column_path} = $fs_path;
        return $schema;
    },
);

has cache_dir    => ( is => 'ro', isa => 'Str', required => 1 );
has template_dir => ( is => 'ro', isa => 'Str', required => 1 );
has view         => (
    is           => 'ro',
    isa          => 'Text::Xslate',
    dependencies => {
        cache_dir => 'cache_dir',
        path      => 'template_dir',
    },
);

has root_controller => (
    is           => 'ro',
    isa          => 'Mox::Web::Controller::Root',
    dependencies => [qw/ model view /],
);
has rest_playlist_controller => (
    is           => 'ro',
    isa          => 'Mox::Web::Controller::REST::Playlist',
    dependencies => [qw/ model /],
);
has rest_playlist_song_controller => (
    is           => 'ro',
    isa          => 'Mox::Web::Controller::REST::PlaylistSong',
    dependencies => [qw/ model /],
);
has rest_song_controller => (
    is           => 'ro',
    isa          => 'Mox::Web::Controller::REST::Song',
    dependencies => [qw/ model /],
);

has static_dir => ( is => 'ro', isa => 'Str', required => 1 );

router as {
    wrap 'Plack::Middleware::DebugLogging';
    wrap 'Plack::Middleware::Header' => (
        set => literal(
            [
                'Cache-Control' => 'no-cache, no-store, must-revalidate',
                'Pragma'        => 'no-cache',
                'Expires'       => 0,
            ]
        )
    );
    wrap 'Plack::Middleware::XSendfile';
    wrap 'Plack::Middleware::Static' => (
        root => 'static_dir',
        path => literal(qr{^/(?:js|css|bower_components)/}),
    );
    route '/'                         => 'root_controller.index';
    route '/rest/playlists'           => 'REST.rest_playlist_controller.root';
    route '/rest/playlists/:id'       => 'REST.rest_playlist_controller.item';
    route '/rest/playlist_songs'      => 'REST.rest_playlist_song_controller.root';
    route '/rest/playlist_songs/:id'  => 'REST.rest_playlist_song_controller.item';
    route '/rest/playlist_songs/:id/move' => 'REST.rest_playlist_song_controller.move';
    route '/rest/songs'               => 'REST.rest_song_controller.root';
    route '/rest/songs/:id'           => 'REST.rest_song_controller.item';
    route '/rest/songs/:id/data'      => 'REST.rest_song_controller.data';
};

__PACKAGE__->meta->make_immutable;
1;
