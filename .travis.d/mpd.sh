#! /usr/bin/env sh

readonly MUSICDIR=/var/media/music

# install all required packages
apt install -y \
	mpc \
	mpd

# create the required directories
mkdir -p \
	/var/lib/mpd \
	${MUSICDIR}

# configure mpd
install ./mpd.conf /etc/mpd.conf

# start the service
service mpd start

# TODO: add some free music
curl https://github.com/PostCocoon/P6-TagLibC/raw/master/t/test.mp3 > ${MUSICDIR}/test.mp3

# sync the music with the mpd library
mpc update --wait
