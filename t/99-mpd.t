#! /usr/bin/env perl6

# This test requires a running MPD instance on 127.1:6600. Unlike the other
# tests, this one is not a standalone unit test. Don't worry too much if this
# fails for now.

use v6.c;
use Test;
use lib "lib";

plan 1;

use MPD::Client;

my $socket = mpd-connect(host => "localhost");

isa-ok $socket, "IO::Socket::INET", "Connects with success";
