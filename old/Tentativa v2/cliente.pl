#!c:\perl\bin\perl.exe
use strict;
use IO::Socket::INET;
my $SIZE = 512;

sub FileMaxSize
{
	my $arquivo = 'MAXSIZE.txt';
	open(my $fh, '>', $arquivo) or die "Não foi possível abrir o arquivo '$arquivo' $!";
	print $fh "$SIZE\n";
	close $fh;
}

sub CreateFrame
{
	my $version = "0100"; #4
	my $ihl = "0101"; #5
	my $typeOfService = "00000000"; #0, mas pode variar
	my $totalLength = "0000000000010101"; #21 (20 de cabecalho + dados)
	my $identification = "0000000001101111"; #111
	my $flags = "000"; #0
	my $fragmentOffset = "0000000000000"; #varia
	my $timeToLive = "01111011"; #123
	my $protocol = "00000110"; #1 ou 6
	my $headerChecksum = "0000000000000000"; #varia, mas foi assumido que não será necessário tratar checksum
	my $sourceAddress = "110000001010100000000000000000001"; #varia
	my $destinationAddress = "110000001010100000000000000000010"; #varia


my $frame;

	$frame = $version . $ihl . $typeOfService . $totalLength . $identification;
	$frame .= $flags . $fragmentOffset . $timeToLive . $protocol;
	$frame .= $headerChecksum . $sourceAddress . $destinationAddress;

	return $frame
}

#FileMaxSize();

my $server = shift;  ##  If this were remote it would be an IP, but localhost for now
my $port = shift;  ##  Same as before

my $socket = IO::Socket::INET->new(
   PeerAddr => $server,
   PeerPort => $port,
   Proto    => 'tcp'
) or die "Can't create client socket: $!";

print "Establishing connection to $server:$port\n";

=pod
my $input;
open $input, "MAXSIZE.txt" or die "Unable to open: $!";
binmode $input;
my $data;
my $nbytes;
my $frame=CreateFrame();
=cut

my $file_path = 'binteste.txt';

open(my $fh, '<', $file_path) or die "Cannot open file '$file_path' for reading";
binmode($fh);

my $frame;
my @binary;
while ( <$socket>) {

	#$socket->send($SIZE);
=pod

	while($nbytes = read $input, $data, 512, length $data) {
		print "$nbytes bytes read\n";
	}
	my $res = $socket->send($frame.$data);
=cut
	my $buffer;
	while ( my $got = read( $fh, $buffer, $SIZE ) ) {

	  warn "Read $got bytes from file\n.";

	  @binary = unpack "N*", $buffer;

	  $frame=$frame . @binary;
	  $socket->send($frame);
	  $buffer = '';
	}
	close $socket;
=pod
	print $socket $_;
	#Imprime numero da mensagem
	print scalar <$socket>;
=cut
}
close $socket;
close $file_path;


=pod
if ($_ eq 'q' or $_ eq 'Q'){
	close $socket;
}
=cut
