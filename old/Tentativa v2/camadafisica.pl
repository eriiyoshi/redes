#1001
#0001000000000001

#!/usr/bin/perl
#!env perl

use strict;
use warnings;
#    0                   1                   2                   3
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |Version|  IHL  |Type of Service|          Total Length         |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |         Identification        |Flags|      Fragment Offset    |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |  Time to Live |    Protocol   |         Header Checksum       |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                       Source Address                          |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Destination Address                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Options                    |    Padding    |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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

#Example 2:
#
#  In this example, we show first a moderate size internet datagram (452
#  data octets), then two internet fragments that might result from the
#  fragmentation of this datagram if the maximum sized transmission
#  allowed were 280 octets.
#
#
#    0                   1                   2                   3
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |Ver= 4 |IHL= 5 |Type of Service|       Total Length = 472      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     Identification = 111      |Flg=0|     Fragment Offset = 0 |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |   Time = 123  | Protocol = 6  |        header checksum        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                         source address                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                      destination address                      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                             data                              |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                             data                              |
#   \                                                               \
#   \                                                               \
#   |                             data                              |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |             data              |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

sub CreateFrame
{
	$version = "0100"; #4
	$ihl = "0101"; #5
	$typeOfService = "00000000"; #0, mas pode variar
	$totalLength = "0000000000010101"; #21 (20 de cabecalho + dados)
	$identification = "0000000001101111"; #111
	$flags = "000"; #0
	$fragmentOffset = "0000000000000"; #varia
	$timeToLive = "01111011"; #123
	$protocol = "00000110"; #1 ou 6
	$headerChecksum = "0000000000000000"; #varia, mas foi assumido que não será necessário tratar checksum
	$sourceAddress = "110000001010100000000000000000001"; #varia
	$destinationAddress = "110000001010100000000000000000010"; #varia



	$frame = $version . $ihl . $typeOfService . $totalLength . $identification;
	$frame .= $flags . $fragmentOffset . $timeToLive . $protocol;
	$frame .= $headerChecksum . $sourceAddress . $destinationAddress;
}

sub Dec2Bin
{
	my $numero = shift

	$binario=sprintf("%b",$numero);

	return $binario
}

sub Arq2Bin
{
	use open IO => ':raw';    # If called as: tobin.pl infile.bin > out.txt

	binmode(STDIN);           # If called as: tobin.pl < infile.bin > out.txt
	binmode(STDOUT);

	local $/ = \(1<<16);

	while (<>) {
	    print unpack 'B*', $_;
	}
}


sub GetSize
{
	my $filename = 'MAXSIZE.txt';

	open(my $fh, '<:', $filename)
	  or die "Could not open file '$filename' $!";

	return $size = <$fh>;
}

#Ta errada
sub RBF
{
	open F, "/bin/bash";
	my @file = do { local $/; <F> };
	close F;
}

open(my $fh, ">",  "frame.txt");
print $fh $frame;

#Concatena o DadosBin.txt com o frame.txt
my $entrada = "DadosBin.txt";
my $saida = "frame.txt";

open my $in_fh, '<', $entrada
    or die "Couldn't open $entrada for reading: $!\n";

open my $out_fh, '>>', $saida
    or die "Couldn't open $saida for appending: $!\n";
{
    local $/ = \65536; # read 64kb chunks

    while ( my $chunk = <$in_fh> )
	{
		print $out_fh $chunk;
	}
}
