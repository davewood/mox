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

has cache_dir     => ( is => 'ro', isa => 'Str', required => 1 );
has template_root => ( is => 'ro', isa => 'Str', required => 1 );
has view          => (
    is           => 'ro',
    isa          => 'Text::Xslate',
    dependencies => {
        cache_dir => 'cache_dir',
        path      => 'template_root',
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

router as {
    #    wrap 'Plack::Middleware::Session' => ( store => literal('File') );
    route '/'      => 'root_controller.index';
    route '/rest'  => 'REST.rest_controller.index';
    #    route '/logout' => 'auth_controller.logout';
    #    route '/admin'  => 'admin_controller.index';
    #    route '/denied' => 'root_controller.deny';
};

__PACKAGE__->meta->make_immutable;
1;
