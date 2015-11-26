package Mox::Web::Controller::REST::Base;
use Moose;
use JSON qw/ to_json /;
use Try::Tiny;
use HTTP::Throwable::Factory qw/http_throw/;
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
sub _get_item {
    my ( $self, $id ) = @_;
    my $item = $self->resultset->find($id);
    die "Item not found! (" . $self->resultset_name . ": $id)"
        unless $item;
    return $item;
}

sub root_GET {
    my ( $self, $req ) = @_;

    my $item_rs = $self->resultset;
    $item_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @items = $item_rs->all;
    return [
        200,
        [ 'Content-Type' => 'application/json' ],
        [ to_json(\@items) ]
    ];
}

sub root_PUT {
    my ( $self, $req ) = @_;

    try {
        my $item_rs = $self->resultset;
        my $p = $item_rs->validate_create( $req->parameters );
        my $item = $item_rs->create($p);
        [
            200,
            [ 'Content-Type' => 'application/json' ],
            [ to_json( { $item->get_columns } ) ]
        ];
    }
    catch {
        my $e = shift;
        http_throw( BadRequest => { message => "$e" } );
    };
}

sub item_POST {
    my ( $self, $req, $id ) = @_;

    my ($error, $item);
    try {
        my $p = $self->resultset->validate_update( $req->parameters );
        $item = $self->_get_item($id);
        $item->update($p);
    }
    catch {
        my $e = shift;
        $error = [
            422,
            [ 'Content-Type' => 'text/plain' ],
            [ "$e" ]
        ];
    };
    return $error if $error;

    return [
        200,
        [ 'Content-Type' => 'application/json' ],
        [ to_json( { $item->get_columns } ) ]
    ];
}

sub item_DELETE {
    my ( $self, $req, $id ) = @_;

    my $error;
    try {
        my $item = $self->_get_item($id);
        $item->delete;
    }
    catch {
        my $e = shift;
        $error = [
            400,
            [ 'Content-Type' => 'text/plain' ],
            [ "$e" ]
        ];
    };
    return $error if $error;

    return [
        204,
        [ 'Content-Type' => 'application/json' ],
        []
    ];
}

__PACKAGE__->meta->make_immutable;
1;
