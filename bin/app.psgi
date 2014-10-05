use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Mox::Config;
use Mox::Web;

my $config = Mox::Config->new;

Mox::Web->new(
    %{ $config->as_hash },
)->to_app;
