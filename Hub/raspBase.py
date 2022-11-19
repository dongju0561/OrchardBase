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

# component의 값을 변경 시켜주는 함수
def changeComponentState(control, component, oldData):
	newData = db.child(control).child(component).get().val()
	if control == "light":
		if newData != oldData: #데이터 상태가 변화했다면
			operateBLU(control, newData)
			print(component+" is changed!")
			return newData
		else: 						# 위에 조건을 만족 못하고 따로 return을 안시켜주면 None값을 return함...
			return oldData 				# 위의 조건을 만족 못할 시
	elif control == "Airconditioner" and component == "dTemp":
		if newData != oldData:
			print(component+" is changed!")
			temp = (db.child(control).child(component).get().val()) #희망온도 읽어오기
			operateBLU(control, temp) #블루투스를 통해 값 전달
			return newData
		else:
			return oldData

	elif control == "Airconditioner" and component == "power":
		if newData != oldData:
			print(component+" is changed!")
			operateBLU(control, newData) #newData가 true인 경우 powerOn 그렇지 않은 경우 powerOff
			return newData
		else: 
			return oldData

def operateBLU(control, new):
	if(control == "light"):
		if(new == True):
			socket.send("y")
			print("send on")
		elif(new == False):
			socket.send('n')
			print("send off")
	if(control == "Airconditioner"):
		#temp up
		#temp down
		#mode change
		#wind direction
		#power on
		#power off
		print("hello")

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
		oldLight1 = changeComponentState("light", "light1", oldLight1)
		oldLight2 = changeComponentState("light","light2", oldLight2)
		oldLight3 = changeComponentState("light","light3", oldLight3)
		oldDTemp = changeComponentState("Airconditioner","dTemp", oldDTemp)
		oldAirPower = changeComponentState("Airconditioner","power", oldAirPower)
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
	time.sleep(0.01)

socket.close
