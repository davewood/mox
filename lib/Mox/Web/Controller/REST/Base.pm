package Mox::Web::Controller::REST::Base;
use Moose;
use JSON qw/ to_json /;
use Try::Tiny;
extends 'Mox::Web::Controller::Base';

has 'resultset_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);
has 'resultset' => (
    is       => 'ro',
    isa      => 'DBIx::Class::ResultSet',
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_resultset',
);
sub _build_resultset {
    my ($self) = @_;
    return $self->model->resultset($self->resultset_name);
}

sub root_GET {
    my ( $self, $req ) = @_;

    my $item_rs = $self->resultset;
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

    my ($p, $error, $item);
    try {
        my $item_rs = $self->resultset;
        $p = $item_rs->validate_create( $req->parameters );
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
        [ to_json( { $item->get_columns } ) ]
    ];
}

sub item_POST {
    my ( $self, $req, $id ) = @_;

    my $item_rs = $self->resultset;
    my ($p, $error, $item);
    try {
        $p = $item_rs->validate_update( $req->parameters );
        $item = $item_rs->find($id);
        $item->update($p);
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
        [ to_json( { $item->get_columns } ) ]
    ];
}

sub item_DELETE {
    my ( $self, $req, $id ) = @_;

    my $error;
    try {
        my $item = $self->resultset->find($id);
        $item->delete;
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