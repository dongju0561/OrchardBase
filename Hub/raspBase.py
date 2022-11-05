import pyrebase
import time
from bluetooth import *

socket = BluetoothSocket( RFCOMM )
socket.connect(("98:da:60:03:82:04",1))

print("bluetooth connected!")

config = {
	"apiKey": "phMTjBWEtRt44mzu67HTUKju2pG7pjrhyY1HIJXG",
	"authDomain": "orchardbase.firebaseapp.com",
	"databaseURL": "https://orchardbase-default-rtdb.asia-southeast1.firebasedatabase.app/",
	"storageBucket": "orchardbase.appspot.com"
}

#firebase와 라즈베리파이 연동을 위한 초기화
firebase = pyrebase.initialize_app(config) 
db = firebase.database()

#전역변수
oldLight1 = ""
oldLight2 = ""
oldLight3 = ""
oldAirPower = ""
oldDTemp = "23" # desiredTemp
oldGas = "false"

print("Start program...")

# 데이터 초기화 함수
def initState(): #edit: initState
	global oldLight1
	global oldLight2
	global oldLight3 
	global oldAirPower
	global oldDTemp
 
	oldLight1 = db.child("light").child("light1").get().val() # get()메소드를 이용해서 조회
	oldLight2 = db.child("light").child("light2").get().val()
	oldLight3 = db.child("light").child("light3").get().val()
	oldAirPower = db.child("Airconditioner").child("power").get().val()
	oldDTemp = db.child("Airconditioner").child("dTemp").get().val()

# 전등 상태 변화 확인 함수
def checkState(control, component, oldData):
	newData = db.child(control).child(component).get().val()
	if control == "light":
		if newData != oldData:
			print(component+" is changed!")
			operateBLU()
			return newData
		else: 						# 위에 조건을 만족 못하고 따로 return을 안시켜주면 None값을 return함...
			return oldData 				# 위의 조건을 만족 못할 시
	elif control == "Airconditioner" and component == "dTemp":
		if newData != oldData:
			print(component+" is changed!")
			operateBLU()
			return newData
		else:
			return oldData

	elif control == "Airconditioner" and component == "dTemp":

		if newData != oldData:
			print(component+" is changed!")
			operateBLU()
			return oldData
		else:
			return oldData

	elif control == "Airconditioner" and component == "power":
		if newData != oldData:
			print(component+" is changed!")
			operateBLU()
			return newData
		else: 
			return oldData

def operateBLU():
	msg = "connect"
	socket.send(msg)


def checkState():
	global oldLight1	
	global oldLight2
	global oldLight3
	global oldAirDownTemp
	global oldAirUpTemp
	global oldAirPower
	global oldDTemp

	state = db.child("state").get().val() # state변수가 바뀌었을때 일괄적으로 component 전체 확인
	if bool(state) == True:
		oldLight1 = checkState("light", "light1", oldLight1)
		oldLight2 = checkState("light","light2", oldLight2)
		oldLight3 = checkState("light","light3", oldLight3)
		oldDTemp = checkState("Airconditioner","dTemp", oldDTemp)
		oldAirPower = checkState("Airconditioner","power", oldAirPower)
		db.child("state").set(False)

def checkGas():
	data = socket.recv(1024)
	data = data[1:4]
	print(type(data)) #bytes 타입
	if (data == bytes(d)):
		print("change")
		db.child("Sensor").child("Gas").set(True)
		oldGas = "true"
	elif(data == "n"):
		db.child("Sensor").child("Gas").set(False)
		oldGas = "false"

# main
initState()

while True:
	checkState()
	time.sleep(0.1)
	checkGas()

socket.close
