use Layer;
use Functions;

my $length;
my $buffer;

my $underHost = '127.0.0.1';
my $underPortReceiver = 8003;
my $underPortSender = 8002;
my $overHost = '127.0.0.1';
my $overPortReceiver = 8004;
my $overPortSender = 8005;

if(scalar @_ == 4){
    $underPortReceiver = $_[0];
    $underPortSender = $_[1];
    $overPortReceiver = $_[2];
    $overPortSender = $_[3];
}

# $layer01 = Layer->new(2, '127.0.0.1', 8003, 8002, '127.0.0.1', 8005, 8004);
$layer01 = Layer->new(2, $underHost, $underPortReceiver, $underPortSender, $overHost, $overPortReceiver, $overPortSender);

sleep(1);

$layer01->initOverSender();

$layer01->initOverReceiver();

sleep(1);

$layer01->initUnderSender();

$layer01->initUnderReceiver();

print "\n\n";
print 'Source MAC: '.$layer01->getUnderMACReceiver."\n";
print 'Source IP: '.$layer01->getUnderIPReceiver."\n";
print 'Destination MAC: '.$layer01->getUnderMACSender."\n";
print 'Destination IP: '.$layer01->getUnderIPSender."\n";

sleep(3);

#$length = $layer01->sendToUnder("Mensagem 01");
$length = $layer01->sendToUnder(
              Functions->createFrame(
                  "Mensagem 01",
                  $layer01->getUnderMACSender,
                  $layer01->getUnderMACReceiver));

#$length = $layer01->sendToOver("Mensagem 02");

$layer01->close();
