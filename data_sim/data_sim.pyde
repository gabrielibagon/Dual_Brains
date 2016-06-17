import csv
import time

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
    print(i)
    print('i/250 (time of recording)', time_of_recording)
    print('comp timer (time of program)', time_of_program)
    if time_of_recording > time_of_program:
      # print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
      time.sleep(time_of_recording-time_of_program)