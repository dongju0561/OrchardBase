# OrchardBase🌳🍎🍓🌳

## Overview
Project “OchardBase” is IoT system which easily controls the lights and the airconditioner in our house, check indoor carbon dioxide concentration to prevent fire and the amount of laundry with mobile device(iOS).

Mobile device and Hub(Raspberry-Pi) shares informations for commands from user on Firebase.

Arduino which is connected by various actuators and sensors  and Hub communicate through Bluetooth

## Schematic
<p align="center">
 <img src="https://user-images.githubusercontent.com/77201628/193321263-5f5d1bde-1dac-4021-9284-7cd43b84dee4.jpeg" width="400">
</p>

Mobile-device ➡️ Firebase|Firebase ➡️ Hub
-----------------|----------------------
 <img src="https://user-images.githubusercontent.com/77201628/193324004-ff17d57a-2005-4350-be4f-b1d0fe73fe40.gif" width="350" height="350">|<img src = "https://user-images.githubusercontent.com/77201628/193322987-8cd055e8-8170-4a9e-b867-29223f15c166.gif" width="300" height="350">

Mobile-device ➡️ Hub ➡️ Arduino| controll the servo motor for light with mobile device
------------------------ |----------------------------------------------------------
<img src = "https://user-images.githubusercontent.com/77201628/200178367-85fda263-05a7-4f43-b176-cbea73c472e3.gif" width="400" height="450">|<img src = "https://user-images.githubusercontent.com/77201628/202427955-a88284be-da21-4058-b6da-cfc48445c20b.gif" width="300" height="350">
