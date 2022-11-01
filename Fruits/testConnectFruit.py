from bluetooth import *

socket = BluetoothSocket( RFCOMM )
socket.connect(("98:da:60:03:82:04",1))

print("bluetooth connected!")

msg = input("send message : ")
socket.send(msg)

print("finished")
socket.close
