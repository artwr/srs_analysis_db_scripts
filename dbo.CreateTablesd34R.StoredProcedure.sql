USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateTablesd34R]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateTablesd34R]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateTablesd34R] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''wld34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[wld34R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''resultsd34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[resultsd34R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''resultsd34RwithQA'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[resultsd34RwithQA]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''tritiumd34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[tritiumd34R]
    
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''wld3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[wld3C4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''resultsd3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[resultsd3C4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''resultsd3C4RwithQA'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[resultsd3C4RwithQA]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''tritiumd3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[tritiumd3C4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''nitrated34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[nitrated34R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''nitrated3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[nitrated3C4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''cesium137d34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[cesium137d34R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''cesium137d3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[cesium137d3C4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''technetiumd34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[technetiumd34R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''strontiumd34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[strontiumd34R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''iodined34R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[iodined34R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''technetiumd3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[technetiumd3C4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''strontiumd3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[strontiumd3C4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''iodined3C4R'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[iodined3C4R]
    
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
      into [SRSAnalysis].[dbo].[wld34R]
      FROM allwaterlevels_d3D wl
      join allstations_d3 s 
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
      into [SRSAnalysis].[dbo].[wld3C4R]
      FROM allwaterlevels_d3C wl
      join allstations_d3 s 
      on wl.STATION_SEQ=s.STATION_SEQ
      where water_elev is NOT NULL
      
      
    --create results analysis table (a join with the samples and the stations for XY coords)
    CREATE TABLE resultsd34R (
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
    
    CREATE TABLE resultsd3C4R (
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
    CREATE TABLE resultsd34RwithQA (
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
    
    CREATE TABLE resultsd3C4RwithQA (
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
    
    insert into resultsd34R (STATION_SEQ, STATION_ID,
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
    from allresults_d3D r
    join allsamples_d3D sa
	on r.SAMPLE_SEQ=sa.SAMPLE_SEQ
	join allstations_d3 s
	on sa.STATION_SEQ=s.STATION_SEQ
	
	
	--
	UPDATE resultsd34R
	set MDATE = [ANALYSIS_DATE]
	
	UPDATE resultsd34R
	set MDATE = [COLLECTION_DATE]
	where MDATE is NULL
	
	UPDATE resultsd34R
	set MYEAR = DATEPART(YEAR, MDATE)
	
	UPDATE resultsd34R
	set MMONTH =DATEPART(MONTH,MDATE)
	
    UPDATE resultsd34R
	set MDAY =  DATEPART(DAY,MDATE)
	
	UPDATE resultsd34R
	set MQUARTER =  DATEPART(Q,MDATE)
	
	--withQA
	
	insert into resultsd34RwithQA (STATION_SEQ, STATION_ID,
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
    from resultsd34R r2
    join allresults_d3D r
    on r2.RESULT_SEQ=r.RESULT_SEQ
    
	
	--Aquifer C
    
    insert into resultsd3C4R (STATION_SEQ, STATION_ID,
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
    from allresults_d3C r
    join allsamples_d3C sa
	on r.SAMPLE_SEQ=sa.SAMPLE_SEQ
	join allstations_d3 s
	on sa.STATION_SEQ=s.STATION_SEQ
	
	
	--
	UPDATE resultsd3C4R
	set MDATE = [ANALYSIS_DATE]
	
	UPDATE resultsd3C4R
	set MDATE = [COLLECTION_DATE]
	where MDATE is NULL
	
	UPDATE resultsd3C4R
	set MYEAR = DATEPART(YEAR, MDATE)
	
	UPDATE resultsd3C4R
	set MMONTH =DATEPART(MONTH,MDATE)
	
    UPDATE resultsd3C4R
	set MDAY =  DATEPART(DAY,MDATE)
	
	UPDATE resultsd3C4R
	set MQUARTER =  DATEPART(Q,MDATE)
	--
	
	--withQA
	
	insert into resultsd3C4RwithQA (STATION_SEQ, STATION_ID,
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
    from resultsd3C4R r2c
    join allresults_d3C r
    on r2c.RESULT_SEQ=r.RESULT_SEQ
	
	--create tritium
	select * 
	into tritiumd34R
	from resultsd34R 
	where ANALYTE_NAME=''TRITIUM''
	
	select * 
	into tritiumd3C4R
	from resultsd3C4R 
	where ANALYTE_NAME=''TRITIUM''
	
	select * 
	into nitrated34R
	from resultsd34R 
	where ANALYTE_NAME like ''NITRATE%''
	
	select * 
	into nitrated3C4R
	from resultsd3C4R 
	where ANALYTE_NAME like ''NITRATE%''
	
	select * 
	into cesium137d34R
	from resultsd34R 
	where ANALYTE_NAME=''CESIUM-137''
	
	select * 
	into cesium137d3C4R
	from resultsd3C4R 
	where ANALYTE_NAME=''CESIUM-137''
	
	select * 
	into technetiumd34R
	from resultsd34R 
	where ANALYTE_NAME=''TECHNETIUM-99''
	
	select * 
	into technetiumd3C4R
	from resultsd3C4R 
	where ANALYTE_NAME=''TECHNETIUM-99''
	
	select * 
	into strontiumd34R
	from resultsd34R 
	where ANALYTE_NAME=''STRONTIUM-90''
	
	select * 
	into iodined34R
	from resultsd34R 
	where ANALYTE_NAME=''IODINE-129''
	
	select * 
	into iodined3C4R
	from resultsd3C4R 
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
