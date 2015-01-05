package Mox::Web::Controller::REST;
use Moose;
use JSON qw/ to_json /;
use Try::Tiny;
extends 'Mox::Web::Controller';

sub root_GET {
    my ( $self, $req ) = @_;

    my $users_rs = $self->model->resultset('User');
    $users_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @users = $users_rs->all;
    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json(\@users) ]
    ];
}

sub root_PUT {
    my ( $self, $req ) = @_;

    my ($p, $error, $user);
    try {
        my $user_rs = $self->model->resultset('User');
        $p = $user_rs->validate_create( $req->parameters );
        $user = $user_rs->create($p);
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
        [ to_json( { $user->get_columns } ) ]
    ];
}

sub item_POST {
    my ( $self, $req, $id ) = @_;

    my $user_rs = $self->model->resultset('User');
    my ($p, $error, $user);
    try {
        $p = $user_rs->validate_update( $req->parameters );
        $user = $user_rs->find($id);
        $user->update($p);
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
        [ to_json( { $user->get_columns } ) ]
    ];
}

sub item_DELETE {
    my ( $self, $req, $id ) = @_;

    my $error;
    try {
        my $user = $self->model->resultset('User')->find($id);
        $user->delete;
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
