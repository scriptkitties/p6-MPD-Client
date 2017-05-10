#! /usr/bin/env false

use v6.c;

use MPD::Client;
use MPD::Client::Util;
use MPD::Exceptions::SocketException;

unit module MPD::Client::Status;

#| Clears the current error message in status (this is also accomplished by any
#| command that starts playback).
sub mpd-clearerror(
	IO::Socket::INET $socket,
	--> IO::Socket::INET
) is export {
	$socket
		==> mpd-send-raw("clearerror")
		==> mpd-check-ok();

	$socket;
}
