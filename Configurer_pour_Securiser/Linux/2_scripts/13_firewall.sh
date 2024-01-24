#!/bin/bash
UNTRUST_NET=192.168.190.0/24
UNTRUST_IP=192.168.190.30
UNTRUST_IF=ens33

TRUST_NET=192.168.131.0/24
TRUST_IF=ens36
CLIENT_IP=192.168.131.16

TCP_PORTS=22,53
UDP_PORTS=53

TRUST_TCP_PORTS=80,443

# Effacer toutes les règles afin de ne créer que celles qu'on veut
iptables -t nat -F
iptables -t nat -X
iptables -F
iptables -X

# Création des points d'inspections qui m'intéressent
iptables -N trust2untrust
iptables -N trust2fw
iptables -N untrust2fw
iptables -N untrust2trust
iptables -N fw2trust
iptables -N fw2untrust


### Exercice A ###

# J'accepte le trafic trust2untrust
iptables -A trust2untrust -j ACCEPT

# Autorise la translation d'adresse pour le trafic sortant du réseau interne
iptables -t nat -A POSTROUTING -s $TRUST_NET -j MASQUERADE

##################
#
#
#
### Exercice B ###

# Autorise le trafic utilisant le protocole TCP dont le port destination est le 22 (SSH) ou le 53 (DNS)
iptables -A untrust2fw -p tcp --destination-port 4022 -j ACCEPT
iptables -A untrust2fw -p tcp --destination-port 53 -j ACCEPT

# Autorise le trafic utilisant le protocole UDP dont le port destination est le 53 (DNS)
iptables -A untrust2fw -p udp --destination-port 53 -j ACCEPT

# Autorise le trafic utilisant le protocole ICMP dont la source vient du réseau untrust (192.168.190.0/24)
iptables -A untrust2fw -p icmp -s $UNTRUST_NET -j ACCEPT

# Autorise le trafic qui serait une réponse à une requete précédemment envoyée
iptables -A untrust2fw -m state --state ESTABLISHED,RELATED -j ACCEPT

# Si le trafic ne rempli pas la condition d'avant, il est journalisé puis droppé
iptables -A untrust2fw -j LOG
iptables -A untrust2fw -j DROP

##################
#
#
#
### Exercice C ###

# Autorise le trafic utilisant les protocoles TCP/UDP sur les ports 53,80 et 443 à sortir
iptables -A trust2untrust -p tcp -m multiport --dports $TRUST_TCP_PORTS -j ACCEPT
iptables -A trust2untrust -p udp -m multiport --dports $UDP_PORTS -j ACCEPT

# Autorise le trafic qui serait une réponse à une requete précédemment envoyée
iptables -A trust2untrust -m state --state ESTABLISHED,RELATED -j ACCEPT

# Si le trafic ne rempli pas la condition d'avant, il est journalisé puis droppé
iptables -A trust2untrust -j LOG
iptables -A trust2untrust -j DROP

##################
#
#
#
### Exercice D ###

# Autorise trafic TCP sur le port 4022 (SSH) et le redirige vers la machine client
iptables -t nat -A PREROUTING -i $UNTRUST_IF -d $UNTRUST_IP -p tcp --destination-port 4022 -j DNAT --to-destination $CLIENT_IP:22
iptables -A untrust2trust -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A untrust2trust -p tcp --destination-port 22 -j ACCEPT
iptables -A untrust2trust -j LOG
iptables -A untrust2trust -j DROP

##################

iptables -A trust2fw -j ACCEPT
iptables -A fw2trust -j ACCEPT
iptables -A fw2untrust -j ACCEPT


iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -i $UNTRUST_IF -j untrust2fw
iptables -A INPUT -i $TRUST_IF -j trust2fw
iptables -A INPUT -j LOG
iptables -A INPUT -j DROP

iptables -A FORWARD -i $UNTRUST_IF -o $TRUST_IF -j untrust2trust
iptables -A FORWARD -i $TRUST_IF -o $UNTRUST_IF -j trust2untrust
iptables -A FORWARD -j LOG
iptables -A FORWARD -j DROP

iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -o $UNTRUST_IF -j fw2untrust
iptables -A OUTPUT -o $TRUST_IF -j fw2trust 
iptables -A OUTPUT -j LOG
iptables -A OUTPUT -j DROP


service iptables save
