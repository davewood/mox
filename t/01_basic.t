#!/usr/bin/env perl
use 5.018;
use warnings;
use Selenium::Firefox;
use Test::More;
use FindBin qw/$Bin/;

my $driver = Selenium::Firefox->new;
$driver->get('http://localhost:3000');

is($driver->get_title, 'Mox', 'check page title');

$driver->set_implicit_wait_timeout(250);

my $delete_song_cb;
my $delete_playlist_cb;

{
    my $song_container = $driver->find_element( 'mox-songs', 'tag_name' );
    is( 0, scalar get_songs($song_container), 'no songs available' );

    my $btn = $driver->find_element_by_id('new_song_btn');
    ok( $btn, 'found button to add new song' );
    $btn->click;
    my $modal = $driver->find_element_by_id('newSongForm');
    ok($modal, 'found newSongForm');
    $driver->pause(200);
    ok($modal->is_displayed, 'modal is displayed');
    my $save_btn = $driver->find_child_element($modal, 'button', 'tag_name');
    ok($save_btn, 'found save button');
    ok($save_btn->get_attribute('disabled'), 'save button is disabled');

    my $name_input = $driver->find_child_element($modal, 'newSongName', 'id');
    ok($name_input, 'found name input field');

    my $file_input = $driver->find_child_element($modal, 'newSongFile', 'id');
    ok($file_input, 'found file input field');
    my $song_name = '__test_song_001__';
    my $file_name = "$song_name.oga";
    my $upload = "$Bin/var/$file_name";
    ok(-e $upload, 'upload file exists');
    $file_input->send_keys($upload);
    $driver->pause(3000);
    is($name_input->get_value, $song_name, 'name was auto-filled-in with filename. (file-extension stripped)');
    ok(!$save_btn->get_attribute('disabled'), 'save button is no longer disabled');
    $driver->pause(250);

    $save_btn->click;
    $driver->pause(2000);
    ok(!$modal->is_displayed, 'modal is no longer displayed');

    my @songs = get_songs($song_container);
    is(1, scalar @songs, 'one song available');
    my $song = $songs[0];
    is($song->get_text(), $song_name, 'song name was saved correctly');

    $delete_song_cb = sub {
        my $delete_btn = $driver->find_child_element($song, 'glyphicon-remove', 'class');
        ok($delete_btn, 'found delete button');
        $delete_btn->click;
        $driver->pause(1000);
        is(0, scalar get_songs($song_container), 'new song has been deleted.');
    }
}

{
    my $playlist_container = $driver->find_element('mox-playlists', 'tag_name');
    is(0, scalar get_playlists($playlist_container), 'no playlists available');

    my $btn = $driver->find_element_by_id('new_playlist_btn');
    ok($btn, 'found button to add new playlist');
    $btn->click;

    my $modal = $driver->find_element_by_id('newPlaylistForm');
    ok($modal, 'found newPlaylistForm');
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

    $delete_playlist_cb = sub {
        my $delete_btn = $driver->find_child_element($playlist, 'glyphicon-remove', 'class');
        ok($delete_btn, 'found delete button');
        $delete_btn->click;
        $driver->pause(1000);
        is(0, scalar get_playlists($playlist_container), 'new playlist has been deleted.');
    }
}

$delete_song_cb->();
$delete_playlist_cb->();
$driver->quit();

sub get_songs {
    my $container = shift;
    my @songs = $driver->find_child_elements($container, 'mox-item', 'class');
    return @songs;
}
sub get_playlists {
    my $container = shift;
    my @playlists = $driver->find_child_elements($container, 'mox-item', 'class');
    return @playlists;
}

done_testing;
