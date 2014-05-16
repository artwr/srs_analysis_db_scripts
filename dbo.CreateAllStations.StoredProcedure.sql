USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateAllStations]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateAllStations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateAllStations] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allstations'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations]
    
	--Create allstations table
	
	/*
	
	select COUNT(*)
/*ss.STATION_SEQ,ss.STATION_ID,
ss.GROUND_ELEVATION,ss.REFERENCE_ELEVATION,ss.REFERENCE_ELEVATION_CODE,sc.TOP_DEPTH,sc.TOP_DEPTH */
from VBEIDMS_SAMPLE_STATIONS ss
join (select * from VBEIDMS_STATION_CONSTRUCT where CONSTRUCTION_OBJECT=''screen'' ) sc
on ss.STATION_SEQ=sc.STATION_SEQ
where ss.REFERENCE_ELEVATION is NULL and GROUND_ELEVATION is NULL
--order by ss.STATION_ID

*/
	  SELECT ss.[STATION_SEQ]
--,sc.STATION_SEQ
      ,[SITE_ID]
      ,[STATION_ID]
      ,[STATION_TYPE]
      ,[STATION_STATUS_CODE]
      ,[GRID_PLANE]
      ,[COORDINATE_STATUS_CODE]
      ,[NORTHING]
      ,[EASTING]
      ,[PLANIMETRIC_UNITS]
      ,[LONGITUDE]
      ,[LATITUDE]
      ,[GROUND_ELEVATION]
      ,[REFERENCE_ELEVATION]
      ,[ELEVATION_UNITS]
      ,[REFERENCE_ELEVATION_CODE]
      ,sc.TOP_DEPTH
      ,sc.BOTTOM_DEPTH
      ,sc.DEPTH_UNITS
      ,sc.INSTALLATION_DATE
      into [SRSAnalysis].[dbo].[allstations]
      FROM (select * from [BEIDMS].[dbo].[VBEIDMS_SAMPLE_STATIONS] where (LATITUDE is not NULL AND LONGITUDE is not NULL) OR (EASTING is not NULL AND NORTHING is not NULL)) as ss
      left outer join (select * from BEIDMS.dbo.VBEIDMS_STATION_CONSTRUCT where CONSTRUCTION_OBJECT=''screen'') as sc
      on ss.STATION_SEQ=sc.STATION_SEQ
	
      
		
      --Clean nulls

/*		
update allstations
set [SAMPLING_EVENT]=NULL 
where [SAMPLING_EVENT]=''NULL'' 

update allstations
set [SAMPLE_ID]=NULL 
where [SAMPLE_ID]=''NULL'' 

update allstations
set [BOTTOM_DEPTH]=NULL 
where [BOTTOM_DEPTH]=''NULL'' 

update allstations
set[TOP_DEPTH]=NULL 
where [TOP_DEPTH]=''NULL'' 

update allstations
set [DEPTH_UNITS]=NULL 
where [DEPTH_UNITS]=''NULL'' 

update allstations
set [RESULT_UNITS]=NULL 
where [RESULT_UNITS]=''NULL'' 

update allstations
set [COLLECTION_CODE]=NULL 
where [COLLECTION_CODE]=''NULL'' 

update allstations
set [COLLECTION_DATE]=NULL 
where [COLLECTION_DATE]=''NULL'' 

update allstations
set [COLLECTION_TIME]=NULL 
where [COLLECTION_TIME]=''NULL'' 

update allstations
set [END_COLLECTION_DATE]=NULL 
where [END_COLLECTION_DATE]=''NULL'' 

update allstations
set [END_COLLECTION_TIME]=NULL 
where [END_COLLECTION_TIME]=''NULL'' 

update allstations
set [DATA_USE]=NULL 
where [DATA_USE]=''NULL'' 

update allstations
set [MATRIX_CODE]=NULL 
where [MATRIX_CODE]=''NULL'' 

update allstations
set [SAMPLE_TYPE]=NULL 
where [SAMPLE_TYPE]=''NULL'' 

update allstations
set [COMMENTS]=NULL 
where [COMMENTS]=''NULL'' 

update allstations
set [COLLECTION_DURATION]=NULL 
where [COLLECTION_DURATION]=''NULL'' 

update allstations
set [COLLECTION_DURATION_UNITS]=NULL 
where [COLLECTION_DURATION_UNITS]=''NULL'' 

update allstations
set [ELAPSED_TIME]=NULL 
where [ELAPSED_TIME]=''NULL'' 

update allstations
set [PERCENT_SATURATED]=NULL 
where [PERCENT_SATURATED]=''NULL'' 

update allstations
set [PLANNED_SAMPLE_SEQ]=NULL 
where [PLANNED_SAMPLE_SEQ]=''NULL'' 

update allstations
set [RECORD_CREATED_DATE]=NULL 
where [RECORD_CREATED_DATE]=''NULL'' 

update allstations
set [RECORD_MODIFIED_DATE]=NULL 
where [RECORD_MODIFIED_DATE]=''NULL'' 
*/


	
	
	--Datatype conversion
	/*update  allstations
	set =convert(float(53),)
	*/
	
	/*update  allstations
	set [NORTHING]=convert(numeric(32,10),[NORTHING])

    update  allstations
	set [EASTING]=convert(numeric(32,10),[EASTING])
	
	update  allstations
	set [LONGITUDE]=CONVERT(numeric(32,14),[LONGITUDE])
      
    update  allstations
	set [LATITUDE]=convert(numeric(32,14),[LATITUDE])
	
	update  allstations
	set [GROUND_ELEVATION]=convert(numeric(32,4),[GROUND_ELEVATION])
	
	update  allstations
	set [REFERENCE_ELEVATION]=convert(numeric(32,4),[REFERENCE_ELEVATION])*/
	
	--Add flag for geometry selection
	/*ALTER TABLE allstations
	ADD areaflag bit NULL;
	
	UPDATE allstations
	SET areaflag = dbo.n_isinfharea(LATITUDE,LONGITUDE)*/
	
	
	--Create index on STATION_SEQ
	--	create index allstations_stationseq_idx
	--	on allstations(STATION_SEQ);
		
END
' 
END
GO
