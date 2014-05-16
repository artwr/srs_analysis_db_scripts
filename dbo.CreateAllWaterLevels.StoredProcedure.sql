USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateAllWaterLevels]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateAllWaterLevels]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateAllWaterLevels] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels]
    
	--Create allwaterlevels table
	
	/*

*/


CREATE TABLE [SRSAnalysis].[dbo].[allwaterlevels] ([STATION_SEQ] nvarchar(127)
      ,[SAMPLING_EVENT] nvarchar(127)
      ,[MEASUREMENT_DATE] nvarchar(127)
      ,[WATER_ELEV] float
      ,[WATER_LEVEL_UNITS] nvarchar(63)
      ,[REFERENCE_ELEVATION_CODE] nvarchar(15)
      ,[REFERENCE_ELEVATION] nvarchar(63)
      ,[DEPTH_TO_PRODUCT] nvarchar(63)
      ,[DEPTH_TO_WATER] nvarchar(127)
      ,[MEASURED_WELL_DEPTH] nvarchar(127)
      ,[DRY] nvarchar(15)
      ,[COMMENTS] nvarchar(max)
      ,[RECOVERED_PRODUCT_VOLUME] nvarchar(255)
      ,[RECOVERED_PRODUCT_VOLUME_UNITS] nvarchar(127)
      ,[DEPTH_TYPE_CODE] nvarchar(63)
      ,[RMS_ERROR] nvarchar(63)
      ,[RMS_ERROR_DESCRIPTION] nvarchar(63)
      ,[COMPLETION_ZONE] nvarchar(63)
      ,[USAGE_CODE] nvarchar(63))



INSERT into [SRSAnalysis].[dbo].[allwaterlevels]
	  SELECT [STATION_SEQ]
      ,[SAMPLING_EVENT]
      ,[MEASUREMENT_DATE]
      ,NULL as [WATER_ELEV]
      ,[WATER_LEVEL_UNITS]
      ,[REFERENCE_ELEVATION_CODE]
      ,[REFERENCE_ELEVATION]
      ,[DEPTH_TO_PRODUCT]
      ,[DEPTH_TO_WATER]
      ,[MEASURED_WELL_DEPTH]
      ,[DRY]
      ,[COMMENTS]
      ,[RECOVERED_PRODUCT_VOLUME]
      ,[RECOVERED_PRODUCT_VOLUME_UNITS]
      ,[DEPTH_TYPE_CODE]
      ,[RMS_ERROR]
      ,[RMS_ERROR_DESCRIPTION]
      ,[COMPLETION_ZONE]
      ,[USAGE_CODE]
      FROM [BEIDMS].[dbo].[VBEIDMS_WATER_LEVEL_MEAS]
      where STATION_SEQ is not null
	
      
		
      --Clean nulls

update allwaterlevels
set [SAMPLING_EVENT]=NULL 
where [SAMPLING_EVENT]=''NULL'' 

update allwaterlevels
set [MEASUREMENT_DATE]=NULL 
where [MEASUREMENT_DATE]=''NULL''

update allwaterlevels
set [REFERENCE_ELEVATION]=NULL 
where [REFERENCE_ELEVATION]=''NULL''

update allwaterlevels
set [DEPTH_TO_PRODUCT]=NULL 
where [DEPTH_TO_PRODUCT]=''NULL''

update allwaterlevels
set [DEPTH_TO_WATER]=NULL 
where [DEPTH_TO_WATER]=''NULL''

update allwaterlevels
set [MEASURED_WELL_DEPTH]=NULL 
where [MEASURED_WELL_DEPTH]=''NULL''

update allwaterlevels
set [DRY]=NULL 
where [DRY]=''NULL'' 

update allwaterlevels
set [COMMENTS]=NULL 
where [COMMENTS]=''NULL'' 

update allwaterlevels
set [RECOVERED_PRODUCT_VOLUME]=NULL
where [RECOVERED_PRODUCT_VOLUME]=''NULL''

update allwaterlevels
set [RECOVERED_PRODUCT_VOLUME_UNITS]=NULL
where [RECOVERED_PRODUCT_VOLUME_UNITS]=''NULL''

update allwaterlevels
set [DEPTH_TYPE_CODE]=NULL 
where [DEPTH_TYPE_CODE]=''NULL'' 
      
update allwaterlevels
set [RMS_ERROR]=NULL 
where [RMS_ERROR]=''NULL''

update allwaterlevels
set [RMS_ERROR_DESCRIPTION]=NULL 
where [RMS_ERROR_DESCRIPTION]=''NULL''

update allwaterlevels
set [COMPLETION_ZONE]=NULL 
where [COMPLETION_ZONE]=''NULL''

update allwaterlevels
set [USAGE_CODE]=NULL 
where [USAGE_CODE]=''NULL''   

--Clean single quotes
UPDATE allwaterlevels
SET [SAMPLING_EVENT]=REPLACE([SAMPLING_EVENT], '''''''', '''')

UPDATE allwaterlevels
SET [MEASUREMENT_DATE]=REPLACE([MEASUREMENT_DATE], '''''''', '''')

UPDATE allwaterlevels
SET [REFERENCE_ELEVATION_CODE]=REPLACE([REFERENCE_ELEVATION_CODE], '''''''', '''')

UPDATE allwaterlevels
SET [WATER_LEVEL_UNITS]=REPLACE([WATER_LEVEL_UNITS], '''''''', '''')

UPDATE allwaterlevels
SET [DRY]=REPLACE([DRY], '''''''', '''')

UPDATE allwaterlevels
SET [DEPTH_TYPE_CODE]=REPLACE([DEPTH_TYPE_CODE], '''''''', '''')

UPDATE allwaterlevels
SET [USAGE_CODE]=REPLACE([USAGE_CODE], '''''''', '''')

--
ALTER TABLE allwaterlevels
ALTER COLUMN [REFERENCE_ELEVATION] float

ALTER TABLE allwaterlevels
ALTER COLUMN [DEPTH_TO_PRODUCT] float

ALTER TABLE allwaterlevels
ALTER COLUMN [DEPTH_TO_WATER] float

ALTER TABLE allwaterlevels
ALTER COLUMN [MEASURED_WELL_DEPTH] float

/*ALTER TABLE allwaterlevels
ADD [WATER_ELEV] float
*/

UPDATE allwaterlevels
SET [WATER_ELEV]=REFERENCE_ELEVATION-DEPTH_TO_WATER

ALTER TABLE allwaterlevels
ALTER COLUMN [STATION_SEQ] int

create index Allwaterlevels_stationseq_idx
		on allwaterlevels(STATION_SEQ);

/*		

*/


	
	
	--Datatype conversion
	/*update  allwaterlevels
	set =convert(float(53),)
	*/
	
	/*update  allwaterlevels
	set [NORTHING]=convert(numeric(32,10),[NORTHING])

    update  allwaterlevels
	set [EASTING]=convert(numeric(32,10),[EASTING])
	
	update  allwaterlevels
	set [LONGITUDE]=CONVERT(numeric(32,14),[LONGITUDE])
      
    update  allwaterlevels
	set [LATITUDE]=convert(numeric(32,14),[LATITUDE])
	
	update  allwaterlevels
	set [GROUND_ELEVATION]=convert(numeric(32,4),[GROUND_ELEVATION])
	
	update  allwaterlevels
	set [REFERENCE_ELEVATION]=convert(numeric(32,4),[REFERENCE_ELEVATION])*/
	
	--Add flag for geometry selection
	/*ALTER TABLE allwaterlevels
	ADD areaflag bit NULL;
	
	UPDATE allwaterlevels
	SET areaflag = dbo.n_isinfharea(LATITUDE,LONGITUDE)*/
	
	
	--Create index on STATION_SEQ
	--	create index allwaterlevels_stationseq_idx
	--	on allwaterlevels(STATION_SEQ);
		
END
' 
END
GO
