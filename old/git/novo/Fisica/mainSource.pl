use Sending;
use Receiving;
#Sending::connect "127.0.0.1", 7890;

my $arqEntrada = "sender/arquivo.bin";
my $arqFrame = "sender/sframe";
my $destinationAddress = "127.0.0.1";
my $port = 7890;
my $arqTMQ = "sender/rtmq";
my $arqVazio = "sender/vazio";
my $tmq;

open my $fhVazio, ">", $arqVazio;
close $fhVazio;

Sending::requestTMQ $arqVazio, $arqFrame, $destinationAddress, $port;

$tmq = Receiving::receiveMessageTMQ $port+1, $arqFrame, $arqTMQ;

print "Recebeu TMQ";

sleep 1;

Sending::sendMessage $arqEntrada, $arqFrame, $destinationAddress, $port, $tmq;
