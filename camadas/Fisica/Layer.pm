package Layer;

use IO::Socket::INET;

use strict;
use warnings;

use LayerSocket;

use Exporter qw(import);

our @EXPORT_OK = qw/.*/;

my $server1client2;

my $underHost;
my $underPortReceiver;
my $underPortSender;
my $overHost;
my $overPortReceiver;
my $overPortSender;

my $over;
my $under;

sub new() {
        my $type = $_[0];

        $server1client2 = $_[1];
        $underHost = $_[2];
        $underPortReceiver = $_[3];
        $underPortSender = $_[4];
        $overHost = $_[5];
        $overPortReceiver = $_[6];
        $overPortSender = $_[7];

# TODO: Criar LayerUnder e LayerOver: Não podem ser usados dois objetos da mesma classe
# Classes serao iguais, mas representarao instancias diferentes

        my $self = {
          server1client2 => $server1client2,
          underHost => $underHost,
          underPortReceiver => $underPortReceiver,
          underPortSender => $underPortSender,
          overHost => $overHost,
          overPortReceiver => $overPortReceiver,
          overPortSender => $overPortSender
        };

        $self->{under} = LayerSocket->new(1, $underHost, $underPortReceiver, $underPortSender);
        $self->{over} = LayerSocket->new(2, $overHost, $overPortReceiver, $overPortSender);

        #$over = LayerSocket->new(2, $overHost, $overPortReceiver, $overPortSender);
# Descomentar linha acima

        #if($server1client2 == 1){
        #  $under = LayerSocket->new(1, $underHost, $underPortReceiver, $underPortSender);
        #  $over = LayerSocket->new(2, $overHost, $overPortReceiver, $overPortSender);
        #}
        #else{
        #  $under = LayerSocket->new(2, $underHost, $underPortReceiver, $underPortSender);
        #  $over = LayerSocket->new(1, $overHost, $overPortReceiver, $overPortSender);
        #}
        return bless $self, $type;
}

sub sendToOver() {
        my($self) = @_;

        my $message = $_[1];
        return $self->{over}->send($message);
}

sub receiveFromOver() {
        my($self) = @_;

        return $self->{over}->receive();
}

sub sendToUnder() {
        my($self) = @_;
        my $message = $_[1];
        return $self->{under}->send($message);
}

sub receiveFromUnder() {
        my($self) = @_;
        return $self->{under}->receive();
}

sub close() {
        my($self) = @_;
        $self->{over}->close();
        $self->{under}->close();
}

sub closeUnderSender() {
        my($self) = @_;
        $self->{under}->close();
}

sub closeOverSender() {
        my($self) = @_;
        $self->{over}->close();
}

sub getOverPortSender() {
        my($self) = @_;
        return $overPortSender;
}

sub getUnderPortSender() {
        my($self) = @_;
        return $underPortSender;
}

sub getOverPortReceiver() {
        my($self) = @_;
        return $overPortReceiver;
}

sub getUnderPortReceiver() {
        my($self) = @_;
        return $underPortReceiver;
}

sub getOverIPReceiver() {
        my($self) = @_;
        return $self->{over}->getDestinationIP;
}

sub getUnderIPReceiver() {
        my($self) = @_;
        return $self->{under}->getDestinationIP;
}

sub getOverIPSender() {
        my($self) = @_;
        return $self->{over}->getSourceIP;
}

sub getUnderIPSender() {
        my($self) = @_;
        return $self->{under}->getSourceIP;
}

sub getOverMACReceiver() {
        my($self) = @_;
        return $self->{over}->getDestinationMAC;
}

sub getUnderMACReceiver() {
        my($self) = @_;
        return $self->{under}->getDestinationMAC;
}

sub getOverMACSender() {
        my($self) = @_;
        return $self->{over}->getSourceMAC;
}

sub getUnderMACSender() {
        my($self) = @_;
        return $self->{under}->getSourceMAC;
}

sub initReceivers() {
        my($self) = @_;
        $self->{under}->initReceiver();
        $self->{over}->initReceiver();
}

sub initSenders() {
        my($self) = @_;
        $self->{under}->initSender();
        sleep(4);
        $self->{over}->initSender();
}

sub initUnderReceiver(){
        my($self) = @_;
        $self->{under}->initReceiver();
}

sub initOverReceiver(){
        my($self) = @_;
        $self->{over}->initReceiver();
}

sub initUnderSender(){
        my($self) = @_;
        $self->{under}->initSender();
}

sub initOverSender(){
        my($self) = @_;
        $self->{over}->initSender();
}

1;
