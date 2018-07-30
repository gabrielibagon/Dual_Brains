# !/usr/local/bin/python
# -*- coding: utf-8 -*-

import sys, os
import time
import filters
import time
import csv
import numpy as np
import open_bci_v3 as bci
import udp_server

class Data_Buffer:
	def __init__(self):
		self.filt = filters.Filters()
		self.data_buffer = []
		self.count = 0
		self.udp_packet = []

	def buffer(self,sample):
		count = 0;
		if sample and ((count%8) == 0):
			EEG = []
			EEG = self.filt.filter_data(sample.channel_data)
			send = []

			if (EEG is not None) and (count%4==0):
				uv = EEG[0]
				fft = EEG[1]
				fft1 = fft[0,10:42]
				fft2 = fft[9,10:42]

				for chan in uv:
					send.append(chan[0])
				for pt in fft1:
					send.append(pt)
				for pt in fft2:
					send.append(pt)
				# print(np.shape(send))
				# print(send)
				udp.receive(send)

		# DATA FORMAT
		# FIRST 18 values are from the raw voltage
		# 0-5: subj 1 eeg
		# 6: subj 1 ecg
		# 7: null
		# 8-13: subj2 eeg
		# 14: subj2 ecg
		# 15: null
		# 16-2080: channels 0-5 and 8-13 fft data (129 points per channel)
		self.count = self.count+1

class TestSample:
	def __init__(self):
		self.channel_data = []

def playback(db, test_file):
	'''
	Plays back recorded files from the aaron_test_data folder.
	'''

	samples = []

	with open(test_file, 'r') as file:
		reader = csv.reader(file, delimiter=',')
		for j, line in enumerate(reader):
			if '%' not in line[0] :
				line = [x.replace(' ','') for x in line]
				samples.append(line)


	print 'Loaded {0} channel lines from {1}'.format(len(samples), test_file)

	last_time_of_program = 0
	start = time.time()
	sample = TestSample()
	for i,channel_data in enumerate(samples):
		sample.channel_data = channel_data
		end = time.time()
		#Mantain the 250 Hz sample rate when reading a file
		#Wait for a period of time if the program runs faster than real time
		time_of_recording = i/250
		time_of_program = end-start
		# print('i/250 (time of recording)', time_of_recording)
		# print('comp timer (time of program)', time_of_program)
		if time_of_recording > time_of_program:
			# print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
			time.sleep(time_of_recording-time_of_program)
		db.buffer(sample)

def main():
	'''
	Data streamer from OpenBCI to the Dual Brains Visualization

	Launch either with a BCI connected to a usb port:
	$: python data_buffer.py --serial-port /dev/tty.usbserial-DQ007RRX

	Or using a pre-recorded test file:
	$: python data_buffer.py --test-file ../aaron_test_data/Filtered_Data/RAW_eeg_data_only_FILTERED.txt
	'''

	if len(sys.argv) is not 3 :
		sys.exit('Usage: %s (--serial-port OR --test-file) /path/to/resource' % sys.argv[0])

	option = sys.argv[1]
	path = sys.argv[2]


	print 'Starting UDP server'
	global udp
	udp = udp_server.UDPServer()

	db = Data_Buffer()

	if option in '--serial-port':
		board = bci.OpenBCIBoard(port=path, send=db)
		board.start_streaming(db.buffer)

	if option in '--test-file':
		playback(db, path)

if __name__ == '__main__':
	try:
		main()
	except KeyboardInterrupt:
		print '\nShutdown requested... Exiting.'
		try:
			sys.exit(0)
		except SystemExit:
			os._exit(0)
