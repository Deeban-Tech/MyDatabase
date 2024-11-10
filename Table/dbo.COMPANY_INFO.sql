use Leetcode
go

DROP TABLE IF EXISTS dbo.COMPANY_INFO
GO
CREATE TABLE dbo.COMPANY_INFO
(  
  COMPANY_ID		INTEGER			NOT NULL
, COMPANY_NAME		VARCHAR(255)	NOT NULL
, COMPANY_START_DT	DATE			NOT NULL
, ADDRESS			VARCHAR(255)	NOT NULL
, CITY				VARCHAR(100)	NOT NULL
, STATE				VARCHAR(100)	NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX idx_company_id ON COMPANY_INFO(COMPANY_ID)
GO