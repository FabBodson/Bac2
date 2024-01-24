# coding: utf8
import socket

buffersize = 16777216

sender_mail = "fa.bodson@student.helmo.be"
sender_name = "Hacker "
receiver_mail = "fabbodson28@gmail.com"
receiver_name = "Fabrice Bodson"
subject = "Test mail"
message = "Test mail"


# create socket
client = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)

# connect to server
ipv4 = socket.gethostbyname("relay.proximus.be")
port = 25
client.connect((ipv4, port))

print(f"You are connected to '{ipv4}:25'")


# send message
data = client.recv(buffersize)
print(data.decode())

if data[0:3].decode() == "220":
    client.sendto(str.encode("EHLO mail_server_helmo.home\n"), (ipv4, 25))
    print("EHLO mail_server_helmo.home")

    data = client.recv(buffersize)
    print(data.decode())

    if data[0:3].decode() == "250":
        client.sendto(str.encode(f"MAIL FROM:<{sender_mail}>\n"), (ipv4, 25))
        print(f"MAIL FROM:<{sender_mail}>")

        data = client.recv(buffersize)
        print(data.decode())

        if data[0:3].decode() == "250":
            client.sendto(str.encode(f"RCPT TO:<{receiver_mail}>\n"), (ipv4, 25))
            print(f"RCPT TO:<{receiver_mail}>")

            data = client.recv(buffersize)
            print(data.decode())

            if data[0:3].decode() == "250":
                client.sendto(str.encode("DATA\n"), (ipv4, 25))
                print("DATA")

                data = client.recv(buffersize)
                print(data.decode())

                if data[0:3].decode() == "354":
                    client.sendto(str.encode("Date: Sat, 27 Mar 21 14:12\n"), (ipv4, 25))
                    print("Date: Sat, 27 Mar 21 14:1")

                    client.sendto(str.encode(f"From: {sender_name} <{sender_mail}>\n"), (ipv4, 25))
                    print(f"From: {sender_name} <{sender_mail}>")

                    client.sendto(str.encode(f"To: {receiver_name} <{receiver_mail}>\n"), (ipv4, 25))
                    print(f"To: {receiver_name} <{receiver_mail}>")

                    client.sendto(str.encode(f"Subject: {subject}\n"), (ipv4, 25))
                    print(f"Subject: {subject}")

                    client.sendto(str.encode(f"{message}\n"), (ipv4, 25))
                    print(f"{message}")

                    client.sendto(str.encode(".\n"), (ipv4, 25))
                    print(".")

                    data = client.recv(buffersize)
                    if data[0:3].decode() == "250":
                        client.sendto(str.encode("quit\n"), (ipv4, 25))
                        print("quit")

# close connection
client.close()
print('Connection closed')
