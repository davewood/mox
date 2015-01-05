package Mox::Web::Controller::REST::Playlist;
use Moose;
use JSON qw/ to_json /;
use Try::Tiny;
extends 'Mox::Web::Controller';

sub root_GET {
    my ( $self, $req ) = @_;

    my $playlists_rs = $self->model->resultset('Playlist');
    $playlists_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @playlists = $playlists_rs->all;
    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json(\@playlists) ]
    ];
}

sub root_PUT {
    my ( $self, $req ) = @_;

    my ($p, $error, $playlist);
    try {
        my $playlist_rs = $self->model->resultset('Playlist');
        $p = $playlist_rs->validate_create( $req->parameters );
        $playlist = $playlist_rs->create($p);
    }
    catch {
        my $e = shift;
        $error = [
            422,
            [ 'Content-type' => 'text/plain' ],
            [ "$e" ]
        ];
    };
    return $error if $error;

    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json( { $playlist->get_columns } ) ]
    ];
}

sub item_POST {
    my ( $self, $req, $id ) = @_;

    my $playlist_rs = $self->model->resultset('Playlist');
    my ($p, $error, $playlist);
    try {
        $p = $playlist_rs->validate_update( $req->parameters );
        $playlist = $playlist_rs->find($id);
        $playlist->update($p);
    }
    catch {
        my $e = shift;
        $error = [
            422,
            [ 'Content-type' => 'text/plain' ],
            [ "$e" ]
        ];
    };
    return $error if $error;

    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json( { $playlist->get_columns } ) ]
    ];
}

sub item_DELETE {
    my ( $self, $req, $id ) = @_;

    my $error;
    try {
        my $playlist = $self->model->resultset('Playlist')->find($id);
        $playlist->delete;
    }
    catch {
        my $e = shift;
        $error = [
            400,
            [ 'Content-type' => 'text/plain' ],
            [ "$e" ]
        ];
    };
    return $error if $error;

    return [
        204,
        [ 'Content-type' => 'application/json' ],
        []
    ];
}

__PACKAGE__->meta->make_immutable;
1;
