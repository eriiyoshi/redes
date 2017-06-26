#Example 1:
#
#  This is an example of the minimal data carrying internet datagram:
#    0                   1                   2                   3
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |Ver= 4 |IHL= 5 |Type of Service|        Total Length = 21      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |      Identification = 111     |Flg=0|   Fragment Offset = 0   |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |   Time = 123  |  Protocol = 1 |        header checksum        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                         source address                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                      destination address                      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |     data      |
#   +-+-+-+-+-+-+-+-+

$version = "0100"; #4
$ihl = "0101"; #5
$typeOfService = "00000000"; #0, mas pode variar
$totalLength = "0000000000010101"; #21 (20 de cabecalho + dados)
$identification = "0000000001101111"; #111
$flags = "000"; #0
$fragmentOffset = "0000000000000"; #varia
$timeToLive = "01111011"; #123
$protocol = "00000110"; #1 ou 6
$headerChecksum = "0000000000000000"; #varia, mas foi assumido que não será necessário tratar checksum
$sourceAddress = "110000001010100000000000000000001"; #varia
$destinationAddress = "110000001010100000000000000000010"; #varia

$frame = $version . $ihl . $typeOfService . $totalLength . $identification;
$frame .= $flags . $fragmentOffset . $timeToLive . $protocol;
$frame .= $headerChecksum . $sourceAddress . $destinationAddress;

open(my $fh, ">",  "frame.txt");
print $fh $frame;