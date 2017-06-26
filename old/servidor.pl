#!c:\perl\bin\perl.exe
use strict;
use IO::Socket::INET;

my $port = shift || die "[!] No port given...\n";;  ##  Value given from terminal

my $server = IO::Socket::INET->new(
   Listen => 5,
   LocalPort => $port,
   Proto     => 'tcp'
) or die "Can't create server socket: $!";

my $client = $server->accept;

open FILE, ">out" or die "Can't open: $!";
while (<$client>) {
   print $_;
}
close FILE;


