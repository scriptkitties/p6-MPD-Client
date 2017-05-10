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
	my $message = "consume";

	if (defined($state)) {
		$message ~= " " ~ ($state ?? "1" !! "0");
	}

	$socket
		==> mpd-send-raw($message)
		==> mpd-response-ok()
		;

	$socket;
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
	my $value = $state;

	if (!defined($value)) {
		$value = !mpd-status($socket)<random>;
	}

	my $message ~= "random " ~ ($value ?? "1" !! "0");

	$socket
		==> mpd-send-raw($message)
		==> mpd-response-ok()
		;

	$socket;
}
