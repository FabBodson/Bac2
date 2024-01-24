UNTRUST_IP=192.168.190.102
UNTRUST_IF=ens33

TRUST_NET=192.168.131.0/24
TRUST_IF=ens36
SERVER1_IP=192.168.131.15

SERVER1_TCP=22,53
SERVER1_TCP_TRUST2UNTRUST=80,443
SERVER1_UDP=53

ICMP=192.190.190.0/24

iptables -t nat -F
iptables -t nat -X
iptables -F
iptables -X

iptables -N untrust2fw
iptables -N fw2untrust
iptables -N fw2trust
iptables -N trust2fw
iptables -N untrust2trust
iptables -N trust2untrust

# firewall => trust
iptables -A fw2trust -j ACCEPT

# firewall => untrust
iptables -A fw2untrust -j ACCEPT

# trust => untrust
iptables -A trust2untrust -p tcp -d $UNTRUST_IP -m multiport --dports $SERVER1_TCP_TRUST2UNTRUST -j ACCEPT
iptables -A trust2untrust -p udp -d $UNTRUST_IP -m multiport --dports $SERVER1_UDP -j ACCEPT
iptables -A trust2untrust -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A trust2untrust -j LOG
iptables -A trust2untrust -j DROP

# untrust => trust
iptables -A untrust2trust -j LOG
iptables -A untrust2trust -j DROP

# untrust => fw
iptables -A untrust2fw -p tcp -d $UNTRUST_IP -m multiport --dports $SERVER1_TCP -m state --state NEW -j ACCEPT
iptables -A untrust2fw -p udp -d $UNTRUST_IP -m multiport --dports $SERVER1_UDP -j ACCEPT
iptables -A untrust2fw -i $UNTRUST_IF -s $ICMP -p icmp -j ACCEPT
iptables -A untrust2fw -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A untrust2fw -j LOG
iptables -A untrust2fw -j DROP

# trust => fw
iptables -A trust2fw -j ACCEPT

## NAT rules
iptables -t nat -A PREROUTING -i ens33 -d 192.168.190.102 -p tcp --destination-port 4022 -j DNAT --to-destination 192.168.131.15:4022
iptables -t nat -A POSTROUTING -s $TRUST_NET -j MASQUERADE

## Distribution rules
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
