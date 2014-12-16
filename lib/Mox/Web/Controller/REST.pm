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

    my $user_rs = $self->model->resultset('User');
    my $p;
    my $error;
    try {
        $p = $user_rs->validate_create( $req->parameters );
    }
    catch {
        my $e = shift;
        $error = [
            422,
            [ 'Content-type' => 'text/plain' ],
            [ $e ]
        ];
    };
    return $error if $error;

    my $user = $user_rs->create($p);

    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json( { $user->get_columns } ) ]
    ];
}

sub item_POST {
    my ( $self, $req, $id ) = @_;

    my $user_rs = $self->model->resultset('User');
    my $p;
    my $error;
    try {
        $p = $user_rs->validate_update( $req->parameters );
    }
    catch {
        my $e = shift;
        $error = [
            422,
            [ 'Content-type' => 'text/plain' ],
            [ $e ]
        ];
    };
    return $error if $error;

    my $user = $user_rs->find($id);
    $user->update($p);

    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json( { $user->get_columns } ) ]
    ];
}

__PACKAGE__->meta->make_immutable;
1;
