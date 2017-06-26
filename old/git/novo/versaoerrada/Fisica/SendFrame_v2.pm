#!/usr/bin/perl

package Fisica::SendFrame_v2;
#use warnings;

#use Path::Class;
#use autodie; # die if problem reading or writing a file
use strict;
use IO::Socket::INET;

use strict;
use warnings;

use Exporter qw(import);

use Fisica::Functions qw(ip2bin2 Asc2Bin Rand_Colisions);

our @EXPORT_OK = qw(sendMessage);

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
  close $socket;
  return $local_ip_address;
}

sub sendFrame {
  #my $srcIP=ip2bin2(get_local_ip_address());
  #my $destIP=ip2bin2(shift);

  my $version = "0100"; #ipv4 (FIXO)
  my $ihl = "0101"; #5 (FIXO)
  my $typeOfService = "00000000"; #0 (FIXO)
  my $totalLength = "0000000000010101"; #21 (20 de cabecalho + dados)
  my $identification = "0000000001101111"; #111 (FIXO)
  my $flags = "000"; #0 (FIXO)
  my $fragmentOffset = "0000000000000"; #varia -> COMO ACHAR ?!
  my $timeToLive = "01111011"; #123 (FIXO)
  my $protocol = "00000110"; #6 -> De acordo com esse site (http://www.tcpipguide.com/free/t_IPDatagramGeneralFormat.htm)
  my$headerChecksum = "0000000000000000"; #varia, mas foi assumido que nao sera necessario tratar checksum
  my $sourceAddress = ip2bin2(get_local_ip_address()); #"110000001010100000000000000000001 ip origem (em binario)
  my $destinationAddress = ip2bin2(shift); #"110000001010100000000000000000010" ip destino (em binario)
  #TAMNHO FRAME 80 bits ate fim do $headerChecksum
  my $tmq = shift;

  my $frame = $version . $ihl . $typeOfService . $totalLength . $identification;
  $frame .= $flags . $fragmentOffset . $timeToLive . $protocol;
  $frame .= $headerChecksum . $sourceAddress . $destinationAddress;

  return $frame;
}

sub sendMessage {

  my $server = shift;  ##  If this were remote it would be an IP, but localhost for now
  my $ip=$server;
  my $port = shift;  ##  Same as before
  #print "Teste: $server, $port\n";
  $server = IO::Socket::INET->new(
  PeerAddr => $server,
  PeerPort => $port,
  Proto    => 'tcp'
  ) or die "Can't create client socket: $!";

  print "Establishing connection to $ip:$port\n";

  my $rodando=1;
  my $tmq = 5;
  my $offset = -1;
  my $got=0;
  my $fh;

  #Asc2Bin('Arquivo_entrada.txt','Arquivo_entrada_bin.txt');
  while ($rodando) {

    my $file_path = 'Arquivo_entrada.txt';
    open($fh, '<', $file_path) or die "Cannot open file '$file_path' for reading";
    binmode($fh);

    my $buffer;
    my $count=1;
    do {
      print "Enviando mensagem $count";

      #print "Read $got bytes from file ", $buffer, "\n";
      my $fileOut = 'frame.txt';
      open(my $fhO, '+>', $fileOut) or die "Cannot open file '$file_path' for writing$!";

    #  local $/;

      my $frame=sendFrame($ip,$tmq);

      while(<$fh>){
        $buffer .= $_;
      }
print "\nTeste: $buffer\n";
      my @binaries = $frame . Asc2Bin($buffer);
      print "\nTeste: \n".Asc2Bin($buffer);

      #Salva em um arquivo
      print $fhO @binaries;

      $buffer = '';
      close $fhO;

      open FRAME, "frame.txt";


      while (<FRAME>) {
        print $server $_;
      }

      #Generate random colisions 1=colision, 0=ok
      my $colision=Rand_Colisions();

      if ($colision==1) {
        print "\nColisao detectada.\n";
        $count++;
        print "Enviando mensagem $count";

        while (<FRAME>) {
          print $server $_;
        }
      }
      $count++;
      if($offset < 0){
        $offset = 0;
      }
      else{
        $offset+=$got;
      }
      print "\nGOT: $got";

    }
    while ( $got = read( $fh, $buffer, $tmq, $offset) );
    $rodando=0;
    close $fh;
  }

}

1;
