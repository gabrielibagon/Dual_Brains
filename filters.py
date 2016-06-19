from collections import deque
import numpy as np
from scipy import signal, fft
import sys
import tkinter as tk
import time

class Filters:
	def __init__(self):
		self.fs_Hz = 250
		self.filter_window = 250
		self.data_buff = deque([])
		self.filtered_data = []
		self.GUI = False
		if self.GUI is True:
			self.gui_setup()



	def gui_setup(self):
		######################################################################
		# FILTER CONTROL GUI
		#
		master = tk.Tk()
		self.master = master
		self.master.title("Filter Control")

		# Filtering Variables
		# notch variables
		self.NOTCH = tk.IntVar()
		self.notch_freq = tk.IntVar()


		self.BANDPASS = tk.IntVar()
		self.bp_low_freq = tk.IntVar()
		self.bp_high_freq = tk.IntVar()

		self.WINDOW = tk.IntVar()
		self.FFT = tk.IntVar()
		
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
		# physical properties and limitations
		max_cutoff = self.filter_window/2
		# low_cutoff_max = self.bp_high_freq.get()
		# low freq
		tk.Scale(master,from_=0, to=max_cutoff,length=500, orient='horizontal',
			variable=self.bp_low_freq, label='Low Cut').grid(row=3,column=0,stick=tk.W)
		tk.Entry(master,width=3,textvariable=self.bp_low_freq).grid(row=3,column=1)
		self.bp_low_freq.set(1)
		tk.Frame(relief='ridge',height=2).grid(stick='ew')
		# high freq
		tk.Scale(master,from_=0, to=max_cutoff, length=500,orient='horizontal',
			variable=self.bp_high_freq, label='High Cut').grid(row=4,column=0,stick=tk.W)
		tk.Entry(master,width=3,textvariable=self.bp_high_freq).grid(row=4,column=1)
		self.bp_high_freq.set(50)


		##############################
		# WINDOW SETUP
		# 
		window_button = tk.Checkbutton(master, text="Window Filter", variable=self.WINDOW).grid(row=5,sticky=tk.W)

		##############################
		# FFT SETUP
		#
		tk.Checkbutton(master, text="SEND FFT", variable=self.FFT).grid(row=6,sticky=tk.W)


	def data_receive(self,sample):
		if len(self.data_buff) < 250:
			self.data_buff.append(sample)
		if self.GUI is True:
			self.master.update_idletasks()
			self.master.update()
		if len(self.data_buff) >249:
			self.data_buff.popleft()
			self.data_buff.append(sample)
				# print(len(self.data_buff))
			data = self.data_buff
			# data = list(map(list,zip(*data)))
			data = np.asarray(data).T
			data = data.astype(np.float)
				# print('post float', data)
			print('SHAPE', len(data), len(data[0]))
			return self.filter_control(data)
			# self.data_buff.pop()
			# self.data_buff.append(sample)
			# print('test')
			# print(self.NOTCH)



	def filter_control(self,data):
		# GET PARAMETERS FROM GUI
		# Notch
		# NOTCH = self.NOTCH.get()
		# notch_freq = self.notch_freq.get()


		# # Bandpass
		# BANDPASS = self.BANDPASS.get()
		# bp_low_freq = self.bp_low_freq.get()
		# bp_high_freq = self.bp_high_freq.get()

		# # Window
		# WINDOW = self.WINDOW.get()


		########################
		# TEMP FOR NO GUI
		NOTCH = 0
		BANDPASS = 0
		WINDOW = 0

		# FFT
		FFT = 1
		if NOTCH == 1 or BANDPASS == 1 or WINDOW == 1:
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
			return data
		elif FFT == 1:
			if FFT == 1:
				print('fft going on')
				fft = self.fft_filter(data)
				# print('FFT FINAL',len(fft), ',', len(fft[0]))
				return fft
		else:
			return data

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
		#######################################
		# FIGURE OUT HOW TO DO THIS VIA METHOD
		# new_data = np.array([])
		# new_data = data
		# data = np.transpose(new_data)
		# for i,channel in enumerate(data):
		# 	for j in range(len(data[0])): #250
		# 		new_data[j][i] = channel[j]
		# data = new_data
		########################################
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

	def spectogram(self,data):
		print('test')


	def rms(self,data):
		rms = []
		n = len(data[0]) #length of data
		for channel in data:
			channel_rms = np.sqrt(np.mean(np.square(channel)))
			rms.append(np.asscalar(channel_rms))
		return rms
