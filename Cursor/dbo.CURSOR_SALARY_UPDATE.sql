
-- The Purpose of this Cursor is update the Salary column by increasing it by 10% for employees 
-- in the specific department and it will print the current and updated salary for each employee

DECLARE @rowcount   INTEGER		 = 0
      , @emp_id		INTEGER	     = 0
	  , @emp_name	VARCHAR(055) = ''
	  , @Department VARCHAR(070) = 'Sales' -- Mention the name of the department for which you want to update the salary
	  , @dept_id	INTEGER      = 0
	  , @PrevSalary MONEY	     = 0
	  , @CurrSalary MONEY	     = 0

DECLARE Employee cursor  
FOR SELECT
    emp.ID
  , isnull(emp.FIRST_NAME, '') + ' ' + emp.LAST_NAME
  , dept.DEPT_ID
  , emp.SALARY
  FROM  dbo.EMPLOYEE_INFO   emp  
  JOIN  dbo.DEPARTMENT_INFO dept
  ON    emp.DEPT_ID		     = dept.DEPT_ID
  WHERE UPPER(TRIM(dept.DEPARTMENT_NAME)) = UPPER(@Department) 
  FOR READ ONLY;

OPEN Employee

    FETCH NEXT FROM Employee INTO @emp_id, @emp_name,@dept_id, @PrevSalary

	WHILE @@FETCH_STATUS = 0  
		BEGIN

		PRINT 'Current Salary for the employee ' + @emp_name + ': ' + CAST(@PrevSalary AS VARCHAR)

		SET NOCOUNT ON

			UPDATE wrkt   
			   SET SALARY = SALARY * 1.10
		    FROM   dbo.EMPLOYEE_INFO  wrkt
			where  wrkt.ID= @emp_id
			AND    wrkt.DEPT_ID = @dept_id

			select @CurrSalary = emp.SALARY FROM dbo.EMPLOYEE_INFO emp where emp.ID = @emp_id AND emp.DEPT_ID = @dept_id
			
		PRINT 'Updated Salary for the employee ' + @emp_name + ': ' + CAST(@CurrSalary AS VARCHAR)
		PRINT '================================================================================='

		FETCH NEXT FROM Employee INTO @emp_id, @emp_name,@dept_id, @PrevSalary

		END
	CLOSE Employee

	DEALLOCATE Employee