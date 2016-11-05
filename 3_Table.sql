
CREATE TABLE [Archive].[Tables](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SchemaName] [varchar](50) NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[DateColumn] [varchar](50) NULL,
	[KeyColumn1] [varchar](50) NULL,
 CONSTRAINT [PK_TablesToArchive] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO



