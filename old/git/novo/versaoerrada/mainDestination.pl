#!/usr/bin/perl
use strict;
use warnings;

use Fisica::ReceiveFrame_v2 qw(conecta);

conecta 7890, "frame.txt", "saida.txt";


=pod
my $arquivoSaida = "saida.txt";

open(my $fh_arq, ">>", $arquivoSaida);
close $arquivoSaida;

print receiveFrame
=cut
