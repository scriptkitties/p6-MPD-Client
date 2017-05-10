#! /usr/bin/env false

use v6.c;

use MPD::Client;
use MPD::Client::Util;

unit module MPD::Client::Control;

#| Set the pause state on MPD. The MPD protocol has deprecated the use of
#| `pause` without arguments. When state is set to True, the pause state will
#| be set, which is the default.
sub mpd-pause (
	IO::Socket::INET $socket,
	Bool $state = True
	--> IO::Socket::INET
) is export {
	$socket
		==> mpd-send-raw("pause " ~ ($state ?? "1" !! "0"))
		==> mpd-response-ok();

	$socket;
}
