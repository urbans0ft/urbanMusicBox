#!/bin/bash
this=$(basename "$0")
me=$(whoami)
if [[ $# -ne 2 ]]; then
	echo "usage: ./$this <db> <rfid-no>"
	exit 1
fi

echo "$this: $@"

sqlite3 $1 <<EOF
.load uuid.so
.load regexp.so
DELETE
FROM Rfid
WHERE RfidNo = '$2'
EOF

exit $?