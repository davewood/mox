package Mox::Web;
use OX;
use OX::RouteBuilder::REST;
use Mox::Schema;

has connect_info => ( is => 'ro', isa => 'HashRef', required => 1 );
has model => (
    is           => 'ro',
    isa          => 'Mox::Schema',
    dependencies => [qw/ connect_info /],
    lifecycle    => 'Singleton',
    block        => sub {
        my $connect_info = shift->param('connect_info');
        Mox::Schema->connect($connect_info);
    },
);

has cache_dir    => ( is => 'ro', isa => 'Str', required => 1 );
has template_dir => ( is => 'ro', isa => 'Str', required => 1 );
has view         => (
    is           => 'ro',
    isa          => 'Text::Xslate',
    dependencies => {
        cache_dir => 'cache_dir',
        path      => 'template_dir',
    },
);

has root_controller => (
    is           => 'ro',
    isa          => 'Mox::Web::Controller::Root',
    dependencies => [qw/ model view /],
);
has rest_controller => (
    is           => 'ro',
    isa          => 'Mox::Web::Controller::REST',
    dependencies => [qw/ model /],
);

has static_dir => ( is => 'ro', isa => 'Str', required => 1 );
router as {
    route '/'                        => 'root_controller.index';
    route '/rest/users'              => 'REST.rest_controller.root';
    route '/rest/users/:id'          => 'REST.rest_controller.item';
    wrap 'Plack::Middleware::Static' => (
        root => 'static_dir',
        path => literal(qr{^/(?:images|js|css)/}),
    );
};

__PACKAGE__->meta->make_immutable;
1;
