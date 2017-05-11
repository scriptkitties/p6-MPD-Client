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

sub mpd-send-bool (
	Str $option,
	Bool $state,
	IO::Socket::INET $socket
	--> IO::Socket::INET
) is export {
	my $message = $option ~ " " ~ ($state ?? "1" !! "0");

	$socket
		==> mpd-send-raw($message)
		==> mpd-response-ok()
		;

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
			last;
		}

		if ($line ~~ m/(.+)\:\s+(.*)/) {
			%response{$0} = $1;
		}
	}

	%response;
}

#| transform 1/0 bools into Perl Bools
sub convert-bools (
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

sub convert-ints (
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

sub convert-reals (
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

sub convert-strings (
	@strings,
	%input
	--> Hash
) is export {
	my %response = %input;

	for @strings -> $string {
		if (!defined(%response{$string})) {
			%response{$string} = 0.0;

			next;
		}

		%response{$string} = %response{$string}.Str;
	}

	%response;
}
