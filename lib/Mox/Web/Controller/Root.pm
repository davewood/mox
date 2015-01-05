package Mox::Web::Controller::Root;
use Moose;
extends 'Mox::Web::Controller';

has view => (
    is       => 'ro',
    isa      => 'Text::Xslate',
    handles  => [qw/ render /],
    required => 1,
);

sub index {
    my ( $self, $req ) = @_;
    return $req->new_response(
        content => $self->render('index.tx'),
        status => '200',
    );
}

__PACKAGE__->meta->make_immutable;
1;
