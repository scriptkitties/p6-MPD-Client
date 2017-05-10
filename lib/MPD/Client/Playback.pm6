#! /usr/bin/env false

use v6.c;

use MPD::Client::Status;
use MPD::Client::Util;
use MPD::Client::Exceptions::ArgumentException;

unit module MPD::Client::Playback;

multi sub mpd-consume (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-consume(!mpd-status("consume", $socket), $socket);
}

multi sub mpd-consume (
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	$socket
		==> mpd-send-raw("consume " ~ ($state ?? "1" !! "0"))
		==> mpd-response-ok()
		;

	$socket;
}

multi sub mpd-crossfade (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-crossfade(0, $socket);
}

multi sub mpd-crossfade (
	Int $seconds,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	$socket
		==> mpd-send-raw("crossfade " ~ $seconds)
		==> mpd-response-ok()
		;

	$socket;
}

sub mpd-deltavol (
	Int $volume,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	my $current = mpd-status("volume", $socket);
	my $new = $current + $volume;

	mpd-setvol($new, $socket);
}

multi sub mpd-mixrampdb (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-mixrampdb(0, $socket);
}

multi sub mpd-mixrampdb (
	Real $decibels,
	IO::Socket::INET $socket
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

multi sub mpd-mixrampdelay (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-mixrampdelay(0, $socket);
}

multi sub mpd-mixrampdelay (
	Int $seconds,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	$socket
		==> mpd-send-raw("mixrampdelay " ~ $seconds)
		==> mpd-response-ok()
		;

	$socket;
}

multi sub mpd-random (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-random(!mpd-status("random", $socket), $socket);
}

multi sub mpd-random (
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send-toggleable("random", $state, $socket);
}

multi sub mpd-repeat (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-repeat(!mpd-status("repeat", $socket), $socket);
}

multi sub mpd-repeat (
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send-toggleable("repeat", $state, $socket);
}

sub mpd-setvol (
	Int $volume,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	if ($volume < 0) {
		MPD::Client::Exceptions::ArgumentException.new("Volume must be positive").throw;
	}

	if ($volume > 100) {
		MPD::Client::Exceptions::ArgumentException.new("Volume cannot exceed 100").throw;
	}

	$socket
		==> mpd-send-raw("setvol " ~ $volume)
		==> mpd-response-ok()
		;

	$socket;
}

multi sub mpd-single (
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-single(!mpd-status("single", $socket), $socket);
}

multi sub mpd-single (
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	mpd-send-toggleable("single", $state, $socket);
}

# todo: Ensure $state is valid (off, track, album, auto)
sub mpd-replay-gain-mode (
	Str $mode,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	my @acceptables = <
		album
		auto
		off
		track
	>;

	my $illegal = True;

	for @acceptables -> $acceptable {
		if ($mode ne $acceptable) {
			next;
		}

		$illegal = False;
		last;
	}

	if ($illegal) {
		MPD::Client::Exceptions::ArgumentException.new("Mode $mode is illegal for replay_gain_mode").throw;
	}

	$socket
		==> mpd-send-raw("replay_gain_mode " ~ $mode)
		==> mpd-response-ok()
		;

	$socket;
}

multi sub mpd-replay-gain-status (
	IO::Socket::INET $socket
	--> Hash
) is export {
	my @strings = [
		"replay_gain_mode",
	];

	$socket
		==> mpd-send-raw("replay_gain_status")
		==> mpd-response-hash()
		==> convert-strings(@strings)
		;
}

multi sub mpd-replay-gain-status (
	Str $key,
	IO::Socket::INET $socket
	--> Any
) is export {
	mpd-replay-gain-status($socket){$key};
}
