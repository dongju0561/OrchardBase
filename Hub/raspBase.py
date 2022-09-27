import pyrebase
import time

config = {
	"apiKey": "phMTjBWEtRt44mzu67HTUKju2pG7pjrhyY1HIJXG",
	"authDomain": "orchardbase.firebaseapp.com",
	"databaseURL": "https://orchardbase-default-rtdb.asia-southeast1.firebasedatabase.app/",
	"storageBucket": "orchardbase.appspot.com"
}

firebase = pyrebase.initialize_app(config) #firebase와 라즈베리파이 연동을 위한 초기화
db = firebase.database()

print("Start program")

#데이터 베이스 최신화 
oldData1 = db.child("light").child("light1").get().val() # get()메소드를 이용해서 조회
oldData2 = db.child("light").child("light2").get().val()
oldData3 = db.child("light").child("light3").get().val()

def checkChangingLightState(light, oldDataP):
	
	newData = db.child("light").child(light).get().val()
	if newData != oldDataP:
		print(light+" is changed!")
		print(newData)
		return newData
	else: # 위에 조건을 만족 못하고 따로 return을 안시켜주면 None값을 return함...
		return oldDataP # 위의 조건을 만족 못할 시 


while True:

	oldData1 = checkChangingLightState("light1", oldData1)
	oldData2 = checkChangingLightState("light2", oldData2)
	oldData3 = checkChangingLightState("light3", oldData3)


# db.child("light").child("light1").set("False") / 키값  light/light1의 값 변경하는 방법

