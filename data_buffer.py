import open_bci_v3
import time
from collections import deque

class Data_Buffer():

	def __init__(self):
		self.data_buffer = deque([]) #this will hold the raw data
		print(type(self.data_buffer))
		self.fs_Hz = 250	#frequency in Hertz
		self.FIRST_BUFFER = True

	def buffer(self,sample):
		print(self.data_buffer)
		print('freq',self.fs_Hz)
		if sample:
			print(type(self.data_buffer))			
			print('before',self.data_buffer)
			sample_string = "ID: %f\n%s\n%s" %(sample.id, str(sample.channel_data)[1:-1], str(sample.aux_data)[1:-1])
			self.data_buffer.append(sample.channel_data)

def main():
	port = '/dev/ttyUSB0'
	db = Data_Buffer()
	filters = Filters()
	board = open_bci_v3.OpenBCIBoard(port=port)
	board.start_streaming(db.buffer)

if __name__ == '__main__':
	main()

