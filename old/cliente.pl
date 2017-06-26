#!c:\perl\bin\perl.exe
use strict;
use IO::Socket::INET;

my $server = shift;  ##  If this were remote it would be an IP, but localhost for now
my $port = shift;  ##  Same as before

my $server = IO::Socket::INET->new(
   PeerAddr => $server,
   PeerPort => $port,
   Proto    => 'tcp'
) or die "Can't create client socket: $!";

print "Establishing connection to $server:$port\n";

open FILE, "mickey.jpg";
while (<FILE>) {
   print $server $_;
}
close FILE;

