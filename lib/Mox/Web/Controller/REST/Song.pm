package Mox::Web::Controller::REST::Song;
use Moose;
extends 'Mox::Web::Controller::REST::Base';
has '+resultset_name' => (default => 'Song');

__PACKAGE__->meta->make_immutable;
1;
