################################################
# 		IMPLEMENTACAO DA CAMADA FISICA		   #
# 	6o Periodo/2017 - Eng Computacao		   #
#	Erica Yoshiwara 201212040180			   #
#	Gustavo Jordao 201212040520				   #
#	Lais Ribeiro 201212040040				   #
#	Lucas Teodoro 201112040501				   #
################################################

package Fisica::Functions;

use IO::Socket::INET;

use strict;
#use 5.010;

use Exporter qw(import);

our @EXPORT_OK = qw(Dec2Bin Bin2Asc Bin2Dec IP2Bin ip2bin2 Asc2Bin
					Rand_Colisions GetMac_Mac2Bin);

sub Dec2Bin {
	#Converter decimal para binario:
	my $bin = sprintf("%b", shift);

	return $bin;
}

sub Bin2Dec {
    #return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
		my @subBinary = @_;

		my $sum =0;
		for(my $j=0; $j<$#subBinary+1; $j++){
			$sum += $subBinary[$#subBinary-$j]*(2**$j);
		}

		return $sum;

}

sub Bin2Asc {

		#Convert binary to asc
		my @data = @_;
		my $chars = $#data+1;
		my $num_bytes = $chars/8.0 > int($chars/8.0) ? $chars/8.0+1 : $chars/8.0;

		my @array = ();

		for(my $i=0; $i<$num_bytes; $i++){

			my @subBinary = @data[$i*8..7+$i*8];
			push @array, chr(Bin2Dec(@subBinary));
		}

		return @array;

}

sub ip2bin2 {
	my ($ip, $delimiter) = @_;
    return     join($delimiter,  map
        substr(unpack("B32",pack("N",$_)),-8),
        split(/\./,$ip));
}

sub Asc2Bin {
	my $file_path = 'Arquivo_entrada.txt';#shift=Arquivo_entrada.txt
	open (my $fh, '<:encoding(UTF-8)', $file_path) or die "Cannot open file '$file_path' for reading";

	my $fileOut = 'Arquivo_entrada_bin.txt';#shift=Arquivo_entrada_bin.txt
	open(my $fhO, '+>', $fileOut) or die "Cannot open file '$file_path' for writing$!";

	while (my $row = <$fh>) {
		(my $out = $row) =~ s/(.)/unpack 'B8', $1/eg;
		print $fhO $out;
	}
	close$fhO;
	close$fh;
}

sub GetMac_Mac2Bin {
	my $mac = `ifconfig | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'`;
	print $mac;

	for(my $i=0; $i<4; $i++){
		$mac=~ s/\://;
	}

	my %h2b = (0 => "0000", 1 => "0001", 2 => "0010", 3 => "0011",
	4 => "0100", 5 => "0101", 6 => "0110", 7 => "0111",
	8 => "1000", 9 => "1001", a => "1010", b => "1011",
	c => "1100", d => "1101", e => "1110", f => "1111",
	);

	my $hex = $mac;
	(my $binMac = $hex) =~ s/(.)/$h2b{lc $1}/g;
	return $binMac;
}

sub Rand_Colisions {

	my $colision= 1 + int rand(50);

	if ( ($colision>=20) && ($colision<=30) ) {
		return 1;
	}
	else{
		return 0;
	}
}

=pod
sub IP2Bin {
		my $ip = '';
		my @ip_partes = split('.', shift);
		my $i;

		for($i=0; $i<4; $i++){
			$ip .= sprintf("%04b", $ip_partes[$i]);
		}

		return $ip;
}
=cut
1;
