from collections import deque
import numpy as np
from scipy import signal, fft
import sys
import time
from recordclass import recordclass
import matplotlib.pyplot as plt
import time


class ECG_Analysis:

	def __init__(self):
		np.set_printoptions(threshold=np.nan)

		self.fs_Hz = 250
		self.filter_window = 750
		self.data_buff = deque()
		self.filtered_data = []
		self.ransac_window_size = 3.0
		self.thresholds = []
		self.max_powers = []
		self.PEAK = False
	def filter_data(self,sample):
		# print("SAMPLE",sample);
		# print("SAMPLE", sample)
		if len(self.data_buff) < 500:
			self.data_buff.append(sample)
		if len(self.data_buff) == 500:
			self.data_buff.popleft()
			self.data_buff.append(sample)
			# print("WOWOWOWO",self.data_buff)
			data = self.data_buff
			data = np.asarray(data).T
			data = data.astype(np.float)
			# print(data.T)
			# print("datatatata", data);
			filtered_eeg = self.filter_control(data)
			return (filtered_eeg.T)[0];

	def filter_control(self,data):
		# FILTER PARAMS
		notch_freq = 60;
		bp_low_freq = 5;
		bp_high_freq = 15;
		# FILTER CONTROL FLOW
		filtered_data = self.notch_filter(data,notch_freq)
		filtered_data = self.bandpass_filter(filtered_data, float(bp_low_freq), float(bp_high_freq))
		# "five point derivative" 
		filtered_data = np.diff(filtered_data)
		# squaring function
		filtered_data = filtered_data**2
		# moving window integration
		# np.convolve(window,np.ones((50,))/50)[(50-1):]
		print(filtered_data)

		return filtered_data

	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty(750)
		low_freq = float(notch_Hz - 1.0)
		high_freq = float(notch_Hz + 1.0)
		notch_Hz = np.array([low_freq, high_freq])			#empty array for filter kernel
		b, a = signal.butter(4,notch_Hz/(self.fs_Hz/2.0),'bandstop') #set up filter
		return signal.lfilter(b,a,data)
	

	def bandpass_filter(self,data,low_cut,high_cut):
		processed_data = np.empty(750)
		bandpass_frequencies = np.array([low_cut, high_cut])
		b,a = signal.butter(2, bandpass_frequencies/(self.fs_Hz / 2.0), 'bandpass')
		# apply filter to data window
		return signal.lfilter(b,a,data)
