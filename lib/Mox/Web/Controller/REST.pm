package Mox::Web::Controller::REST;
use Moose;
use JSON qw/ to_json /;
extends 'Mox::Web::Controller';

sub index_GET {
    my ( $self, $req ) = @_;

    my $username = $self->model->resultset('User')->first->username;
    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json({ username => $username }) ]
    ];
}

__PACKAGE__->meta->make_immutable;
1;
