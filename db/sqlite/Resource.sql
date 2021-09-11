DROP TABLE IF EXISTS Resource;
CREATE TABLE IF NOT EXISTS Resource (
	ResourceId  TEXT       PRIMARY KEY DEFAULT(uuid()),
	InsertTime  TIMESTAMP              DEFAULT CURRENT_TIMESTAMP,
	UpdateTime  TIMESTAMP,
	InsertUser  TEXT       NOT NULL,
	UpdateUser  TEXT,
	CurrentUser TEXT,
	Uri         TEXT       UNIQUE NOT NULL,
	Description TEXT,
	Jpeg        BLOB
) WITHOUT ROWID;

--  "null", "integer", "real", "text", or "blob"

-- Primary key check
DROP TRIGGER IF EXISTS TR_Resource_ResourceId_PKCheck;
CREATE TRIGGER IF NOT EXISTS TR_Resource_ResourceId_PKCheck
	BEFORE INSERT
	ON Resource
	WHEN NOT regexp('^[0-9abcdef]{8}(-[0-9abcdef]{4}){4}[0-9abcdef]{8}$', NEW.ResourceId)
BEGIN
	SELECT RAISE (ABORT, 'PRIMARY KEY constraint UUID (8-4-4-4-12) failed: Resource.ResourceId');
END;

-- Insert into _LastInsertRowId
DROP TRIGGER IF EXISTS TR_Resource_InsertLastRowId;
CREATE TRIGGER IF NOT EXISTS TR_Resource_InsertLastRowId
	AFTER INSERT
	ON Resource
BEGIN
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_Trigger_NoUpdate';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	INSERT INTO _LastInsertRowId (Id, TableName) VALUES (NEW.ResourceId, 'Resource');
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_Trigger_NoUpdate';
END;

-- Forbid modifying InsertUser, ResourceId, InsertTime, UpdateTime
DROP TRIGGER IF EXISTS TR_Resource_NoUpdate;
CREATE TRIGGER IF NOT EXISTS TR_Resource_NoUpdate
	BEFORE UPDATE OF ResourceId, InsertUser, InsertTime, UpdateTime
	ON Resource
BEGIN
	SELECT
	CASE
        WHEN OLD.ResourceId <> NEW.ResourceId THEN RAISE (ABORT, 'UPDATE forbidden: Resource.ResourceId')
        WHEN OLD.InsertUser <> NEW.InsertUser THEN RAISE (ABORT, 'UPDATE forbidden: Resource.InsertUser')
        WHEN OLD.InsertTime <> NEW.InsertTime THEN RAISE (ABORT, 'UPDATE forbidden: Resource.InsertTime')
        WHEN OLD.UpdateTime <> NEW.UpdateTime THEN RAISE (ABORT, 'UPDATE forbidden: Resource.UpdateTime')
	END;
END;

-- Enforce setting of CurrentUser on UPDATE
DROP TRIGGER IF EXISTS TR_Resource_CurrentUser_Enforce;
CREATE TRIGGER IF NOT EXISTS TR_Resource_CurrentUser_Enforce
	BEFORE UPDATE
	ON Resource
	WHEN OLD.CurrentUser IS NULL AND NEW.CurrentUser IS NULL
BEGIN
	SELECT RAISE (ABORT, 'UPDATE mandatory: Resource.CurrentUser');
END;

-- Move CurrentUser to UpdateUser after UPDATE
DROP TRIGGER IF EXISTS TR_Resource_UpdateUser_Set;
CREATE TRIGGER IF NOT EXISTS TR_Resource_UpdateUser_Set
	AFTER UPDATE
	ON Resource
BEGIN
	UPDATE Resource SET UpdateUser  = NEW.CurrentUser,
                        CurrentUser = NULL,
                        UpdateTime  = CURRENT_TIMESTAMP
	WHERE ResourceId = NEW.ResourceId;
END;
