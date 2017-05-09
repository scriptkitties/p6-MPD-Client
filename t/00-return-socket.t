#! /usr/bin/env perl6

use v6.c;
use lib "lib";
use Test;

plan 1;

use MPD::Client;

my $socket = mpd-connect(host => "localhost");

isa-ok $socket, "IO::Socket", "mpd-connect returns a socket";
