USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateDCTables]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateDCTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
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
			where id = OBJECT_ID(N''allsamples_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_a]
		
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_d3'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_d3]
	
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allsamples_D'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_D]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allstations_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allstations_a]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allresults_D'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_D]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_D'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_D]
	
	if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allsamples_C'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_C]
		
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allresults_C'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allresults_C]
		
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allwaterlevels_C'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allwaterlevels_C]
	
	--
	--select the stations we are interested in
      select *
      into allstations_a
      from allstations_clean
      where ISINDOMAIN2=1 and STATION_TYPE not in (''UNKNOWN'',''SOIL'',''SEDIMENT'',''SED/SW'',''CPT'',''PRODUCTION WELL'',''DEWATER WELL'') and STATION_ID not like ''UNK%''
      
      select *
      into allstations_d3
      from allstations_clean
      where ISINDOMAIN3=1 and STATION_TYPE not in (''UNKNOWN'',''SOIL'',''SEDIMENT'',''SED/SW'',''CPT'',''PRODUCTION WELL'',''DEWATER WELL'') and STATION_ID not like ''UNK%''
      
      
      create index AllStationsa_stationseq_idx
		on allstations_a(STATION_SEQ);
	  
	  create index AllStationsd3_stationseq_idx
		on allstations_d3(STATION_SEQ);
	
	--fast index stations_a
	DECLARE @stationseqt TABLE (STATION_SEQ int)
      
    INSERT INTO @stationseqt (STATION_SEQ)
    select distinct STATION_SEQ from allstations_a
    
    --fast index station d3
    DECLARE @stationseqtd3 TABLE (STATION_SEQ int)
      
    INSERT INTO @stationseqtd3 (STATION_SEQ)
    select distinct STATION_SEQ from allstations_d3
		
	--select the samples of interest
	select samp.*
	into allsamples_a
	from allsamples samp
	where STATION_SEQ in (select STATION_SEQ from @stationseqt)
	
	--select the water level measurements of interest
	select wl.*
	into allwaterlevels_a
	from allwaterlevels wl
	where STATION_SEQ in (select STATION_SEQ from @stationseqt)
	
	--select the water level measurements of interest
	select wl.*
	into allwaterlevels_d3
	from allwaterlevels wl
	where STATION_SEQ in (select STATION_SEQ from @stationseqtd3)
	
		
	--Define the proper aquifers
	
      update allstations_a
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
       WHEN STATION_ID=''FIN 8'' or STATION_ID=''FIN 9'' THEN ''C''
       WHEN STATION_ID=''FEX 8'' or STATION_ID=''FEX 9'' THEN ''C''
       WHEN STATION_ID like ''FAW%'' then ''D''
       WHEN STATION_ID = ''FTF 14'' THEN ''D''
       WHEN STATION_ID like ''FIP%'' then ''D''
       WHEN STATION_ID like ''ZW%'' then ''D''
       WHEN STATION_TYPE=''INJECTION WELL'' THEN ''D''
       WHEN STATION_TYPE=''EXTRACTION WELL'' THEN ''D''
       END
       
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
       WHEN STATION_ID=''FIN 8'' or STATION_ID=''FIN 9'' THEN ''C''
       WHEN STATION_ID=''FEX 8'' or STATION_ID=''FEX 9'' THEN ''C''
       WHEN STATION_ID like ''FAW%'' then ''D''
       WHEN STATION_ID = ''FTF 14'' THEN ''D''
       WHEN STATION_ID like ''FIP%'' then ''D''
       WHEN STATION_ID like ''ZW%'' then ''D''
       WHEN STATION_TYPE=''INJECTION WELL'' THEN ''D''
       WHEN STATION_TYPE=''EXTRACTION WELL'' THEN ''D''
       END
       
       
       
      --Deal with duplicate station ids
      create table #dups  (
		station varchar(256),
		s_seq int,
		alias varchar(256),
		as_seq int);
		
	
	  insert into #dups (station, alias)
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
		
	update #dups
	set #dups.s_seq = a.STATION_SEQ
	from #dups d join allstations_a a
		on d.station = a.station_id
		
	update #dups
	set #dups.as_seq = a.STATION_SEQ
	from #dups d join allstations_a a
		on d.alias = a.station_id
		
	delete from #dups
	where s_seq is null or as_seq is null
	
	--change the station_seq of the sample that we want
	update allsamples_a
	set STATION_SEQ=d.s_seq
	from allsamples_a sampa join #dups d
	on sampa.STATION_SEQ=d.as_seq
	
	update allwaterlevels_a
	set STATION_SEQ=d.s_seq
	from allwaterlevels_a wla join #dups d
	on wla.STATION_SEQ=d.as_seq
	
	--remove the duplicate stations
	--delete from allstations_a
	--where STATION_SEQ in (select as_seq from #dups)
	
	
      
      --fast index table
      
      /*
      DECLARE @stationseqt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_a --where AQUIFER=''D''
      */
      
      
      DECLARE @stationseqDt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqDt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_a where AQUIFER=''D''
      
      DECLARE @stationseqCt TABLE (STATION_SEQ int)
      
      INSERT INTO @stationseqCt (STATION_SEQ)
      select distinct STATION_SEQ from allstations_a where AQUIFER=''C'' AND STATION_ID not in(''FEX 8'',''FEX 9'',''FIN 8'',''FIN 9'')
    
	--Create allsamples table
	select * 
	into [SRSAnalysis].[dbo].[allsamples_D]
	from [SRSAnalysis].[dbo].[allsamples_a]
	where STATION_SEQ in (select STATION_SEQ from @stationseqDt)
	
	select * 
	into [SRSAnalysis].[dbo].[allsamples_C]
	from [SRSAnalysis].[dbo].[allsamples_a]
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
	from [SRSAnalysis].[dbo].[allwaterlevels_a]
	where STATION_SEQ in (select STATION_SEQ from @stationseqDt)
	
	create index AllwaterlevelsD_stationseq_idx
		on allwaterlevels_D(STATION_SEQ);
		
	select * 
	into [SRSAnalysis].[dbo].[allwaterlevels_C]
	from [SRSAnalysis].[dbo].[allwaterlevels_a]
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
' 
END
GO
