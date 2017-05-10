#! /usr/bin/env false

use v6.c;

use MPD::Exceptions::SocketException;

unit module MPD::Client::Util;

#| Send a raw command to the MPD socket.
sub mpd-send-raw (
	Str $message,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	$socket.put($message);
	$socket;
}

#| Check wether the latest response on the MPD socket is OK.
sub mpd-check-ok (
	IO::Socket::INET $socket
	--> Bool
) is export {
	($socket.get() eq "OK");
}
