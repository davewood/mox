use strict;
use warnings;
use Dir::Self;

my $root = __DIR__ . '/../';

return {
    fs_path => $root . 'static/files', # path where songs are stored
    connect_info => {
        dsn            => "dbi:SQLite:dbname=$root/mox.db",
        sqlite_unicode => 1,
        on_connect_call => 'use_foreign_keys',
    },
    template_dir => "$root/templates",
    cache_dir    => "$root/templates_cache",
    static_dir   => "$root/static",
};
