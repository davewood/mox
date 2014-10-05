#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Mox::Config;
use Mox::Schema;
use 5.020;

my $config = Mox::Config->new->as_hash;

my $schema = Mox::Schema->connect( $config->{connect_info} )
  or die "Unable to connect\n";

say "Enter 'Y' to deploy the schema. This will delete all existing data.";
my $ui = <>;
chomp $ui;

if ( $ui eq 'Y' ) {
    $schema->deploy( { add_drop_table => 1 } );
}
else {
    say "schema deployment aborted.";
    exit;
}
