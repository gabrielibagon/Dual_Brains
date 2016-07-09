from collections import deque
import numpy as np
from scipy import signal, fft
import sys
import time


class Filters:
	def __init__(self):
		np.set_printoptions(threshold=np.nan)

		self.fs_Hz = 250
		self.filter_window = 500
		self.data_buff = deque([])
		self.filtered_data = []
		# recordclass structure should hold all of the information that Processing may need

	def filter_data(self,sample):
		# print("SAMPLE",sample);
		if len(self.data_buff) < 500:
			self.data_buff.append(sample)
		else:
			self.data_buff.popleft()
			self.data_buff.append(sample)
			data = self.data_buff
			data = np.asarray(data).T
			data = data.astype(np.float)
			filtered_eeg = self.noise_filters(data)
			return filtered_eeg

	def noise_filters(self,data):
		fs = 250
		fn = 125
		filter_order = 2   #2nd order filter
		f_high = 35
		f_low = 5
		wn = [59,61]       #Nyquist filter window

		[b,a] = signal.butter(filter_order,f_high/fn, 'low')
		[b1,a1] = signal.butter(filter_order,f_low/fn, 'high')
		[bn,an] = signal.butter(4,[x/fn for x in wn], 'stop')

		filtered_eeg = []
		spectogram = []
		notched = []
		high_passed = []
		low_passed = []
		for i in range(len(data)):
		  channel =  data[i]
		  high_passed = signal.filtfilt(b1,a1,channel);        # high pass filter
		  low_passed = signal.filtfilt(b,a,high_passed);       # low pass filter
		  y = signal.filtfilt(bn,an,low_passed);        # notch filter
		  filtered_eeg.append(y);
		# print(filtered_eeg)
		return filtered_eeg

	def fft_receive(self,sample):
		if len(self.data_buff) < 500:
			self.data_buff.append(sample)
		else:
			self.data_buff.popleft()
			self.data_buff.append(sample)
			data = self.data_buff
			data = np.asarray(data).T
			data = data.astype(np.float)
			return(self.fft_filter(data))


	def fft_filter(self,data):
		fft_array = []
		for i,channel in enumerate(data):
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
		return np.asarray(fft_array)