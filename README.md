Spotify RFID Music Player via Rasperry Pi
=========================================

The complete configuration of the Rasperry in this documentation is done via _ssh_. So there's no need to connect the Rasperry with display.

Prerequisites and (Runtime) Environment
---------------------------------------

Many things of the prequisites are exchangeable (e.g. Raspberry Pi versions). The following list is meant to illustrate a configuration which worked for me.

- Micro SD Card
- Win 10 64bit
- Win32Disk Imager
- Raspbian Lite
- LAN access
- Headphones or Speaker with 3.5mm audio jack

Configuration
-------------

- Burn image to SD Card using Win32Disk Imager
- create file named _ssh_ on _boot_ drive
- ssh pi@<ip> / password: raspberry

```
  sudo raspi-config
  # 7 Advanced options
  #   A1 Expand Filesystem
  #   A4 Audio
  #     0 Headphones
  # Finish -> Reboot
  sudo apt-get update
  sudo apt-get upgrade
```
  
Connect you speakers (headphones) to the Raspberry's audio jack and test the general audio output.

	export DISPLAY=:0
	speaker-test -c2 -twave -l7

Install _mopidy_ plus Spotify and [mpd](https://en.wikipedia.org/wiki/Music_Player_Daemon) extension.

	wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
	sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
	sudo apt update
	sudo apt install mopidy # this may take some time
	sudo apt install mopidy-spotify
	sudo apt install mopidy-mpd
	
	sudo apt install mpc


Configure the spotify connection:
	
	sudo apt-get install vim

sudo vim /etc/mopidy/mopidy.conf


	[spotify]
	enabled = true
	client_id = <client-id>
	client_secret = <client-secrect>
	username = <username>
	password = <password>
	bitrate = 320


The crucial part are the properties `client_id` and `client_secret`. They must be retrived via [Mopidy-Spotify extension site](https://mopidy.com/ext/spotify/). All possible Spotify properties can be found [here](https://github.com/mopidy/mopidy-spotify#configuration).


Have a look at the resulting mopidy configuration:

	sudo mopidyctl config

Configure start / stop the mopidy daemon:

	sudo systemctl enable mopidy
	sudo systemctl start mopidy
	sudo systemctl stop mopidy
	sudo systemctl restart mopidy
	sudo systemctl status mopidy

Have a look at the journal in case something went wrong.
	sudo journalctl -u mopidy


Play music over the mopidy daemon

```
  mpc clear
  mpc add spotify:playlist:2OZVlENh6kAfqpRyPIPyl7
  mpc play

	mpc load Fete
	mpc play
	mpc pause
	mpc stop
```

RFID Reader
-----------

and pypi with evdev package

	sudo apt install python3-pip
	sudo pip3 install evdev

	#!/usr/bin/env python3

	import evdev

	KeyDict = {
		evdev.ecodes.KEY_0: "0",
		evdev.ecodes.KEY_1: "1",
		evdev.ecodes.KEY_2: "2",
		evdev.ecodes.KEY_3: "3",
		evdev.ecodes.KEY_4: "4",
		evdev.ecodes.KEY_5: "5",
		evdev.ecodes.KEY_6: "6",
		evdev.ecodes.KEY_7: "7",
		evdev.ecodes.KEY_8: "8",
		evdev.ecodes.KEY_9: "9",
	}
	nico
	devices = evdev.list_devices()
	for device in devices:
		inputDevice = evdev.InputDevice(device)
		print(inputDevice.path, inputDevice.phys, "\"" +inputDevice.name +"\"")
	
	rfidDevice = evdev.InputDevice('/dev/input/event1')
	for event in rfidDevice.read_loop():
		# event.val contains the key events (https://python-evdev.readthedocs.io/en/latest/apidoc.html#evdev.events.KeyEvent)
		if event.type == evdev.ecodes.EV_KEY and event.value == 1:
			#print(evdev.categorize(event))
			#print(event)
			if event.code == evdev.ecodes.KEY_ENTER:
				break
			print(KeyDict[event.code], end='')
	
	print('')

Infrared Receiver
-----------------

	sudo vim /boot/config.txt
		dtoverlay=gpio-ir,gpio_pin=17

	sudo apt install ir-keytable
	pi@raspberrypi:~ $ sudo ir-keytable -p all -t
	Protocols changed to other lirc rc-5 rc-5-sz jvc sony nec sanyo mce_kbd rc-6 sharp xmp imon
	Testing events. Please, press CTRL-C to abort.
	237.200072: lirc protocol(nec): scancode = 0x46
	237.200115: event type EV_MSC(0x04): scancode = 0x46
	237.200115: event type EV_SYN(0x00).

Now we know that we have to use the _nec_ protocoll (`ir-keytable -p nec`).

	vim elegoo.toml
	[[protocols]]
	name = "Elegoo"
	protocol = "nec"
	variant = "nec32"
	
	[protocols.scancodes]
	0x45 = "KEY_POWER"
	0x46 = "KEY_VOLUMEUP"
	0x47 = "KEY_FN_S"
	0x44 = "KEY_BACK"
	0x40 = "KEY_PLAYPAUSE"
	0x43 = "KEY_FORWARD"
	0x07 = "KEY_DOWN"
	0x15 = "KEY_VOLUMEDOWN"
	0x09 = "KEY_UP"
	0x16 = "KEY_0"
	0x19 = "KEY_EQUAL"
	0x0d = "KEY_REPLY"
	0x0c = "KEY_1"
	0x18 = "KEY_2"
	0x5e = "KEY_3"
	0x08 = "KEY_4"
	0x1c = "KEY_5"
	0x5a = "KEY_6"
	0x42 = "KEY_7"
	0x52 = "KEY_8"
	0x4a = "KEY_9"

	pi@raspberrypi:~/ir $ sudo ir-keytable -c -w elegoo.toml
	Old keytable cleared
	Wrote 21 keycode(s) to driver
	Protocols changed to nec
	pi@raspberrypi:~/ir $ ir-keytable -r
	scancode 0x0007 = KEY_DOWN (0x6c)
	scancode 0x0008 = KEY_4 (0x05)
	scancode 0x0009 = KEY_UP (0x67)
	scancode 0x000c = KEY_1 (0x02)
	scancode 0x000d = KEY_REPLY (0xe8)
	scancode 0x0015 = KEY_VOLUMEDOWN (0x72)
	scancode 0x0016 = KEY_0 (0x0b)
	scancode 0x0018 = KEY_2 (0x03)
	scancode 0x0019 = KEY_EQUAL (0x0d)
	scancode 0x001c = KEY_5 (0x06)
	scancode 0x0040 = KEY_PLAYPAUSE (0xa4)
	scancode 0x0042 = KEY_7 (0x08)
	scancode 0x0043 = KEY_FORWARD (0x9f)
	scancode 0x0044 = KEY_BACK (0x9e)
	scancode 0x0045 = KEY_POWER (0x74)
	scancode 0x0046 = KEY_VOLUMEUP (0x73)
	scancode 0x0047 = KEY_FN_S (0x1e3)
	scancode 0x004a = KEY_9 (0x0a)
	scancode 0x0052 = KEY_8 (0x09)
	scancode 0x005a = KEY_6 (0x07)
	scancode 0x005e = KEY_3 (0x04)
	Enabled kernel protocols: lirc nec

Move tested file to standard folder

	pi@raspberrypi:~/ir $ sudo mv elegoo.toml /etc/rc_keymaps/
	sudo vim /etc/rc_maps.cfg
	
	sudo vim /etc/rc.local
	ir-keytable -a /etc/rc_maps.cfg -s rc0
	
	
sudo vim /etc/triggerhappy/triggers.d/ir.conf

	KEY_VOLUMEUP    1       mpc volume +5
	KEY_VOLUMEDOWN  1       mpc volume -5
	KEY_FORWARD     1       mpc next
	KEY_BACK        1       mpc prev
	KEY_PLAYPAUSE   1       /home/pi/thd/mpc-play-toggle.sh
	
	[[ $(mpc status | grep paused) == *"paused"* ]] && mpc play || mpc pause


Resume Playback
---------------

```
mpc status

Andreas H. Schmachtl - Kapitel 17.3 & Kapitel 18.1 - Missi Moppel. Das Geheimnis im Turmzimmer und andere Rätselhaftigkeiten
[paused]  #39/127   0:30/1:46 (28%)
volume:  2%   repeat: off   random: off   single: off   consume: off
```

	^\[[a-z]+\]\s+#([0-9]+)\/[0-9]+\s+([0-9:]+)\/[0-9:]+.*$

	Match  1: 39
	Match 2: 0:30
	
### Grep current volume

mpc status | grep "^volume:" | sed -E 's/^[^0-9]+([0-9]+).*/\1/'

Alas Mixer
----------

Install the `alsa-utils`

	sudo apt install alsa-utils

Install ALASMixser Mopidy extension:

	sudo apt install mopidy-alsamixer

The default `control = master` needs to be changed because the master volume
control is named `Digital` for the Hifi Berry AMP2.  
sudo vim /etc/mopidy/mopidy.conf

	[audio]
	mixer = alsamixer
	
	[alsamixer]
	enabled = true
	card = 0
	control = Digital
	min_volume = 0
	max_volume = 100
	volume_scale = cubic

Control the volume via the `amixer` because `mpc volume +1` does not work. The step
size seems to small you may use bigger ones.

	amixer set Digital 1%+ # Volume up
	amixer set Digital 1%- # Volume down



