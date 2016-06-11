import open_bci_v3
import time

def printer(sample):
	if sample:
		sample_string = "ID: %f\n%s\n%s" %(sample.id, str(sample.channel_data)[1:-1], str(sample.aux_data)[1:-1])
		print("---------------------------------")
		print(sample_string)
		print("---------------------------------")

port = '/dev/ttyUSB0'
board = open_bci_v3.OpenBCIBoard(port=port)
print('wowowowo')
print('test')
board.start_streaming(printer)