USE [SRSAnalysis]
GO
/****** Object:  UserDefinedFunction [dbo].[is_in_d]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:              AWiedmer
-- Create date:
-- Description: Determines whether the point defined by lat,long is in
-- a polygon defined in the function body. Returns bit 1 if TRUE
-- =============================================
CREATE FUNCTION [dbo].[is_in_d]
(
        -- Add the parameters for the function here
        @lat float,
        @long float
)
RETURNS bit
AS
BEGIN
        -- Declare the return variable here
        DECLARE @Result bit

        -- Add the T-SQL statements to compute the return value here
        /*DECLARE @fharea geometry
        SET @fharea = 'POLYGON((-81.69916545891509 33.29691707038678,
		-81.69582803811416 33.26220562703161, 
		-81.62808524032883 33.26608313233162, 
		-81.63056277012669 33.29962470503676,
		-81.69916545891509 33.29691707038678))';
		*/
		
		DECLARE @d geometry 
		SET @d = 'POLYGON((-81.69959850412471 33.25157883545753,
		-81.67044897936366 33.27019298584946,
		-81.67168817516688 33.27837760341561,
		-81.69388086898707 33.28329777530127,
		-81.69959850412471 33.25157883545753))';

        --Create the intermediate string object
        DECLARE @strgeom1 varchar(255)
        SET @strgeom1 = 'POINT ('+CONVERT(VARCHAR(50),@long)+' '+CONVERT(VARCHAR(50),@lat)+' NULL NULL)'

        DECLARE @p1 geometry
        SET @p1 = geometry::Parse(@strgeom1);

    SELECT @Result = @d.STIntersects(@p1);

        -- Return the result of the function
        RETURN @Result

END
GO
/****** Object:  UserDefinedFunction [dbo].[f_isinfharea]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:              AWiedmer
-- Create date:
-- Description: Determines whether the point defined by lat,long is in
-- a polygon defined in the function body. Returns bit 1 if TRUE
-- =============================================
CREATE FUNCTION [dbo].[f_isinfharea]
(
        -- Add the parameters for the function here
        @lat float,
        @long float
)
RETURNS bit
AS
BEGIN
        -- Declare the return variable here
        DECLARE @Result bit

        -- Add the T-SQL statements to compute the return value here
        DECLARE @fharea geometry
        SET @fharea = 'POLYGON((-81.69916545891509 33.29691707038678,
-81.69582803811416 33.26220562703161, -81.62808524032883
33.26608313233162, -81.63056277012669 33.29962470503676,
-81.69916545891509 33.29691707038678))';

        --Create the intermediate string object
        DECLARE @strgeom1 varchar(255)
    SET @strgeom1 = 'POINT ('+CONVERT(VARCHAR(50),@long)+'
'+CONVERT(VARCHAR(50),@lat)+' NULL NULL)'

        DECLARE @p1 geometry
        SET @p1 = geometry::Parse(@strgeom1);

    SELECT @Result = @fharea.STIntersects(@p1);

        -- Return the result of the function
        RETURN @Result

END
GO
/****** Object:  StoredProcedure [dbo].[CreateTritium1]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
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
			where id = OBJECT_ID(N'tritium1')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
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
  FROM [SRSAnalysis].[dbo].[allresults_a] where ANALYTE_NAME='TRITIUM') r
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
GO
/****** Object:  StoredProcedure [dbo].[CreateTables4R]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
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
			where id = OBJECT_ID(N'wl4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[wl4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'results4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[results4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'tritium4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[tritium4R]
    
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'wlC4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[wlC4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'resultsC4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[resultsC4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'tritiumC4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[tritiumC4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'nitrate4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[nitrate4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'nitrateC4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[nitrateC4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'cesium1374R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[cesium1374R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'technetium4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[technetium4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'strontium4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[strontium4R]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'iodine4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
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
	
	--create tritium
	select * 
	into tritium4R
	from results4R 
	where ANALYTE_NAME='TRITIUM'
	
	select * 
	into tritiumC4R
	from resultsC4R 
	where ANALYTE_NAME='TRITIUM'
	
	select * 
	into nitrate4R
	from results4R 
	where ANALYTE_NAME like 'NITRATE%'
	
	select * 
	into nitrateC4R
	from resultsC4R 
	where ANALYTE_NAME like 'NITRATE%'
	
	select * 
	into cesium1374R
	from results4R 
	where ANALYTE_NAME='CESIUM-137'
	
	select * 
	into technetium4R
	from results4R 
	where ANALYTE_NAME='TECHNETIUM-99'
	
	select * 
	into strontium4R
	from results4R 
	where ANALYTE_NAME='STRONTIUM-90'
	
	select * 
	into iodine4R
	from results4R 
	where ANALYTE_NAME='IODINE-129'
	
/*
IODINE-129
CESIUM-137
TECHNETIUM-99
COBALT-60
STRONTIUM-90
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
GO
/****** Object:  StoredProcedure [dbo].[CreateTableCorrelations4R]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateTableCorrelations4R] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'corr4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[corr4R]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'corrC4R')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[corrC4R]
		
      
    --create results analysis table (a join with the samples and the stations for XY coords)
    
    /*
    CREATE TABLE corr4R (
    STATION_SEQ	int,
    STATION_ID nvarchar(63),
    EASTING nvarchar(63),
    NORTHING nvarchar(63),
    LATITUDE nvarchar(63),
    LONGITUDE nvarchar(63),
    MDATE smalldatetime,
    MYEAR int,
    MMONTH int,
    MDAY int,
    MQUARTER int,
    ANALYTE_NAME nvarchar(255),
    RESULT float,
    RESULT_UNITS nvarchar(63),
    GROUND_ELEVATION float, 
    REFERENCE_ELEVATION float, 
    TOP_ELEV float, 
    BOTTOM_ELEV float
    )
    
    CREATE TABLE corrC4R (
    STATION_SEQ	int,
    STATION_ID nvarchar(63),
    EASTING nvarchar(63),
    NORTHING nvarchar(63),
    LATITUDE nvarchar(63),
    LONGITUDE nvarchar(63),
    MDATE smalldatetime,
    MYEAR int,
    MMONTH int,
    MDAY int,
    MQUARTER int,
    ANALYTE_NAME nvarchar(255),
    RESULT float,
    RESULT_UNITS nvarchar(63),
    GROUND_ELEVATION float, 
    REFERENCE_ELEVATION float, 
    TOP_ELEV float, 
    BOTTOM_ELEV float
    )
    */
    
    --Create correlations table
    
    SELECT [STATION_SEQ]
      ,[STATION_ID]
      ,[EASTING]
      ,[NORTHING]
      ,[LATITUDE]
      ,[LONGITUDE]
      ,[GROUND_ELEVATION]
      ,[REFERENCE_ELEVATION]
      ,[TOP_ELEV]
      ,[BOTTOM_ELEV]
      ,[MDATE]
      ,[MYEAR]
      ,[MMONTH]
      ,[MDAY]
      ,[MQUARTER]
      ,[TRITIUM],[NONVOLATILE BETA],[GROSS ALPHA],[CADMIUM],[LEAD],[NITRATE-NITRITE AS NITROGEN],[ALUMINUM],[PH],[SPECIFIC CONDUCTANCE],[MERCURY],[SILVER],[BARIUM],[CHROMIUM],[ZINC],[ARSENIC],[SELENIUM],[NICKEL],[COPPER],[COBALT],[THALLIUM],[ANTIMONY],[VANADIUM],[CYANIDE],[IRON],[RADIUM-226],[IODINE-129],[RADIUM-228],[URANIUM-235],[URANIUM-238],[CESIUM-137],[URANIUM-233/234],[COBALT-60],[TECHNETIUM-99],[RADIUM, TOTAL ALPHA-EMITTING],[BERYLLIUM],[STRONTIUM-90],[AMERICIUM-241],[CHLORIDE],[THORIUM-228],[THORIUM-232],[CURIUM-243/244],[THORIUM-230],[CURIUM-242],[MANGANESE],[PLUTONIUM-238],[PLUTONIUM-239/240],[SODIUM],[CURIUM-245/246],[MAGNESIUM],[POTASSIUM],[CALCIUM],[TOTAL ACTIVITY],[CARBON-14],[CESIUM-134],[TOTAL ORGANIC CARBON],[POTASSIUM-40],[SULFATE],[ANTIMONY-125],[TOTAL PHOSPHATES (AS  P)],[EUROPIUM-154],[EUROPIUM-155],[PROMETHIUM-146],[EUROPIUM-152],[FLUORIDE],[TOTAL DISSOLVED SOLIDS],[ACTINIUM-228],[LEAD-212],[TIN],[RUTHENIUM-106],[CERIUM-144],[NITRATE],[MANGANESE-54],[ZINC-65],[SODIUM-22],[COBALT-57],[PROMETHIUM-144],[YTTRIUM-88],[BARIUM-133],[URANIUM],[NEPTUNIUM-237],[ZIRCONIUM-95],[STRONTIUM-89],[STRONTIUM],[STRONTIUM-89/90],[AMERICIUM-243]
    into corr4R
    FROM 
    (select [STATION_SEQ]
      ,[STATION_ID]
      ,[EASTING]
      ,[NORTHING]
      ,[LATITUDE]
      ,[LONGITUDE]
      ,[GROUND_ELEVATION]
      ,[REFERENCE_ELEVATION]
      ,[TOP_ELEV]
      ,[BOTTOM_ELEV]
      ,[MDATE]
      ,[MYEAR]
      ,[MMONTH]
      ,[MDAY]
      ,[MQUARTER]
      ,[ANALYTE_NAME]
      ,CONVERT(float,[RESULT]) as [RESULT]
      from [SRSAnalysis].[dbo].[results4R]) p
    PIVOT
    (
    AVG(RESULT)
    FOR ANALYTE_NAME in ([TRITIUM],[NONVOLATILE BETA],[GROSS ALPHA],[CADMIUM],[LEAD],[NITRATE-NITRITE AS NITROGEN],[ALUMINUM],[PH],[SPECIFIC CONDUCTANCE],[MERCURY],[SILVER],[BARIUM],[CHROMIUM],[ZINC],[ARSENIC],[SELENIUM],[NICKEL],[COPPER],[COBALT],[THALLIUM],[ANTIMONY],[VANADIUM],[CYANIDE],[IRON],[RADIUM-226],[IODINE-129],[RADIUM-228],[URANIUM-235],[URANIUM-238],[CESIUM-137],[URANIUM-233/234],[COBALT-60],[TECHNETIUM-99],[RADIUM, TOTAL ALPHA-EMITTING],[BERYLLIUM],[STRONTIUM-90],[AMERICIUM-241],[CHLORIDE],[THORIUM-228],[THORIUM-232],[CURIUM-243/244],[THORIUM-230],[CURIUM-242],[MANGANESE],[PLUTONIUM-238],[PLUTONIUM-239/240],[SODIUM],[CURIUM-245/246],[MAGNESIUM],[POTASSIUM],[CALCIUM],[TOTAL ACTIVITY],[CARBON-14],[CESIUM-134],[TOTAL ORGANIC CARBON],[POTASSIUM-40],[SULFATE],[ANTIMONY-125],[TOTAL PHOSPHATES (AS  P)],[EUROPIUM-154],[EUROPIUM-155],[PROMETHIUM-146],[EUROPIUM-152],[FLUORIDE],[TOTAL DISSOLVED SOLIDS],[ACTINIUM-228],[LEAD-212],[TIN],[RUTHENIUM-106],[CERIUM-144],[NITRATE],[MANGANESE-54],[ZINC-65],[SODIUM-22],[COBALT-57],[PROMETHIUM-144],[YTTRIUM-88],[BARIUM-133],[URANIUM],[NEPTUNIUM-237],[ZIRCONIUM-95],[STRONTIUM-89],[STRONTIUM],[STRONTIUM-89/90],[AMERICIUM-243])
    ) as pvt
    order by STATION_SEQ, MDATE
    
    --Aquifer C
    
    SELECT [STATION_SEQ]
      ,[STATION_ID]
      ,[EASTING]
      ,[NORTHING]
      ,[LATITUDE]
      ,[LONGITUDE]
      ,[GROUND_ELEVATION]
      ,[REFERENCE_ELEVATION]
      ,[TOP_ELEV]
      ,[BOTTOM_ELEV]
      ,[MDATE]
      ,[MYEAR]
      ,[MMONTH]
      ,[MDAY]
      ,[MQUARTER]
      ,[TRITIUM],[NONVOLATILE BETA],[GROSS ALPHA],[CADMIUM],[LEAD],[NITRATE-NITRITE AS NITROGEN],[ALUMINUM],[PH],[SPECIFIC CONDUCTANCE],[MERCURY],[SILVER],[BARIUM],[CHROMIUM],[ZINC],[ARSENIC],[SELENIUM],[NICKEL],[COPPER],[COBALT],[THALLIUM],[ANTIMONY],[VANADIUM],[CYANIDE],[IRON],[RADIUM-226],[IODINE-129],[RADIUM-228],[URANIUM-235],[URANIUM-238],[CESIUM-137],[URANIUM-233/234],[COBALT-60],[TECHNETIUM-99],[RADIUM, TOTAL ALPHA-EMITTING],[BERYLLIUM],[STRONTIUM-90],[AMERICIUM-241],[CHLORIDE],[THORIUM-228],[THORIUM-232],[CURIUM-243/244],[THORIUM-230],[CURIUM-242],[MANGANESE],[PLUTONIUM-238],[PLUTONIUM-239/240],[SODIUM],[CURIUM-245/246],[MAGNESIUM],[POTASSIUM],[CALCIUM],[TOTAL ACTIVITY],[CARBON-14],[CESIUM-134],[TOTAL ORGANIC CARBON],[POTASSIUM-40],[SULFATE],[ANTIMONY-125],[TOTAL PHOSPHATES (AS  P)],[EUROPIUM-154],[EUROPIUM-155],[PROMETHIUM-146],[EUROPIUM-152],[FLUORIDE],[TOTAL DISSOLVED SOLIDS],[ACTINIUM-228],[LEAD-212],[TIN],[RUTHENIUM-106],[CERIUM-144],[NITRATE],[MANGANESE-54],[ZINC-65],[SODIUM-22],[COBALT-57],[PROMETHIUM-144],[YTTRIUM-88],[BARIUM-133],[URANIUM],[NEPTUNIUM-237],[ZIRCONIUM-95],[STRONTIUM-89],[STRONTIUM],[STRONTIUM-89/90],[AMERICIUM-243]
    into corrC4R
    FROM 
    (select [STATION_SEQ]
      ,[STATION_ID]
      ,[EASTING]
      ,[NORTHING]
      ,[LATITUDE]
      ,[LONGITUDE]
      ,[GROUND_ELEVATION]
      ,[REFERENCE_ELEVATION]
      ,[TOP_ELEV]
      ,[BOTTOM_ELEV]
      ,[MDATE]
      ,[MYEAR]
      ,[MMONTH]
      ,[MDAY]
      ,[MQUARTER]
      ,[ANALYTE_NAME]
      ,CONVERT(float,[RESULT]) as [RESULT]
      from [SRSAnalysis].[dbo].[resultsC4R]) p
    PIVOT
    (
    AVG(RESULT)
    FOR ANALYTE_NAME in ([TRITIUM],[NONVOLATILE BETA],[GROSS ALPHA],[CADMIUM],[LEAD],[NITRATE-NITRITE AS NITROGEN],[ALUMINUM],[PH],[SPECIFIC CONDUCTANCE],[MERCURY],[SILVER],[BARIUM],[CHROMIUM],[ZINC],[ARSENIC],[SELENIUM],[NICKEL],[COPPER],[COBALT],[THALLIUM],[ANTIMONY],[VANADIUM],[CYANIDE],[IRON],[RADIUM-226],[IODINE-129],[RADIUM-228],[URANIUM-235],[URANIUM-238],[CESIUM-137],[URANIUM-233/234],[COBALT-60],[TECHNETIUM-99],[RADIUM, TOTAL ALPHA-EMITTING],[BERYLLIUM],[STRONTIUM-90],[AMERICIUM-241],[CHLORIDE],[THORIUM-228],[THORIUM-232],[CURIUM-243/244],[THORIUM-230],[CURIUM-242],[MANGANESE],[PLUTONIUM-238],[PLUTONIUM-239/240],[SODIUM],[CURIUM-245/246],[MAGNESIUM],[POTASSIUM],[CALCIUM],[TOTAL ACTIVITY],[CARBON-14],[CESIUM-134],[TOTAL ORGANIC CARBON],[POTASSIUM-40],[SULFATE],[ANTIMONY-125],[TOTAL PHOSPHATES (AS  P)],[EUROPIUM-154],[EUROPIUM-155],[PROMETHIUM-146],[EUROPIUM-152],[FLUORIDE],[TOTAL DISSOLVED SOLIDS],[ACTINIUM-228],[LEAD-212],[TIN],[RUTHENIUM-106],[CERIUM-144],[NITRATE],[MANGANESE-54],[ZINC-65],[SODIUM-22],[COBALT-57],[PROMETHIUM-144],[YTTRIUM-88],[BARIUM-133],[URANIUM],[NEPTUNIUM-237],[ZIRCONIUM-95],[STRONTIUM-89],[STRONTIUM],[STRONTIUM-89/90],[AMERICIUM-243])
    ) as pvt
    order by STATION_SEQ, MDATE
    
    
    --
    
  
	
	--
	
	
/*
IODINE-129
CESIUM-137
TECHNETIUM-99
COBALT-60
STRONTIUM-90
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
GO
/****** Object:  StoredProcedure [dbo].[CreateInorganics]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateInorganics] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allinorganics')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allinorganics]
    
	--Create allresults table
	select ar.*
    into [SRSAnalysis].[dbo].[allinorganics]
    from [SRSAnalysis].[dbo].[allresults] as ar
    join [BEIDMS].[dbo].[VBEIDMS_ANALYTES] as a
    on ar.analyte_name=a.analyte_name
    where a.chemical_class='I'
		
END
GO
/****** Object:  StoredProcedure [dbo].[CreateDCTables]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateDCTables] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    /*
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allsamples_a')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allstations_a')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allresults_a')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allwaterlevels_a')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_a]
		
	*/
	
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allsamples_D')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_D]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allstations_a')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allresults_D')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_D]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allwaterlevels_D')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_D]
	
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allsamples_C')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_C]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allstations_a')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allresults_C')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_C]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allwaterlevels_C')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_C]
	
	--
	--select the stations we are interested in
      select *
      into allstations_a
      from allstations_clean
      where ISINDOMAIN=1 and STATION_TYPE not in ('UNKNOWN','SOIL','SEDIMENT','SED/SW','CPT','PRODUCTION WELL','DEWATER WELL') and STATION_ID not like 'UNK%'
      
      create index AllStationsa_stationseq_idx
		on allstations_a(STATION_SEQ);
		
	--Define the proper aquifers
	
      update allstations_a
      set AQUIFER =  CASE 
       WHEN STATION_TYPE='SURFACE WATER' THEN 'D'
       WHEN STATION_TYPE='SEEPLINE' THEN 'D'
       WHEN STATION_TYPE='PIEZOMETER WELL' THEN 'D'
       WHEN STATION_ID like 'FM %' then 'D'
       WHEN STATION_ID like 'PMW%' then 'D'
       WHEN STATION_ID like '%D' THEN 'D'
       WHEN STATION_ID like '%DR' THEN 'D'
       WHEN STATION_ID like '%C' THEN 'C'
       WHEN STATION_ID like '%CR' THEN 'C'
       WHEN STATION_ID like '%B' THEN 'B'
       WHEN STATION_ID like '%BR' THEN 'B'
       WHEN STATION_ID like '%A' THEN 'A'
       WHEN STATION_ID like '%AR' THEN 'A'
       WHEN STATION_ID like 'FSB 7%' then 'D'
       WHEN STATION_ID like 'F  %' then 'D'
       WHEN STATION_ID='FIN 8' or STATION_ID='FIN 9' THEN 'C'
       WHEN STATION_ID='FEX 8' or STATION_ID='FEX 9' THEN 'C'
       WHEN STATION_ID like 'FAW%' then 'D'
       WHEN STATION_ID = 'FTF 14' THEN 'D'
       WHEN STATION_ID like 'FIP%' then 'D'
       WHEN STATION_ID like 'ZW%' then 'D'
       WHEN STATION_TYPE='INJECTION WELL' THEN 'D'
       WHEN STATION_TYPE='EXTRACTION WELL' THEN 'D'
       END
      
      --fast index table
      
      /*
      DECLARE @stationseqt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_a --where AQUIFER='D'
      */
      
      
      DECLARE @stationseqDt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqDt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_a where AQUIFER='D'
      
      DECLARE @stationseqCt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqCt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_a where AQUIFER='C' AND STATION_ID not in('FEX 8','FEX 9','FIN 8','FIN 9')
    
	--Create allsamples table
	select * 
	into [SRSAnalysis].[dbo].[allsamples_D]
	from [SRSAnalysis].[dbo].[allsamples]
	where STATION_SEQ in (select STATION_SEQ from @stationseqDt)
	
	select * 
	into [SRSAnalysis].[dbo].[allsamples_C]
	from [SRSAnalysis].[dbo].[allsamples]
	where STATION_SEQ in (select STATION_SEQ from @stationseqCt)
		
		--Create index on SAMPLE_SEQ
		create index AllSamplesD_sampleseq_idx
		on allsamples_D(SAMPLE_SEQ);
		
		create index AllSamplesD_stationseq_idx
		on allsamples_D(STATION_SEQ);
		
		create index AllSamplesC_sampleseq_idx
		on allsamples_C(SAMPLE_SEQ);
		
		create index AllSamplesC_stationseq_idx
		on allsamples_C(STATION_SEQ);
		
	
	/*	
	DECLARE @stationseqt TABLE (STATION_SEQ int)
      
    INSERT INTO @stationseqt (STATION_SEQ)
    select distinct STATION_SEQ from allstations_a
	*/
	--Create water levels
	select * 
	into [SRSAnalysis].[dbo].[allwaterlevels_D]
	from [SRSAnalysis].[dbo].[allwaterlevels]
	where STATION_SEQ in (select STATION_SEQ from @stationseqDt)
	
	create index AllwaterlevelsD_stationseq_idx
		on allwaterlevels_D(STATION_SEQ);
		
	select * 
	into [SRSAnalysis].[dbo].[allwaterlevels_C]
	from [SRSAnalysis].[dbo].[allwaterlevels]
	where STATION_SEQ in (select STATION_SEQ from @stationseqCt)
	
	create index AllwaterlevelsC_stationseq_idx
		on allwaterlevels_C(STATION_SEQ);
	--
	
	--Samples of interest
	DECLARE @sampleseqDt TABLE (SAMPLE_SEQ int)
    
    INSERT INTO @sampleseqDt (SAMPLE_SEQ)
    select distinct SAMPLE_SEQ from allsamples_D
    
    DECLARE @sampleseqCt TABLE (SAMPLE_SEQ int)
    
    INSERT INTO @sampleseqCt (SAMPLE_SEQ)
    select distinct SAMPLE_SEQ from allsamples_C
    
    /*
    DECLARE @sampleseqt TABLE (SAMPLE_SEQ int)
    
    INSERT INTO @sampleseqt (SAMPLE_SEQ)
    select distinct SAMPLE_SEQ from allsamples_D
    */
    
    --Create allresults_*
    select * 
	into [SRSAnalysis].[dbo].[allresults_D]
	from [SRSAnalysis].[dbo].[allresults_clean]
	where SAMPLE_SEQ in (select SAMPLE_SEQ from @sampleseqDt)
	
	select * 
	into [SRSAnalysis].[dbo].[allresults_C]
	from [SRSAnalysis].[dbo].[allresults_clean]
	where SAMPLE_SEQ in (select SAMPLE_SEQ from @sampleseqCt)
	--Create index on SAMPLE_SEQ
		create index AllResultsD_sampleseq_idx
		on allresults_D(SAMPLE_SEQ);
		
		create index AllResultsD_stationseq_idx
		on allresults_D(RESULT_SEQ);
		
		create index AllResultsC_sampleseq_idx
		on allresults_C(SAMPLE_SEQ);
		
		create index AllResultsC_stationseq_idx
		on allresults_C(RESULT_SEQ);
	
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
GO
/****** Object:  StoredProcedure [dbo].[CreateAllWaterLevels]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
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
			where id = OBJECT_ID(N'allwaterlevels')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels]
    
	--Create allwaterlevels table
	
	/*

*/
	  SELECT [STATION_SEQ]
      ,[SAMPLING_EVENT]
      ,[MEASUREMENT_DATE]
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
      into [SRSAnalysis].[dbo].[allwaterlevels]
      FROM [BEIDMS].[dbo].[VBEIDMS_WATER_LEVEL_MEAS]
      where STATION_SEQ is not null
	
      
		
      --Clean nulls

update allwaterlevels
set [SAMPLING_EVENT]=NULL 
where [SAMPLING_EVENT]='NULL' 

update allwaterlevels
set [MEASUREMENT_DATE]=NULL 
where [MEASUREMENT_DATE]='NULL'

update allwaterlevels
set [REFERENCE_ELEVATION]=NULL 
where [REFERENCE_ELEVATION]='NULL'

update allwaterlevels
set [DEPTH_TO_PRODUCT]=NULL 
where [DEPTH_TO_PRODUCT]='NULL'

update allwaterlevels
set [DEPTH_TO_WATER]=NULL 
where [DEPTH_TO_WATER]='NULL'

update allwaterlevels
set [MEASURED_WELL_DEPTH]=NULL 
where [MEASURED_WELL_DEPTH]='NULL'

update allwaterlevels
set [DRY]=NULL 
where [DRY]='NULL' 

update allwaterlevels
set [COMMENTS]=NULL 
where [COMMENTS]='NULL' 

update allwaterlevels
set [RECOVERED_PRODUCT_VOLUME]=NULL
where [RECOVERED_PRODUCT_VOLUME]='NULL'

update allwaterlevels
set [RECOVERED_PRODUCT_VOLUME_UNITS]=NULL
where [RECOVERED_PRODUCT_VOLUME_UNITS]='NULL'

update allwaterlevels
set [DEPTH_TYPE_CODE]=NULL 
where [DEPTH_TYPE_CODE]='NULL' 
      
update allwaterlevels
set [RMS_ERROR]=NULL 
where [RMS_ERROR]='NULL'

update allwaterlevels
set [RMS_ERROR_DESCRIPTION]=NULL 
where [RMS_ERROR_DESCRIPTION]='NULL'

update allwaterlevels
set [COMPLETION_ZONE]=NULL 
where [COMPLETION_ZONE]='NULL'

update allwaterlevels
set [USAGE_CODE]=NULL 
where [USAGE_CODE]='NULL'   

--Clean single quotes
UPDATE allwaterlevels
SET [SAMPLING_EVENT]=REPLACE([SAMPLING_EVENT], '''', '')

UPDATE allwaterlevels
SET [MEASUREMENT_DATE]=REPLACE([MEASUREMENT_DATE], '''', '')

UPDATE allwaterlevels
SET [REFERENCE_ELEVATION_CODE]=REPLACE([REFERENCE_ELEVATION_CODE], '''', '')

UPDATE allwaterlevels
SET [WATER_LEVEL_UNITS]=REPLACE([WATER_LEVEL_UNITS], '''', '')

UPDATE allwaterlevels
SET [DRY]=REPLACE([DRY], '''', '')

UPDATE allwaterlevels
SET [DEPTH_TYPE_CODE]=REPLACE([DEPTH_TYPE_CODE], '''', '')

UPDATE allwaterlevels
SET [USAGE_CODE]=REPLACE([USAGE_CODE], '''', '')

--
ALTER TABLE allwaterlevels
ALTER COLUMN [REFERENCE_ELEVATION] float

ALTER TABLE allwaterlevels
ALTER COLUMN [DEPTH_TO_PRODUCT] float

ALTER TABLE allwaterlevels
ALTER COLUMN [DEPTH_TO_WATER] float

ALTER TABLE allwaterlevels
ALTER COLUMN [MEASURED_WELL_DEPTH] float

ALTER TABLE allwaterlevels
ADD [WATER_ELEV] float

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
GO
/****** Object:  StoredProcedure [dbo].[CreateAllSamples]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
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
			where id = OBJECT_ID(N'allsamples')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
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
where [SAMPLING_EVENT]='NULL' 

update allsamples
set [SAMPLE_ID]=NULL 
where [SAMPLE_ID]='NULL' 

update allsamples
set [BOTTOM_DEPTH]=NULL 
where [BOTTOM_DEPTH]='NULL' 

update allsamples
set[TOP_DEPTH]=NULL 
where [TOP_DEPTH]='NULL' 

update allsamples
set [DEPTH_UNITS]=NULL 
where [DEPTH_UNITS]='NULL' 

update allsamples
set [COLLECTION_CODE]=NULL 
where [COLLECTION_CODE]='NULL' 

update allsamples
set [COLLECTION_DATE]=NULL 
where [COLLECTION_DATE]='NULL' 

update allsamples
set [COLLECTION_TIME]=NULL 
where [COLLECTION_TIME]='NULL' 

update allsamples
set [END_COLLECTION_DATE]=NULL 
where [END_COLLECTION_DATE]='NULL' 

update allsamples
set [END_COLLECTION_TIME]=NULL 
where [END_COLLECTION_TIME]='NULL' 

update allsamples
set [DATA_USE]=NULL 
where [DATA_USE]='NULL' 

update allsamples
set [MATRIX_CODE]=NULL 
where [MATRIX_CODE]='NULL' 

update allsamples
set [SAMPLE_TYPE]=NULL 
where [SAMPLE_TYPE]='NULL' 

update allsamples
set [COMMENTS]=NULL 
where [COMMENTS]='NULL' 

update allsamples
set [COLLECTION_DURATION]=NULL 
where [COLLECTION_DURATION]='NULL' 

update allsamples
set [COLLECTION_DURATION_UNITS]=NULL 
where [COLLECTION_DURATION_UNITS]='NULL' 

update allsamples
set [ELAPSED_TIME]=NULL 
where [ELAPSED_TIME]='NULL' 

update allsamples
set [PERCENT_SATURATED]=NULL 
where [PERCENT_SATURATED]='NULL' 

update allsamples
set [PLANNED_SAMPLE_SEQ]=NULL 
where [PLANNED_SAMPLE_SEQ]='NULL' 

update allsamples
set [RECORD_CREATED_DATE]=NULL 
where [RECORD_CREATED_DATE]='NULL' 

update allsamples
set [RECORD_MODIFIED_DATE]=NULL 
where [RECORD_MODIFIED_DATE]='NULL' 
	
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
GO
/****** Object:  StoredProcedure [dbo].[CreateAllResults]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateAllResults] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allresults')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults]
    
	--Create allresults table
	select t.* 
	into [SRSAnalysis].[dbo].[allresults]
	from
	(SELECT [ANALYSIS_DATE],[ANALYSIS_TIME]
		,[ANALYTE_ID],[ANALYTE_NAME]
		,[RESULT],[RESULT_UNITS]
		,[ERROR]
		,[DILUTION_FACTOR]
		,[ANALYTE_TYPE]
		,[DETECTION_LIMIT]
		,[DETECTION_UNITS]
		,[INSTRUMENT_DETECTION_LIMIT]
		,[INSTRUMENT_DETECTION_UNITS]
		,[PREP_DATE]
		,[PREP_TIME]
		,[RECORD_CREATED_DATE]
		,[RETENTION_TIME]
		,[SAMPLE_QUANTITATION_LIMIT]
		,[SAMPLE_QUANTITATION_UNITS]
		,[SAMPLE_SEQ]
		,[RESULT_SEQ]
		,[RESULT_TYPE]
		FROM [BEIDMS].[dbo].[VBEIDMS_RESULTS]
		UNION ALL
		SELECT [ANALYSIS_DATE]
		,[ANALYSIS_TIME]
		,[ANALYTE_ID]
		,[ANALYTE_NAME]
		,[RESULT]
		,[RESULT_UNITS]
		,[ERROR]
		,[DILUTION_FACTOR]
		,[ANALYTE_TYPE]
		,[DETECTION_LIMIT]
		,[DETECTION_UNITS]
		,[INSTRUMENT_DETECTION_LIMIT]
		,[INSTRUMENT_DETECTION_UNITS]
		,[PREP_DATE]
		,[PREP_TIME]
		,[RECORD_CREATED_DATE]
		,[RETENTION_TIME]
		,[SAMPLE_QUANTITATION_LIMIT]
		,[SAMPLE_QUANTITATION_UNITS]
		,[SAMPLE_SEQ]
		,[RESULT_SEQ]
		,[RESULT_TYPE]
		FROM [BEIDMS].[dbo].[VBEIDMS_INTERIM_RESULTS]) as t
		
		
		--Create index on SAMPLE_SEQ
		create index AllResults_sampleseq_idx
		on allresults(SAMPLE_SEQ);
		
		create index AllResults_resultseq_idx
		on allresults(RESULT_SEQ);
		
		--Clean nulls
update allresults
set[ANALYSIS_DATE]=NULL 
where[ANALYSIS_DATE]='NULL' 

update allresults
set[ANALYSIS_TIME]=NULL 
where[ANALYSIS_TIME]='NULL' 

update allresults
set[ANALYTE_ID]=NULL 
where[ANALYTE_ID]='NULL' 

update allresults
set[ANALYTE_NAME]=NULL 
where[ANALYTE_NAME]='NULL' 

update allresults
set[RESULT]=NULL 
where[RESULT]='NULL' 

update allresults
set[RESULT_UNITS]=NULL 
where[RESULT_UNITS]='NULL' 

update allresults
set[ERROR]=NULL 
where[ERROR]='NULL' 

update allresults
set[DILUTION_FACTOR]=NULL 
where[DILUTION_FACTOR]='NULL' 

update allresults
set[ANALYTE_TYPE]=NULL 
where[ANALYTE_TYPE]='NULL' 

update allresults
set[DETECTION_LIMIT]=NULL 
where[DETECTION_LIMIT]='NULL' 

update allresults
set[DETECTION_UNITS]=NULL 
where[DETECTION_UNITS]='NULL' 

update allresults
set[INSTRUMENT_DETECTION_LIMIT]=NULL 
where[INSTRUMENT_DETECTION_LIMIT]='NULL' 

update allresults
set[INSTRUMENT_DETECTION_UNITS]=NULL 
where[INSTRUMENT_DETECTION_UNITS]='NULL' 

update allresults
set[PREP_DATE]=NULL 
where[PREP_DATE]='NULL' 

update allresults
set[PREP_TIME]=NULL 
where[PREP_TIME]='NULL' 

update allresults
set[SAMPLE_QUANTITATION_LIMIT]=NULL 
where[SAMPLE_QUANTITATION_LIMIT]='NULL' 

update allresults
set[SAMPLE_QUANTITATION_UNITS]=NULL 
where[SAMPLE_QUANTITATION_UNITS]='NULL' 

update allresults
set[SAMPLE_SEQ]=NULL 
where[SAMPLE_SEQ]='NULL' 

update allresults
set[RESULT_SEQ]=NULL 
where[RESULT_SEQ]='NULL' 

update allresults
set[RESULT_TYPE]=NULL 
where[RESULT_TYPE]='NULL' 
	
	--Datatype conversion
	/*update  allresults
	set =convert(float(53),)
	*/
	
	/*update  allresults
	set [NORTHING]=convert(numeric(32,10),[NORTHING])

    update  allresults
	set [EASTING]=convert(numeric(32,10),[EASTING])
	
	update  allresults
	set [LONGITUDE]=CONVERT(numeric(32,14),[LONGITUDE])
      
    update  allresults
	set [LATITUDE]=convert(numeric(32,14),[LATITUDE])
	
	update  allresults
	set [GROUND_ELEVATION]=convert(numeric(32,4),[GROUND_ELEVATION])
	
	update  allresults
	set [REFERENCE_ELEVATION]=convert(numeric(32,4),[REFERENCE_ELEVATION])*/
	
	--Add flag for geometry selection
	/*ALTER TABLE allresults
	ADD areaflag bit NULL;
	
	UPDATE allresults
	SET areaflag = dbo.n_isinfharea(LATITUDE,LONGITUDE)*/
		
END
GO
/****** Object:  StoredProcedure [dbo].[CleanAllStations]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
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
			where id = OBJECT_ID(N'allstations_temp')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_temp]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allstations_clean')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_clean]
    
	--Create allstations table
	
	/*
	
	select COUNT(*)
/*ss.STATION_SEQ,ss.STATION_ID,
ss.GROUND_ELEVATION,ss.REFERENCE_ELEVATION,ss.REFERENCE_ELEVATION_CODE,sc.TOP_DEPTH,sc.TOP_DEPTH */
from VBEIDMS_SAMPLE_STATIONS ss
join (select * from VBEIDMS_STATION_CONSTRUCT where CONSTRUCTION_OBJECT='screen' ) sc
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
      where REFERENCE_ELEVATION is NULL and GROUND_ELEVATION is NULL and REFERENCE_ELEVATION_CODE='G'
		
      --Add domain selection
      
      ALTER TABLE allstations_temp
      ADD ISINDOMAIN bit
      
      update allstations_temp 
      set ISINDOMAIN = dbo.is_in_d(LATITUDE, LONGITUDE)
      
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
where [SAMPLING_EVENT]='NULL' 

update allstations
set [SAMPLE_ID]=NULL 
where [SAMPLE_ID]='NULL' 

update allstations
set [BOTTOM_DEPTH]=NULL 
where [BOTTOM_DEPTH]='NULL' 

update allstations
set[TOP_DEPTH]=NULL 
where [TOP_DEPTH]='NULL' 

update allstations
set [DEPTH_UNITS]=NULL 
where [DEPTH_UNITS]='NULL' 

update allstations
set [RESULT_UNITS]=NULL 
where [RESULT_UNITS]='NULL' 

update allstations
set [COLLECTION_CODE]=NULL 
where [COLLECTION_CODE]='NULL' 

update allstations
set [COLLECTION_DATE]=NULL 
where [COLLECTION_DATE]='NULL' 

update allstations
set [COLLECTION_TIME]=NULL 
where [COLLECTION_TIME]='NULL' 

update allstations
set [END_COLLECTION_DATE]=NULL 
where [END_COLLECTION_DATE]='NULL' 

update allstations
set [END_COLLECTION_TIME]=NULL 
where [END_COLLECTION_TIME]='NULL' 

update allstations
set [DATA_USE]=NULL 
where [DATA_USE]='NULL' 

update allstations
set [MATRIX_CODE]=NULL 
where [MATRIX_CODE]='NULL' 

update allstations
set [SAMPLE_TYPE]=NULL 
where [SAMPLE_TYPE]='NULL' 

update allstations
set [COMMENTS]=NULL 
where [COMMENTS]='NULL' 

update allstations
set [COLLECTION_DURATION]=NULL 
where [COLLECTION_DURATION]='NULL' 

update allstations
set [COLLECTION_DURATION_UNITS]=NULL 
where [COLLECTION_DURATION_UNITS]='NULL' 

update allstations
set [ELAPSED_TIME]=NULL 
where [ELAPSED_TIME]='NULL' 

update allstations
set [PERCENT_SATURATED]=NULL 
where [PERCENT_SATURATED]='NULL' 

update allstations
set [PLANNED_SAMPLE_SEQ]=NULL 
where [PLANNED_SAMPLE_SEQ]='NULL' 

update allstations
set [RECORD_CREATED_DATE]=NULL 
where [RECORD_CREATED_DATE]='NULL' 

update allstations
set [RECORD_MODIFIED_DATE]=NULL 
where [RECORD_MODIFIED_DATE]='NULL' 
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
GO
/****** Object:  StoredProcedure [dbo].[CleanAllSamples]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CleanAllSamples] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allsamples_clean')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_clean]
	/*	
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allsamples_a')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_a]
    */
    
	--Create allresults_clean table
	select t.*
	into [SRSAnalysis].[dbo].[allsamples_clean]
	from [SRSAnalysis].[dbo].[allsamples] as t
	
		--ALTER INDEX COLUMNS
		ALTER TABLE [SRSAnalysis].[dbo].[allresults_clean]
		ALTER COLUMN RESULT_SEQ int
		
		ALTER TABLE [SRSAnalysis].[dbo].[allresults_clean]
		ALTER COLUMN SAMPLE_SEQ int
		
		
		--Create index on SAMPLE_SEQ
		create index Allsamples2_sampleseq_idx
		on allsamples_clean(SAMPLE_SEQ);
		
		create index AllResults2_stationseq_idx
		on allsamples_clean(STATION_SEQ);
		
		
	--Unit conversions
	
	--Datatype conversion
	/*update  allresults
	set =convert(float(53),)
	*/
	
	/*update  allresults
	set [NORTHING]=convert(numeric(32,10),[NORTHING])

    update  allresults
	set [EASTING]=convert(numeric(32,10),[EASTING])
	
	update  allresults
	set [LONGITUDE]=CONVERT(numeric(32,14),[LONGITUDE])
      
    update  allresults
	set [LATITUDE]=convert(numeric(32,14),[LATITUDE])
	
	update  allresults
	set [GROUND_ELEVATION]=convert(numeric(32,4),[GROUND_ELEVATION])
	
	update  allresults
	set [REFERENCE_ELEVATION]=convert(numeric(32,4),[REFERENCE_ELEVATION])*/
	
	--Add flag for geometry selection
	/*ALTER TABLE allresults
	ADD areaflag bit NULL;
	
	UPDATE allresults
	SET areaflag = dbo.n_isinfharea(LATITUDE,LONGITUDE)*/
		
END
GO
/****** Object:  StoredProcedure [dbo].[CleanAllResults]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CleanAllResults] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N'allresults_clean')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_clean]
    
	--Create allresults_clean table
	select [ANALYSIS_DATE]
      ,[ANALYSIS_TIME]
      ,[ANALYTE_ID]
      ,[ANALYTE_NAME]
      ,[RESULT]
      ,[RESULT_UNITS]
      ,[ERROR]
      ,[DILUTION_FACTOR]
      ,[ANALYTE_TYPE]
      ,[DETECTION_LIMIT] as MDL
      ,[DETECTION_UNITS] as MDL_UNITS
      ,[INSTRUMENT_DETECTION_LIMIT] as IDL
      ,[INSTRUMENT_DETECTION_UNITS] as IDL_UNITS
      ,[PREP_DATE]
      ,[PREP_TIME]
      ,[RECORD_CREATED_DATE]
      ,[RETENTION_TIME]
      ,[SAMPLE_QUANTITATION_LIMIT] as PQL
      ,[SAMPLE_QUANTITATION_UNITS] as PQL_UNITS
      ,[SAMPLE_SEQ]
      ,[RESULT_SEQ]
      ,[RESULT_TYPE] 
	into [SRSAnalysis].[dbo].[allresults_clean]
	from
	[SRSAnalysis].[dbo].[allresults] as t
	where t.RESULT_UNITS<>'%' and t.RESULT_UNITS is not NULL and t.RESULT is not NULL
	
		--ALTER INDEX COLUMNS
		ALTER TABLE [SRSAnalysis].[dbo].[allresults_clean]
		ALTER COLUMN RESULT_SEQ int
		
		ALTER TABLE [SRSAnalysis].[dbo].[allresults_clean]
		ALTER COLUMN SAMPLE_SEQ int
		
		
		--Create index on SAMPLE_SEQ
		create index AllResults2_sampleseq_idx
		on allresults_clean(SAMPLE_SEQ);
		
		create index AllResults2_resultseq_idx
		on allresults_clean(RESULT_SEQ);
		
		
	--Unit conversions
	
	--	ng/L --> ug/L
	
	update analytes
	set result = convert(float(53), result) / 1000.0,
	    result_units = 'ug/L'
	from allresults_clean analytes
	where result_units = 'ng/L'
	--
	update analytes
	set mdl = convert(float(53), mdl) / 1000.0,
	    mdl_units = 'ug/L'
	from allresults_clean analytes
	where mdl_units = 'ng/L'	
	--
	update analytes
	set pql = convert(float(53), pql) / 1000.0,
	    pql_units = 'ug/L'
	from allresults_clean analytes
	where pql_units = 'ng/L'	

	-- mg/L --> ug/L
		
	update analytes
	set result = convert(float(53), result) * 1000.0,
	    result_units = 'ug/L'
	from allresults_clean analytes
	where result_units = 'mg/L'
	--
	update analytes
	set mdl = convert(float(53), mdl) * 1000.0,
	    mdl_units = 'ug/L'
	from allresults_clean analytes
	where mdl_units = 'mg/L'	
	--
	update analytes
	set pql = convert(float(53), pql) * 1000.0,
	    pql_units = 'ug/L'
	from allresults_clean analytes
	where pql_units = 'mg/L'	
	
	-- mg/kg --> ug/kg
	
	update analytes
	set result = convert(float(53), result) * 1000.0,
	    result_units = 'ug/kg'
	from allresults_clean analytes
	where result_units = 'mg/kg'
	--
	update analytes
	set mdl = convert(float(53), mdl) * 1000.0,
	    mdl_units = 'ug/kg'
	from allresults_clean analytes
	where mdl_units = 'mg/kg'	
	--
	update analytes
	set pql = convert(float(53), pql) * 1000.0,
	    pql_units = 'ug/kg'
	from allresults_clean analytes
	where pql_units = 'mg/kg'	
	
	-- pCi/ml --> pCi/L
		
	update analytes
	set result = convert(float(53), result) * 1000.0,
	    error = convert(float(53), error) * 1000.0,
	    result_units = 'pCi/L'
	from allresults_clean analytes
	where result_units = 'pCi/mL'
	--
	update analytes
	set mdl = convert(float(53), mdl) * 1000.0,
	    mdl_units = 'pCi/L'
	from allresults_clean analytes
	where mdl_units = 'pCi/mL'	
	--
	update analytes
	set pql = convert(float(53), pql) * 1000.0,
	    pql_units = 'pCi/L'
	from allresults_clean analytes
	where pql_units = 'pCi/mL'
		
	
	--Datatype conversion
	/*update  allresults
	set =convert(float(53),)
	*/
	
	/*update  allresults
	set [NORTHING]=convert(numeric(32,10),[NORTHING])

    update  allresults
	set [EASTING]=convert(numeric(32,10),[EASTING])
	
	update  allresults
	set [LONGITUDE]=CONVERT(numeric(32,14),[LONGITUDE])
      
    update  allresults
	set [LATITUDE]=convert(numeric(32,14),[LATITUDE])
	
	update  allresults
	set [GROUND_ELEVATION]=convert(numeric(32,4),[GROUND_ELEVATION])
	
	update  allresults
	set [REFERENCE_ELEVATION]=convert(numeric(32,4),[REFERENCE_ELEVATION])*/
	
	--Add flag for geometry selection
	/*ALTER TABLE allresults
	ADD areaflag bit NULL;
	
	UPDATE allresults
	SET areaflag = dbo.n_isinfharea(LATITUDE,LONGITUDE)*/
		
END
GO
/****** Object:  StoredProcedure [dbo].[CreateAllStations]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
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
			where id = OBJECT_ID(N'allstations')
				and OBJECTPROPERTY(id,N'IsUserTable') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations]
    
	--Create allstations table
	
	/*
	
	select COUNT(*)
/*ss.STATION_SEQ,ss.STATION_ID,
ss.GROUND_ELEVATION,ss.REFERENCE_ELEVATION,ss.REFERENCE_ELEVATION_CODE,sc.TOP_DEPTH,sc.TOP_DEPTH */
from VBEIDMS_SAMPLE_STATIONS ss
join (select * from VBEIDMS_STATION_CONSTRUCT where CONSTRUCTION_OBJECT='screen' ) sc
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
      left outer join (select * from BEIDMS.dbo.VBEIDMS_STATION_CONSTRUCT where CONSTRUCTION_OBJECT='screen') as sc
      on ss.STATION_SEQ=sc.STATION_SEQ
	
      
		
      --Clean nulls

/*		
update allstations
set [SAMPLING_EVENT]=NULL 
where [SAMPLING_EVENT]='NULL' 

update allstations
set [SAMPLE_ID]=NULL 
where [SAMPLE_ID]='NULL' 

update allstations
set [BOTTOM_DEPTH]=NULL 
where [BOTTOM_DEPTH]='NULL' 

update allstations
set[TOP_DEPTH]=NULL 
where [TOP_DEPTH]='NULL' 

update allstations
set [DEPTH_UNITS]=NULL 
where [DEPTH_UNITS]='NULL' 

update allstations
set [RESULT_UNITS]=NULL 
where [RESULT_UNITS]='NULL' 

update allstations
set [COLLECTION_CODE]=NULL 
where [COLLECTION_CODE]='NULL' 

update allstations
set [COLLECTION_DATE]=NULL 
where [COLLECTION_DATE]='NULL' 

update allstations
set [COLLECTION_TIME]=NULL 
where [COLLECTION_TIME]='NULL' 

update allstations
set [END_COLLECTION_DATE]=NULL 
where [END_COLLECTION_DATE]='NULL' 

update allstations
set [END_COLLECTION_TIME]=NULL 
where [END_COLLECTION_TIME]='NULL' 

update allstations
set [DATA_USE]=NULL 
where [DATA_USE]='NULL' 

update allstations
set [MATRIX_CODE]=NULL 
where [MATRIX_CODE]='NULL' 

update allstations
set [SAMPLE_TYPE]=NULL 
where [SAMPLE_TYPE]='NULL' 

update allstations
set [COMMENTS]=NULL 
where [COMMENTS]='NULL' 

update allstations
set [COLLECTION_DURATION]=NULL 
where [COLLECTION_DURATION]='NULL' 

update allstations
set [COLLECTION_DURATION_UNITS]=NULL 
where [COLLECTION_DURATION_UNITS]='NULL' 

update allstations
set [ELAPSED_TIME]=NULL 
where [ELAPSED_TIME]='NULL' 

update allstations
set [PERCENT_SATURATED]=NULL 
where [PERCENT_SATURATED]='NULL' 

update allstations
set [PLANNED_SAMPLE_SEQ]=NULL 
where [PLANNED_SAMPLE_SEQ]='NULL' 

update allstations
set [RECORD_CREATED_DATE]=NULL 
where [RECORD_CREATED_DATE]='NULL' 

update allstations
set [RECORD_MODIFIED_DATE]=NULL 
where [RECORD_MODIFIED_DATE]='NULL' 
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
GO
/****** Object:  StoredProcedure [dbo].[CreateAllTables]    Script Date: 03/04/2013 17:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreateAllTables] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	--
	Exec CreateAllResults
	Exec CleanAllResults
	--
	Exec CreateAllSamples
	Exec CreateAllStations
	Exec CleanAllStations
	
		
END
GO
