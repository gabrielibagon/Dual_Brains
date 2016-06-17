import socket

ip = "127.0.0.1"
port = 888

sock = socket.socket(socket.AF_INET, socket.sock_DGRAM)
sock.bind((ip,port))

while True:
  data, addr = sock.recvbfrom(1024)
  print(data)