#!/bin/bash

if [[ $# -ne 2 ]]; then
	echo "usage: ./play <db> <rfid-no>"
	exit 1
fi

# chage to dir the script it in
cd "$(dirname "$0")"
# the current dir is a lib dir as well (*.so)
LD_LIBRARY_PATH="$(pwd)"
export LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH

echo "RfidNo: $@"
uri=$(./readRfid.sh $1 $2 Uri)
if [[ $? -ne 0 ]]; then
	echo "RfidNo '$2' in $1 not found."
	exit 1
fi

mpc stop
mpc clear
while IFS= read -r l; do
	mpc add "$l"
done <<< "$uri"
mpc play

exit 0
