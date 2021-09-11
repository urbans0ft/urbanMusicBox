.shell clear

-- load uuid extension
.load uuid.so
-- load regexp extension
.load regexp.so

.read 'Trigger.sql'

-- table to keep track of uuids.
DROP TABLE IF EXISTS _LastInsertRowId;
CREATE TABLE IF NOT EXISTS _LastInsertRowId (
	Id         TEXT      PRIMARY KEY,
	TableName  TEXT,
	InsertTime TIMESTAMP             DEFAULT CURRENT_TIMESTAMP
) WITHOUT ROWID;

-- Prohibit manual modifying of _LastInsertRowId table
DROP TRIGGER IF EXISTS TR_LastInsertRowId_InsertProhibit;
CREATE TRIGGER IF NOT EXISTS TR_LastInsertRowId_InsertProhibit
	BEFORE INSERT
	ON _LastInsertRowId
	WHEN EXISTS(SELECT 1 FROM "Trigger" WHERE name = 'TR_LastInsertRowId_InsertProhibit' AND Enabled = 1)
BEGIN
	SELECT RAISE (ABORT, 'INSERT forbidden: _LastInsertRowId');
END;
DROP TRIGGER IF EXISTS TR_LastInsertRowId_UpdateProhibit;
CREATE TRIGGER IF NOT EXISTS TR_LastInsertRowId_UpdateProhibit
	BEFORE UPDATE
	ON _LastInsertRowId
BEGIN
	SELECT RAISE (ABORT, 'UPDATE forbidden: _LastInsertRowId');
END;
-- Table "Trigger" and the trigger "TR_LastInsertRowId_InsertProhibit" itself
-- have to be present before an insertion is allowed because a trigger on the 
-- table "Trigger" prohibits the insertion of unknown triggers.
Insert Into "Trigger"(InsertUser, Name, Enabled) Values('SYSTEM', 'TR_LastInsertRowId_InsertProhibit', 1);


.read 'Nfc.sql'
.read 'Resource.sql'
.read 'NfcStartsResource.sql'

.read 'data.sql'