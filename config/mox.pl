use strict;
use warnings;
use Dir::Self;

my $root = __DIR__ . '/../';

return {
    connect_info => {
        dsn            => "dbi:SQLite:dbname=$root/mox.db",
        sqlite_unicode => 1,
    },
};
