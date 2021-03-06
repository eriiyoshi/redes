use Layer;
use Functions;

print "\nFísica - Servidor\n";

my $length;
my $buffer;

my $underHost = '127.0.0.1';
my $underPortReceiver = 8002;
my $underPortSender = 8003;
my $overHost = '127.0.0.1';
my $overPortReceiver = 9004;
my $overPortSender = 9005;

if(scalar @_ == 4){
    $underPortReceiver = $_[0];
    $underPortSender = $_[1];
    $overPortReceiver = $_[2];
    $overPortSender = $_[3];
}

# $layer02 = Layer->new(1, '127.0.0.1', 8002, 8003, '127.0.0.1', 9004, 9005);
$layer02 = Layer->new(1, $underHost, $underPortReceiver, $underPortSender, $overHost, $overPortReceiver, $overPortSender);

sleep(1);

$layer02->initOverSender();

$layer02->initOverReceiver();

sleep(1);

$layer02->initUnderReceiver();

sleep(1);

$layer02->initUnderSender();

print "\n\n";
print 'Source MAC: '.$layer02->getUnderMACReceiver."\n";
print 'Source IP: '.$layer02->getUnderIPReceiver."\n";
print 'Destination MAC: '.$layer02->getUnderMACSender."\n";
print 'Destination IP: '.$layer02->getUnderIPSender."\n";

print "\n\n---------------------------\n\n";

while(1){

  $buffer = $layer02->receiveFromUnder() or last;
  Functions->printFrame($buffer);
  $buffer = Functions->getDataFromFrame($buffer);
  $layer02->sendToOver($buffer);

  $buffer = $layer02->receiveFromOver();
  my $frame = Functions->createFrame(
      $buffer,
      $layer02->getUnderMACSender,
      $layer02->getUnderMACReceiver
  );
  Functions->printFrame($frame); # printPacket
  # $buffer = "TIRIÇA"; # fromPacket
  $layer02->sendToUnder($frame);

}
$layer02->close();
