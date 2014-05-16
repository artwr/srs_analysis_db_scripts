USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateTables4R]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateTables4R]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateTables4R] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''wl4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[wl4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''results4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[results4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''tritium4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[tritium4R]
    
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''wlC4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[wlC4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''resultsC4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[resultsC4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''tritiumC4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[tritiumC4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''nitrate4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[nitrate4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''nitrateC4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[nitrateC4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''cesium1374R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[cesium1374R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''technetium4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[technetium4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''strontium4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[strontium4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''iodine4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[iodine4R]
    
	--Create water levels table
	SELECT wl.[STATION_SEQ]
      ,s.STATION_ID
      ,s.EASTING
      ,s.NORTHING
      ,[WATER_ELEV]
      ,[MEASUREMENT_DATE]
      ,DATEPART(YEAR,[MEASUREMENT_DATE]) as MYEAR
      ,DATEPART(MONTH,[MEASUREMENT_DATE]) as MMONTH
      ,DATEPART(DAY,[MEASUREMENT_DATE]) as MDAY
      ,DATEPART(Q,[MEASUREMENT_DATE]) as MQUARTER
      ,wl.[REFERENCE_ELEVATION_CODE] 
      ,wl.[REFERENCE_ELEVATION]
      ,[DEPTH_TO_WATER]
      into [SRSAnalysis].[dbo].[wl4R]
      FROM allwaterlevels_D wl
      join allstations_a s 
      on wl.STATION_SEQ=s.STATION_SEQ
      where water_elev is NOT NULL
      
    SELECT wl.[STATION_SEQ]
      ,s.STATION_ID
      ,s.EASTING
      ,s.NORTHING
      ,[WATER_ELEV]
      ,[MEASUREMENT_DATE]
      ,DATEPART(YEAR,[MEASUREMENT_DATE]) as MYEAR
      ,DATEPART(MONTH,[MEASUREMENT_DATE]) as MMONTH
      ,DATEPART(DAY,[MEASUREMENT_DATE]) as MDAY
      ,DATEPART(Q,[MEASUREMENT_DATE]) as MQUARTER
      ,wl.[REFERENCE_ELEVATION_CODE] 
      ,wl.[REFERENCE_ELEVATION]
      ,[DEPTH_TO_WATER]
      into [SRSAnalysis].[dbo].[wlC4R]
      FROM allwaterlevels_C wl
      join allstations_a s 
      on wl.STATION_SEQ=s.STATION_SEQ
      where water_elev is NOT NULL
      
      
    --create results analysis table (a join with the samples and the stations for XY coords)
    CREATE TABLE results4R (
    STATION_SEQ	int,
    STATION_ID nvarchar(63),
    EASTING nvarchar(63),
    NORTHING nvarchar(63),
    LATITUDE nvarchar(63),
    LONGITUDE nvarchar(63),
    ANALYSIS_DATE smalldatetime,
    COLLECTION_DATE smalldatetime,
    MDATE smalldatetime,
    MYEAR int,
    MMONTH int,
    MDAY int,
    MQUARTER int,
    ANALYTE_NAME nvarchar(255),
    RESULT nvarchar(127),
    RESULT_UNITS nvarchar(63),
    PQL nvarchar(127),
    PQL_UNITS nvarchar(63),
    -- nvarchar(127),
    --PQL_UNITS nvarchar(63),
    RESULT_SEQ nvarchar(63),
    SAMPLE_SEQ nvarchar(63),
    GROUND_ELEVATION float, 
    REFERENCE_ELEVATION float, 
    TOP_ELEV float, 
    BOTTOM_ELEV float
    )
    
    CREATE TABLE resultsC4R (
    STATION_SEQ	int,
    STATION_ID nvarchar(63),
    EASTING nvarchar(63),
    NORTHING nvarchar(63),
    LATITUDE nvarchar(63),
    LONGITUDE nvarchar(63),
    ANALYSIS_DATE smalldatetime,
    COLLECTION_DATE smalldatetime,
    MDATE smalldatetime,
    MYEAR int,
    MMONTH int,
    MDAY int,
    MQUARTER int,
    ANALYTE_NAME nvarchar(255),
    RESULT nvarchar(127),
    RESULT_UNITS nvarchar(63),
    PQL nvarchar(127),
    PQL_UNITS nvarchar(63),
    RESULT_SEQ nvarchar(63),
    SAMPLE_SEQ nvarchar(63),
    GROUND_ELEVATION float, 
    REFERENCE_ELEVATION float, 
    TOP_ELEV float, 
    BOTTOM_ELEV float
    )
    
    --create results analysis table (a join with the samples and the stations for XY coords)
    CREATE TABLE results4RwithQA (
    STATION_SEQ	int,
    STATION_ID nvarchar(63),
    EASTING nvarchar(63),
    NORTHING nvarchar(63),
    LATITUDE nvarchar(63),
    LONGITUDE nvarchar(63),
    ANALYSIS_DATE smalldatetime,
    COLLECTION_DATE smalldatetime,
    MDATE smalldatetime,
    MYEAR int,
    MMONTH int,
    MDAY int,
    MQUARTER int,
    ANALYTE_NAME nvarchar(255),
    RESULT nvarchar(127),
    RESULT_UNITS nvarchar(63),
    PQL nvarchar(127),
    PQL_UNITS nvarchar(63),
    MDL nvarchar(127),
    MDL_UNITS nvarchar(63),
    IDL nvarchar(127),
    IDL_UNITS nvarchar(63),
    RESULT_SEQ nvarchar(63),
    SAMPLE_SEQ nvarchar(63),
    GROUND_ELEVATION float, 
    REFERENCE_ELEVATION float, 
    TOP_ELEV float, 
    BOTTOM_ELEV float
    )
    
    CREATE TABLE resultsC4RwithQA (
    STATION_SEQ	int,
    STATION_ID nvarchar(63),
    EASTING nvarchar(63),
    NORTHING nvarchar(63),
    LATITUDE nvarchar(63),
    LONGITUDE nvarchar(63),
    ANALYSIS_DATE smalldatetime,
    COLLECTION_DATE smalldatetime,
    MDATE smalldatetime,
    MYEAR int,
    MMONTH int,
    MDAY int,
    MQUARTER int,
    ANALYTE_NAME nvarchar(255),
    RESULT nvarchar(127),
    RESULT_UNITS nvarchar(63),
    PQL nvarchar(127),
    PQL_UNITS nvarchar(63),
    MDL nvarchar(127),
    MDL_UNITS nvarchar(63),
    IDL nvarchar(127),
    IDL_UNITS nvarchar(63),
    RESULT_SEQ nvarchar(63),
    SAMPLE_SEQ nvarchar(63),
    GROUND_ELEVATION float, 
    REFERENCE_ELEVATION float, 
    TOP_ELEV float, 
    BOTTOM_ELEV float
    )
    
    insert into results4R (STATION_SEQ, STATION_ID,
    EASTING, NORTHING,
    LATITUDE, LONGITUDE,
    ANALYSIS_DATE,
    COLLECTION_DATE,
    MDATE,
    MYEAR, MMONTH, MDAY, MQUARTER,
    ANALYTE_NAME,
    RESULT, RESULT_UNITS,
    PQL, PQL_UNITS, 
    RESULT_SEQ, SAMPLE_SEQ,
    GROUND_ELEVATION, REFERENCE_ELEVATION, TOP_ELEV, BOTTOM_ELEV)
    
    select s.STATION_SEQ, s.STATION_ID, 
    s.EASTING, s.NORTHING, 
    s.LATITUDE, s.LONGITUDE ,
    CONVERT(smalldatetime,r.ANALYSIS_DATE) as ANALYSIS_DATE, 
    CONVERT(smalldatetime,sa.COLLECTION_DATE) as COLLECTION_DATE , 
    NULL as MDATE, NULL as MYEAR, NULL as MMONTH, NULL as MDAY, NULL as MQUARTER,
    ANALYTE_NAME, RESULT, 
    RESULT_UNITS, PQL, PQL_UNITS, 
    r.RESULT_SEQ, r.SAMPLE_SEQ, 
    s.GROUND_ELEVATION, s.REFERENCE_ELEVATION, s.TOP_ELEV, s.BOTTOM_ELEV
    from allresults_D r
    join allsamples_D sa
	on r.SAMPLE_SEQ=sa.SAMPLE_SEQ
	join allstations_a s
	on sa.STATION_SEQ=s.STATION_SEQ
	
	
	--
	UPDATE results4R
	set MDATE = [ANALYSIS_DATE]
	
	UPDATE results4R
	set MDATE = [COLLECTION_DATE]
	where MDATE is NULL
	
	UPDATE results4R
	set MYEAR = DATEPART(YEAR, MDATE)
	
	UPDATE results4R
	set MMONTH =DATEPART(MONTH,MDATE)
	
    UPDATE results4R
	set MDAY =  DATEPART(DAY,MDATE)
	
	UPDATE results4R
	set MQUARTER =  DATEPART(Q,MDATE)
	
	--withQA
	
	insert into results4RwithQA (STATION_SEQ, STATION_ID,
    EASTING, NORTHING,
    LATITUDE, LONGITUDE,
    ANALYSIS_DATE,
    COLLECTION_DATE,
    MDATE,
    MYEAR, MMONTH, MDAY, MQUARTER,
    ANALYTE_NAME,
    RESULT, RESULT_UNITS,
    PQL, PQL_UNITS, 
    MDL, MDL_UNITS,
    IDL, IDL_UNITS,
    RESULT_SEQ, SAMPLE_SEQ,
    GROUND_ELEVATION, REFERENCE_ELEVATION, TOP_ELEV, BOTTOM_ELEV)
    
    select r2.STATION_SEQ, r2.STATION_ID, 
    r2.EASTING, r2.NORTHING, 
    r2.LATITUDE, r2.LONGITUDE ,
    r2.ANALYSIS_DATE, 
    r2.COLLECTION_DATE , 
    r2.MDATE, r2.MYEAR, r2.MMONTH, r2.MDAY, r2.MQUARTER,
    r2.ANALYTE_NAME, r2.RESULT, 
    r2.RESULT_UNITS, r2.PQL, r2.PQL_UNITS, 
    r.MDL, r.MDL_UNITS,
    r.IDL, r.IDL_UNITS,
    r2.RESULT_SEQ, r2.SAMPLE_SEQ, 
    r2.GROUND_ELEVATION, r2.REFERENCE_ELEVATION, r2.TOP_ELEV, r2.BOTTOM_ELEV
    from results4R r2
    join allresults_D r
    on r2.RESULT_SEQ=r.RESULT_SEQ
    
	
	--Aquifer C
    
    insert into resultsC4R (STATION_SEQ, STATION_ID,
    EASTING, NORTHING,
    LATITUDE, LONGITUDE,
    ANALYSIS_DATE,
    COLLECTION_DATE,
    MDATE,
    MYEAR, MMONTH, MDAY, MQUARTER,
    ANALYTE_NAME,
    RESULT, RESULT_UNITS,
    PQL, PQL_UNITS, 
    RESULT_SEQ, SAMPLE_SEQ,
    GROUND_ELEVATION, REFERENCE_ELEVATION, TOP_ELEV, BOTTOM_ELEV)
    
    select s.STATION_SEQ, s.STATION_ID, 
    s.EASTING, s.NORTHING, 
    s.LATITUDE, s.LONGITUDE ,
    CONVERT(smalldatetime,r.ANALYSIS_DATE) as ANALYSIS_DATE, 
    CONVERT(smalldatetime,sa.COLLECTION_DATE) as COLLECTION_DATE , 
    NULL as MDATE, NULL as MYEAR, NULL as MMONTH, NULL as MDAY, NULL as MQUARTER,
    ANALYTE_NAME, RESULT, 
    RESULT_UNITS, PQL, PQL_UNITS, 
    r.RESULT_SEQ, r.SAMPLE_SEQ, 
    s.GROUND_ELEVATION, s.REFERENCE_ELEVATION, s.TOP_ELEV, s.BOTTOM_ELEV
    from allresults_C r
    join allsamples_C sa
	on r.SAMPLE_SEQ=sa.SAMPLE_SEQ
	join allstations_a s
	on sa.STATION_SEQ=s.STATION_SEQ
	
	
	--
	UPDATE resultsC4R
	set MDATE = [ANALYSIS_DATE]
	
	UPDATE resultsC4R
	set MDATE = [COLLECTION_DATE]
	where MDATE is NULL
	
	UPDATE resultsC4R
	set MYEAR = DATEPART(YEAR, MDATE)
	
	UPDATE resultsC4R
	set MMONTH =DATEPART(MONTH,MDATE)
	
    UPDATE resultsC4R
	set MDAY =  DATEPART(DAY,MDATE)
	
	UPDATE resultsC4R
	set MQUARTER =  DATEPART(Q,MDATE)
	--
	
	--withQA
	
	insert into resultsC4RwithQA (STATION_SEQ, STATION_ID,
    EASTING, NORTHING,
    LATITUDE, LONGITUDE,
    ANALYSIS_DATE,
    COLLECTION_DATE,
    MDATE,
    MYEAR, MMONTH, MDAY, MQUARTER,
    ANALYTE_NAME,
    RESULT, RESULT_UNITS,
    PQL, PQL_UNITS, 
    MDL, MDL_UNITS,
    IDL, IDL_UNITS,
    RESULT_SEQ, SAMPLE_SEQ,
    GROUND_ELEVATION, REFERENCE_ELEVATION, TOP_ELEV, BOTTOM_ELEV)
    
    select r2c.STATION_SEQ, r2c.STATION_ID, 
    r2c.EASTING, r2c.NORTHING, 
    r2c.LATITUDE, r2c.LONGITUDE ,
    r2c.ANALYSIS_DATE, 
    r2c.COLLECTION_DATE , 
    r2c.MDATE, r2c.MYEAR, r2c.MMONTH, r2c.MDAY, r2c.MQUARTER,
    r2c.ANALYTE_NAME, r2c.RESULT, 
    r2c.RESULT_UNITS, r2c.PQL, r2c.PQL_UNITS, 
    r.MDL, r.MDL_UNITS,
    r.IDL, r.IDL_UNITS,
    r2c.RESULT_SEQ, r2c.SAMPLE_SEQ, 
    r2c.GROUND_ELEVATION, r2c.REFERENCE_ELEVATION, r2c.TOP_ELEV, r2c.BOTTOM_ELEV
    from resultsC4R r2c
    join allresults_C r
    on r2c.RESULT_SEQ=r.RESULT_SEQ
	
	--create tritium
	select * 
	into tritium4R
	from results4R 
	where ANALYTE_NAME=''TRITIUM''
	
	select * 
	into tritiumC4R
	from resultsC4R 
	where ANALYTE_NAME=''TRITIUM''
	
	select * 
	into nitrate4R
	from results4R 
	where ANALYTE_NAME like ''NITRATE%''
	
	select * 
	into nitrateC4R
	from resultsC4R 
	where ANALYTE_NAME like ''NITRATE%''
	
	select * 
	into cesium1374R
	from results4R 
	where ANALYTE_NAME=''CESIUM-137''
	
	select * 
	into cesium137C4R
	from resultsC4R 
	where ANALYTE_NAME=''CESIUM-137''
	
	select * 
	into technetium4R
	from results4R 
	where ANALYTE_NAME=''TECHNETIUM-99''
	
	select * 
	into technetiumC4R
	from resultsC4R 
	where ANALYTE_NAME=''TECHNETIUM-99''
	
	select * 
	into strontium4R
	from results4R 
	where ANALYTE_NAME=''STRONTIUM-90''
	
	select * 
	into iodine4R
	from results4R 
	where ANALYTE_NAME=''IODINE-129''
	
	select * 
	into iodineC4R
	from resultsC4R 
	where ANALYTE_NAME=''IODINE-129''
	
/*
IODINE-129
CESIUM-137
TECHNETIUM-99
STRONTIUM-90

COBALT-60
AMERICIUM-241
PLUTONIUM-238
PLUTONIUM-239/240
THORIUM-228
CURIUM-243/244
THORIUM-232
CURIUM-242
THORIUM-230
CURIUM-245/246
TOTAL ACTIVITY
CESIUM-134
POTASSIUM-40
ANTIMONY-125
ACTINIUM-228
RUTHENIUM-106
*/
		
END
' 
END
GO
