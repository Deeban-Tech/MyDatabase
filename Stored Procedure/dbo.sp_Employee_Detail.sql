DROP PROCEDURE IF EXISTS dbo.Employee_Detail
GO
CREATE PROCEDURE dbo.Employee_Detail
  @pinEmpID			INTEGER		= 0	
, @pinDepartmentID	INTEGER		= 0
AS 
/*
*	Procedure	: dbo.Employee_Detail 0, 5
*
*   Purpose		: The purpose of this report to show employee informations based on the parameters.
*
*   Input		: Employee ID
*			      Department ID
*
*   Output		: Detailed informations for each employees
*
*/

BEGIN

BEGIN TRY

/*
******************************************************************************
* Declaration for the local variables
******************************************************************************
*/

    DECLARE @litRetCD		INTEGER		    = 0
	      , @PrintError		VARCHAR(255)	= SPACE(255)	
		  , @RowCount		INTEGER			= 0

/*
******************************************************************************
* Validate Passed parameters
******************************************************************************
*/

    IF @pinEmpID = 0 AND @pinDepartmentID = 0
	BEGIN
	    SET @PrintError = 'Employee ID or Department ID should be passed';
	    THROW 51000, @PrintError, 1;
        END

    IF @pinEmpID > 0 AND @pinDepartmentID > 0
	BEGIN
		    
	    SELECT @RowCount	= COUNT(*)
	    FROM   dbo.EMPLOYEE_INFO		emp
	    WHERE  emp.ID	= @pinEmpID
	    AND    emp.DEPT_ID	= @pinDepartmentID

	    IF @RowCount = 0
		BEGIN
		    SET @PrintError = 'Invalid combination of Employee and Department';
		    THROW 51000, @PrintError, 1;
		END
	END

    IF @pinEmpID > 0 AND @pinDepartmentID = 0
	BEGIN
		    
	    SELECT @RowCount	= COUNT(*)
	    FROM   dbo.EMPLOYEE_INFO	emp
	    WHERE  emp.ID		= @pinEmpID

	    IF @RowCount = 0
	        BEGIN
		    SET @PrintError = 'Invalid Employee ID';
		    THROW 51000, @PrintError, 1;
		END
	END
			    
    IF @pinEmpID = 0 AND @pinDepartmentID > 0
	BEGIN
		    
	    SELECT @RowCount	= COUNT(*)
	    FROM   dbo.EMPLOYEE_INFO		emp
	    WHERE  emp.DEPT_ID	= @pinDepartmentID

	    IF @RowCount = 0
	    	BEGIN
		    SET @PrintError = 'Invalid Department ID';
		    THROW 51000, @PrintError, 1;
		END
	END
/*
******************************************************************************
* Create temp table 
******************************************************************************
*/
    SET @PrintError = 'Create temp table #EMPLOYEE'

    CREATE TABLE #EMPLOYEE
    (
      EMP_ID	     INTEGER		NULL
    , DEPT_ID	     INTEGER		NULL
    , EMP_NAME	     VARCHAR(035)	NULL
    , DEPT_NAME	     VARCHAR(070)	NULL
    , SALARY	     MONEY		NULL
    , POSITION	     VARCHAR(030)	NULL
    , MANAGER_NAME   VARCHAR(055)	NULL
    , COMPANY_NAME   VARCHAR(100)	NULL
    , PHONE_NO	     VARCHAR(010)	NULL
    , JOINING_DATE   DATETIME		NULL
    , RELIEVING_DATE DATETIME		NULL
    , EMP_STATUS     VARCHAR(008)	NULL
    , EXPERIENCE     INTEGER     	NULL
    )

/*
******************************************************************************
* Get employee informations
******************************************************************************
*/
    SET @PrintError = 'Get employee informations'

    INSERT INTO #EMPLOYEE
    (
      EMP_ID		
    , DEPT_ID	    
    , EMP_NAME		
    , DEPT_NAME		
    , SALARY		
    , POSITION		
    , MANAGER_NAME
    , COMPANY_NAME	
    , PHONE_NO	    
    , JOINING_DATE  
    , RELIEVING_DATE
    , EMP_STATUS
    , EXPERIENCE
    )
    SELECT DISTINCT
      emp.ID
    , dept.DEPT_ID
    , TRIM(emp.FIRST_NAME) + ' ' + TRIM(emp.LAST_NAME)
    , dept.DEPARTMENT_NAME
    , emp.SALARY
    , ''
    , TRIM(mang.FIRST_NAME) + ' ' + TRIM(mang.LAST_NAME)
    , TRIM(comp.COMPANY_NAME)
    , emp.PHONE_NO
    , emp.JOINING_DATE
    , emp.RELIEVING_DATE
    , CASE WHEN ISNULL(emp.RELIEVING_DATE, '01/01/1753') = '01/01/1753' THEN
		'Active'
	   ELSE 'Relieved'
      END
    , DATEDIFF(YY, emp.JOINING_DATE, COALESCE(emp.RELIEVING_DATE, GETDATE()))
    FROM  dbo.EMPLOYEE_INFO		emp
    JOIN  dbo.COMPANY_INFO		comp
    ON    emp.COMPANY_ID		= comp.COMPANY_ID
    JOIN  dbo.DEPARTMENT_INFO		dept
    ON    emp.DEPT_ID			= dept.DEPT_ID
    JOIN  dbo.EMPLOYEE_INFO		mang
    ON    emp.MANAGER_ID		= mang.ID
    WHERE (@pinEmpID			= 0	
    OR	  emp.ID			= @pinEmpID)
    AND   (@pinDepartmentID		= 0
    OR	  dept.DEPT_ID			= @pinDepartmentID)

/*
******************************************************************************
* Update the position field
******************************************************************************
*/
    SET @PrintError = 'Update the position field'

    UPDATE WRKT
       SET POSITION  = CASE WHEN EXPERIENCE >= 0 AND EXPERIENCE <= 3 THEN
			         'Junior Level'
			    WHEN EXPERIENCE > 3 AND EXPERIENCE <= 6 THEN
				 'Mid-Senior Level'
			    ELSE 'Senior Lever'
		       END
    FROM  #EMPLOYEE		WRKT

/*
******************************************************************************
* Final Records to the report
******************************************************************************
*/

    SELECT @RowCount = COUNT(*)
    FROM   #EMPLOYEE  
   
    IF @RowCount > 0 
	BEGIN

	    SELECT 
	      EMP_ID				'Employee ID'
	    , EMP_NAME				'Employee Name'	
	    , DEPT_NAME				'Department Name'
	    , SALARY				'Employee Salary'
	    , POSITION				'Position' 
	    , MANAGER_NAME			'Manager Name'
	    , COMPANY_NAME			'Company Name'
	    , PHONE_NO				'Phone Number'
	    , JOINING_DATE			'Date of Joining'
	    , RELIEVING_DATE			'Date of Relieving'
	    , EMP_STATUS			'Employee status'
	    , EXPERIENCE			'Current Experience'
	    FROM #EMPLOYEE	

	END
    ELSE
	BEGIN
	    PRINT 'No Data for the report'
        END
RETURN 0
END TRY
BEGIN CATCH

    THROW 51000, @PrintError, 1;
    RETURN 1
	    
END CATCH
END
GO
