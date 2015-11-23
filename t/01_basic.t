#!/usr/bin/env perl
use 5.018;
use warnings;
use Selenium::Firefox;
use Test::More;

my $driver = Selenium::Firefox->new;
$driver->get('http://localhost:3000');

is($driver->get_title, 'Mox');

$driver->set_implicit_wait_timeout(250);

{
    my $song_container = $driver->find_element( 'mox-songs', 'tag_name' );
    is( 0, scalar get_songs($song_container), 'no songs available' );

    my $btn = $driver->find_element_by_id('new_song_btn');
    ok( $btn, 'found button to add new song' );
    $btn->click;
    my $modal = $driver->find_element_by_id('newSongModal');
    ok($modal, 'found newSongModal');
    $driver->pause(200);
    ok($modal->is_displayed, 'modal is displayed');
    my $save_btn = $driver->find_child_element($modal, 'button', 'tag_name');
    ok($save_btn, 'found save button');
    ok($save_btn->get_attribute('disabled'), 'save button is disabled');

    $btn->click;
    $driver->pause(1000);
    ok(!$modal->is_displayed, 'modal is no longer displayed');
}

{
    my $playlist_container = $driver->find_element('mox-playlists', 'tag_name');
    is(0, scalar get_playlists($playlist_container), 'no playlists available');

    my $btn = $driver->find_element_by_id('new_playlist_btn');
    ok($btn, 'found button to add new playlist');
    $btn->click;

    my $modal = $driver->find_element_by_id('newPlaylistModal');
    ok($modal, 'found newPlaylistModal');
    $driver->pause(200);
    ok($modal->is_displayed, 'modal is displayed');
    my $save_btn = $driver->find_child_element($modal, 'button', 'tag_name');
    ok($save_btn, 'found save button');
    ok($save_btn->get_attribute('disabled'), 'save button is disabled');
    my $input = $driver->find_child_element($modal, 'input', 'tag_name');
    ok($input, 'found input');
    my $playlist_name = '__test_playlist_001__';
    $input->send_keys($playlist_name);
    ok(!$save_btn->get_attribute('disabled'), 'save button is no longer disabled');
    $driver->pause(250);
    $save_btn->click;
    $driver->pause(1000);
    ok(!$modal->is_displayed, 'modal is no longer displayed');
    my @playlists = get_playlists($playlist_container);
    is(1, scalar @playlists, 'one playlist available');
    my $playlist = $playlists[0];
    is($playlist->get_text(), $playlist_name, 'playlist name was saved correctly');

    unlike($playlist->get_attribute('class'), qr/selected/ , 'playlist is not selected');
    $playlist->click;
    like($playlist->get_attribute('class'), qr/selected/ , 'playlist is selected');

    my $delete_btn = $driver->find_child_element($playlist, 'glyphicon-remove', 'class');
    ok($delete_btn, 'found delete button');
    $delete_btn->click;
    $driver->pause(1000);
    is(0, scalar get_playlists($playlist_container), 'new playlist has been deleted.');
}

$driver->pause(3000);
$driver->quit();

sub get_songs {
    my $container = shift;
    my @songs = $driver->find_child_elements($container, 'mox-song', 'class');
    return @songs;
}
sub get_playlists {
    my $container = shift;
    my @playlists = $driver->find_child_elements($container, 'mox-playlist', 'class');
    return @playlists;
}

done_testing;
