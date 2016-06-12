import open_bci_v3
import time
import filters
import tkinter

class Data_Buffer():

	def __init__(self, root):

		#instantiate EEG and ECG lists for subj1 and subj2
		self.subj1_EEG = []
		self.subj1_ECG = []
		self.subj2_EEG = []
		self.subj2_ECG = []

		self.data_buffer = [] #this will hold the raw data
		self.fs_Hz = 250	#frequency in Hertz
		self.FIRST_BUFFER = True

		self.root = root

	def buffer(self,sample):
		if sample:
			sample_string = "ID: %f\n%s\n%s" %(sample.id, str(sample.channel_data)[1:-1], str(sample.aux_data)[1:-1])
			self.data_buffer.append(sample.channel_data)

			# DATA COLLECTION INTO BUFFER
			# subject 1
			self.subj1_EEG.append(sample.channel_data[0:6])
			self.subj1_ECG.append(sample.channel_data[6:9])
			# subject 2
			self.subj2_EEG.append(sample.channel_data[8:14])
			self.subj2_ECG.append(sample.channel_data[14:17])
			print('huh')
			filt.data_receive(sample.channel_data, self.root)

def main():
	port = '/dev/ttyUSB0'
	root = tkinter.Tk()
	db = Data_Buffer(root)
	global filt
	filt = filters.Filters(root)
	board = open_bci_v3.OpenBCIBoard(port=port)
	board.start_streaming(db.buffer)

if __name__ == '__main__':
	main()

