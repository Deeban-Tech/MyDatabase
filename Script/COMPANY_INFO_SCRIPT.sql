SET NOCOUNT ON
GO
DECLARE @RowCount   INTEGER			= 0
	  , @lRetcd	    INTEGER			= 0
	  , @lPrintErr  VARCHAR(100)	= ''

-- Delete existing records from Company Info table

DELETE FROM dbo.COMPANY_INFO 

SET @RowCount = @@ROWCOUNT
SET @lRetcd   = @@ERROR

IF @RowCount = 0 
	BEGIN
		IF @lRetcd <> 0
			BEGIN 
				PRINT 'Error when deleting existing records'
			END
		PRINT 'No records have been deleted from COMPANY_INFO'
	END
ELSE
    BEGIN 
	   PRINT 'Records successfully deleted from COMPANY_INFO table'
	   PRINT 'No of records deleted: ' + CONVERT(CHAR(010), @RowCount)
    END

-- Insert records into company information table

INSERT INTO dbo.COMPANY_INFO (COMPANY_ID, COMPANY_NAME, COMPANY_START_DT, ADDRESS, CITY, STATE)
VALUES
(1, 'Tech Innovations Inc.', '2010-05-15', '123 Tech Park, Silicon Valley', 'San Francisco', 'California'),
(2, 'Global Solutions LLC', '2008-08-25', '456 Global Road, Business City', 'New York', 'New York'),
(3, 'Creative Minds Ltd.', '2015-02-10', '789 Creative Ave, Art District', 'Los Angeles', 'California'),
(4, 'Blue Ocean Enterprises', '2012-07-19', '101 Ocean Blvd, Beach Town', 'Miami', 'Florida'),
(5, 'NextGen Systems', '2020-11-05', '2020 Innovation Street, Tech Valley', 'Austin', 'Texas');

SELECT @RowCount = COUNT(*) FROM dbo.COMPANY_INFO
SET @lRetcd   = @@ERROR

IF @RowCount = 0 
	BEGIN
		IF @lRetcd <> 0
			BEGIN 
				PRINT 'Error when inserting records into dbo.COMPANY_INFO'
			END
		PRINT 'No records have been inserted into COMPANY_INFO'
	END
ELSE
    BEGIN 
	   PRINT 'Records successfully inserted into COMPANY_INFO table'
	   PRINT 'No of records inserted: ' + CONVERT(CHAR(010), @RowCount)
    END