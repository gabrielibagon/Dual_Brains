from collections import deque
import numpy as np
from scipy import signal, fft
import filter_controls
import sys
import tkinter
import time

class Filters:
	def __init__(self,master):
		self.fs_Hz = 250
		self.data_buff = deque([])
		self.filtered_data = []

		# Filtering Booleans
		self.NOTCH = tkinter.IntVar()
		self.BANDPASS = tkinter.IntVar()
		self.WINDOW = tkinter.IntVar()
		self.FFT = tkinter.IntVar()

		# Set up Filter Control GUI
		self.master = master
		master.title("Filter Control")
		notch_button = tkinter.Checkbutton(master, text="Notch Filter", variable=self.NOTCH).grid(row=0,sticky=tkinter.W)
		bandpass_button = tkinter.Checkbutton(master, text="Bandpass", variable=self.BANDPASS).grid(row=1,sticky=tkinter.W)
		window_button = tkinter.Checkbutton(master, text="Window Filter", variable=self.WINDOW).grid(row=2,sticky=tkinter.W)


	def data_receive(self,sample, root):
		if len(self.data_buff) < 1000:
			self.data_buff.append(sample)
		else:
			root.update_idletasks()
			root.update()
			data = self.data_buff
			data = np.asarray(list(zip(*data)))
			data = data.astype(np.float)					#convert to float
			self.filter_control(data)
			self.data_buff.pop()
			self.data_buff.append(sample)
			print('test')
			print(self.NOTCH)



	def filter_control(self,data):
		if self.NOTCH is True:
			# NOTCH Filter
			# 
			# Optional arguments:
			# 		notch_Hz = 60
			#
			data = self.notch_filter(data)

		if self.BANDPASS is True:
			data = self.bandpass_filter(data, 1., 50.)
			print('suc')
		if self.WINDOW is True:
			data = self.window_filter(data)
			print('ssuc')
		if self.FFT is True:
			fft = self.fft_filter(self.data_buff)
			print('sssssuc')


	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty([16,1000])
		low_freq = float(notch_Hz - 1.0)
		high_freq = float(notch_Hz + 1.0)
		notch_Hz = np.array([low_freq, high_freq])			#empty array for filter kernel
		b, a = signal.butter(2,notch_Hz/(self.fs_Hz / 2.0), 'bandstop') #set up filter
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel) 	#filter each channel
		return processed_data
	

	def bandpass_filter(self,data,low_cut,high_cut):
		processed_data = np.empty([16,1000])
		bandpass_frequencies = np.array([low_cut, high_cut])
		b,a = signal.butter(2, bandpass_frequencies/(self.fs_Hz / 2.0), 'bandpass')
		# apply filter to data window
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel)
		return processed_data

	def window_filter(self,data):
		#not sure how to execute this
		return

	def fft_filter(self,data):
		fft_array = []
		for i,channel in enumerate(data):
			#FFT ALGORITHM
			fft_data1 = []
			fft_data2 = []
			fft_data1 = np.fft.fft(channel).conj().reshape(-1, 1)
			fft_data1 = abs(fft_data1/self.fs_Hz) #generate two-sided spectrum
			fft_data2 = fft_data1[0:(250/2)+1]
			fft_data1[1:len(fft_data1)-1] = 2*fft_data1[1:len(fft_data1)-1]
			# fft_data1 = fft_data1.reshape(250)
			print(fft_data1)
			fft_array[i] = fft_data1
		time.sleep(2)
		return fft_array

	def rms(self,data):
		rms = []
		n = len(data[0]) #length of data
		for channel in data:
			channel_rms = np.sqrt(np.mean(np.square(channel)))
			rms.append(np.asscalar(channel_rms))
		return rms
