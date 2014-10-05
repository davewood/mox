package Mox::Web::Controller::Root;
use Moose;
extends 'Mox::Web::Controller';

sub index {
    my ( $self, $req ) = @_;
    my $model = $self->model;
    return $self->model->resultset('User')->first->username;
}

__PACKAGE__->meta->make_immutable;
1;
