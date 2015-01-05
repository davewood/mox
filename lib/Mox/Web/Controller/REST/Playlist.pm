package Mox::Web::Controller::REST::Playlist;
use Moose;
extends 'Mox::Web::Controller::REST::Base';
has '+resultset_name' => (default => 'Playlist');

__PACKAGE__->meta->make_immutable;
1;
