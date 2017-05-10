#! /usr/bin/env false

use v6.c;

use MPD::Client::Status;
use MPD::Client::Util;

unit module MPD::Client::Control;

#| Set the pause state on MPD. The MPD protocol has deprecated the use of
#| `pause` without arguments. When state is set to True, the pause state will
#| be set, which is the default.
multi sub mpd-pause (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-pause(mpd-status("pause", $socket), $socket);
}

multi sub mpd-pause (
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send-toggleable("pause", $state, $socket);
}
