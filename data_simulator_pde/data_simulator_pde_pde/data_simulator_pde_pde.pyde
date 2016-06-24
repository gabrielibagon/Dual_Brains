with open('sample16.txt', 'r') as file:
    reader = csv.reader(file, delimiter=',')
    next(file)
    j = 0
    for line in reader:
      channel_data.append(line[1:]) #list
      j+=1