
/*********************************************************************************************
Created By:		Clint Spann


Revision History:
-- 8/16/2016 – Created.  Yay!!!  


  
Purpose:	This procedure will archive data from each table listed in the Archive.Tables table
			 
     
Disclaimer: Use this procedure at your own risk.   I take no responsibility for the outcome of this procedure 
			on your system(s).  Please read, and be aware of, the "NEEDED TESTING" and "KNOWN ISSUES/CAVEATS" below - 
			these sections descibe potential issues with the code that may, or may not, affect your use of it.


NEEDED TESTING:


KNOWN ISSUES/CAVEATS:
--It is possible that the data being archinved won't be in chronological order


FUTURE ENHANCEMENTS:
--need to ensure records are removed in chronological order
--allow deadlock priority to be passed in
--create section to do a test (i.e. print commands)
--do we want to add an archive date for all tables?
--change table names to have an "_archive" suffix?
--variable lengths may need to be better

 
     
Parameters:

 @pArchiveDatabase varchar(100) = '[ArchiveDBName]'
			The database containing the archive tables
,@pArchiveSchema varchar(100) = '[ArchiveSchemaName]'
			The schema to which the archive tables belong
,@pDaysToGoBack int = 365 
			The number of days worth of data that are keep (e.g. start right now, and go back this many days - anything before that is archived)
,@pRowCount varchar(10) = 50
			How many rows do we archive from each table

--------------------------------------------------------------
TEST BLOCK

exec [Archive].[MoveData] @pArchiveDatabase = '[ArchiveDBName]'
					,@pArchiveSchema = 'dbo'
					,@pDaysToGoBack = 365 
					,@pRowCount = 50
--------------------------------------------------------------
*********************************************************************************************/



CREATE PROCEDURE [Archive].[MoveData]
(
 @pArchiveDatabase varchar(100) = ''
,@pArchiveSchema varchar(100) = ''
,@pDaysToGoBack int = 365 
,@pRowCount varchar(10) = 50
)
AS


SET NOCOUNT ON;


--make this the victim if a deadlock occurs
SET DEADLOCK_PRIORITY LOW

DECLARE @Command nvarchar(max)


CREATE TABLE #ArchiveCommands
(
ID int identity(1,1) NOT NULL
,Command varchar(8000)
)


INSERT INTO #ArchiveCommands (Command)
--Form commands for Archiving data
SELECT 'INSERT INTO ' + @pArchiveDatabase + '.' + @pArchiveSchema + '.' + t.TableName + ' (' + ColumnList + ') 
						SELECT ' + ColumnList + ' 
						FROM (DELETE TOP('+ @pRowCount + ') FROM ' + t.SchemaName + '.' + t.TableName + ' OUTPUT DELETED.* WHERE ' + t.DateColumn + ' < ''' + CAST((GETDATE() - @pDaysToGoBack) as VARCHAR(30)) + ''') as RowsToArchive'  
FROM
(
--get table name and its comma-separated list of columns
select OBJECT_NAME(c2.id) as TableName
     , ColumnList = STUFF (( SELECT ', ' + c1.name + ''
							 FROM syscolumns c1
							 WHERE c1.id = c2.id
							 FOR XML PATH('')), 1, 1, '') 
FROM syscolumns c2
GROUP BY c2.id
) TableData INNER JOIN Archive.[Tables] t on TableData.TableName = t.TableName


DECLARE @MaxRows int
DECLARE @Counter int = 1

Select @MaxRows = COUNT(*)
from #ArchiveCommands

WHILE @Counter <= @MaxRows
BEGIN

SELECT @Command = Command FROM #ArchiveCommands WHERE ID = @Counter

EXECUTE sp_executesql @Command

SET @Counter = @Counter + 1

END

DROP TABLE #ArchiveCommands

