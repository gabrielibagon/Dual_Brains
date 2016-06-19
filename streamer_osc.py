# requires pyosc
from OSC import OSCClient, OSCMessage
import pickle

# Use OSC protocol to broadcast data (UDP layer), using "/openbci" stream. (NB. does not check numbers of channel as TCP server)

class StreamerOSC():
	"""

	Relay OpenBCI values to OSC clients

	Args:
	  port: Port of the server
	  ip: IP address of the server
	  address: name of the stream
	"""
	    
	def __init__(self, ip='localhost', port=12345, address="/openbci"):
		# connection infos
		self.ip = ip
		self.port = port
		self.address = address
		# init network
		# print "Selecting OSC streaming. IP: ", self.ip, ", port: ", self.port, ", address: ", self.address
		self.client = OSCClient()
		self.client.connect( (self.ip, self.port) )

	# send channels values
	def osc_send(self, sample):
		mes = OSCMessage(self.address)
		# sample = [elem.strip().split(',') for elem in sample]
		mes.append(pickle.dumps(sample))
		# silently pass if connection drops
		try:
			self.client.send(mes)
		except:
			return