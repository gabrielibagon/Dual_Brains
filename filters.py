from collections import deque
import numpy as np
from scipy import signal, fft
import scipy.fftpack
import sys
import time


class Filters:
	def __init__(self):
		np.set_printoptions(threshold=np.nan)

		self.fs_Hz = 250
		self.fn = self.fs_Hz/2
		self.filter_window = 256
		self.data_buff = deque([[0]*16]*self.filter_window)
		self.filtered_data = []

		fs = self.fs_Hz
		fn = self.fn
		filter_order = 2   #2nd order filter
		f_high = 40
		f_low = 2
		wn = [59,61]       #Nyquist filter window
		self.low_pass_coefficients = signal.butter(filter_order,f_high/fn, 'low')
		self.high_pass_coefficients = signal.butter(filter_order,f_low/fn, 'high')
		self.notch_coefficients = signal.butter(4,[x/fn for x in wn], 'stop')
		self.filtered_eeg = np.empty([16,256])

	def collect_data(self,sample):
		self.data_buff.popleft()
		self.data_buff.append(sample)
		# print(self.data_buff)

	def filter_data(self):
		data = self.data_buff
		data = np.asarray(data).T
		data = data.astype(np.float)
		filtered_eeg = self.noise_filters(data)
		fft = self.fft_filter(data)
		return [filtered_eeg, fft]

	def noise_filters(self,data):
		[b1, a1] = [self.high_pass_coefficients[0],self.high_pass_coefficients[1]]
		[b, a] = [self.low_pass_coefficients[0],self.low_pass_coefficients[1]]
		[bn, an] = [self.notch_coefficients[0],self.notch_coefficients[1]]


		notched = []
		high_passed = []
		low_passed = []
		# print(range(len(data)))
		# print(data)
		for i in range(len(data)-1):
		  channel =  data[i]
		  high_passed = signal.filtfilt(b1,a1,channel);        # high pass filter
		  low_passed = signal.filtfilt(b,a,high_passed);       # low pass filter
		  y = signal.filtfilt(bn,an,low_passed);        # notch filter
		  self.filtered_eeg[i] = y;
		return self.filtered_eeg

	def fft_filter(self,data):
		# print(np.shape(data))
		fft = np.empty([16,129])
		for i,channel in enumerate(data):
			#FFT ALGORITHM
			temp_fft = np.fft.fft(channel)
			temp_fft = np.abs(temp_fft/len(channel))
			temp_fft = temp_fft[0:(len(channel)/2 + 1)]
			temp_fft[1:len(temp_fft)] = 2*temp_fft[1:len(temp_fft)]
			fft[i] = temp_fft
		return fft