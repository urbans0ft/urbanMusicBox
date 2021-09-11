#!/usr/bin/env python3

import sys
import evdev
from evdev import ecodes

# map from KEY_* code to string
KeyDict = {
    ecodes.KEY_0: "0",
    ecodes.KEY_1: "1",
    ecodes.KEY_2: "2",
    ecodes.KEY_3: "3",
    ecodes.KEY_4: "4",
    ecodes.KEY_5: "5",
    ecodes.KEY_6: "6",
    ecodes.KEY_7: "7",
    ecodes.KEY_8: "8",
    ecodes.KEY_9: "9",
}

rfidReaderName = sys.argv[1]
rfidReaderPath = ''

devices = evdev.list_devices()
for device in devices:
    inputDevice = evdev.InputDevice(device)
    if inputDevice.name == rfidReaderName:
        rfidReaderPath = inputDevice.path
    inputDevice.close()

if rfidReaderPath == '':
    sys.exit()

rfidDevice = evdev.InputDevice(rfidReaderPath)
for event in rfidDevice.read_loop():
    # event.value contains the key events (https://python-evdev.readthedocs.io/en/latest/apidoc.html#evdev.events.KeyEvent)
    if event.type == evdev.ecodes.EV_KEY and event.value == 1:
        #print(evdev.categorize(event))
	#print(event)
        if event.code == evdev.ecodes.KEY_ENTER:
            break
        print(KeyDict[event.code], end='')
rfidDevice.close()
print('')
