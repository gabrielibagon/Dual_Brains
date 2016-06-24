from collections import deque
import numpy as np
from scipy import signal, fft
import sys
import time
from recordclass import recordclass

class ECG_analysis:

	def __init__(self):
		np.set_printoptions(threshold=np.nan)

		self.fs_Hz = 250
		self.filter_window = 750
		self.data_buff = deque()
		self.filtered_data = []
		self.ransac_window_size = 3.0
		self.thresholds = []
		self.max_powers = []

	def filter_data(self,sample):
		# print("SAMPLE",sample);
		if len(self.data_buff) < 750:
			self.data_buff.append(sample)
		if len(self.data_buff) == 750:
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
		bp_low_freq = 5;
		bp_high_freq = 15;
		# FILTER CONTROL FLOW
		filtered_data = self.notch_filter(data,notch_freq)
		filtered_data = self.bandpass_filter(filtered_data, float(bp_low_freq), float(bp_high_freq))
		self.peak_detect(filtered_data)
		return filtered_data

	def peak_detect(self,data):
		# square of the discrete difference of the signal)
		decg = np.diff(data)
		decg_power = decg**2
		for i in range(len(decg_power)/750)
		sample = slice(i*750, (i+1)*750)
		d = decg_power[sample]
		self.thresholds.append(0.5*np.std(d))
		self.max_powers.append(np.max(d))



	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty(750)
		low_freq = float(notch_Hz - 1.0)
		high_freq = float(notch_Hz + 1.0)
		notch_Hz = np.array([low_freq, high_freq])			#empty array for filter kernel
		b, a = signal.butter(4,notch_Hz/(self.fs_Hz/2.0),'bandstop') #set up filter
		return signal.lfilter(b,a,channel)
	

	def bandpass_filter(self,data,low_cut,high_cut):
		processed_data = np.empty(750)
		bandpass_frequencies = np.array([low_cut, high_cut])
		b,a = signal.butter(2, bandpass_frequencies/(self.fs_Hz / 2.0), 'bandpass')
		# apply filter to data window
		return signal.lfilter(b,a,channel)
