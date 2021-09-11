.shell clear

-- load uuid extension
.load uuid.so
-- load regexp extension
.load regexp.so


DROP TABLE IF EXISTS %Template%;
CREATE TABLE IF NOT EXISTS %Template% (
	%Template%Id  TEXT       PRIMARY KEY DEFAULT(uuid()),
	InsertTime  TIMESTAMP              DEFAULT CURRENT_TIMESTAMP,
	UpdateTime  TIMESTAMP,
	InsertUser  TEXT       NOT NULL,
	UpdateUser  TEXT,
	Content     TEXT,
	CurrentUser TEXT
) WITHOUT ROWID;

--  "null", "integer", "real", "text", or "blob"

-- Primary key check
DROP TRIGGER IF EXISTS TR_%Template%_%Template%Id_PKCheck;
CREATE TRIGGER IF NOT EXISTS TR_%Template%_%Template%Id_PKCheck
	BEFORE INSERT
	ON %Template%
	WHEN NOT regexp('^[0-9abcdef]{8}(-[0-9abcdef]{4}){4}[0-9abcdef]{8}$', NEW.%Template%Id)
BEGIN
	SELECT RAISE (ABORT, 'PRIMARY KEY constraint UUID (8-4-4-4-12) failed: %Template%.%Template%Id');
END;

-- Insert into _LastInsertRowId
DROP TRIGGER IF EXISTS TR_%Template%_InsertLastRowId;
CREATE TRIGGER IF NOT EXISTS TR_%Template%_InsertLastRowId
	AFTER INSERT
	ON %Template%
BEGIN
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_Trigger_NoUpdate';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 0 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	INSERT INTO _LastInsertRowId (Id, TableName) VALUES (NEW.%Template%Id, '%Template%');
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_LastInsertRowId_InsertProhibit';
	UPDATE "Trigger" SET CurrentUser = 'SYSTEM', Enabled = 1 WHERE name = 'TR_Trigger_NoUpdate';
END;

-- Forbid modifying InsertUser, %Template%Id, InsertTime, UpdateTime
DROP TRIGGER IF EXISTS TR_%Template%_NoUpdate;
CREATE TRIGGER IF NOT EXISTS TR_%Template%_NoUpdate
	BEFORE UPDATE OF %Template%Id, InsertUser, InsertTime, UpdateTime
	ON %Template%
BEGIN
	SELECT
	CASE
        WHEN OLD.%Template%Id <> NEW.%Template%Id THEN RAISE (ABORT, 'UPDATE forbidden: %Template%.%Template%Id')
        WHEN OLD.InsertUser <> NEW.InsertUser THEN RAISE (ABORT, 'UPDATE forbidden: %Template%.InsertUser')
        WHEN OLD.InsertTime <> NEW.InsertTime THEN RAISE (ABORT, 'UPDATE forbidden: %Template%.InsertTime')
        WHEN OLD.UpdateTime <> NEW.UpdateTime THEN RAISE (ABORT, 'UPDATE forbidden: %Template%.UpdateTime')
	END;
END;

-- Enforce setting of CurrentUser on UPDATE
DROP TRIGGER IF EXISTS TR_%Template%_CurrentUser_Enforce;
CREATE TRIGGER IF NOT EXISTS TR_%Template%_CurrentUser_Enforce
	BEFORE UPDATE
	ON %Template%
	WHEN OLD.CurrentUser IS NULL AND NEW.CurrentUser IS NULL
BEGIN
	SELECT RAISE (ABORT, 'UPDATE mandatory: %Template%.CurrentUser');
END;

-- Move CurrentUser to UpdateUser after UPDATE
DROP TRIGGER IF EXISTS TR_%Template%_UpdateUser_Set;
CREATE TRIGGER IF NOT EXISTS TR_%Template%_UpdateUser_Set
	AFTER UPDATE
	ON %Template%
BEGIN
	UPDATE %Template% SET UpdateUser  = NEW.CurrentUser,
                        CurrentUser = NULL,
                        UpdateTime  = CURRENT_TIMESTAMP
	WHERE %Template%Id = NEW.%Template%Id;
END;
