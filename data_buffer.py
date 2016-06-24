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



	def buffer(self,sample):
		if sample:
			print(sample)
			# SUBJECT 1
			## EEG DATA
			# subj1_EEG = filt_subj1.filter_data(sample[1:7])
			# subj1_FFT = filt_subj1.fft_receive()
			# ECG Data
			# subj1_beat = ecg_subj1.filter_data(sample[7])

			# SUBJECT 2
			## EEG Data
			# subj2_EEG = filt_subj2.filter_data(sample[10:16])
			# subj2_FFT = filt_subj2.fft_receive();


def main():


	global udp
	udp = udp_server.UDPServer()
	global osc
	osc = streamer_osc.StreamerOSC()
	global tcp
		# tcp = tcp_server.TCPServer()





	# # client = webserver.WebSocketClient()

	# # webserver.connect()
	# # board = open_bci_v3.OpenBCIBoard(port=port)
	# # board.start_streaming(db.buffer)
	# channel_data = []
	# with open('sample16.txt', 'r') as file:
	# 	reader = csv.reader(file, delimiter=',')
	# 	next(file)
	# 	for j,line in enumerate(reader):
	# 		line = [x.replace(' ','') for x in line]
	# 		channel_data.append(line) #list




	# last_time_of_program = 0
	# start = time.time()
	# for i,sample in enumerate(channel_data):
	# 	end = time.time()
	# 	#Mantain the 250 Hz sample rate when reading a file
	# 	#Wait for a period of time if the program runs faster than real time
	# 	time_of_recording = i/250
	# 	time_of_program = end-start
	# 	# print('i/250 (time of recording)', time_of_recording)
	# 	# print('comp timer (time of program)', time_of_program)
	# 	if time_of_recording > time_of_program:
	# 		# print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
	# 		time.sleep(time_of_recording-time_of_program)
	# 	db.buffer(sample)


if __name__ == '__main__':
	main()

