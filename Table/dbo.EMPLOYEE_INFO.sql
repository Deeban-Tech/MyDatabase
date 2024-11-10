DROP TABLE IF EXISTS dbo.EMPLOYEE_INFO
GO
CREATE TABLE dbo.EMPLOYEE_INFO   
(
  ID			 INTEGER		NOT NULL
, FIRST_NAME	 VARCHAR(100)	NOT NULL
, LAST_NAME		 VARCHAR(100)	NOT NULL
, MANAGER_ID	 INTEGER		NULL
, COMPANY_ID	 INTEGER		NULL
, PHONE_NO		 VARCHAR(20)	NULL
, JOINING_DATE	 DATETIME		NOT NULL
, RELIEVING_DATE DATE			NULL
, SALARY		 DECIMAL(15, 2) NOT NULL
, DEPT_ID		 INTEGER		NOT NULL, CONSTRAINT chk_phone_number CHECK (LEN(PHONE_NO) = 8) 
, CONSTRAINT chk_Salary		  CHECK (SALARY > 0)
, CONSTRAINT chk_Joining_Date CHECK (ISNULL(JOINING_DATE, '') > '' AND JOINING_DATE > '01/01/1900')
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX idx_Employee_Info_1 ON dbo.EMPLOYEE_INFO (ID)
GO
CREATE NONCLUSTERED INDEX idx_Employee_Info ON dbo.EMPLOYEE_INFO (ID, DEPT_ID, MANAGER_ID, COMPANY_ID)
GO
-- Insert employee records
CREATE TRIGGER dbo.TRIGGER_EMPLOYEE_INFO
ON  dbo.EMPLOYEE_INFO
FOR UPDATE
AS 
BEGIN

    UPDATE WRKT 
	   SET TERM_DATE	= GETDATE()
	FROM   dbo.EMPLOYEE_AUDIT_INFO   WRKT	
	WHERE  WRKT.ID		IN (SELECT ID FROM inserted)

	INSERT INTO dbo.EMPLOYEE_AUDIT_INFO
	(
	  ID			
	, FIRST_NAME	
	, LAST_NAME		
	, MANAGER_ID	
	, COMPANY_ID	
	, PHONE_NO		
	, JOINING_DATE	
	, RELIEVING_DATE
	, SALARY		
	, DEPT_ID					
	)
	SELECT 
	  ID			
	, FIRST_NAME	
	, LAST_NAME		
	, MANAGER_ID	
	, COMPANY_ID	
	, PHONE_NO		
	, JOINING_DATE	
	, RELIEVING_DATE
	, SALARY		
	, DEPT_ID			
	FROM inserted

END
GO
