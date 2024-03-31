# OrchardBase🌳🍎🍓🌳

## Overview
프로젝트 'OrchardBase'는 모바일 기기(iOS)를 사용하여 집 안의 조명 및 에어컨을 제어할 수 있는 IoT 시스템입니다. 모바일 기기와 서버(Raspberry-Pi)는 사용자의 명령을 받아 Firebase에서 해당 정보를 공유합니다. Arduino는 다양한 액추에이터 및 센서에 연결되어 있으며 허브와 Bluetooth를 통해 통신합니다.

아래에서는 화재를 방지하기 위해 실내 가스 농도를 검사하고 라이트 스위치를 제어하기 위해 서보 모터를 제어하는 다양한 기능을 찾을 수 있습니다.

## 개발 노트
https://likeable-clave-775.notion.site/ffb5be62f26a47ea86f332e640748f6f?pvs=74

## Tech stack
### iOS 관련
- UIKit
- SwiftUI
- Firebase

### 그 외
- Raspberry Pi
- Arduino(Bluetooth, Gas_dectection_modul, Servo_motor, IR_generator)
- Python3

## IoT Structure

![iot-architecture](https://github.com/dongju0561/OrchardBase/assets/77201628/9519f78d-190c-419f-b291-e15b9f3042a0)

이미지 출처: https://iotdunia.com/iot-architecture/

<br>

## Schematic

<img src="https://user-images.githubusercontent.com/77201628/193321263-5f5d1bde-1dac-4021-9284-7cd43b84dee4.jpeg" width="400"> 

<br>

모바일 디바이스 ➡️ Firebase|
|-----------------|
 |<img src="https://user-images.githubusercontent.com/77201628/193324004-ff17d57a-2005-4350-be4f-b1d0fe73fe40.gif" width="350" height="350">|<img src = "https://user-images.gitserverusercontent.com/77201628/193322987-8cd055e8-8170-4a9e-b867-29223f15c166.gif" width="300" height="350">|

모바일 디바이스 ➡️ 서버 ➡️ Arduino| 조명 제어를 위한 서보모터 동작제어
------------------------ |----------------------------------------------------------
<img src = "https://user-images.githubusercontent.com/77201628/200178367-85fda263-05a7-4f43-b176-cbea73c472e3.gif" width="400" height="450">|<img src = "https://user-images.githubusercontent.com/77201628/202427955-a88284be-da21-4058-b6da-cfc48445c20b.gif" width="350" height="400">

"gasIsDetected"변수 가스감지모듈로 가스 감지 후 상태 변화|
------------------------------------------------|
<img src = "https://user-images.githubusercontent.com/77201628/204012469-aa5e052b-a8ee-41f9-a305-a37ceecff2ec.gif" width="350" height="400">|

