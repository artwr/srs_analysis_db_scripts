USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreatedSWTables]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatedSWTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Arthur Wiedmer
-- Create date: 2012-08-24
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[CreatedSWTables] 
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
			where id = OBJECT_ID(N''allsamples_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allstations_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allresults_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_a]
		
	*/
	
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allsamples_sw'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_sw]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_d3'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_d3]
	
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allsamples_d3D'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_d3D]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allstations_d3'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_d3]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allresults_d3D'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_d3D]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_d3D'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_d3D]
	
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allsamples_d3C'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_d3C]
		
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allresults_d3C'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_d3C]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_d3C'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_d3C]
	
	--
	--select the stations we are interested in
    
      SELECT *
INTO   allstations_d3
FROM   allstations_clean
WHERE  ISINDOMAIN3 = 1
       AND STATION_TYPE NOT IN (''UNKNOWN'', ''SOIL'', ''SEDIMENT'', ''SED/SW'', ''CPT'', ''PRODUCTION WELL'', ''DEWATER WELL'', ''GEOTECH BORING'', ''ML MONITOR WELL'')
       AND STATION_ID NOT LIKE ''UNK%''
       AND STATION_SEQ NOT IN (''28304683'', ''28304684'', ''28304685'', ''28304686'', ''28304651'', ''1012344'', ''1012346'', ''26528019'', ''26528569'');
	  
	  create index AllStationsd3_stationseq_idx
		on allstations_d3(STATION_SEQ);
    
    --fast index station d3
    DECLARE @stationseqtd3 TABLE (STATION_SEQ int)
      
    INSERT INTO @stationseqtd3 (STATION_SEQ)
    select distinct STATION_SEQ from allstations_d3
		
	--select the samples of interest

	select samp.*
	into allsamples_d3
	from allsamples samp
	where STATION_SEQ in (select STATION_SEQ from @stationseqtd3)
	
	--select the water level measurements of interest
	select wl.*
	into allwaterlevels_d3
	from allwaterlevels wl
	where STATION_SEQ in (select STATION_SEQ from @stationseqtd3)
	
		
	--Define the proper aquifers
       
      update allstations_d3
      set AQUIFER =  CASE 
       WHEN STATION_TYPE=''SURFACE WATER'' THEN ''D''
       WHEN STATION_TYPE=''SEEPLINE'' THEN ''D''
       WHEN STATION_TYPE=''PIEZOMETER WELL'' THEN ''D''
       WHEN STATION_ID like ''FM %'' then ''D''
       WHEN STATION_ID like ''PMW%'' then ''D''
       WHEN STATION_ID like ''%D'' THEN ''D''
       WHEN STATION_ID like ''%DR'' THEN ''D''
       WHEN STATION_ID like ''%C'' THEN ''C''
       WHEN STATION_ID like ''%CR'' THEN ''C''
       WHEN STATION_ID like ''%B'' THEN ''B''
       WHEN STATION_ID like ''%BR'' THEN ''B''
       WHEN STATION_ID like ''%A'' THEN ''A''
       WHEN STATION_ID like ''%AR'' THEN ''A''
       WHEN STATION_ID like ''FSB 7%'' then ''D''
       WHEN STATION_ID like ''F  %'' then ''D''
       WHEN STATION_ID like ''FBP%'' then ''D''
       WHEN STATION_ID like ''S  %'' then ''D''
       WHEN STATION_ID like ''SSS%'' then ''D''
       WHEN STATION_ID=''FIN 8'' or STATION_ID=''FIN 9'' THEN ''C''
       WHEN STATION_ID=''FEX 8'' or STATION_ID=''FEX 9'' THEN ''C''
       WHEN STATION_ID like ''FAW%'' then ''D''
       WHEN STATION_ID=''FTF 28'' then NULL
       WHEN STATION_ID like ''FTF%'' THEN ''D''
       WHEN STATION_ID like ''FIP%'' then ''D''
       WHEN STATION_ID like ''ZW%'' then ''D''
       WHEN STATION_ID like ''MZ %'' then ''D''
       WHEN STATION_ID like ''BG %'' then ''D''
       WHEN STATION_TYPE=''INJECTION WELL'' THEN ''D''
       WHEN STATION_TYPE=''EXTRACTION WELL'' THEN ''D''
       END
       
       
	--
	
	 --Deal with duplicate station ids
      create table #dupsd3  (
		station varchar(256),
		s_seq int,
		alias varchar(256),
		as_seq int);
		
	
	  insert into #dupsd3 (station, alias)
		values
		(''FSP-60'', ''FSP-060''),
		(''FSP-61'', ''FSP-061''),
		(''FSP-62'', ''FSP-062''),
		(''FSP-63'', ''FSP-063''),
		(''FSP-64'', ''FSP-064''),
		(''FSP-65'', ''FSP-065''),
		(''FSP-66'', ''FSP-066''),
		(''FSP-67'', ''FSP-067''),
		(''FSP-68'', ''FSP-068''),
		(''FSP-69'', ''FSP-069''),
		(''FSP-70'', ''FSP-070''),
		(''FSP-71'', ''FSP-071''),
		(''FSP-72'', ''FSP-072'')
		
	update #dupsd3
	set #dupsd3.s_seq = d3.STATION_SEQ
	from #dupsd3 d join allstations_d3 d3
		on d.station = d3.station_id
		
	update #dupsd3
	set #dupsd3.as_seq = d3.STATION_SEQ
	from #dupsd3 d join allstations_d3 d3
		on d.alias = d3.station_id
		
	delete from #dupsd3
	where s_seq is null or as_seq is null
	
	
	--change the station_seq of the sample that we want
	update allsamples_d3
	set STATION_SEQ=d.s_seq
	from allsamples_d3 sampa join #dupsd3 d
	on sampa.STATION_SEQ=d.as_seq
	
	update allwaterlevels_d3
	set STATION_SEQ=d.s_seq
	from allwaterlevels_d3 wla join #dupsd3 d
	on wla.STATION_SEQ=d.as_seq
	
	--remove the duplicate stations
	--delete from allstations_a
	--where STATION_SEQ in (select as_seq from #dups)
	
	
      
      --fast index tables
      
      /*
      DECLARE @stationseqt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_a --where AQUIFER=''D''
      */
      
      
      DECLARE @stationseqd3Dt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqd3Dt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_d3 where AQUIFER=''D''
      
      DECLARE @stationseqd3Ct TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqd3Ct (STATION_SEQ)
      select distinct STATION_SEQ from allstations_d3 where AQUIFER=''C'' AND STATION_ID not in(''FEX 8'',''FEX 9'',''FIN 8'',''FIN 9'')
    
    
    
	--Create allsamples table
	select * 
	into [SRSAnalysis].[dbo].[allsamples_d3D]
	from [SRSAnalysis].[dbo].[allsamples_d3]
	where STATION_SEQ in (select STATION_SEQ from @stationseqd3Dt)
	
	select * 
	into [SRSAnalysis].[dbo].[allsamples_d3C]
	from [SRSAnalysis].[dbo].[allsamples_d3]
	where STATION_SEQ in (select STATION_SEQ from @stationseqd3Ct)
		
		--Create index on SAMPLE_SEQ
		create index AllSamplesd3D_sampleseq_idx
		on allsamples_d3D(SAMPLE_SEQ);
		
		create index AllSamplesd3D_stationseq_idx
		on allsamples_d3D(STATION_SEQ);
		
		create index AllSamplesd3C_sampleseq_idx
		on allsamples_d3C(SAMPLE_SEQ);
		
		create index AllSamplesd3C_stationseq_idx
		on allsamples_d3C(STATION_SEQ);
		
	
	/*	
	DECLARE @stationseqt TABLE (STATION_SEQ int)
      
    INSERT INTO @stationseqt (STATION_SEQ)
    select distinct STATION_SEQ from allstations_a
	*/
	--Create water levels
	select * 
	into [SRSAnalysis].[dbo].[allwaterlevels_d3D]
	from [SRSAnalysis].[dbo].[allwaterlevels_d3]
	where STATION_SEQ in (select STATION_SEQ from @stationseqd3Dt)
	
	create index Allwaterlevelsd3D_stationseq_idx
		on allwaterlevels_d3D(STATION_SEQ);
		
	select * 
	into [SRSAnalysis].[dbo].[allwaterlevels_d3C]
	from [SRSAnalysis].[dbo].[allwaterlevels_d3]
	where STATION_SEQ in (select STATION_SEQ from @stationseqd3Ct)
	
	create index Allwaterlevelsd3C_stationseq_idx
		on allwaterlevels_d3C(STATION_SEQ);
	--
	
	--Samples of interest
	DECLARE @sampleseqd3Dt TABLE (SAMPLE_SEQ int)
    
    INSERT INTO @sampleseqd3Dt (SAMPLE_SEQ)
    select distinct SAMPLE_SEQ from allsamples_d3D
    
    DECLARE @sampleseqd3Ct TABLE (SAMPLE_SEQ int)
    
    INSERT INTO @sampleseqd3Ct (SAMPLE_SEQ)
    select distinct SAMPLE_SEQ from allsamples_d3C
    
    /*
    DECLARE @sampleseqt TABLE (SAMPLE_SEQ int)
    
    INSERT INTO @sampleseqt (SAMPLE_SEQ)
    select distinct SAMPLE_SEQ from allsamples_D
    */
    
    --Create allresults_*
    select * 
	into [SRSAnalysis].[dbo].[allresults_d3D]
	from [SRSAnalysis].[dbo].[allresults_clean]
	where SAMPLE_SEQ in (select SAMPLE_SEQ from @sampleseqd3Dt)
	
	select * 
	into [SRSAnalysis].[dbo].[allresults_d3C]
	from [SRSAnalysis].[dbo].[allresults_clean]
	where SAMPLE_SEQ in (select SAMPLE_SEQ from @sampleseqd3Ct)
	--Create index on SAMPLE_SEQ
		create index AllResultsd3D_sampleseq_idx
		on allresults_d3D(SAMPLE_SEQ);
		
		create index AllResultsd3D_stationseq_idx
		on allresults_d3D(RESULT_SEQ);
		
		create index AllResultsd3C_sampleseq_idx
		on allresults_d3C(SAMPLE_SEQ);
		
		create index AllResultsd3C_stationseq_idx
		on allresults_d3C(RESULT_SEQ);
	
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
