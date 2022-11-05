from bluetooth import *
#bluetooth 라이브러리 위치는 어디일까?

socket = BluetoothSocket( RFCOMM )
#RFCOMM은 L2CAP 계층을 통해 블루투스 프로토콜 스택의 하위 계층에 연결된다.
socket.connect(("98:da:60:03:82:04",1))
#하나의 argument인가? python 문법?

print("bluetooth connected!")
while True:
	msg = input("send message : ")
	socket.send(msg)

socket.close

