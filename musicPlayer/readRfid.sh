#!/bin/bash
this=$(basename "$0")
me=$(whoami)
if [[ $# -ne 3 ]]; then
	echo "usage: ./$this <db> <rfid-no> <column>"
	exit 1
fi

rowExists=$(sqlite3 $1 "SELECT count(*) FROM Rfid WHERE RfidNo = '$2'")
if [[ $rowExists -eq 0 ]]; then
	echo "[NULL]"
	exit 1
fi

sqlite3 $1 <<EOF
.load uuid.so
.load regexp.so
SELECT $3
FROM Rfid
WHERE RfidNo = '$2'
EOF

exit $?