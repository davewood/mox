#!/usr/bin/env perl
use 5.018;
use warnings;
use Selenium::Firefox;
use Test::More;

my $driver = Selenium::Firefox->new;
$driver->get('http://localhost:3000');

is($driver->get_title, 'Mox');

$driver->set_implicit_wait_timeout(250);

my $btn = $driver->find_element_by_id('new_playlist_btn');
ok($btn, 'found button to add new playlist');
$btn->click;

my $modal = $driver->find_element_by_id('newPlaylistModal');
ok($modal, 'found newPlaylistModal');
$driver->pause(200);
ok($modal->is_displayed, 'modal is displayed');

$driver->pause(3000);
$driver->quit();

done_testing;
