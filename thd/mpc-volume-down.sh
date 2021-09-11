#!/bin/bash
# grab current volume
volume=$(mpc status | grep "^volume:" | sed -E 's/^[^0-9]+([0-9]+).*/\1/')
if (( $volume > 1 )); then
	amixer set Digital 1%- # mpc volume -1 
else
	echo -ne '\007'
fi
