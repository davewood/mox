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

__PACKAGE__->meta->make_immutable;
1;
