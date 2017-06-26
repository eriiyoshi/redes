use Receiving;

my $port = 7890;

my $arqFrame = "receiver/rframe";
my $arqTMQ = "receiver/tmq";
my $arqSaida = "receiver/saida.bin";
my $tmq = 10;

Receiving::receiveMessage $port, $arqFrame, $arqTMQ, $arqSaida, $tmq;
