use strict;
use warnings;
use Dir::Self;

my $root = __DIR__ . '/../';

return {
    connect_info => {
        dsn            => "dbi:SQLite:dbname=$root/mox.db",
        sqlite_unicode => 1,
    },
    template_root => "$root/templates",
    cache_dir     => "$root/templates_cache",
};
