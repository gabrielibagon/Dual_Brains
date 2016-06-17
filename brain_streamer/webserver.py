import django

class Websocket():
	def __init__(self,ip='localhost',port=8888):
		self.ip = ip
		self.port = port
		self.handler = SimpleHTTPServer.SimpleHTTPRequestHandler
		httpd = SocketServer.TCPServer(('', port), Handler)

		httpd.serve_forever()
		# self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		# self.sock.connect((socket.gethostname(),port))
		# self.sock.listen(2)
		# self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		# self.sock.bind((self.ip, self.port))
		# self.sock.connect((ip,port))
		# self.sock.listen(1)

		print('server connected on port', port)
		# self.connect(ip,port)

		# server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		# server.bind((ip,port))
		# server.listen(1

	def receive(self,sample):
		self.send_data(json.dumps(sample))
# 		http_response = """\
# HTTP/1.1 200 OK

# Hello, World!
# """
# 		# self.client_connection = self.server.accept()
		# request = self.client_connection.recv(1024)
		# print(request)
		# self.client_connection.sendall(http_response.encode())
		# self.client_connection.close()

	def send_data(self,sample):
		self.sock.sendto(bytes(sample, "utf-8"), (self.ip, self.port))