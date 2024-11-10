DROP TABLE IF EXISTS dbo.DEPARTMENT_INFO
GO
CREATE TABLE dbo.DEPARTMENT_INFO
(
  DEPT_ID			INTEGER		 NOT NULL
, DEPARTMENT_NAME	VARCHAR(070) NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX idx_dept_id ON dbo.DEPARTMENT_INFO (DEPT_ID)
GO
