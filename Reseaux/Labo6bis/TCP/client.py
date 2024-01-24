# coding: utf8
import socket

buffersize = 2048

# create socket
client = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)

# connect to server
# ipv4 = "localhost"    # if server is MacBook
ipv4 = "192.168.254.5"  # If server is Kali
port = 8000
# port = 8080 # Port exercise 4.5
client.connect((ipv4, port))

print(f"Client is connected to '{ipv4}:8000'")

# create 'bytes' objects
msg = str.encode("I am the client")

# send message
client.send(msg)

# read message
data = client.recv(buffersize)

# close connection
client.close()

print(f"[+] Client has received data from connected server: '{data.decode()}'")
