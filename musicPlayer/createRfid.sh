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
INSERT INTO Rfid (InsertUser, RfidNo, Uri)
VALUES('$me', '$2', '$3');
EOF

exit $?