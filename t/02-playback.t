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

	mpd-consume(True, $conn);
	is mpd-status($conn)<consume>, True, "Consume state is set";

	mpd-consume(False, $conn);
	is mpd-status($conn)<consume>, False, "Consume state is not set";
}

subtest "crossfade" => {
	plan 3;

	isa-ok mpd-crossfade($conn), "IO::Socket::INET", "crossfade returns the socket";

	mpd-crossfade(10, $conn);
	is mpd-status($conn)<xfade>, 10, "Check wether crossfade is applied properly";

	mpd-crossfade($conn);
	is mpd-status($conn)<xfade>, 0, "Check wether crossfade has been removed";
}

subtest "mixrampdb" => {
	plan 4;

	mpd-mixrampdb(-17, $conn);
	is mpd-status($conn)<mixrampdb>, -17, "Check wether mixrampdb is applied properly";

	mpd-mixrampdb(-17.7, $conn);
	is-approx mpd-status($conn)<mixrampdb>, -17.7, "Check wether mixrampdb is applied properly with a Rat";

	throws-like { mpd-mixrampdb(17, $conn) }, MPD::Client::Exceptions::ArgumentException, "Throws ArgumentException on positive decibel value";

	mpd-mixrampdb($conn);
	is mpd-status($conn)<mixrampdb>, 0, "Check wether mixrampdb has been removed";
}

subtest "mixrampdelay" => {
	plan 2;

	mpd-mixrampdelay(5, $conn);
	is mpd-status($conn)<mixrampdelay>, 5, "Check wether mixrampdb is applied properly";

	mpd-mixrampdelay($conn);
	is mpd-status($conn)<mixrampdelay>, 0, "Check wether mixrampdb has been removed";
}

subtest "random" => {
	plan 3;

	mpd-random(True, $conn);
	is mpd-status("random", $conn), True, "Random state is set";

	mpd-random(False, $conn);
	is mpd-status("random", $conn), False, "Random state is not set";

	mpd-random($conn);
	is mpd-status("random", $conn), True, "Random state has been toggled";
}
