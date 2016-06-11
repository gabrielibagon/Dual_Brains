import open_bci_v3
import filters
import time

class Data_Buffer():

	def __init__(self):
		self.data_buffer = [] #this will hold the raw data
		self.fs_Hz = 250	#frequency in Hertz
		self.FIRST_BUFFER = True

	def buffer(self,sample):
		if sample:
			sample_string = "ID: %f\n%s\n%s" %(sample.id, str(sample.channel_data)[1:-1], str(sample.aux_data)[1:-1])
			self.data_buffer.append(sample.channel_data)
			print(type(sample.channel_data))
			filt.data_receive(sample.channel_data)

def main():
	port = '/dev/ttyUSB0'
	db = Data_Buffer()
	global filt
	filt = filters.Filters()
	board = open_bci_v3.OpenBCIBoard(port=port)
	board.start_streaming(db.buffer)

if __name__ == '__main__':
	main()

