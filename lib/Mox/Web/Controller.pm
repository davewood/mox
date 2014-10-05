package Mox::Web::Controller;
use Moose;

has model => (
    is       => 'ro',
    isa      => 'Mox::Schema',
    #handles  => [qw/ load_user_from_session /],
    required => 1,
);

__PACKAGE__->meta->make_immutable;
1;
