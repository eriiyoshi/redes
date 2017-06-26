#!/usr/bin/perl
use strict;
use warnings;

use Fisica::ReceiveFrame qw(receiveFrame);

use Fisica::SendFrame_v2 qw(sendMessage);

#print receiveFrame "frame.txt", "teste.txt";

sendMessage("127.0.0.1", 7890);
# requestTMQ
# responseTMQ
# sendMessage
