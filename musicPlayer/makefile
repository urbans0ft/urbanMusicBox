all: uuid regexp

uuid: uuid.so
	@echo 'uuid.so' built with C source code as an amalgamation, version 3.36.0.

regexp: regexp.so
	@echo 'regexp.so' built with C source code as an amalgamation, version 3.36.0.

uuid.so: uuid.c sqlite3ext.h sqlite3.h
	gcc -g -fPIC -shared uuid.c -o uuid.so

regexp.so: regexp.c sqlite3ext.h sqlite3.h
	gcc -g -fPIC -shared regexp.c -o regexp.so

db: uuid regexp db.sqlite
	sqlite3 rfid.db ".read db.sqlite"

clean:
	rm -rf uuid.so
	rm -rf regexp.so