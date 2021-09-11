DROP TABLE IF EXISTS "Trigger";
CREATE TABLE IF NOT EXISTS "Trigger" (
	TriggerId   TEXT       PRIMARY KEY DEFAULT(uuid()),
	InsertTime  TIMESTAMP              DEFAULT CURRENT_TIMESTAMP,
	UpdateTime  TIMESTAMP,
	InsertUser  TEXT       NOT NULL,
	UpdateUser  TEXT,
	CurrentUser TEXT,
	Name        TEXT       NOT NULL,
	Enabled     BOOLEAN    NOT NULL CHECK (Enabled = 1 OR Enabled = 0)
) WITHOUT ROWID;

-- Primary key check
DROP TRIGGER IF EXISTS TR_Trigger_TriggerId_PKCheck;
CREATE TRIGGER IF NOT EXISTS TR_Trigger_TriggerId_PKCheck
	BEFORE INSERT
	ON "Trigger"
	WHEN NOT regexp('^[0-9abcdef]{8}(-[0-9abcdef]{4}){4}[0-9abcdef]{8}$', NEW.TriggerId)
BEGIN
	SELECT RAISE (ABORT, 'PRIMARY KEY constraint UUID (8-4-4-4-12) failed: Trigger.TriggerId');
END;

-- Insert into _LastInsertRowId
DROP TRIGGER IF EXISTS TR_Trigger_InsertLastRowId;
CREATE TRIGGER IF NOT EXISTS TR_Trigger_InsertLastRowId
	AFTER INSERT
	ON "Trigger"
BEGIN
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_Trigger_NoUpdate';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	INSERT INTO _LastInsertRowId (Id, TableName) VALUES (NEW.TriggerId, 'Trigger');
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_Trigger_NoUpdate';
END;

-- Forbid modifying InsertUser, TriggerId, InsertTime, UpdateTime
DROP TRIGGER IF EXISTS TR_Trigger_NoUpdate;
CREATE TRIGGER IF NOT EXISTS TR_Trigger_NoUpdate
	BEFORE UPDATE OF TriggerId, InsertUser, InsertTime, UpdateTime
	ON "Trigger"
	WHEN EXISTS(SELECT 1 FROM "Trigger" WHERE name = 'TR_Trigger_NoUpdate' AND Enabled = 1)
BEGIN
	SELECT
	CASE
        WHEN OLD.TriggerId <> NEW.TriggerId THEN RAISE (ABORT, 'UPDATE forbidden: Trigger.TriggerId')
        WHEN OLD.InsertUser <> NEW.InsertUser THEN RAISE (ABORT, 'UPDATE forbidden: Trigger.InsertUser')
        WHEN OLD.InsertTime <> NEW.InsertTime THEN RAISE (ABORT, 'UPDATE forbidden: Trigger.InsertTime')
        WHEN OLD.UpdateTime <> NEW.UpdateTime THEN RAISE (ABORT, 'UPDATE forbidden: Trigger.UpdateTime')
	END;
END;
Insert Into "Trigger"(InsertUser, Name, Enabled) Values('SYSTEM', 'TR_Trigger_NoUpdate', 1);

-- Enforce setting of CurrentUser on UPDATE
DROP TRIGGER IF EXISTS TR_Trigger_CurrentUser_Enforce;
CREATE TRIGGER IF NOT EXISTS TR_Trigger_CurrentUser_Enforce
	BEFORE UPDATE
	ON "Trigger"
	WHEN OLD.CurrentUser IS NULL AND NEW.CurrentUser IS NULL
BEGIN
	SELECT RAISE (ABORT, 'UPDATE mandatory: Trigger.CurrentUser');
END;

-- Move CurrentUser to UpdateUser after UPDATE
DROP TRIGGER IF EXISTS TR_Trigger_UpdateUser_Set;
CREATE TRIGGER IF NOT EXISTS TR_Trigger_UpdateUser_Set
	AFTER UPDATE
	ON "Trigger"
BEGIN
	UPDATE "Trigger" SET UpdateUser  = NEW.CurrentUser,
                         CurrentUser = NULL,
                         UpdateTime  = CURRENT_TIMESTAMP
	WHERE TriggerId = NEW.TriggerId;
END;

-- Only allow insertion for trigger which really exist
DROP TRIGGER IF EXISTS TR_Trigger_INSERT_Exists;
CREATE TRIGGER IF NOT EXISTS TR_Trigger_INSERT_Exists
	BEFORE INSERT
	ON "Trigger"
	WHEN NOT EXISTS (SELECT 1 FROM sqlite_master WHERE type = 'trigger' AND name = NEW.Name)
BEGIN
	SELECT RAISE (ABORT, 'INSERT "Trigger" does not exist: "Trigger".Name');
END;