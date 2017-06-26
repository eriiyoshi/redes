#!c:\perl\bin\perl.exe
use strict;
use IO::Socket::INET;

my $port = shift || die "[!] No port given...\n";;  ##  Value given from terminal

my $socket = IO::Socket::INET->new(
   Listen => 5,
   LocalPort => $port,
   Proto     => 'tcp'
) or die "Can't create server socket: $!";

print "Listening for connections on $port\n";

#my $client = $socket->accept;

#print "Connection established\n";

#open FILE, ">out" or die "Can't open: $!";

my @arq;
my $frame;
my $outfile = 'footer.txt';
open (FILE, ">> $outfile") || die "problem opening $outfile\n";
while (my $client = $socket->accept) {
        my $addr = gethostbyaddr($client->peeraddr, AF_INET);
        my $port = $client->peerport;
        while (<$client>) {
				#$socket->recv($frame, 512);
				$frame = <$socket>;
				@arq=@arq . $frame;
				print FILE @arq;
=pod
				print $_;
                #print "[Client:$port] $_";  ##  Print the client port and the message recived
                print $client "$.: $_";
=cut
        }
        close $client || die "[!] Connection unable to close...\n";
        die "[!] Can not connect $!\n";
}
close FILE;

=pod
while (<$client>) {

print $_;

if ($_ eq 'q' or $_ eq 'Q'){
close $socket;
}
}
=cut
