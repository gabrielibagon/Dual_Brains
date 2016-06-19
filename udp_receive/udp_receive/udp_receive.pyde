import socket

ip = "localhost"
port = 8888

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((ip,port))

while True:
  data = sock.recv(4096)
  print(data)

def setup():
    size(200,200)
    framerate(30)
def draw():
    background(data *2)
    