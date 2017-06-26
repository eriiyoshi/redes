#!/bin/bash

ip=$1

ping $ip -c 1 > /dev/null
mac=$(arp -a | grep $ip | cut -d' ' -f4) # recupera mac address
iface=$(route | grep default | sed -r "s/^.* //") # recupera interface
mac_gateway=$(ifconfig | grep $iface | sed "s/.*HWaddr //") # recupera mac address do gateway

if [ -z $mac ]; then
	mac=$mac_gateway
fi

echo -n $mac
