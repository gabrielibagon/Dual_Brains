"""A server that handles a connection with an OpenBCI board and serves that
data over both a UDP socket server and a WebSocket server.

Requires:
  - pyserial
  - asyncio
  - websockets
"""
import json
import socket
import numpy as np

class UDPServer():
  def __init__(self, ip='localhost', port=6100):
    self.ip = ip
    self.port = port
    self.server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # self.logging.raiseExceptions = False

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
    # print(type(sample))
    # sample = np.asarray(sample,dtype='int')
    # print(np.shape(sample))
    if type(sample) is list:
      # print("meep")
      json_sample = json.dumps(sample)
    else:
      # print("beep")
      json_sample = json.dumps(sample.tolist())
    # print(json_sample)
    self.send_data(json_sample)

    
  def send_data(self, data):
    # print(type(data));
    try:
      self.server.sendto(data.encode(),(self.ip, self.port))
    except Exception as e:
      print(e)
      print('sup')

  # From IPlugin: close sockets, send message to client
  def deactivate(self):
    self.server.close();

  def show_help(self):
      print("""Optional arguments: [ip [port]]
      \t ip: target IP address (default: 'localhost')
      \t port: target port (default: 12345)""")
