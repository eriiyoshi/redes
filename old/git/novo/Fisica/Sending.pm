################################################
# 		IMPLEMENTACAO DA CAMADA FISICA		   #
# 	6o Periodo/2017 - Eng Computacao		   #
#	Erica Yoshiwara 201212040180			   #
#	Gustavo Jordao 201212040520				   #
#	Lais Ribeiro 201212040040				   #
#	Lucas Teodoro 201112040501				   #
################################################

package Sending;

use IO::Socket::INET;

use strict;
use warnings;

use Functions qw(IP2Bin Bin2IP MAC2Bin Bin2MAC Dec2Bin Bin2Dec Asc2Bin Bin2Asc get_local_ip_address printFrame);

use Exporter qw(import);

our @EXPORT_OK = qw(connect sendFrame sendMessage requestTMQ);

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

my $server;


sub connect {
	##  If this were remote it would be an IP, but localhost for now
	my $ip = shift;
	my $port = shift;  ##  Same as before

	my $mac = `./getmac.sh $ip`;

	my $date = localtime();
	print "$date\n";
	print "\nConectando a IP: $ip:$port -> MAC Address: $mac...";

	$|=1;
	$server = IO::Socket::INET->new(
		PeerAddr => $ip,
		PeerPort => $port,
		Proto    => 'tcp',
		Timeout	=> 10
	) or die "Falha: $!";

	print "Ok\n";
}

sub sendFrame {

	my $buffer = "";

	my $fhEntrada;
	my $fhFrame;

	my $arqEntrada = shift;
	my $arqFrame = shift;

	my $destinationIP = shift;
	my $tmq = shift;
	my $offset = shift;

	# Prepara frame

	my $version = "0100"; #ipv4 (FIXO)
	my $ihl = "0101"; #5 (FIXO)
	my $typeOfService = "00000000"; #0 (FIXO)
	my $totalLength = 20;#"0000000000010101"; #21 (20 de cabecalho + dados)
	my $identification = "0000000001101111"; #111 (FIXO)
	my $flags = "000"; #0 (FIXO)
	my $fragmentOffset = "0000000000000"; #varia -> COMO ACHAR ?!
	my $timeToLive = "01111011"; #123 (FIXO)
	my $protocol = "00000110"; #6 -> De acordo com esse site (http://www.tcpipguide.com/free/t_IPDatagramGeneralFormat.htm)
	my $headerChecksum = "0000000000000000"; #varia, mas foi assumido que nao sera necessario tratar checksum
	my $sourceAddress = IP2Bin(Functions::get_local_ip_address()); #"110000001010100000000000000000001 ip origem (em binario)
	my $destinationAddress = IP2Bin($destinationIP); #"110000001010100000000000000000010" ip destino (em binario)

	# Lê campo Data

	open($fhEntrada, "<", $arqEntrada) or die "Cannot open file '$arqEntrada' for reading";
	binmode($fhEntrada);
	my $recebidos = read($fhEntrada, $buffer, 4000);
	my @bytes = split '', $buffer;
	close $fhEntrada;

	$totalLength += $recebidos - ($offset+$tmq) >= 0 ? $tmq : ($offset+$tmq) - $recebidos;
	$totalLength = sprintf "%016b", $totalLength;

	my $frame = $version . $ihl . $typeOfService . $totalLength . $identification;
	$frame .= $flags . $fragmentOffset . $timeToLive . $protocol;
	$frame .= $headerChecksum . $sourceAddress . $destinationAddress;

	# Salva frame em arquivo

	open($fhFrame, '>', $arqFrame) or die "Cannot open file '$arqFrame' for reading";

	print $fhFrame $frame;

	my $i;
	for($i=$offset; $i<$offset+$tmq && $i<$recebidos; $i++){
		my $byte=$bytes[$i];
		print $fhFrame Asc2Bin($byte);
	}

	close $fhFrame;

	# Envia frame
	my $date = localtime();
	print "$date\n";
	print "\nEnviando $arqFrame...";

	my $bufferFrame = '';

	open $fhFrame, '<', $arqFrame;
  while (<$fhFrame>) {

		my $colisao = int(rand(10));
		while($colisao < 3){
			$date = localtime();
			print "$date\n";
			print "Colisão no envio do $arqFrame\nReenviando $arqFrame...";
			$colisao = int(rand(10));
		}

		$bufferFrame .= $_;

  }

	print "Ok\n";

	$date = localtime();
	print "$date\n";
	print "$arqFrame enviado:";
	Functions::printFrame $bufferFrame;
	print $server $bufferFrame;

	close $fhFrame;

}

sub sendMessage {

	my $arqEntrada = shift;
	my $arqFrame = shift;
	my $destinationIP = shift;
	my $port = shift;
	my $tmq = shift;

	my $buffer;
	my $fhEntrada;

	my $offset = 0;

	open $fhEntrada, '<', $arqEntrada;
	my $tamEntrada = read($fhEntrada, $buffer, 4000);

	my $div = $tamEntrada/$tmq;
	my $iteracoes = $div == int($div) && $div != 0 ? $div : int($div)+1;

	#Sending::connect $destinationIP, $port;
	for(my $i=0; $i<$iteracoes; $i++){
		#if(!(defined $server)){
		sleep 1;
			Sending::connect $destinationIP, $port;
		#}
		sendFrame $arqEntrada, $arqFrame.$i, $destinationIP, $tmq, $offset;
		$offset += $tmq;

		close $server;
	}
	#close $server;
}

sub requestTMQ {
	my $arqEntrada = shift;
	my $arqFrame = shift;
	my $destinationIP = shift;
	my $port = shift;

	my $date = localtime();
	print "$date\n";
	print "\nSolicitando TMQ.";

	Sending::connect $destinationIP, $port;
	sendFrame $arqEntrada, $arqFrame, $destinationIP, 1, 0;
	close $server;

}

1;
