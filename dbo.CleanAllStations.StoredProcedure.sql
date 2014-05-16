USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CleanAllStations]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CleanAllStations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CleanAllStations] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allstations_temp'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_temp]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allstations_clean'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_clean]
    
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
	  SELECT *
      into [SRSAnalysis].[dbo].[allstations_temp]
      FROM [SRSAnalysis].[dbo].[allstations]
      
      --ALTER INDEX COLUMNS
		ALTER TABLE [SRSAnalysis].[dbo].[allstations_temp]
		ALTER COLUMN STATION_SEQ int

      --Consistency 
	
	  update allstations_temp 
      set REFERENCE_ELEVATION = GROUND_ELEVATION
      where REFERENCE_ELEVATION is NULL and GROUND_ELEVATION is not NULL and REFERENCE_ELEVATION_CODE=''G''
		
      --Add domain selection
      
      ALTER TABLE allstations_temp
      ADD ISINDOMAIN bit
      
      ALTER TABLE allstations_temp
      ADD ISINDOMAIN2 bit
      
      ALTER TABLE allstations_temp
      ADD ISINDOMAIN3 bit
      
      ALTER TABLE allstations_temp
      ADD ISINDOMAINSW bit
      
      update allstations_temp 
      set ISINDOMAIN2 = dbo.is_in_d2(LATITUDE, LONGITUDE)
      
      update allstations_temp 
      set ISINDOMAIN3 = dbo.is_in_d3(LATITUDE, LONGITUDE)
      
      update allstations_temp 
      set ISINDOMAINSW = dbo.is_in_domsw(LATITUDE, LONGITUDE)
      
      ALTER TABLE allstations_temp
      ADD AQUIFER varchar(15)
      
      --
      ALTER TABLE allstations_temp
      ALTER COLUMN REFERENCE_ELEVATION float
      
      ALTER TABLE allstations_temp
      ALTER COLUMN GROUND_ELEVATION float
      
      ALTER TABLE allstations_temp
      ALTER COLUMN TOP_DEPTH float
      
      ALTER TABLE allstations_temp
      ALTER COLUMN BOTTOM_DEPTH float
      
      --Compute elevations
      ALTER TABLE allstations_temp
      ADD TOP_ELEV float
      
      ALTER TABLE allstations_temp
      ADD BOTTOM_ELEV float
      
      UPDATE allstations_temp
      set TOP_ELEV=REFERENCE_ELEVATION-TOP_DEPTH,
          BOTTOM_ELEV = REFERENCE_ELEVATION-BOTTOM_DEPTH
      
     
      
      --pass to _clean
      select *
      into allstations_clean
      from allstations_temp
      --where ISINDOMAIN=1

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
