#! /usr/bin/env false

use v6.c;

use MPD::Client::Status;
use MPD::Client::Util;

unit module MPD::Client::Control;

sub mpd-next (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("next", $socket);
}

multi sub mpd-pause (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-pause(!mpd-status("pause", $socket), $socket);
}

multi sub mpd-pause (
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("pause", $state, $socket);
}

sub mpd-play (
	Int $songpos,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("play", $songpos, $socket);
}

sub mpd-playid (
	Int $songid,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("playid", $songid, $socket);
}

sub mpd-previous (
	IO::Socket::INET $socket,
	--> IO::Socket::INET
) is export {
	mpd-send("previous", $socket);
}

sub mpd-seek (
	Int $songpos,
	Real $time,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("seek", [$songpos, $time], $socket);
}

sub mpd-seekid (
	Int $songid,
	Real $time,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("seekid", [$songid, $time], $socket);
}

sub mpd-seekcur (
	Real $time,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("seekcur", $time, $socket);
}

sub mpd-stop (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send("stop", $socket);
}
