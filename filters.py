from collections import deque
import numpy as np
from scipy import signal, fft
import sys
import time


class Filters:
	def __init__(self):
		np.set_printoptions(threshold=np.nan)

		self.fs_Hz = 250
		self.filter_window = 250
		self.data_buff = deque([])
		self.filtered_data = []
		# recordclass structure should hold all of the information that Processing may need

	def filter_data(self,sample):
		# print("SAMPLE",sample);
		if len(self.data_buff) < 250:
			self.data_buff.append(sample)
		if len(self.data_buff) == 250:
			self.data_buff.popleft()
			self.data_buff.append(sample)
			# print("WOWOWOWO",self.data_buff)
			data = self.data_buff
			data = np.asarray(data).T
			data = data.astype(np.float)
			# print(data.T)
			# print("datatatata", data);
			filtered_eeg = self.filter_control(data)
			# print((filtered_eeg.T)[0])
			return (filtered_eeg.T)[0];

	def filter_control(self,data):
		# FILTER PARAMS
		notch_freq = 60;
		bp_low_freq = 1;
		bp_high_freq = 50;
		# FILTER CONTROL FLOW
		filtered_data = self.notch_filter(data,notch_freq)
		filtered_data = self.bandpass_filter(filtered_data, float(bp_low_freq), float(bp_high_freq))
		return filtered_data

	def fft_receive(self):
		if len(self.data_buff) == 250:
			# print("WOWOWOWO",self.data_buff)
			data = self.data_buff
			data = np.asarray(data).T
			data = data.astype(np.float)
			return(self.fft_filter(data))

	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty([6,250])
		low_freq = float(notch_Hz - 1.0)
		high_freq = float(notch_Hz + 1.0)
		notch_Hz = np.array([low_freq, high_freq])			#empty array for filter kernel
		b, a = signal.butter(4,notch_Hz/(self.fs_Hz/2.0),'bandstop') #set up filter
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel) 	#filter each channel
		return processed_data
	

	def bandpass_filter(self,data,low_cut,high_cut):
		processed_data = np.empty([6,250])
		bandpass_frequencies = np.array([low_cut, high_cut])
		b,a = signal.butter(2, bandpass_frequencies/(self.fs_Hz / 2.0), 'bandpass')
		# apply filter to data window
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel)
		return processed_data

	def fft_filter(self,data):
		fft_array = []
		for i,channel in enumerate(data):
			# print('ch',channel)
			#FFT ALGORITHM
			fft_data1 = []
			fft_data2 = []
			fft_data1 = np.fft.fft(channel).conj().reshape(-1, 1)
			fft_data2 = abs(fft_data1/self.filter_window) #generate two-sided spectrum
			fft_data1 = fft_data2[0:(250/2)]
			# fft_data1 = fft_data1*2
			fft_data1[1:len(fft_data1)-1] = 2*fft_data1[1:len(fft_data1)-1]
			fft_data1 = fft_data1.reshape(125)
			# fft_data1 = fft_data1.reshape(250)
			fft_array.append(fft_data1)
			# print(fft_data1)
		return fft_array