################################################
# 		IMPLEMENTACAO DA CAMADA FISICA		   #
# 	6o Periodo/2017 - Eng Computacao		   #
#	Erica Yoshiwara 201212040180			   #
#	Gustavo Jordao 201212040520				   #
#	Lais Ribeiro 201212040040				   #
#	Lucas Teodoro 201112040501				   #
################################################

package Functions;

use IO::Socket::INET;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(IP2Bin Bin2IP MAC2Bin Bin2MAC Dec2Bin Bin2Dec Asc2Bin Bin2Asc get_local_ip_address printFrame);

sub IP2Bin {

	my $bin = '';
	my @partes = split('\.', shift);
	foreach my $parte (@partes){
		$bin = $bin . Dec2Bin($parte);
	}
	return $bin;

}

sub MAC2Bin {

	my $bin = '';
	my @partes = split(':', shift);
	foreach my $parte (@partes){
		$bin = $bin . Dec2Bin(hex($parte));
	}
	return $bin;

}

sub Dec2Bin {
	return sprintf ("%08b", shift);
}

sub Asc2Bin {

	my @ascii = split('', shift);
	my $bin = "";

	foreach my $char (@ascii){
		$bin .= Dec2Bin(ord($char));
	}

	return $bin;

}

sub Bin2IP {

	my $bin = shift;
	my @vec_bin = split '', $bin;
	my $num_bits = scalar (@vec_bin);
	my $ip = "";

	for(my $i=0; $i<4; $i++){
		my $parte = join('', @vec_bin[$i*8..7+$i*8]);
		$ip .= Bin2Dec($parte);
		if($i < 3){
			$ip.='.';
		}
	}

	return $ip;

}

sub Bin2MAC {

	my $bin = shift;
	my @vec_bin = split '', $bin;
	my $num_bits = scalar (@vec_bin);
	my $mac = "";

	for(my $i=0; $i<6; $i++){
		my $parte = join('', @vec_bin[$i*8..7+$i*8]);
		$mac .= sprintf("%02X", Bin2Dec($parte));
		if($i < 5){
			$mac.=':';
		}
	}

	return $mac;

}

sub Bin2Dec {
	my @bits = split('', shift);
	my $sum=0;
	my $num_bits = scalar(@bits);
	for(my $i=0; $i<$num_bits; $i++){
		$sum += (2**($num_bits-$i-1)) * ($bits[$i]);
	}

	return $sum;
}

sub Bin2Asc {

	my $bin = shift;
	my @vec_bin = split '', $bin;
	my $num_bits = scalar (@vec_bin);
	my $num_chars = $num_bits/8.0 > int($num_bits/8.0) ? int($num_bits/8.0)+1 : $num_bits/8.0;
	my $ascii = "";

	for(my $i=0; $i<$num_chars; $i++){
		my $char = join('', @vec_bin[$i*8..7+$i*8]);
		$ascii .= chr(Bin2Dec($char));
	}
	return $ascii;

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

sub printFrame {
	my $frame = shift;

	my $version = Bin2Dec(substr $frame, 0, 4);
	my $ihl = Bin2Dec(substr $frame, 4, 4);
	my $typeOfService = Bin2Dec(substr $frame, 8, 8);
	my $totalLength = Bin2Dec(substr $frame, 16, 16);
	my $identification = Bin2Dec(substr $frame, 32, 16);
	my $flags = Bin2Dec(substr $frame, 48, 3);
	my $fragmentOffset = Bin2Dec(substr $frame, 51, 13);
	my $timeToLive = Bin2Dec(substr $frame, 64, 8);
	my $protocol = Bin2Dec(substr $frame, 72, 8);
	my $headerChecksum = Bin2Dec(substr $frame, 80, 16);
	my $sourceAddress = Bin2IP(substr $frame, 96, 32);
	my $destinationAddress = Bin2IP(substr $frame, 128, 32);
	my $data = Bin2Asc(substr $frame, 160, length($frame)-160);

	print "\n";
	print "\nVERSION: $version ";
	print "\nIHL: $ihl";
	print "\nTYPE OF SERVICE: $typeOfService";
	print "\nTOTAL LENGTH: $totalLength";
	print "\nIDENTIFICATION: $identification";
	print "\nFLAGS: $flags";
	print "\nTIME TO LIVE: $timeToLive";
	print "\nPROTOCOL: $protocol";
	print "\nHEADER CHECKSUM: $headerChecksum";
	print "\nSOURCE ADDRESS: $sourceAddress";
	print "\nDESTINATION ADDRESS: $destinationAddress";
	print "\nDATA: $data";

	print "\n\nFRAME: ", $frame;
	print "\n--------------------------------------------------\n";
}

1;
