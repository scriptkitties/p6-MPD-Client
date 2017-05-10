#! /usr/bin/env perl6

use v6.c;
use lib "lib";
use Test;

plan 5;

use MPD::Client;
use MPD::Client::Playback;
use MPD::Client::Status;
use MPD::Client::Exceptions::ArgumentException;

my $conn = mpd-connect(host => "localhost");

subtest "consume" => {
	plan 2;

	mpd-consume($conn, True);
	is mpd-status($conn)<consume>, True, "Consume state is set";

	mpd-consume($conn, False);
	is mpd-status($conn)<consume>, False, "Consume state is not set";
}

subtest "crossfade" => {
	plan 3;

	isa-ok mpd-crossfade($conn), "IO::Socket::INET", "crossfade returns the socket";

	mpd-crossfade($conn, 10);
	is mpd-status($conn)<xfade>, 10, "Check wether crossfade is applied properly";

	mpd-crossfade($conn);
	is mpd-status($conn)<xfade>, 0, "Check wether crossfade has been removed";
}

subtest "mixrampdb" => {
	plan 3;

	mpd-mixrampdb($conn, -17);
	is mpd-status($conn)<mixrampdb>, -17, "Check wether mixrampdb is applied properly";

	throws-like { mpd-mixrampdb($conn, 17) }, MPD::Client::Exceptions::ArgumentException, "Throws ArgumentException on positive decibel value";

	mpd-mixrampdb($conn);
	is mpd-status($conn)<mixrampdb>, 0, "Check wether mixrampdb has been removed";
}

subtest "mixrampdelay" => {
	plan 2;

	mpd-mixrampdelay($conn, 5);
	is mpd-status($conn)<mixrampdelay>, 5, "Check wether mixrampdb is applied properly";

	mpd-mixrampdelay($conn);
	is mpd-status($conn)<mixrampdelay>, 0, "Check wether mixrampdb has been removed";
}

subtest "random" => {
	plan 3;

	mpd-random($conn, True);
	is mpd-status($conn)<random>, True, "Random state is set";

	mpd-random($conn, False);
	is mpd-status($conn)<random>, False, "Random state is not set";

	mpd-random($conn);
	is mpd-status($conn)<random>, True, "Random state has been toggled";
}
