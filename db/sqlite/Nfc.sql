DROP TABLE IF EXISTS Nfc;
CREATE TABLE IF NOT EXISTS Nfc (
	NfcId       TEXT       PRIMARY KEY DEFAULT(uuid()),
	InsertTime  TIMESTAMP              DEFAULT CURRENT_TIMESTAMP,
	UpdateTime  TIMESTAMP,
	InsertUser  TEXT       NOT NULL,
	UpdateUser  TEXT,
	CurrentUser TEXT,
	NfcNo       TEXT       UNIQUE NOT NULL
) WITHOUT ROWID;

--  "null", "integer", "real", "text", or "blob"

-- Primary key check
DROP TRIGGER IF EXISTS TR_Nfc_NfcId_PKCheck;
CREATE TRIGGER IF NOT EXISTS TR_Nfc_NfcId_PKCheck
	BEFORE INSERT
	ON Nfc
	WHEN NOT regexp('^[0-9abcdef]{8}(-[0-9abcdef]{4}){4}[0-9abcdef]{8}$', NEW.NfcId)
BEGIN
	SELECT RAISE (ABORT, 'PRIMARY KEY constraint UUID (8-4-4-4-12) failed: Nfc.NfcId');
END;

-- Insert into _LastInsertRowId
DROP TRIGGER IF EXISTS TR_Nfc_InsertLastRowId;
CREATE TRIGGER IF NOT EXISTS TR_Nfc_InsertLastRowId
	AFTER INSERT
	ON Nfc
BEGIN
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_Trigger_NoUpdate';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	INSERT INTO _LastInsertRowId (Id, TableName) VALUES (NEW.NfcId, 'Nfc');
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_Trigger_NoUpdate';
END;

-- Forbid modifying InsertUser, NfcId, InsertTime, UpdateTime
DROP TRIGGER IF EXISTS TR_Nfc_NoUpdate;
CREATE TRIGGER IF NOT EXISTS TR_Nfc_NoUpdate
	BEFORE UPDATE OF NfcId, InsertUser, InsertTime, UpdateTime
	ON Nfc
BEGIN
	SELECT
	CASE
        WHEN OLD.NfcId <> NEW.NfcId THEN RAISE (ABORT, 'UPDATE forbidden: Nfc.NfcId')
        WHEN OLD.InsertUser <> NEW.InsertUser THEN RAISE (ABORT, 'UPDATE forbidden: Nfc.InsertUser')
        WHEN OLD.InsertTime <> NEW.InsertTime THEN RAISE (ABORT, 'UPDATE forbidden: Nfc.InsertTime')
        WHEN OLD.UpdateTime <> NEW.UpdateTime THEN RAISE (ABORT, 'UPDATE forbidden: Nfc.UpdateTime')
	END;
END;

-- Enforce setting of CurrentUser on UPDATE
DROP TRIGGER IF EXISTS TR_Nfc_CurrentUser_Enforce;
CREATE TRIGGER IF NOT EXISTS TR_Nfc_CurrentUser_Enforce
	BEFORE UPDATE
	ON Nfc
	WHEN OLD.CurrentUser IS NULL AND NEW.CurrentUser IS NULL
BEGIN
	SELECT RAISE (ABORT, 'UPDATE mandatory: Nfc.CurrentUser');
END;

-- Move CurrentUser to UpdateUser after UPDATE
DROP TRIGGER IF EXISTS TR_Nfc_UpdateUser_Set;
CREATE TRIGGER IF NOT EXISTS TR_Nfc_UpdateUser_Set
	AFTER UPDATE
	ON Nfc
BEGIN
	UPDATE Nfc SET UpdateUser  = NEW.CurrentUser,
                        CurrentUser = NULL,
                        UpdateTime  = CURRENT_TIMESTAMP
	WHERE NfcId = NEW.NfcId;
END;
