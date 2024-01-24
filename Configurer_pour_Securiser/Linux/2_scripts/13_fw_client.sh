#!/bin/bash

INTERNAL_NETWORK=192.168.131.0/24
DEVICE_IF=ens33
MY_IP=192.168.131.16

FTP_PORTS=63000:63500


# Effacer toutes les règles afin de ne créer que celles qu'on veut
iptables -t nat -F
iptables -t nat -X
iptables -F
iptables -X


## INPUT
iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -i $DEVICE_IF -p tcp --destination-port 22 -j ACCEPT

iptables -A INPUT -i $DEVICE_IF -p tcp -m multiport --dports $FTP_PORTS -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j LOG
iptables -A INPUT -j DROP


## FORWARD
iptables -P FORWARD DROP

## OUTPUT
iptables -P OUTPUT ACCEPT

service iptables save



