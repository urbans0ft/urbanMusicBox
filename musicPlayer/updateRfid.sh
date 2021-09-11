#!/bin/bash
this=$(basename "$0")
me=$(whoami)
if [[ $# -ne 3 ]]; then
	echo "usage: ./$this <db> <rfid-no> <uri>"
	exit 1
fi

echo "$this: $@"

sqlite3 $1 <<EOF
.load uuid.so
.load regexp.so
UPDATE Rfid
SET Uri = '$3', CurrentUser = '$me' WHERE RfidNo = '$2';
EOF

exit $?