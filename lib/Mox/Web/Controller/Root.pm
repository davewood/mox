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

    my $username = $self->model->resultset('User')->first->username;
    return $req->new_response(
        content => $self->render(
            'index.tx',
            {
                username => $username,
            }
        ),
        status => '200',
    );
}

__PACKAGE__->meta->make_immutable;
1;
