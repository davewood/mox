package Mox::Config;
use Moose;
use Config::ZOMG;
use feature qw/say/;

has config => (
    is      => 'ro',
    isa     => 'Config::ZOMG',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        my $config = Config::ZOMG->new(
            name => 'mox',
            path => 'config/',
        );
        $config->load; # for ->found to work
        say "Loading config file '$_'" for $config->found;
        return $config;
    },
);

sub as_hash {
    my ($self) = @_;
    return $self->config->load;
}

__PACKAGE__->meta->make_immutable;
1;
