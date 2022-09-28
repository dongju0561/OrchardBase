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
oldAirDownTemp = "False"
oldAirUpTemp = "False"
oldAirPower = "False"

print("Start program")

# 데이터 초기화 함수
def getCurrentState():
	global oldLight1
	global oldLight2
	global oldLight3 

	oldLight1 = db.child("light").child("light1").get().val() # get()메소드를 이용해서 조회
	oldLight2 = db.child("light").child("light2").get().val()
	oldLight3 = db.child("light").child("light3").get().val()
	db.child("Airconditioner").child("downTemp").set("False") 
	db.child("Airconditioner").child("power").set("False") 
	db.child("Airconditioner").child("upTemp").set("False") 

# 전등 상태 변화 확인 함수
def checkChangingState(control, component, oldData):
	if control == "light":
		newData = db.child("light").child(component).get().val()

		if newData != oldData:
			print(component+" is changed!")
			return newData

		else: 						# 위에 조건을 만족 못하고 따로 return을 안시켜주면 None값을 return함...
			return oldData 				# 위의 조건을 만족 못할 시

	elif control == "airconditioner":
		newData = db.child("Airconditioner").child(component).get().val()

		if newData != oldData:
			operateAir(component)
			print(newData)
			print(oldData)	
			print(component+" is changed!")
			return oldData

		else:
			return oldData

def operateAir(AirComponent):
	operateBLU()
	db.child("Airconditioner").child(AirComponent).set("False") 

def operateBLU():
	print("send data")
	
# main
getCurrentState()

while True:
	oldLight1 = checkChangingState("light", "light1", oldLight1)
	oldLight2 = checkChangingState("light","light2", oldLight2)
	oldLight3 = checkChangingState("light","light3", oldLight3)
	oldAirDownTemp = checkChangingState("airconditioner", "downTemp", oldAirDownTemp)
	oldAirUpTemp = checkChangingState("airconditioner","upTemp", oldAirUpTemp)
	oldAirPower = checkChangingState("airconditioner","power", oldAirPower)
