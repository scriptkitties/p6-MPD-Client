#! /usr/bin/env false

use v6.c;

use MPD::Client::Exceptions::SocketException;

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
sub mpd-response-ok (
	IO::Socket::INET $socket
	--> Bool
) is export {
	($socket.get() eq "OK");
}

#| Turn the latest MPD response into a Hash object.
sub mpd-response-hash (
	IO::Socket::INET $socket
	--> Hash
) is export {
	my %response;

	for $socket.lines() -> $line {
		if $line eq "OK" {
			return %response;
		}

		if ($line ~~ m/(.+)\:\s+(.*)/) {
			%response{$0} = $1;
		}
	}
}
