#!/usr/bin/env perl
use 5.018;
use warnings;
use Selenium::Firefox;
use Test::More;
use FindBin qw/$Bin/;

my $driver = Selenium::Firefox->new;
$driver->get('http://localhost:5000');

is($driver->get_title, 'Mox', 'check page title');

$driver->set_implicit_wait_timeout(250);

my $delete_song_cb;
my $delete_playlist_cb;

{
    my $song_container = $driver->find_element( 'mox-songs', 'tag_name' );
    is( scalar get_items($song_container), 0, 'no songs available' );

    my $btn = $driver->find_element_by_id('new_song_btn');
    ok( $btn, 'found button to add new song' );
    $btn->click;
    my $form = $driver->find_element_by_id('newSongForm');
    ok($form, 'found newSongForm');
    $driver->pause(250);
    ok($form->is_displayed, 'form is displayed');
    my $save_btn = $driver->find_child_element($form, 'button', 'tag_name');
    ok($save_btn, 'found save button');
    ok($save_btn->get_attribute('disabled'), 'save button is disabled');

    my $name_input = $driver->find_child_element($form, 'newSongName', 'id');
    ok($name_input, 'found name input field');

    my $file_input = $driver->find_child_element($form, 'newSongFile', 'id');
    ok($file_input, 'found file input field');
    my $song_name = '__test_song_001__';
    my $file_name = "$song_name.oga";
    my $upload = "$Bin/var/$file_name";
    ok(-e $upload, 'upload file exists');
    $file_input->send_keys($upload);
    $driver->pause(250);
    is($name_input->get_value, $song_name, 'name was auto-filled-in with filename. (file-extension stripped)');
    ok(!$save_btn->get_attribute('disabled'), 'save button is no longer disabled');
    $driver->pause(250);

    $save_btn->click;
    $driver->pause(250);
    ok(!$form->is_displayed, 'form is no longer displayed');

    my @songs = get_items($song_container);
    is(scalar @songs, 1, 'one song available');
    my $song = $songs[0];
    is($song->get_text(), $song_name, 'song name was saved correctly');

    $delete_song_cb = sub {
        my $delete_btn = $driver->find_child_element($song, 'glyphicon-remove', 'class');
        ok($delete_btn, 'found delete button');
        $delete_btn->click;
        $driver->pause(250);
        is(scalar get_items($song_container), 0, 'new song has been deleted.');
    }
}

{
    my $playlist_container = $driver->find_element('mox-playlists', 'tag_name');
    is(scalar get_items($playlist_container), 0,'no playlists available');

    my $btn = $driver->find_element_by_id('new_playlist_btn');
    ok($btn, 'found button to add new playlist');
    $btn->click;

    my $form = $driver->find_element_by_id('newPlaylistForm');
    ok($form, 'found newPlaylistForm');
    $driver->pause(250);
    ok($form->is_displayed, 'form is displayed');
    my $save_btn = $driver->find_child_element($form, 'button', 'tag_name');
    ok($save_btn, 'found save button');
    ok($save_btn->get_attribute('disabled'), 'save button is disabled');
    my $input = $driver->find_child_element($form, 'input', 'tag_name');
    ok($input, 'found input');
    my $playlist_name = '__test_playlist_001__';
    $input->send_keys($playlist_name);
    ok(!$save_btn->get_attribute('disabled'), 'save button is no longer disabled');
    $driver->pause(250);
    $save_btn->click;
    $driver->pause(250);
    ok(!$form->is_displayed, 'form is no longer displayed');
    my @playlists = get_items($playlist_container);
    is(scalar @playlists, 1, 'one playlist available');
    my $playlist = $playlists[0];
    is($playlist->get_text(), $playlist_name, 'playlist name was saved correctly');

    unlike($playlist->get_attribute('class'), qr/selected/ , 'playlist is not selected');
    my $playlist_song_container = $driver->find_element('mox-playlist-songs', 'tag_name');
    is(scalar get_items($playlist_song_container), 0, 'no playlist_songs available');
    my $sortable = $driver->find_child_element($playlist_song_container, 'sortable', 'id');
    ok($sortable, 'got a sortable container');
    unlike($sortable->get_attribute('class'), qr/drop-info/, 'sortable does not have class drop-info');
    $playlist->click;
    like($playlist->get_attribute('class'), qr/selected/ , 'playlist is selected');
    like($sortable->get_attribute('class'), qr/drop-info/, 'sortable has class drop-info');

    $delete_playlist_cb = sub {
        my $delete_btn = $driver->find_child_element($playlist, 'glyphicon-remove', 'class');
        ok($delete_btn, 'found delete button');
        $delete_btn->click;
        $driver->pause(250);
        is(scalar get_items($playlist_container), 0, 'new playlist has been deleted.');
    }
}

$delete_song_cb->();
$delete_playlist_cb->();
$driver->quit();

sub get_items {
    my $container = shift;
    my @items = $driver->find_child_elements($container, 'mox-item', 'class');
    return @items;
}

done_testing;
