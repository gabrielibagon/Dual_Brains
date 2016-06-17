import socket

ip = "localhost"
port = 8888

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((ip,port))

while True:
  data = sock.recv(1024)
  print(data)