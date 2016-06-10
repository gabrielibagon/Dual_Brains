import numpy as np
from scipy import signal, fft
import csv
import time
import sys
import threading
from recordclass import recordclass
from PyQt4.QtCore import QThread, pyqtSignal, pyqtSlot, SIGNAL #PyQt version 4.11.4
import gui
import udp_server
from collections import deque


class Streamer(QThread):
	'Streamer object to simulate EEG data streaming'

	#this creates a record class: mutable named tuple to hold all of the data of one data window
	Data_Return = recordclass('Data_Return', 'raw_data filtered_data rms fft_data')
	data_return = Data_Return([],[],[],[])

	# This defines a signal called 'new_data' that takes a 'Data_Return' type argument
	new_data = pyqtSignal(Data_Return)

	def __init__(self,fs_Hz, filters):
		QThread.__init__(self)
		self.data = deque([])
		self.fs_Hz = fs_Hz
		self.FIRST_BUFFER = True
		self.filters = filters
		# UDP = True

		# if UDP:
		# 	self.Udp_server = udp_server.UDPServer()

	def run(self):
		self.file_input()

	def pause(self):
		print('paused')


	def stop(self):
		sys.exit()

	def file_input(self):
		global form
		global new_data
		channel_data = []
		with open('sample.txt', 'r') as file:
			reader = csv.reader(file, delimiter=',')
			next(file)
			j = 0
			for line in reader:
				channel_data.append(line[1:]) #list
				j+=1
		last_time_of_program = 0
		start = time.time()
		for i,sample in enumerate(channel_data):
			end = time.time()

			# Mantain the 250 Hz sample rate when reading a file
			# Wait for a period of time if the program runs faster than real time
			time_of_recording = i/250
			time_of_program = end-start
			# print('i/250 (time of recording)', time_of_recording)
			# print('comp timer (time of program)', time_of_program)
			if time_of_recording > time_of_program:
				# print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
				time.sleep(time_of_recording-time_of_program)
				# time.sleep(2)
			if self.FIRST_BUFFER is True:
				self.init_buffer(sample)
				self.new_data.emit(self.data_return)
				# print("Emit")
			else:
				self.sample_buffer(sample)
				if i%10 is 0:
					self.new_data.emit(self.data_return)
				self.udp_server(self.data_return)

	#Send for processing
	def init_buffer(self,sample):
		self.data.append(sample)
		if len(self.data) < 250:
			#PUT GROWING INITIAL BUFFER IN RAW_DATA
			data = self.data
			data = np.asarray(list(zip(*data)))					#convert to numpy array
			data = data.astype(np.float)					#convert to float
			self.data_return.raw_data = data 			#put in raw_data
		else:
			#reformat data for processing
			data = self.data
			data = np.asarray(list(zip(*data))) #change that format of data to [channels, samples] for processed
			data = data.astype(np.float) #change the contents of the data to float for processed
			self.data_return.raw_data = data
			if FILTER is True:
				self.data_return.filtered_data = self.filters.signal_filters(data)
			self.FIRST_BUFFER = False

	def sample_buffer(self,sample):
	
		self.data.popleft()
		self.data.append(sample)

		# reformat data from string to float array
		# put the full window of data in data_return
		data = self.data
		data = np.asarray(list(zip(*data)))					#convert to numpy array
		data = data.astype(np.float)					#convert to float
		self.data_return.raw_data = data 			#put in raw_data

		# SEND FOR PROCESSING AND ANALYSIS
		if FILTER is True:
			self.data_return.filtered_data = self.filters.signal_filters(data)
		# FFT (used for FFT plot. It is always computed, and uses filtered data)
		self.data_return.fft_data = self.filters.fft(self.data_return.filtered_data)
		# RMS (used for EEG trace. It is always computed, and uses filtered data)
		self.data_return.rms = self.filters.rms(self.data_return.filtered_data)


	####################################################################################
	# UDP Communication

	def udp_server(self,data):
		# self.Udp_server.receive_data(data,'raw_data')
		print('nice')



class Filters:
	'Class containing EEG filtering and analysis tools' 

	#To use, instantiate the class with parameters specifying the type of filter and analysisf.
	#Then, call the Filters.data parameter in order to then get the filtered data
	def __init__(self,fs_Hz,filter_types):
		self.fs_Hz = fs_Hz #setting the sample rate
		self.processed_data = [] #creating an array for filtered data
		
		#determine which filters were called
		for type in filter_types:
			if type is "fft":
				#notch and bandpass are pre-requisites for fft
				self.NOTCH = True
				self.BANDPASS = True
				self.FFT = True
			elif type is "notch":
				self.NOTCH = True
			elif type is "bandpass":
				self.BANDPASS = True


	def signal_filters(self,data):
		# self.data = data
		processed_data = data #processed_data initialized with data, it will then be sent through the filters
		
		# DATA FILTERS
		if self.NOTCH is True:
			processed_data = self.notch_filter(processed_data,60)
		if self.BANDPASS is True:
			processed_data = self.bandpass_filter(processed_data,1,50)
		return data

	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty([8,250])

		#set up filter
		notch_Hz = np.array([float(notch_Hz - 1.0), float(notch_Hz + 1.0)])
		b, a = signal.butter(2,notch_Hz/(self.fs_Hz / 2.0), 'bandstop')
		i=0
		#apply the filter to the stream, one channel at a time
		for channel in data:
			processed_data[i] = signal.lfilter(b,a,channel)
			i+=1
		return processed_data


	def bandpass_filter(self,data,low_cut,high_cut):
		processed_data = np.empty([8,250])
		# set up filter
		bandpass_frequencies = np.array([low_cut, high_cut])
		b,a = signal.butter(2, bandpass_frequencies/(self.fs_Hz / 2.0), 'bandpass')
		# apply filter to data window
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel)
		return processed_data

	def fft(self,data):
		global fft_array
		i=0
		for channel in data:
			#FFT ALGORITHM
			fft_data1 = []
			fft_data2 = []
			fft_data1 = np.fft.fft(channel).conj().reshape(-1, 1)
			fft_data1 = abs(fft_data1/self.fs_Hz) #generate two-sided spectrum
			fft_data2 = fft_data1[0:(250/2)+1]
			fft_data1[1:len(fft_data1)-1] = 2*fft_data1[1:len(fft_data1)-1]
			fft_data1 = fft_data1.reshape(250)
			fft_array[i] = fft_data1
			i+=1
		return fft_array #fft computation and normalization

	#calculates the root mean square, used for the voltage scroll plot
	def rms(self,data):
		# algorithm: x_rms = sqrt((1/n)((x_1)^2 + (x_2)^2 + ...+ (x_n)^2)))
		rms = []
		n = len(data[0]) #length of data
		for channel in data:
			channel_rms = np.sqrt(np.mean(np.square(channel)))
			# print("CHANNEL_RMS",type(channel_rms))
			# print("RMS", type(rms))
			rms.append(np.asscalar(channel_rms))
		# print(rms)
		return rms


def main(argv):
	global FILTER
	FILTER = True
	if FILTER is True:
		filters = Filters(250,['fft'])
	streamer = Streamer(250,filters)
	if '-GUI' in argv:
		print('DISPLAYING GUI')
		gui.Gui(streamer)
	else:
		print('NO GUI')
		streamer.run()



if __name__ == '__main__':
	fft_array = np.empty([8,250])
	main(sys.argv)