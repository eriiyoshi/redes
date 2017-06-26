package LayerSocket;

use IO::Socket::INET;
use Functions;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw/.*/;

my $server1client2;

my $ipOther;

my $portReceiver;
my $portSender;

my $socketReceiver;
my $socketSender;

my $socketClient;

my $LIMIT = 4000;

sub new() {
        my $type = $_[0];

        $server1client2 = $_[1];
        $ipOther = $_[2];
        $portReceiver = $_[3];
        $portSender = $_[4];

        my $self = {
          server1client2 => $server1client2,
          ipOther => $ipOther,
          portReceiver => $portReceiver,
          portSender => $portSender
        };

        $self->{macOther} = `./getmac.sh $ipOther`;
        $self->{ipThis} = Functions->get_local_ip_address;
        $self->{macThis} = `./getmac.sh $self->{ipThis}`;

        #print "Porta de envio ".$portSender."\n";
        #if($server1client2 == 1){
        #    initReceiver();
        #}
        #else{
        #    initSender();
        #}
        #print "Concluido\n";

        return bless $self, $type;
}

sub getDestinationIP {
        my($self) = @_;
        return $self->{ipOther};
}

sub getSourceIP {
        my($self) = @_;
        return $self->{ipThis};
}

sub getDestinationMAC {
        my($self) = @_;
        return $self->{macOther};
}

sub getSourceMAC {
        my($self) = @_;
        return $self->{macThis};
}

sub initReceiver() {
        my($self) = @_;
        print "Inicializando recebimento para porta ". $self->{portReceiver} ."\n";
        $|=1;
        $self->{socketReceiver} = IO::Socket::INET->new(
          LocalPort => $self->{portReceiver},
          Listen => 5,
          Proto => 'tcp',
          Timeout	=> 3600
        ) or print $!;

        $self->{socketClient} = $self->{socketReceiver}->accept() or die $!;
        print 'Concluido'."\n";
}

sub initSender() {
        my($self) = @_;
        #$ipOther = "192.168.25.198";
        print "Inicializando envio para porta ". $self->{ipOther}.':'.$self->{portSender} ."\n";

        $|=1;
        $self->{socketSender} = IO::Socket::INET->new(
          PeerAddr => $self->{ipOther},
          PeerPort => $self->{portSender},
          Proto    => 'tcp',
          Timeout	=> 3600
        ) or die $!; #print 'Deu errado';
        print 'Concluido'."\n";

}

sub receive() {
        my($self) = @_;
        my $bytes;

        $self->{socketClient}->recv($bytes, $LIMIT);

        print "===============================\n";
        print "Recebidos " . length($bytes) . " bytes na porta " . $self->{portReceiver} . "\n";

        return $bytes;
}

sub send() {
        my($self) = @_;
        my $bytes = $_[1];

        if($self->{socketSender}->send($bytes)){
          print "==============================" . "\n";
          print "Enviados ". length($bytes) . " bytes pela porta " . $self->{portSender} . "\n";
        }
        return length($bytes);
}

sub close() {
        my($self) = @_;
        $self->{socketSender}->close();
        $self->{socketReceiver}->close();
}

1;
