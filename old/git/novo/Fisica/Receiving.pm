################################################
# 		IMPLEMENTACAO DA CAMADA FISICA		   #
# 	6o Periodo/2017 - Eng Computacao		   #
#	Erica Yoshiwara 201212040180			   #
#	Gustavo Jordao 201212040520				   #
#	Lais Ribeiro 201212040040				   #
#	Lucas Teodoro 201112040501				   #
################################################

package Receiving;

use IO::Socket::INET;

use strict;
use warnings;

use Functions qw(IP2Bin Bin2IP MAC2Bin Bin2MAC Dec2Bin Bin2Dec Asc2Bin Bin2Asc get_local_ip_address printFrame);

use Sending qw(sendMessage);

use Exporter qw(import);

our @EXPORT_OK = qw(connect receiveFrame receiveMessage processFrame receiveMessageTMQ);

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

  my $port = shift || die "[!] No port given...\n";  ##  Value given from terminal
  my $ip = Functions::get_local_ip_address();

  my $mac = `./getmac.sh $ip`;

  my $date = localtime();
	print "$date\n";
	print "\nConectando a IP: $ip:$port -> MAC Address: $mac...";

  $|=1;
  $server = IO::Socket::INET->new(
     LocalPort => $port,
     Listen => 5,
     Proto     => 'tcp',
     Timeout => 10
  ) or die "Falha: $!";

  print "Ok\n";
}

sub processFrame {

  my $arqFrame = shift;
  my $fhFrame;

  my $arqSaida = shift;
  my $fhSaida;

  open $fhSaida, '>>', $arqSaida;
  binmode($fhSaida);

  open $fhFrame, '<', $arqFrame;
  my $buffer = '';
  while(<$fhFrame>){
      $buffer .= $_;
  }

  my $frame = substr($buffer, 160);

  print $fhSaida Bin2Asc($frame);

  close $fhFrame;
  close $fhSaida;

}

sub processFrameTMQ {

  my $arqFrame = shift;
  my $fhFrame;

  my $arqSaida = shift;
  my $fhSaida;

  my $tmq = shift;

  # Salva frame com TMQ

  open $fhSaida, '>', $arqSaida;
  binmode($fhSaida);

  print $fhSaida Bin2Asc(Dec2Bin($tmq));

  # Obtém endereço IP da origem

  open $fhFrame, '<', $arqFrame;
  my $buffer = '';
  while(<$fhFrame>){
      $buffer .= $_;
  }

#  print "\n\nFrame TMQ: $buffer \n\n";
  my $sourceAddress = substr($buffer, 96, 32);

  close $fhSaida;
  close $fhFrame;

  return $sourceAddress;

}

sub receiveFrame {

  my $arqFrame = shift;
  my $fhFrame;
  my $bufferFrame = "";

  #my $socket = $server->accept();
  #$socket->recv(my $frame, 4000); #or die("Finalizado por Timeout");
  my $frame = $server->accept or die("Finalizado por Timeout");

  open($fhFrame, '+>', $arqFrame) or die "Cannot open file '$arqFrame' for writing$!";

  # my $teste=select $fhFrame;
  # $|=1;

  while (<$frame>) {
    $bufferFrame .= $_;
    print $fhFrame $_ or die('Falha');
  }

  my $date = localtime();
	print "$date\n";
	print "\n$arqFrame recebido:";
  Functions::printFrame $bufferFrame;
	print "Ok\n";
  close $fhFrame;



}

sub receiveMessage {

  my $port = shift;
  my $arqFrame = shift;
  my $arqTMQ = shift;
  my $arqSaida = shift;
  my $tmq = shift;

  my $i = 0;
  my $fhFrame;

  Receiving::connect $port;

  receiveFrame $arqFrame;

  #close $server;

  my $sourceAddress = processFrameTMQ $arqFrame, $arqTMQ, $tmq;

  my $date = localtime();
	print "$date\n";
	print "\nRecebida solicitação de TMQ.";
  print "\nEnviando TMQ...";

  sleep 1;

  Sending::sendMessage $arqTMQ, $arqFrame.'tmq', Bin2IP($sourceAddress), $port+1, 10;

  print "Ok\n";

  open my $fhSaida, '>', $arqSaida;
  close $fhSaida;

  #Receiving::connect $port;

  while(1){
    #Receiving::connect $port;
    receiveFrame $arqFrame.$i;
    processFrame $arqFrame.$i, $arqSaida;
    #close $server;

    $i++;
  }

}

sub receiveMessageTMQ {

  my $port = shift;
  my $arqFrame = shift;
  my $arqTMQ = shift;

  my $i = 0;
  my $fhTMQ;

  my $buffer = '';

  Receiving::connect $port;

  receiveFrame $arqFrame.'tmq';
  processFrame $arqFrame.'tmq', $arqTMQ, 10;

  close $server;

  open $fhTMQ, '<', $arqTMQ;
  while(<$fhTMQ>){
    $buffer .= $_;
  }
  close $fhTMQ;

  return ord($buffer);

}

1;
