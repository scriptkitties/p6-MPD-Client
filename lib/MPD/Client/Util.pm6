#! /usr/bin/env false

use v6.c;

use MPD::Client::Exceptions::SocketException;

unit module MPD::Client::Util;

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
			last;
		}

		if ($line ~~ m/(.+)\:\s+(.*)/) {
			%response{$0} = $1;
		}
	}

	%response;
}

#| Send a boolean value $state for the given $option to the MPD $socket.
multi sub mpd-send (
	Str $option,
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	my $message = $option ~ " " ~ ($state ?? "1" !! "0");

	$socket
		==> mpd-send($message)
		==> mpd-response-ok()
		;

	$socket;
}

multi sub mpd-send (
	Str $option,
	Str $value,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	my $message = $option ~ " " ~ $value;

	$socket
		==> mpd-send($message)
		==> mpd-response-ok()
		;

	$socket;
}

#| Send a raw command to the MPD socket.
multi sub mpd-send (
	Str $message,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	$socket.put($message);

	$socket;
}

#| Transform a hashed response from MPD to have all @bools be native perl Bool
#| objects.
sub transform-response-bools (
	@bools,
	%input
	--> Hash
) is export {
	my %response = %input;

	for @bools -> $bool {
		if (!defined(%response{$bool})) {
			%response{$bool} = False;

			next;
		}

		%response{$bool} = (%response{$bool} eq "1" ?? True !! False);
	}

	%response;
}

#| Transform a hashed response from MPD to have all @ints be native perl Int
#| objects.
sub transform-response-ints (
	@ints,
	%input
	--> Hash
) is export {
	my %response = %input;

	for @ints -> $int {
		if (!defined(%response{$int})) {
			%response{$int} = 0;

			next;
		}

		%response{$int} = %response{$int}.Real;
	}

	%response;
}

#| Transform a hashed response from MPD to have all @reals be native perl Real
#| objects.
sub transform-response-reals (
	@reals,
	%input
	--> Hash
) is export {
	my %response = %input;

	for @reals -> $real {
		if (!defined(%response{$real})) {
			%response{$real} = 0.0;

			next;
		}

		%response{$real} = %response{$real}.Real;
	}

	%response;
}

#| Transform a hashed response from MPD to have all @strings be native perl Str
#| objects.
sub transform-response-strings (
	@strings,
	%input
	--> Hash
) is export {
	my %response = %input;

	for @strings -> $string {
		if (!defined(%response{$string})) {
			%response{$string} = "";

			next;
		}

		%response{$string} = %response{$string}.Str;
	}

	%response;
}
