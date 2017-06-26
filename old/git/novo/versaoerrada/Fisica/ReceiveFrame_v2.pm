#!/usr/bin/perl

package Fisica::ReceiveFrame_v2;

use strict;
use IO::Socket::INET;

use Exporter qw(import);

use Fisica::ReceiveFrame qw(receiveFrame);

our @EXPORT_OK = qw(conecta);

sub conecta {

  my $port = shift || die "[!] No port given...\n";;  ##  Value given from terminal

  my $frame = shift;
  my $saida = shift;

  my $server = IO::Socket::INET->new(
     Listen => 5,
     LocalPort => $port,
     Proto     => 'tcp'
  ) or die "Can't create server socket: $!";

  while(1){
    my $client = $server->accept;

#    my $fileOut='temp.txt';
    open(my $fhTemp, '+>', $saida) or die "Cannot open file '$saida' for writing$!";
    while (<$client>) {
       print $fhTemp $_;
    }

    receiveFrame $frame, $saida;

    my $fileOut='saida.txt';
    open(my $fhO, '+>', $fileOut) or die "Cannot open file '$fileOut' for writing$!";

    read( $fhTemp, my $buffer, 4000, 160);

    while (<$buffer>) {
       print $fhO $_;
    }
    close $fhO;
  }
}

1;
