################################################
# 		IMPLEMENTACAO DA CAMADA FISICA		   #
# 	6o Periodo/2017 - Eng Computacao		   #
#	Erica Yoshiwara 201212040180			   #
#	Gustavo Jordao 201212040520				   #
#	Lais Ribeiro 201212040040				   #
#	Lucas Teodoro 201112040501				   #
################################################

package Fisica::ReceiveFrame;

use strict;
use warnings;

use Fisica::Functions qw(Bin2Asc Bin2Dec IP2Bin);

use Exporter qw(import);

our @EXPORT_OK = qw(receiveFrame);

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
#   |   Time = 123  |  Protocol = 1 |        header checksum        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                         source address                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                      destination address                      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     data      |
#   +-+-+-+-+-+-+-+-+

sub receiveFrame {

  #mensagem que chegou
  my $file_path = shift;
  open(my $fh, "<", $file_path);

  #concatenacao para formar arquivo final
  my $arquivo_enviado = shift;
  open(my $fh_arq, ">>", $arquivo_enviado);

  my @frame = ();

  #while (<$fh>){
  while ( read( $fh, my $buffer, 1 ) ) {
    push @frame, $buffer;
  #  print 'asd', $buffer, ' ';
  }

  my @version = @frame[0..3]; #ipv4 (FIXO)
  my @ihl = @frame[4..7]; #5 (FIXO)
  my @typeOfService = @frame[8..15]; #0 no nosso caso é fixo
  my @totalLength = @frame[16..31]; #21 (20 de cabecalho + dados)
  my @identification = @frame[32..47]; #111 (FIXO)
  my @flags = @frame[48..51]; #0 (FIXO)
  my @fragmentOffset = @frame[52..63]; #varia
  my @timeToLive = @frame[64..71]; #123 (FIXO)
  my @protocol = @frame[72..79]; #1 ou 6
  my @headerChecksum = @frame[80..95]; #varia, mas foi assumido que nao sera necessario tratar checksum
  my @sourceAddress = @frame[96..127]; #varia
  my @destinationAddress = @frame[128..159]; #varia
  my @data = @frame[160..$#frame];

  print "\nversion: ", @version;
  print "\nihl: ", @ihl;
  print "\ntypeOfService: ", @typeOfService;
  print "\ntotalLength: ", @totalLength;
  print "\nidentification: ", @identification;
  print "\nflags: ", @flags;
  print "\nfragmentOffset: ", @fragmentOffset;
  print "\ntimeToLive: ", @timeToLive;
  print "\nprotocol: ", @protocol;
  print "\nheaderChecksum: ", @headerChecksum;
  print "\nsourceAddress: ", @sourceAddress;
  print "\ndestinationAddress: ", @destinationAddress;
  print "\ndata: ", @data;

  print "\n";

  # salva os bits os dados no arquivo de saída
  # TODO: é necessário converter para bytes

  my @packArray = @data;#Bin2Asc(@data);

  print @packArray;
  print $fh_arq @packArray;
  print "\n";

  close $fh;
  close $fh_arq;

  return @packArray;

}

1;
