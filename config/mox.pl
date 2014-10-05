use strict;
use warnings;

return {
    connect_info => {
        dsn            => 'dbi:SQLite:dbname=mox.db',
        sqlite_unicode => 1,
    },
};
