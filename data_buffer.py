import open_bci_v3
import time
import filters
import tkinter
import time
import csv
import udp_server
import tcp_server
import numpy as np
import streamer_osc
# import webserver

class Data_Buffer():

	def __init__(self):

		#instantiate EEG and ECG lists for subj1 and subj2
		self.subj1_EEG = []
		self.subj1_ECG = []
		self.subj2_EEG = []
		self.subj2_ECG = []

		self.data_buffer = [] #this will hold the raw data
		self.fs_Hz = 250	#frequency in Hertz
		self.FIRST_BUFFER = True
		self.full_out = []


		# use this to send raw data
		self.RAW_RETURN = False
		# use this to send by channel versus by sample (default format)
		self.BY_CHANNEL = True



	def buffer(self,sample):
		if sample:
			# sample_string = "ID: %f\n%s\n%s" %(sample.id, str(sample.channel_data)[1:-1], str(sample.aux_data)[1:-1])
			# self.data_buffer.append(sample.channel_data)

			# DATA COLLECTION INTO BUFFER
			# subject 1
			# # EEG data 
			self.subj1_EEG.append(sample[0:6])
			# # EMG
			self.subj1_ECG.append(sample[6:9])

			# subject 2
			# # EEG data
			self.subj2_EEG.append(sample[8:14])
			self.subj2_ECG.append(sample[14:17])
			data_send = filt.data_receive(sample)
			# webserver.data_send(sample)
			# tcp.receive(sample)
			# print(data_send)
			if self.RAW_RETURN is True:
				self.full_out.append(sample)
			elif data_send is not None:
				self.full_out.append(data_send)
				udp.receive(data_send)
				# osc.osc_send(data_send)


def main():
	port = '/dev/ttyUSB0'
	# root = tkinter.Tk()
	db = Data_Buffer()
	global filt
	filt = filters.Filters()
	global udp
	udp = udp_server.UDPServer()
	global osc
	osc = streamer_osc.StreamerOSC()
	global tcp
		# tcp = tcp_server.TCPServer()





	# client = webserver.WebSocketClient()

	# webserver.connect()
	# board = open_bci_v3.OpenBCIBoard(port=port)
	# board.start_streaming(db.buffer)
	channel_data = []
	with open('sample16.txt', 'r') as file:
		reader = csv.reader(file, delimiter=',')
		next(file)
		j = 0
		for line in reader:
			channel_data.append(line[1:]) #list
			j+=1
	last_time_of_program = 0
	start = time.time()
	for i,sample in enumerate(channel_data):
		end = time.time()
		# Mantain the 250 Hz sample rate when reading a file
		# Wait for a period of time if the program runs faster than real time
		time_of_recording = i/250
		time_of_program = end-start
		print('i/250 (time of recording)', time_of_recording)
		print('comp timer (time of program)', time_of_program)
		if time_of_recording > time_of_program:
			# print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
			time.sleep(time_of_recording-time_of_program)
		db.buffer(sample)
	print("DONE",db.full_out)
	output = db.full_out
	# print(output)
	# output = map(float,output)
	# print(output)
	# print(type(db.full_out))
	# if db.BY_CHANNEL is True:
	# 	output = np.asarray(output).T
		# data = data.astype(np.float)

	# with open('test_data.csv', 'w') as text_file:
	# 	writer = csv.writer(text_file)
	# 	print('writing....')
	# 	writer.writerows(output)
	# 	print('done')

if __name__ == '__main__':
	main()

