# DataArchiving
TSQL code for archiving data from tables

1) If you already have a database you wish to use for archiving, skip this step.  Otherwise, run "1_ArchiveDB.sql" to create a new archive database

2) Change the context to the user database which contains the tables from which you want to archive data, then run "2_Schema.sql" to create the Archive schema (NOTE - if you already have an archive schema, this will error).

3) On the same user database as #2, run "#3_table.sql" to create the lookup table for archive tables

4) On the same user database as #3, run "4_proc.sql" to create the archiving proc

4) Populate the table creatd in step #3 with the schema, table name, and key column from each table you want to archive data from

5) Now you can run the procedure, with appropriate parameters, to archive data from the tables in your lookup table

!!IMPORTANT!!
Please read, and be aware of, the "NEEDED TESTING" and "KNOWN ISSUES/CAVEATS" below - these sections descibe potential issues with the code that may, or may not, affect your use of it.
!!---------!!

