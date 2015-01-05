package Mox::Schema::Result::User;
use parent qw/ DBIx::Class::Core /;

use strict;
use warnings;

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('usr');

__PACKAGE__->add_column(
    usr_id => {
        data_type   => 'integer',
        is_nullable => 0
    },
    username => {
        data_type   => 'varchar',
        is_nullable => 0,
    },
#    password => {
#        data_type        => 'text',
#        is_nullable      => 0,
#        passphrase       => 'rfc2307',
#        passphrase_class => 'BlowfishCrypt',
#        passphrase_args  => {
#            salt_random => 1,
#            cost        => 14,
#        },
#        passphrase_check_method => 'check_passphrase',
#    },
);

__PACKAGE__->set_primary_key(qw/ usr_id /);
__PACKAGE__->add_unique_constraint( [qw/ username /] );
__PACKAGE__->resultset_class('Mox::Schema::ResultSet::User');

1;
