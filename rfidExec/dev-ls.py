#!/usr/bin/env python3

from evdev import InputDevice, list_devices

devicePaths = list_devices()
num = 1
name = []
for path in devicePaths:
    inputDevice = InputDevice(path)
    print("[", num, "]: ", inputDevice)
    name.append(inputDevice.name)
    inputDevice.close()
    num += 1
choice = input("Choose (USB) RFID reader: ")
if choice.isnumeric() and int(choice) > 0 and int(choice) <= len(name):
    idx = int(choice) - 1
    deviceName = (name[idx])
    f = open("rfid.device", "w")
    f.write(deviceName)
    f.close()
    print("Setting device \"{}\"".format(name[idx]))
else:
    print("No valid choice taken.")
