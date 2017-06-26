################################################
# 		IMPLEMENTACAO DA CAMADA FISICA		   #
# 	6o Periodo/2017 - Eng Computacao		   #
#	Erica Yoshiwara 201212040180			   #
#	Gustavo Jordao 201212040520				   #
#	Lais Ribeiro 201212040040				   #
#	Lucas Teodoro 201112040501				   #
################################################

package Fisica::SendFrame;

use IO::Socket::INET;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(sendFrame);

#Example:
#
#  This is an example of the minimal data carrying internet datagram:
#    0                   1                   2                   3
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |Ver= 4 |IHL= 5 |Type of Service|        Total Length = 21      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |      Identification = 111     |Flg=0|   Fragment Offset = 0   |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |   Time = 123  |  Protocol = 6 |        header checksum        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                         source address                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                      destination address                      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     data      |
#   +-+-+-+-+-+-+-+-+
#


sub sendFrame {
	$version = "0100"; #ipv4 (FIXO)
	$ihl = "0101"; #5 (FIXO)
	$typeOfService = "00000000"; #0 (FIXO)
	$totalLength = "0000000000010101"; #21 (20 de cabecalho + dados)
	$identification = "0000000001101111"; #111 (FIXO)
	$flags = "000"; #0 (FIXO)
	$fragmentOffset = "0000000000000"; #varia -> COMO ACHAR ?!
	$timeToLive = "01111011"; #123 (FIXO)
	$protocol = "00000110"; #6 -> De acordo com esse site (http://www.tcpipguide.com/free/t_IPDatagramGeneralFormat.htm)
	$headerChecksum = "0000000000000000"; #varia, mas foi assumido que nao sera necessario tratar checksum
	$sourceAddress = sprintf("%b", get_local_ip_address()); #"110000001010100000000000000000001 ip origem (em binario)
	$destinationAddress = sprintf("%b", shift) #"110000001010100000000000000000010" ip destino (em binario)

	$tmq = shift;

	$frame = $version . $ihl . $typeOfService . $totalLength . $identification;
	$frame .= $flags . $fragmentOffset . $timeToLive . $protocol;
	$frame .= $headerChecksum . $sourceAddress . $destinationAddress;

	my $file_path = 'Arquivo_entrada.txt';
	open(my $fh, '<', $file_path) or die "Cannot open file '$file_path' for reading";
	binmode($fh);

	my $buffer;
	while ( my $got = read( $fh, $buffer, $tmq) ) {

		#print "Read $got bytes from file ", $buffer, "\n";
		my $fileOut = 'frame.txt';
		open(my $fhO, '+>', $fileOut) or die "Cannot open file '$file_path' for writing$!";

		local $/;

		@binaries = $frame . $buffer;

		#Salva em um arquivo
		print $fhO @binaries;

		$buffer = '';
		close $fileOut;
	}
	close $file_path;
}


# This idea was stolen from Net::Address::IP::Local::connected_to()
sub get_local_ip_address {
    my $socket = IO::Socket::INET->new(
        Proto       => 'tcp',
        PeerAddr    => '198.41.0.4', # a.root-servers.net
        PeerPort    => '53', # DNS
    );

    # A side-effect of making a socket connection is that our IP address
    # is available from the 'sockhost' method
    my $local_ip_address = $socket->sockhost;

    return $local_ip_address;
}
