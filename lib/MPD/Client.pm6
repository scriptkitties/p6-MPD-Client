#! /usr/bin/env false

use v6.c;

use MPD::Exceptions::SocketException;

unit module MPD::Client;

#| Connect to a running MPD instance over TCP.
sub mpd-connect(
	Str :$host = "127.1",
	Int :$port = 6600
	--> IO::Socket::INET
) is export {
	my $socket = IO::Socket::INET.new(host => $host, port => $port);
	my $response = $socket.get();

	if ($response eq "") {
		MPD::Exceptions::SocketException.new("Empty response").throw();
	}

	if ($response !~~ m/OK\sMPD\s.+/) {
		my $error = "Incorrect response string '" ~ $response ~ "'";

		MPD::Exceptions::SocketException.new($error).throw();
	}

	$socket;
}

#| Set the pause state on MPD. The MPD protocol has deprecated the use of
#| `pause` without arguments. When state is set to True, the pause state will
#| be set, which is the default.
sub mpd-pause(
	IO::Socket::INET $socket,
	Bool $state = True
	--> IO::Socket::INET
) is export {
	$socket.put("pause " ~ ($state ?? "1" !! "0"));

	my $response = $socket.get();

	if ($response ne "OK") {
		MPD::Exceptions::SocketException.new("Non-OK response: " ~ $response).throw();
	}

	$socket;
}
