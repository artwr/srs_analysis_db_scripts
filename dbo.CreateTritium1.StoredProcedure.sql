USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateTritium1]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateTritium1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateTritium1] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''tritium1'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[tritium1]
    
	--Create allresults table
	select t.* 
	into [SRSAnalysis].[dbo].[tritium1]
	from
	(
	select r.*,s.collection_DATE,s.STATION_SEQ,ss.STATION_ID,ss.NORTHING,ss.EASTING,ss.LATITUDE,ss.LONGITUDE,ss.GROUND_ELEVATION,ss.REFERENCE_ELEVATION,ss.TOP_ELEV,ss.BOTTOM_ELEV
     from
     (SELECT [ANALYSIS_DATE]
      ,[ANALYTE_NAME]
      ,[RESULT]
      ,[RESULT_UNITS]
      ,[ERROR]
      ,[MDL]
      ,[MDL_UNITS]
      ,[IDL]
      ,[IDL_UNITS]
      ,[PQL]
      ,[PQL_UNITS]
      ,[SAMPLE_SEQ]
      ,[RESULT_SEQ]
  FROM [SRSAnalysis].[dbo].[allresults_a] where ANALYTE_NAME=''TRITIUM'') r
  join allsamples_a s
  on r.sample_seq=s.sample_seq
  join allstations_a ss
  on s.station_seq=ss.station_seq
	) as t
		
		ALTER TABLE tritium1
		ADD MDATE varchar(127)
		
		UPDATE tritium1
		SET MDATE=COLLECTION_DATE
		
		UPDATE tritium1
		SET MDATE=ANALYSIS_DATE
		where MDATE is NULL
		
		
		--Create index on SAMPLE_SEQ
		/*
		create index AllResults_sampleseq_idx
		on tritium1(SAMPLE_SEQ);
		
		create index AllResults_resultseq_idx
		on tritium1(RESULT_SEQ);
		*/
		create index AllResults_stationseq_idx
		on tritium1(STATION_SEQ);
		
		
		
END
' 
END
GO
