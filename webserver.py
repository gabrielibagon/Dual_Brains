# import json
# import http.server
# import socketserver
# import socket
# import sys
# from threading import *
# import tornado.ioloop
# import tornado.web

# class Handler(tornado.websocket.WebSocketHandler):
# ################################################################
# 	# def __init__(self,ip="localhost",port=8000):
# 	# 	self.ip = ip
# 	# 	self.port = port
# 	# 	self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 	# 	self.sock.connect((ip,port))

# 	# 	# self.connection = http.client.HTTPSConnection(ip,port)
# 	# def receive(self,sample):
# 	# 	print("ok")
# 	# 	self.send_data(json.dumps(sample))
# 	# def send_data(self,sample):
# 	# 	print(sample)
# 	# 	self.sock.sendto(bytes(sample, "utf-8"), (self.ip, self.port))
# 		# self.connection.send(sample)
# #################################################################
# 	def open(self):
# 		self.write_message('connected')

# 	def on_message(self,message):
# 		print(message)
# 	def on_close(self):
# 		print('Connection closed')


# # class WebSocketClient():
# # 	def __init__(self):
# # 		self.connect()
		
# # 	def connect(self,url='http://c848ec60.ngrok.io/'):

# # 	def send(self):

# # 	def close(self):

# # 	# def _connect_callback(self,tornado.future):
# # 	# 	self._ws_connection = tornado.future.result()

# tornado.httpserver.HTTPServer(tornado.web.Application([("/", Handler)])).listen(1024)
# tornado.ioloop.IOLoop.instance().start()


from tornado import gen, httpclient, ioloop
from tornado import ioloop, web
import tornado

class WebSocketHandler(tornado.websocket.WebSocketHandler):
	def open(self):
		print('new connection')
	def on_message(self,message):
		self.write_message("message being written")

# collection of request handlers that make up a web application


if __name__ == "__main__":
	app = tornado.web.Application([
		(r'/', WebSocketHandler),
	])
	http_server = tornado.httpserver.HTTPServer(app)
	http_server.listen(8888)
	
