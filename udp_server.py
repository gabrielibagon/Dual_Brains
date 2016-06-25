"""A server that handles a connection with an OpenBCI board and serves that
data over both a UDP socket server and a WebSocket server.

Requires:
  - pyserial
  - asyncio
  - websockets
"""
import json
import pickle
import socket

class UDPServer():
  def __init__(self, ip='localhost', port=8000):
    self.ip = ip
    self.port = port
    self.server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
  def activate(self):
    print("udp_server plugin")
    print(self.args)

    if len(self.args) > 0:
      self.ip = self.args[0]
    if len(self.args) > 1:
      self.port = int(self.args[1])
    
    # init network
    print("Selecting raw UDP streaming. IP: ", self.ip, ", port: ", str(self.port))

    self.server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    print("Server started on port " + str(self.port))

  def receive(self, sample): 
    # self.send_data(json.dumps(sample))
    # print(sample.astype('str'))
    json_sample = json.dumps(sample.tolist())
    print(json_sample)
    self.send_data(json_sample)

    
  def send_data(self, data):
    print(type(data));
    self.server.sendto(data.encode(),(self.ip, self.port))
    print('sup')

  # From IPlugin: close sockets, send message to client
  def deactivate(self):
    self.server.close();

  def show_help(self):
      print("""Optional arguments: [ip [port]]
      \t ip: target IP address (default: 'localhost')
      \t port: target port (default: 12345)""")
