package Mox::Web::Controller::REST::Playlist;
use Moose;
use JSON qw/ to_json /;
use Try::Tiny;
extends 'Mox::Web::Controller::REST::Base';
has '+resultset_name' => (default => 'Playlist');

__PACKAGE__->meta->make_immutable;
1;
