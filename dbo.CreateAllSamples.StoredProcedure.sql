USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateAllSamples]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateAllSamples]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateAllSamples] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allsamples'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples]
    
	--Create allsamples table
	select s.* 
	into [SRSAnalysis].[dbo].[allsamples]
	from
	(SELECT [SAMPLE_SEQ]
      ,[FACILITY_ID]
      ,[SITE_ID]
      ,[SAMPLING_EVENT]
      ,[SAMPLE_ID]
      ,[STATION_SEQ]
      ,[BOTTOM_DEPTH]
      ,[TOP_DEPTH]
      ,[DEPTH_UNITS]
      ,[COLLECTION_CODE]
      ,[COLLECTION_DATE]
      ,[COLLECTION_TIME]
      ,[END_COLLECTION_DATE]
      ,[END_COLLECTION_TIME]
      ,[DATA_USE]
      ,[MATRIX_CODE]
      ,[SAMPLE_TYPE]
      ,[COMMENTS]
      ,[COLLECTION_DURATION]
      ,[COLLECTION_DURATION_UNITS]
      ,[ELAPSED_TIME]
      ,[PERCENT_SATURATED]
      ,[PLANNED_SAMPLE_SEQ]
      ,[RECORD_CREATED_DATE]
      ,[RECORD_MODIFIED_DATE]
		FROM [BEIDMS].[dbo].[VBEIDMS_SAMPLES]
	) as s
		
		--ALTER INDEX COLUMNS
		ALTER TABLE [SRSAnalysis].[dbo].[allsamples]
		ALTER COLUMN STATION_SEQ int
		
		ALTER TABLE [SRSAnalysis].[dbo].[allsamples]
		ALTER COLUMN SAMPLE_SEQ int
		
		--Create index on SAMPLE_SEQ
		create index AllSamples_sampleseq_idx
		on allsamples(SAMPLE_SEQ);
		
		create index AllSamples_stationseq_idx
		on allsamples(STATION_SEQ);
		
		--Clean nulls
		
update allsamples
set [SAMPLING_EVENT]=NULL 
where [SAMPLING_EVENT]=''NULL'' 

update allsamples
set [SAMPLE_ID]=NULL 
where [SAMPLE_ID]=''NULL'' 

update allsamples
set [BOTTOM_DEPTH]=NULL 
where [BOTTOM_DEPTH]=''NULL'' 

update allsamples
set[TOP_DEPTH]=NULL 
where [TOP_DEPTH]=''NULL'' 

update allsamples
set [DEPTH_UNITS]=NULL 
where [DEPTH_UNITS]=''NULL'' 

update allsamples
set [COLLECTION_CODE]=NULL 
where [COLLECTION_CODE]=''NULL'' 

update allsamples
set [COLLECTION_DATE]=NULL 
where [COLLECTION_DATE]=''NULL'' 

update allsamples
set [COLLECTION_TIME]=NULL 
where [COLLECTION_TIME]=''NULL'' 

update allsamples
set [END_COLLECTION_DATE]=NULL 
where [END_COLLECTION_DATE]=''NULL'' 

update allsamples
set [END_COLLECTION_TIME]=NULL 
where [END_COLLECTION_TIME]=''NULL'' 

update allsamples
set [DATA_USE]=NULL 
where [DATA_USE]=''NULL'' 

update allsamples
set [MATRIX_CODE]=NULL 
where [MATRIX_CODE]=''NULL'' 

update allsamples
set [SAMPLE_TYPE]=NULL 
where [SAMPLE_TYPE]=''NULL'' 

update allsamples
set [COMMENTS]=NULL 
where [COMMENTS]=''NULL'' 

update allsamples
set [COLLECTION_DURATION]=NULL 
where [COLLECTION_DURATION]=''NULL'' 

update allsamples
set [COLLECTION_DURATION_UNITS]=NULL 
where [COLLECTION_DURATION_UNITS]=''NULL'' 

update allsamples
set [ELAPSED_TIME]=NULL 
where [ELAPSED_TIME]=''NULL'' 

update allsamples
set [PERCENT_SATURATED]=NULL 
where [PERCENT_SATURATED]=''NULL'' 

update allsamples
set [PLANNED_SAMPLE_SEQ]=NULL 
where [PLANNED_SAMPLE_SEQ]=''NULL'' 

update allsamples
set [RECORD_CREATED_DATE]=NULL 
where [RECORD_CREATED_DATE]=''NULL'' 

update allsamples
set [RECORD_MODIFIED_DATE]=NULL 
where [RECORD_MODIFIED_DATE]=''NULL'' 
	
	--Datatype conversion
	/*update  allsamples
	set =convert(float(53),)
	*/
	
	/*update  allsamples
	set [NORTHING]=convert(numeric(32,10),[NORTHING])

    update  allsamples
	set [EASTING]=convert(numeric(32,10),[EASTING])
	
	update  allsamples
	set [LONGITUDE]=CONVERT(numeric(32,14),[LONGITUDE])
      
    update  allsamples
	set [LATITUDE]=convert(numeric(32,14),[LATITUDE])
	
	update  allsamples
	set [GROUND_ELEVATION]=convert(numeric(32,4),[GROUND_ELEVATION])
	
	update  allsamples
	set [REFERENCE_ELEVATION]=convert(numeric(32,4),[REFERENCE_ELEVATION])*/
	
	--Add flag for geometry selection
	/*ALTER TABLE allsamples
	ADD areaflag bit NULL;
	
	UPDATE allsamples
	SET areaflag = dbo.n_isinfharea(LATITUDE,LONGITUDE)*/
		
END
' 
END
GO
