SET NOCOUNT ON
GO

-- Declaration of local variables

DECLARE @RowCount   INTEGER			= 0
	  , @lRetcd	    INTEGER			= 0
	  , @lPrintErr  VARCHAR(100)	= ''

-- Delete existing records from Company Info table

DELETE FROM dbo.DEPARTMENT_INFO 

SET @RowCount = @@ROWCOUNT
SET @lRetcd   = @@ERROR

IF @RowCount = 0 
	BEGIN
		IF @lRetcd <> 0
			BEGIN 
				PRINT 'Error when deleting existing records'
			END
		PRINT 'No records have been deleted from DEPARTMENT_INFO'
	END
ELSE
    BEGIN 
	   PRINT 'Records successfully deleted from DEPARTMENT_INFO table'
	   PRINT 'No of records deleted: ' + CONVERT(CHAR(010), @RowCount)
    END

-- Insert records into department table

INSERT INTO dbo.DEPARTMENT_INFO (DEPT_ID, DEPARTMENT_NAME)
VALUES
(1, 'Human Resources'),
(2, 'Engineering'),
(3, 'Sales'),
(4, 'Marketing'),
(5, 'Finance'),
(6, 'Operations'),
(7, 'Product Management'),
(8, 'Customer Support'),
(9, 'IT'),
(10, 'Legal');

SELECT @RowCount = COUNT(*) FROM dbo.DEPARTMENT_INFO
SET @lRetcd   = @@ERROR

IF @RowCount = 0 
	BEGIN
		IF @lRetcd <> 0
			BEGIN 
				PRINT 'Error when inserting records into dbo.DEPARTMENT_INFO'
			END
		PRINT 'No records have been inserted into DEPARTMENT_INFO'
	END
ELSE
    BEGIN 
	   PRINT 'Records successfully inserted into DEPARTMENT_INFO table'
	   PRINT 'No of records inserted: ' + CONVERT(CHAR(010), @RowCount)
    END