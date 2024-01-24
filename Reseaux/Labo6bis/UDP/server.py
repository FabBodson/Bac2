# coding: utf8
import socket
import ipaddress

buffersize = 2048

# create socket
s = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
# bind socket to address and port
s.bind(("0.0.0.0", 8000))

# listen for data forever and reply with "[+] Server : Send message received"
while True:
    data, (ip, port) = s.recvfrom(buffersize)
    print(f"Data from {ipaddress.IPv4Address(ip)} is : '{data.decode()}'")
    msg = str.encode("[+] Server : Send message received")
    s.sendto(msg, (ip, port))
