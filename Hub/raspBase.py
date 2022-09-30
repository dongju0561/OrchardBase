import pyrebase
import time

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

print("Start program")

# 데이터 초기화 함수
def initState(): #edit: initState
	print("getCurrentState")
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
def changeState(control, component, oldData):
	newData = db.child(control).child(component).get().val()
	if control == "light":
		if newData != oldData:
			print(component+" is changed!")
			operateBLU(newData)
			return newData
		else: 						# 위에 조건을 만족 못하고 따로 return을 안시켜주면 None값을 return함...
			return oldData 				# 위의 조건을 만족 못할 시
	elif control == "Airconditioner" and component == "dTemp":
		if newData != oldData:
			print(component+" is changed!")
			operateBLU(newData)
			return newData
		else:
			return oldData

	elif control == "Airconditioner" and component == "dTemp":

		if newData != oldData:
			print(component+" is changed!")
			operateBLU(newData)
			return oldData
		else:
			return oldData

	elif control == "Airconditioner" and component == "power":
		if newData != oldData:
			print(component+" is changed!")
			operateBLU(newData)
			return newData
		else: 
			return oldData

def operateBLU(value):
	print(value + "send data")

def checkState():
	global oldLight1	
	global oldLight2
	global oldLight3
	global oldAirDownTemp
	global oldAirUpTemp
	global oldAirPower
	global oldDTemp

	state = db.child("state").get().val() # state변수가 바뀌었을때 일괄적으로 component 전체 확인

	if state == "true":
		oldLight1 = changeState("light", "light1", oldLight1)
		oldLight2 = changeState("light","light2", oldLight2)
		oldLight3 = changeState("light","light3", oldLight3)
		oldDTemp = changeState("Airconditioner","dTemp", oldDTemp)
		oldAirPower = changeState("Airconditioner","power", oldAirPower)
		db.child("state").set("False")
# main
initState()

while True:
	checkState()






















