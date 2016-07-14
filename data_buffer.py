import open_bci_v3
import time
import filters
import time
import csv
import numpy as np
import open_bci_v3 as bci
import udp_server

class Data_Buffer():

	def __init__(self):
		self.filt = filters.Filters()
		self.data_buffer = []
		self.count = 0
		self.udp_packet = []

	def buffer(self,sample):
		count = 0;
		if sample and ((count%8) == 0):
			EEG = []
			EEG = self.filt.filter_data(sample.channel_data)
			send = []

			if (EEG is not None) and (count%4==0):
				uv = EEG[0]
				fft = EEG[1]
				fft1 = fft[0,10:42]
				fft2 = fft[9,10:42]

				for chan in uv:
					send.append(chan[0])
				for pt in fft1:
					send.append(pt)
				for pt in fft2:
					send.append(pt)
				print(np.shape(send))
				print(send)
				udp.receive(send)

		# DATA FORMAT
		# FIRST 18 values are from the raw voltage
		# 0-5: subj 1 eeg
		# 6: subj 1 ecg
		# 7: null
		# 8-13: subj2 eeg
		# 14: subj2 ecg
		# 15: null
		# 16-2080: channels 0-5 and 8-13 fft data (129 points per channel)
		self.count = self.count+1

def main():


	global udp
	udp = udp_server.UDPServer()

	db = Data_Buffer()
	board = bci.OpenBCIBoard(port='/dev/ttyUSB0', send=db)
	board.start_streaming(db.buffer)

	################################
	#
	# SIMULATION VERSION
	#

	# channel_data = []
	# with open('aaron_test_data/latest_trials/trial2.txt', 'r') as file:
	# 	reader = csv.reader(file, delimiter=',')
	# 	# next(file)
	# 	for j,line in enumerate(reader):
	# 		line = [x.replace(' ','') for x in line]
	# 		channel_data.append(line) #list
	# 		print(line)



	# print(len(channel_data))
	# last_time_of_program = 0
	# start = time.time()
	# for i,sample in enumerate(channel_data):
	# 	end = time.time()
	# 	#Mantain the 250 Hz sample rate when reading a file
	# 	#Wait for a period of time if the program runs faster than real time
	# 	time_of_recording = i/250
	# 	time_of_program = end-start
	# 	print('i/250 (time of recording)', time_of_recording)
	# 	print('comp timer (time of program)', time_of_program)
	# 	if time_of_recording > time_of_program:
	# 		# print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
	# 		time.sleep(time_of_recording-time_of_program)
	# 	db.buffer(sample)


if __name__ == '__main__':
	main()

