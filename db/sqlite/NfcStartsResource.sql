DROP TABLE IF EXISTS NfcStartsResource;
CREATE TABLE IF NOT EXISTS NfcStartsResource (
	NfcStartsResourceId TEXT       PRIMARY KEY DEFAULT(uuid()),
	InsertTime          TIMESTAMP              DEFAULT CURRENT_TIMESTAMP,
	UpdateTime          TIMESTAMP,
	InsertUser          TEXT       NOT NULL,
	UpdateUser          TEXT,
	CurrentUser         TEXT,
	NfcId               TEXT       NOT NULL,
	ResourceId          TEXT       NOT NULL,
	FOREIGN KEY(NfcId)      REFERENCES Nfc(NfcId),
	FOREIGN KEY(ResourceId) REFERENCES Resource(ResourceId)
) WITHOUT ROWID;

--  "null", "integer", "real", "text", or "blob"

-- Primary key check
DROP TRIGGER IF EXISTS TR_NfcStartsResource_NfcStartsResourceId_PKCheck;
CREATE TRIGGER IF NOT EXISTS TR_NfcStartsResource_NfcStartsResourceId_PKCheck
	BEFORE INSERT
	ON NfcStartsResource
	WHEN NOT regexp('^[0-9abcdef]{8}(-[0-9abcdef]{4}){4}[0-9abcdef]{8}$', NEW.NfcStartsResourceId)
BEGIN
	SELECT RAISE (ABORT, 'PRIMARY KEY constraint UUID (8-4-4-4-12) failed: NfcStartsResource.NfcStartsResourceId');
END;

-- Insert into _LastInsertRowId
DROP TRIGGER IF EXISTS TR_NfcStartsResource_InsertLastRowId;
CREATE TRIGGER IF NOT EXISTS TR_NfcStartsResource_InsertLastRowId
	AFTER INSERT
	ON NfcStartsResource
BEGIN
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_Trigger_NoUpdate';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	INSERT INTO _LastInsertRowId (Id, TableName) VALUES (NEW.NfcStartsResourceId, 'NfcStartsResource');
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_Trigger_NoUpdate';
END;

-- Forbid modifying InsertUser, NfcStartsResourceId, InsertTime, UpdateTime
DROP TRIGGER IF EXISTS TR_NfcStartsResource_NoUpdate;
CREATE TRIGGER IF NOT EXISTS TR_NfcStartsResource_NoUpdate
	BEFORE UPDATE OF NfcStartsResourceId, InsertUser, InsertTime, UpdateTime
	ON NfcStartsResource
BEGIN
	SELECT
	CASE
        WHEN OLD.NfcStartsResourceId <> NEW.NfcStartsResourceId THEN RAISE (ABORT, 'UPDATE forbidden: NfcStartsResource.NfcStartsResourceId')
        WHEN OLD.InsertUser <> NEW.InsertUser THEN RAISE (ABORT, 'UPDATE forbidden: NfcStartsResource.InsertUser')
        WHEN OLD.InsertTime <> NEW.InsertTime THEN RAISE (ABORT, 'UPDATE forbidden: NfcStartsResource.InsertTime')
        WHEN OLD.UpdateTime <> NEW.UpdateTime THEN RAISE (ABORT, 'UPDATE forbidden: NfcStartsResource.UpdateTime')
	END;
END;

-- Enforce setting of CurrentUser on UPDATE
DROP TRIGGER IF EXISTS TR_NfcStartsResource_CurrentUser_Enforce;
CREATE TRIGGER IF NOT EXISTS TR_NfcStartsResource_CurrentUser_Enforce
	BEFORE UPDATE
	ON NfcStartsResource
	WHEN OLD.CurrentUser IS NULL AND NEW.CurrentUser IS NULL
BEGIN
	SELECT RAISE (ABORT, 'UPDATE mandatory: NfcStartsResource.CurrentUser');
END;

-- Move CurrentUser to UpdateUser after UPDATE
DROP TRIGGER IF EXISTS TR_NfcStartsResource_UpdateUser_Set;
CREATE TRIGGER IF NOT EXISTS TR_NfcStartsResource_UpdateUser_Set
	AFTER UPDATE
	ON NfcStartsResource
BEGIN
	UPDATE NfcStartsResource SET UpdateUser  = NEW.CurrentUser,
                        CurrentUser = NULL,
                        UpdateTime  = CURRENT_TIMESTAMP
	WHERE NfcStartsResourceId = NEW.NfcStartsResourceId;
END;
