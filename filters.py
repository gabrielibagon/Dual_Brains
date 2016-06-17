from collections import deque
import numpy as np
from scipy import signal, fft
import sys
import tkinter as tk
import time

class Filters:
	def __init__(self,master):
		self.fs_Hz = 250
		self.data_buff = deque([])
		self.filtered_data = []

		# Filtering Variables
		# notch variables
		self.NOTCH = tk.IntVar()
		self.notch_freq = tk.IntVar()


		self.BANDPASS = tk.IntVar()
		self.bp_low_freq = tk.IntVar()
		self.bp_high_freq = tk.IntVar()

		self.WINDOW = tk.IntVar()
		self.FFT = tk.IntVar()

		######################################################################
		# FILTER CONTROL GUI
		#
		self.master = master
		master.title("Filter Control")
		
		############################
		# NOTCH SETUP

		# button
		tk.Checkbutton(master, text="Notch Filter",pady=10,variable=self.NOTCH,
				).grid(row=0,sticky=tk.W)
		# entry
		tk.Entry(master,width=3,textvariable=self.notch_freq).grid(row=1,column=0,sticky='w')
		self.notch_freq.set(60)

		#############################
		# BANDPASS SETUP
		# button
		tk.Checkbutton(master, text="Bandpass", variable=self.BANDPASS).grid(row=2,sticky=tk.W)
		# low freq
		tk.Scale(master,from_=0, to=50,length=500, orient='horizontal',
			variable=self.bp_low_freq, label='Low Cut').grid(row=3,column=0,stick=tk.W)
		tk.Entry(master,width=3,textvariable=self.bp_low_freq).grid(row=3,column=1)
		self.bp_low_freq.set(1)
		tk.Frame(relief='ridge',height=2).grid(stick='ew')
		# high freq
		tk.Scale(master,from_=0, to=200, length=500,orient='horizontal',
			variable=self.bp_high_freq, label='High Cut').grid(row=4,column=0,stick=tk.W)
		tk.Entry(master,width=3,textvariable=self.bp_high_freq).grid(row=4,column=1)
		self.bp_high_freq.set(50)


		##############################
		# WINDOW SETUP
		# 
		window_button = tk.Checkbutton(master, text="Window Filter", variable=self.WINDOW).grid(row=8,sticky=tk.W)

	def data_receive(self,sample, root):
		if len(self.data_buff) < 250:
			self.data_buff.append(sample)
		else:
			root.update_idletasks()
			root.update()
			data = self.data_buff
			# data = list(map(list,zip(*data)))
			data = np.asarray(data).T
			data = data.astype(np.float)
			# print('post float', data)
			self.filter_control(data)
			# self.data_buff.pop()
			# self.data_buff.append(sample)
			# print('test')
			# print(self.NOTCH)



	def filter_control(self,data):
		# GET PARAMETERS FROM GUI
		# Notch
		NOTCH = self.NOTCH.get()
		notch_freq = self.notch_freq.get()


		# Bandpass
		BANDPASS = self.BANDPASS.get()
		bp_low_freq = self.bp_low_freq.get()
		bp_high_freq = self.bp_high_freq.get()

		# Window
		WINDOW = self.WINDOW.get()

		# FFT
		FFT = self.FFT.get()

		if NOTCH == 1:
			# NOTCH Filter
			# 
			# Optional arguments:
			# 		notch_Hz = 60
			#
			print("Notching at ", notch_freq)
			data = self.notch_filter(data,notch_freq)
		if BANDPASS == 1:
			data = self.bandpass_filter(data, float(bp_low_freq), float(bp_high_freq))
			print('Bandpass between ', float(bp_low_freq), float(bp_high_freq))
		if WINDOW == 1:
			data = self.window_filter(data)
			print('ssuc')
		if FFT == 1:
			fft = self.fft_filter(self.data_buff)
			print('sssssuc')


	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty([16,250])
		low_freq = float(notch_Hz - 1.0)
		high_freq = float(notch_Hz + 1.0)
		notch_Hz = np.array([low_freq, high_freq])			#empty array for filter kernel
		b, a = signal.butter(4,notch_Hz/(self.fs_Hz/2.0),'bandstop') #set up filter
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel) 	#filter each channel
		return processed_data
	

	def bandpass_filter(self,data,low_cut,high_cut):
		processed_data = np.empty([16,250])
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
		return fft_array

	def rms(self,data):
		rms = []
		n = len(data[0]) #length of data
		for channel in data:
			channel_rms = np.sqrt(np.mean(np.square(channel)))
			rms.append(np.asscalar(channel_rms))
		return rms
