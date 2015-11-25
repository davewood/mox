# mox
mox is a simple web audio player written in Perl and Javascript.

## Features

* playlists
* drag&drop

## Installation

    cpanm --installdeps .
    perl bin/db_deploy.pl
    npm install
    bower install
    plackup bin/app.psgi

## headless selenium tests

    aptitude install xvfb
    Xvfb :99
    Display=:99 prove -lvr t
