# coding: utf8
import socket
import ipaddress

buffersize = 2048

# create socket
s = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)  # create bytes object
msg = str.encode("Hello")

# send message
print(f"[+] Client is sending a message: '{msg.decode()}' ...")
# s.sendto(msg, ("localhost", 8000))
# If server is Kali Linux:
s.sendto(msg, ("192.168.254.5", 8000))

# read message
data, (ip, port) = s.recvfrom(buffersize)
print(f"[+] Client has received data from {ipaddress.IPv4Address(ip)}, it is: {data.decode()}")
