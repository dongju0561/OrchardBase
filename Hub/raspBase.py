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
def checkComponentState(control, component, oldData):
	newData = db.child(control).child(component).get().val()
	if control == "light":
		if newData != oldData:
			operateBLU(newData)
			print(component+" is changed!")
			return newData
		else: 						# 위에 조건을 만족 못하고 따로 return을 안시켜주면 None값을 return함...
			return oldData 				# 위의 조건을 만족 못할 시
	elif control == "Airconditioner" and component == "dTemp":
		if newData != oldData:
			temp = (db.child(control).child(component).get().val())
			print(" send! ")	
			return newData
		else:
			return oldData

	elif control == "Airconditioner" and component == "power":
		if newData != oldData:
			print(component+" is changed!")
			return newData
		else: 
			return oldData

def operateBLU(new):
	print(new)
	if(new == True):
		socket.send('y')
		print("send on")
	elif(new == False):
		socket.send('n')
		print("send off")

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
		oldLight1 = checkComponentState("light", "light1", oldLight1)
		oldLight2 = checkComponentState("light","light2", oldLight2)
		oldLight3 = checkComponentState("light","light3", oldLight3)
		oldDTemp = checkComponentState("Airconditioner","dTemp", oldDTemp)
		oldAirPower = checkComponentState("Airconditioner","power", oldAirPower)
		db.child("state").set(False)

# 현재 개발자 개정이 없어 인증키가 없어 APNS를 이용하지 못해 보류
def checkGas():
	global oldGas

	data = socket.recv(128)
	print(data)
	data = int.from_bytes(data,"big") #bytes -> int (big-endian)
	if (data == 0x81 and oldGas == "false"): #0x81 = detect
		db.child("Sensor").child("Gas").set(True)
		oldGas = "true"
	elif(data == 0x80):			 #0x80 = undetect
		db.child("Sensor").child("Gas").set(False)
		oldGas = "false"

# main
initState()

while True:
	checkState()
	time.sleep(0.1)

socket.close
