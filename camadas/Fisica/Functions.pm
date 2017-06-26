package Functions;

use IO::Socket::INET;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw/.*/;

my $LIMIT = 4000;

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
	my @partes = split(':', $_[0]);
	foreach my $parte (@partes){
		$bin = $bin . Dec2Bin(hex($parte));
	}
	return $bin;

}

#sub Dec2Bin {
#  return sprintf ("%08b", shift);
#}
sub Dec2Bin {
  my $nParams = @_;
  my $string = "%08b";
  if($nParams == 2){
    $string = "%0".$_[1]."b";
  }

  return sprintf ($string, shift);
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
	my $frame = $_[1];
  my $dataLength = length($frame)-176-32;

	my $preamble = substr $frame, 0, 64; #Bin2Dec(substr $frame, 0, 64);
	my $destinationMAC = Bin2MAC(substr $frame, 64, 48);
	my $sourceMAC = Bin2MAC(substr $frame, 112, 48);
	my $etherType = Bin2Dec(substr $frame, 160, 16);
	my $data = Bin2Asc(substr $frame, 176, $dataLength);
	my $fcs = Bin2Dec(substr $frame, 176+$dataLength, 32);

	print "\n";
	print "\nPREAMBLE: $preamble ";
	print "\nDESTINATION MAC ADDRESS: $destinationMAC";
  print "\nSOURCE MAC ADDRESS: $sourceMAC";
	print "\nTYPE/LENGTH: $etherType";
	print "\nDATA: $data";
	print "\nFCS: $fcs";

	print "\n\nFRAME: ", $frame;
	print "\n\n";
}

sub createFrame {
  # https://wiki.wireshark.org/Ethernet
  my $dataFrame = $_[1];
  my $dMAC = $_[2];
  my $sMAC = $_[3];
  my $dataLength = length($dataFrame);

	my $preamble = '1010101010101010101010101010101010101010101010101010101010101011';
	my $destinationMAC = MAC2Bin($dMAC);
	my $sourceMAC = MAC2Bin($sMAC);
	my $etherType = Dec2Bin($dataLength, 16);
	my $data = Asc2Bin($dataFrame);
	my $fcs = '00000000000000000000000000000000';

  my $frame = $preamble.$destinationMAC.$sourceMAC.$etherType.$data.$fcs;

	return $frame;
}

1;
