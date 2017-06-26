#!/usr/bin/env perl

use IO::Socket::INET;

#Camada Física
#Erica Yoshiwara 201212040180
#Gustavo Jordao
#Lais Ribeiro
#Lucas Teodoro
#6o Periodo/2017


#Example 1:
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

$tmq = shift;

$version = "0100"; #ipv4 (FIXO)
$ihl = "0101"; #5 (FIXO)
$typeOfService = "00000000"; #0 (FIXO)
$totalLength = "0000000000010101"; #21 (20 de cabecalho + dados)
$identification = "0000000001101111"; #111 (FIXO)
$flags = "000"; #0 (FIXO)
$fragmentOffset = "0000000000000"; #varia
$timeToLive = "01111011"; #123 (FIXO)
$protocol = "00000110"; #1 ou 6
$headerChecksum = "0000000000000000"; #varia, mas foi assumido que nao sera necessario tratar checksum
$sourceAddress = get_local_ip_address(); #"110000001010100000000000000000001"; #ip origem
$destinationAddress = "110000001010100000000000000000010"; #ip destino

$frame = $version . $ihl . $typeOfService . $totalLength . $identification;
$frame .= $flags . $fragmentOffset . $timeToLive . $protocol;
$frame .= $headerChecksum . $sourceAddress . $destinationAddress;

open(my $fh, ">",  "frame.txt");
print $fh $frame;


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