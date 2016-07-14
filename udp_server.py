import json
import socket
import numpy as np

class UDPServer():
  def __init__(self, ip='localhost', port=6100):
    self.ip = ip
    self.port = port
    self.server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

  def receive(self, sample): 
    if type(sample) is list:
      json_sample = json.dumps(sample)
    else:
      json_sample = json.dumps(sample.tolist())
    self.send_data(json_sample)

    
  def send_data(self, data):
    try:
      self.server.sendto(data.encode(),(self.ip, self.port))
    except Exception as e:
      print(e)
      print('sup')