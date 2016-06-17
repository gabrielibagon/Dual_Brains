from django.http import HttpResponse
import socket
import json
import http.server
import requests
import socketserver

class Websocket():
################################################################
	# def __init__(self,ip="localhost",port=8000):
	# 	self.ip = ip
	# 	self.port = port
	# 	self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	# 	self.sock.connect((ip,port))

	# 	# self.connection = http.client.HTTPSConnection(ip,port)
	# def receive(self,sample):
	# 	print("ok")
	# 	self.send_data(json.dumps(sample))
	# def send_data(self,sample):
	# 	print(sample)
	# 	self.sock.sendto(bytes(sample, "utf-8"), (self.ip, self.port))
		# self.connection.send(sample)
#################################################################
	def __init__(self,ip="localhost",port=8000):
		Handler = http.server.SimpleHTTPRequestHandler
		httpd = socketserver.TCPServer(('',port), Handler)
		
		print('server at port', port)

		httpd.serve_forever()