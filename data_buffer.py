import open_bci_v3
import time
import filters
import tkinter
import time
import csv
import udp_server
import tcp_server
import numpy as np
import streamer_osc
import ecg_analysis
# import webserver
import open_bci_v3 as bci

class Data_Buffer():

	def __init__(self):
		#subj1 objects
		global filt_subj1
		filt_subj1 = filters.Filters()
		global ecg_subj1
		ecg_subj1 = ecg_analysis.ECG_Analysis()
		#subj2 objects
		global filt_subj2
		filt_subj2 = filters.Filters()
		global ecg_subj2
		ecg_subj2 = ecg_analysis.ECG_Analysis()


		#instantiate EEG and ECG lists for subj1 and subj2
		self.subj1_EEG = []
		self.subj1_ECG = []
		self.subj2_EEG = []
		self.subj2_ECG = []

		self.data_buffer = [] #this will hold the raw data
		self.fs_Hz = 250	#frequency in Hertz
		self.FIRST_BUFFER = True
		self.full_out = []

		self.count = 0

		self.udp_packet = []


	def buffer(self,sample):
		if sample:
			self.count = self.count+1
			# SUBJECT 1
			## EEG DATA
			### Filtered
			# subj1_EEG = filt_subj1.filter_data(sample.channel_data[1:7]) #real data
			subj1_EEG = filt_subj1.filter_data(sample[0:6]) #fake data
			# print(subj1_EEG)
			### FFT
			# subj1_FFT = filt_subj1.fft_receive(sample.channel_data[1:7])
			# ECG Data
			# subj1_beat = ecg_subj1.filter_data(sample[7])

			# SUBJECT 2
			## EEG Data
				# print(np.shape(subj1_EEG))
				# print(subj1_EEG)
				
			# subj2_EEG = filt_subj2.filter_data(sample[10:16])
			# subj2_FFT = filt_subj2.fft_receive();
			# print(subj1_EEG)
			# if subj1_EEG is not None:
			# 	print(type(subj1_EEG))
			# 	if self.count%50 is 0:
			# 		udp.receive(subj1_EEG)
			# print(subj1_FFT)
			# print(subj1_EEG)
			if subj1_EEG is not None:
				# print(subj1_EEG)
				final_subj1 = []
				for chan in subj1_EEG:
					final_subj1.append(chan[0:400])

				subj2_EEG = final_subj1; #CHANGE THIS FOR REAL EXPERIMENT
				EEG_send = np.concatenate((final_subj1,subj2_EEG), axis=0)
				EEG_send.astype(np.int)
				# if self.count%60 is 0:
				# 	self.upd_packet.append(1)
				# else:
				# 	self.upd_packet.append(0)
				if self.count%10 is 0:
					# print(len(subj1_EEG))
					udp.receive(EEG_send)



def main():


	global udp
	udp = udp_server.UDPServer()

	db = Data_Buffer()
	# board = bci.OpenBCIBoard(port='/dev/ttyUSB0', send=db)
	# board.start_streaming(db.buffer)

	channel_data = []
	with open('RAW_eeg_data_only_FILTERED.txt', 'r') as file:
		reader = csv.reader(file, delimiter=',')
		next(file)
		for j,line in enumerate(reader):
			line = [x.replace(' ','') for x in line]
			channel_data.append(line) #list



	print(len(channel_data))
	last_time_of_program = 0
	start = time.time()
	for i,sample in enumerate(channel_data):
		end = time.time()
		#Mantain the 250 Hz sample rate when reading a file
		#Wait for a period of time if the program runs faster than real time
		time_of_recording = i/250
		time_of_program = end-start
			# print('i/250 (time of recording)', time_of_recording)
			# print('comp timer (time of program)', time_of_program)
		if time_of_recording > time_of_program:
			# print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
			time.sleep(time_of_recording-time_of_program)
		db.buffer(sample)


if __name__ == '__main__':
	main()

