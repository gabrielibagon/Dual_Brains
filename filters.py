from collections import deque

class Filters():
	def __init__(self):
		self.fs_Hz = 250
		self.data_buff = deque([])
		self.filtered_data = []

	def data_receive(self,sample):
		if len(self.data_buff) < 250:
			self.data_buff.append(sample)
		else:
			self.filter_control(self.data_buff)
			self.data_buff.pop()
			self.data_buff.append(sample)

	def filter_control(self,data_buff):
		data = self.data_buff
		if NOTCH is True:
			# NOTCH Filter
			# 
			# Optional arguments:
			# 		notch_Hz = 60
			#
			data = self.notch(data)

		if BANDPASS is True:
			data = self.bandpass(data)
		if WINDOW is True:
			data = self.window(data)
		if FFT is True:
			fft = self.fft(self.data_buff)

	def notch_filter(self,data,notch_Hz=60):
		processed_data = np.empty([8,250])
		low_freq = float(notch_Hz - 1.0)
		high_freq = float(notch_Hz + 1.0)]
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
