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
fanNum = (0,2,4,5)
fanIndex = 0
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
	oldAirPower = db.child("Airconditioner").child("powerIsOn").get().val()
	oldDTemp = db.child("Airconditioner").child("dTemp").get().val()

# component의 값을 변경 시켜주는 함수
def changeComponentState(control, component, oldData):
	global oldLight1
	global oldAirPower
	global oldDTemp

	newData = db.child(control).child(component).get().val()
	if control == "light":
		if newData != oldData: #데이터 상태가 변화했다면
			print(component+" is changed!")
			oldLight1 = newData	
			operateLightBLU(control, oldLight1)
		else: 						# 위에 조건을 만족 못하고 따로 return을 안시켜주면 None값을 return함...
			oldLight1 = oldData 				# 위의 조건을 만족 못할 
			operateLightBLU(control, oldLight1)

	elif control == "Airconditioner" and component == "dTemp":
		if newData != oldData:
			print(component+" is changed!")
			temp = (db.child(control).child(component).get().val()) #희망온도 읽어오기
			operateACBLU(control, temp) #블루투스를 통해 값 전달
			oldDTemp = newData
		else:
			oldDTemp = oldData

	elif control == "Airconditioner" and component == "powerIsOn":
		if newData != oldData:
			print(component+" is changed!")
			oldAirPower = newData
			operateACBLU(component, oldAirPower) #newData가 true인 경우 powerOn 그렇지 않은 경우 powerOff
		else: 
			oldAirPower = oldData

def operateLightBLU(control, new):
	global oldDTemp
	if(control == "light"):
		if(new == True):
			socket.send("lo#")
			print("send on")
		elif(new == False):
			socket.send("lf#")
			print("send off")

def operateACBLU(component, newData):
	global fanNum
	global fanIndex
	global oldAirPower
	if(component == "powerIsOn"):
		if(newData == True):
			socket.send("ao162#")
			print("power on")
		elif(newData == False):
			socket.send("af#")
			print("power off")
	elif(control == "temp"):
		socket.send("at"+oldAirPower+"1@")
	elif(control == "fan"):
		socket.send("an"+oldAirPower+"1@")

def checkState():
	global oldLight1
	global oldAirPower
	global oldDTemp

	state = db.child("state").get().val() # state변수가 바뀌었을때 일괄적으로 component 전체 확인

	if bool(state) == True:
		changeComponentState("light", "light1", oldLight1)
		changeComponentState("Airconditioner","dTemp", oldDTemp)
		changeComponentState("Airconditioner","powerIsOn", oldAirPower)
		db.child("state").set(False)

# 현재 개발자 개정이 없어 인증키가 없어 APNS를 이용하지 못해 보류
def checkGas():
	global oldGas
	data = socket.recv(128)
	data = int.from_bytes(data,"big") #bytes -> int (big-endian)
	if (data == 0x81 and oldGas == "false"): #0x81 = detect
		db.child("Sensor").child("gasIsDetected").set(True)
		oldGas = "true"
	elif(data == 0x80):			 #0x80 = undetect
		db.child("Sensor").child("gasIsDetected").set(False)
		oldGas = "false"

# main
initState()

while True:
	checkState()
#	checkGas()
socket.close
