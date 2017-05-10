#! /usr/bin/env false

use v6.c;

use MPD::Client;
use MPD::Client::Status;
use MPD::Client::Util;
use MPD::Client::Exceptions::ArgumentException;

unit module MPD::Client::Playback;

sub mpd-consume (
	IO::Socket::INET $socket,
	Bool $state?
	--> IO::Socket::INET
) is export {
	my $current = mpd-status("consume", $socket);

	mpd-send-toggleable("consume", $state // !$current, $socket);
}

sub mpd-crossfade (
	IO::Socket::INET $socket,
	Int $seconds = 0
	--> IO::Socket::INET
) is export {
	$socket
		==> mpd-send-raw("crossfade " ~ $seconds)
		==> mpd-response-ok()
		;

	$socket;
}

sub mpd-mixrampdb (
	IO::Socket::INET $socket,
	Real $decibels = 0
	--> IO::Socket::INET
) is export {
	if ($decibels > 0) {
		MPD::Client::Exceptions::ArgumentException.new("Decibel value must be negative").throw;
	}

	$socket
		==> mpd-send-raw("mixrampdb " ~ $decibels)
		==> mpd-response-ok()
		;

	$socket;
}

sub mpd-mixrampdelay (
	IO::Socket::INET $socket,
	Int $seconds = 0
	--> IO::Socket::INET
) is export {
	$socket
		==> mpd-send-raw("mixrampdelay " ~ $seconds)
		==> mpd-response-ok()
		;

	$socket;
}

sub mpd-random (
	IO::Socket::INET $socket,
	Bool $state?
	--> IO::Socket::INET
) is export {
	my $current = mpd-status("random", $socket);

	mpd-send-toggleable("random", $state // !$current, $socket);
}
