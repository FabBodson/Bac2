# coding: utf8
import socket
import ipaddress

buffersize = 2048

# create socket
server = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)

# bind socket to address and port
server.bind(("0.0.0.0", 8000))

# wait for connections
server.listen(0)

# accept connections forever
while True:
    accepted_connection, (ip, port) = server.accept()
    print(f"Server is connected to {ipaddress.IPv4Address(ip)}:{port}")

    # listen to data and reply with "Message received"
    while True:
        data = accepted_connection.recv(buffersize)
        # Client finished to send message
        if not data:
            break
        print(f"[+] Data received: '{data.decode()}'\n")
        msg = str.encode("Server has received the message")
        accepted_connection.send(msg)
    # close connection
    accepted_connection.close()
