from bluetooth import *

socket = BluetoothSocket(RFCOMM)
socket.connect(("98:da:60:03:82:04",1))
print("bluetooth connected")

while True:
	data = socket.recv(1024)
	print("%s" %data)
