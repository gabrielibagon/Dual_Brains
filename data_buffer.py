import open_bci_v3
import time
import filters
import time
import csv
import numpy as np
import ecg_analysis
import open_bci_v3 as bci
import udp_server

class Data_Buffer():

	def __init__(self):
		#subj1 objects
		global filt_subj1
		filt = filters.Filters()
		#subj2 objects
		# global filt_subj2
		# filt_subj2 = filters.Filters()

		#instantiate EEG and ECG lists for subj1 and subj2
		self.subj1_EEG = []
		self.subj1_ECG = []
		self.subj2_EEG = []
		self.subj2_ECG = []

		self.data_buffer = [] #this will hold the raw data

		self.count = 0

		self.udp_packet = []


	def buffer(self,sample):
		count = 0;
		if sample and ((count%20) == 0):
			# SUBJECT 1
			## EEG DATA
			### Filtered
			# subj1_EEG = filt_subj1.filter_data(sample.channel_data[1:7]) #real data
			EEG = []
			EEG = filt.filter_data(sample.channel_data) #fake data
			# print(subj1_EEG)
			### FFT
			# subj1_FFT = filt_subj1.fft_receive(sample.channel_data[1:7])
			# subj1_FFT = filt_subj1.fft_receive(sample[0:6])

			# ECG Data
			# subj1_beat = ecg_subj1.filter_data(sample[7])

			# SUBJECT 2
			## EEG Data
				# print(np.shape(subj1_EEG))
				# print(subj1_EEG)
			if subj1_EEG is not None:
				send = [EEG, FFT]
				# subj2_sample = subj1_sample; #CHANGE THIS FOR REAL EXPERIMENT
				# EEG_send = np.concatenate((subj1_sample,subj2_sample), axis=0)
				# if self.count%60 is 0:
				# 	self.upd_packet.append(1)
				# else:
				# 	self.upd_packet.append(0)
				# print(EEG_send)
					# print(len(subj1_EEG))
				udp.receive(EEG_send)
		self.count = self.count+1




def main():


	global udp
	udp = udp_server.UDPServer()

	db = Data_Buffer()
	board = bci.OpenBCIBoard(port='/dev/ttyUSB0', send=db)
	board.start_streaming(db.buffer)

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

