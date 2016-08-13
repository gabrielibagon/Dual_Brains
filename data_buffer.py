import open_bci_v3
import time
import filters
import time
import csv
import numpy as np
import open_bci_v3 as bci
import udp_server
from collections import deque

class Data_Buffer():

	def __init__(self):
		global udp
		self.udp = udp
		self.filt = filters.Filters()
		self.count = 0
		self.udp_array = []
		self.EEG = [] 
		self.mean_buffer = [0]*15
		self.HAND_HOLDING = 0


	def buffer(self,sample):
		print(self.count)
		self.filt.collect_data(sample.channel_data)
		print(len(self.filt.data_buff[0]))
		# print(self.filt.data_buff)
		if (self.count%8==0 and self.count>256):
			EEG = self.filt.filter_data()
			uv = EEG[0]
			fft = EEG[1]
			fft1 = fft[0,10:42]
			fft2 = fft[9,10:42]
			uv = self.normalize(uv)
			for chan in uv:
				self.udp_array.append(chan[0])
			for pt in fft1:
				self.udp_array.append(pt)
			for pt in fft2:
				self.udp_array.append(pt)
			# print(np.shape(send))
			# print(send)
			if (self.count>5000) and self.HAND_HOLDING == 0:
				self.HAND_HOLDING = self.hand_holding_detect(uv)
			print(self.HAND_HOLDING)
			self.udp_array.append(self.HAND_HOLDING)
			self.udp.receive(self.udp_array)
		self.count+=1

		# DATA FORMAT
		# FIRST 18 values are from the raw voltage
		# 0-5: subj 1 eeg
		# 6: subj 1 ecg
		# 7: null
		# 8-13: subj2 eeg
		# 14: subj2 ecg
		# 15: null
		# 16-2080: channels 0-5 and 8-13 fft data (129 points per channel)

	def hand_holding_detect(self,uv):
		subj1_mean = np.mean(np.square(uv[0]))

		if subj1_mean - np.mean(self.mean_buffer) < -25:
			return 1
		else:
			self.mean_buffer.popleft()
			self.mean_buffer.append(subj1_mean)
			return 0


	def normalize(self,uv):
		print(uv)
		subj1_eeg = uv[0:6]
		subj2_eeg = uv[8:14]
		ratio = np.sqrt(np.mean(np.square(subj1_eeg)) / np.mean(np.square(subj2_eeg)))
		new_subj2_eeg = ratio*subj2_eeg
		for i in range(len(subj1_eeg)):
			uv[i+8] = new_subj2_eeg[i]
		return uv


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

