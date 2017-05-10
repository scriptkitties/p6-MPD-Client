#! /usr/bin/env perl6

use v6.c;
use lib "lib";
use Test;

plan 2;

use MPD::Client;
use MPD::Client::Status;

my $conn = mpd-connect(host => "localhost");

subtest "Ensure all the available fields are returned by mpd-status" => {
	my %response = mpd-status($conn);
	my @keys = [
		"volume",
		"repeat",
		"random",
		"single",
		"consume",
		"playlist",
		"playlistlength",
		"state",
		"song",
		"songid",
		"nextsong",
		"nextsongid",
		"time",
		"elapsed",
		"duration",
		"bitrate",
		"xfade",
		"mixrampdb",
		"mixrampdelay",
		"audio",
		"updating_db",
		"error",
	];

	plan (@keys.end + 1);

	for @keys -> $key {
		ok %response{$key}:exists, "$key exists";
	}
}

subtest "Ensure all the available fields are returned by mpd-stats" => {
	my %response = mpd-stats($conn);
	my @keys = [
		"artists",
		"albums",
		"songs",
		"uptime",
		"db_playtime",
		"db_update",
		"playtime",
	];

	plan (@keys.end + 1);

	for @keys -> $key {
		ok %response{$key}:exists, "$key exists";
	}
}
