from collections import deque
import numpy as np
from scipy import signal, fft
import filter_controls
from pyqtgraph.Qt import QtGui, QtCore
from PyQt4.QtCore import QThread, pyqtSignal, pyqtSlot, SIGNAL #PyQt version 4.11.4
import sys

class Filters(QtGui.QMainWindow, filter_controls.Ui_MainWindow):
	def __init__(self):
		self.fs_Hz = 250
		self.data_buff = deque([])
		self.filtered_data = []

		# Filtering Booleans
		self.NOTCH = True
		self.BANDPASS = True
		self.WINDOW = True
		self.FFT = True

		app = QtGui.QApplication(sys.argv)  		# new instance of QApplication
		super(self.__class__,self).__init__()
		self.setupUi(self)

		print(self.radioButton.isChecked())

		self.show()
		
		sys.exit(app.exec_())


	def data_receive(self,sample):
		if len(self.data_buff) < 250:
			self.data_buff.append(sample)
		else:
			self.filter_control(self.data_buff)
			self.data_buff.pop()
			self.data_buff.append(sample)
		if (self.radioButton.isChecked()):
			print('change!!!!')

	def filter_control(self,data_buff):
		data = self.data_buff
		if self.NOTCH is True:
			# NOTCH Filter
			# 
			# Optional arguments:
			# 		notch_Hz = 60
			#
			data = self.notch_filter(data)

		if self.BANDPASS is True:
			data = self.bandpass_filter(data, 1., 50.)
		if self.WINDOW is True:
			data = self.window_filter(data)
		if self.FFT is True:
			fft = self.fft_filter(self.data_buff)

	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty([250,16])
		low_freq = float(notch_Hz - 1.0)
		high_freq = float(notch_Hz + 1.0)
		notch_Hz = np.array([low_freq, high_freq])			#empty array for filter kernel
		b, a = signal.butter(2,notch_Hz/(self.fs_Hz / 2.0), 'bandstop') #set up filter
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel) 	#filter each channel
		return processed_data
	

	def bandpass_filter(self,data,low_cut,high_cut):
		processed_data = np.empty([8,250])
		bandpass_frequencies = np.array([low_cut, high_cut])
		b,a = signal.butter(2, bandpass_frequencies/(self.fs_Hz / 2.0), 'bandpass')
		# apply filter to data window
		for i,channel in enumerate(data):
			processed_data[i] = signal.lfilter(b,a,channel)
		return processed_data

	def window(self,data):
		#not sure how to execute this
		return

	def fft(self,data):
		global fft_array
		for i,channel in enumerate(data):
			#FFT ALGORITHM
			fft_data1 = []
			fft_data2 = []
			fft_data1 = np.fft.fft(channel).conj().reshape(-1, 1)
			fft_data1 = abs(fft_data1/self.fs_Hz) #generate two-sided spectrum
			fft_data2 = fft_data1[0:(250/2)+1]
			fft_data1[1:len(fft_data1)-1] = 2*fft_data1[1:len(fft_data1)-1]
			fft_data1 = fft_data1.reshape(250)
			fft_array[i] = fft_data1
		return fft_array

	def rms(self,data):
		rms = []
		n = len(data[0]) #length of data
		for channel in data:
			channel_rms = np.sqrt(np.mean(np.square(channel)))
			rms.append(np.asscalar(channel_rms))
		return rms
