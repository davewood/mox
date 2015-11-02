package Mox::Web::Controller::REST::PlaylistSong;
use Moose;
use JSON qw/ to_json /;
use Try::Tiny;
extends 'Mox::Web::Controller::REST::Base';
has '+resultset_name' => (default => 'PlaylistSong');

sub root_GET {
    my ( $self, $req ) = @_;

    my $playlist_id = $req->parameters->{playlist_id};
    my $item_rs = $self->resultset->search(
        { playlist_id => $playlist_id },
        {
            join      => 'song',
            '+select' => ['song.name'],
            '+as'     => ['name'],
        }
    );
    $item_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @items = $item_rs->all;
    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json(\@items) ]
    ];
}

sub root_PUT {
    my ( $self, $req ) = @_;

    my ($error, $item);
    try {
        my $item_rs = $self->resultset;
        my $p = $item_rs->validate_create( $req->parameters );
        $item = $item_rs->create($p);
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
        [ to_json( { $item->get_columns, name => $item->song->name } ) ]
    ];
}

__PACKAGE__->meta->make_immutable;
1;
