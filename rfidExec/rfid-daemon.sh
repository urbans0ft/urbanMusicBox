#!/bin/sh
deviceFile="rfid.device"

[ -f $deviceFile ] || { echo "Use ./devic-ls.py first (rfid.device does not exist)."; exit 1; }

deviceName=$(cat $deviceFile)
while true; do
	no=$(./rfid-read.py "$deviceName")
	#./action.sh "$no"
	/home/pi/musicPlayer/play.sh /home/pi/musicPlayer/rfid.db "$no"
done
