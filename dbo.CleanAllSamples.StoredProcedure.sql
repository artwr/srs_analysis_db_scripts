USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CleanAllSamples]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CleanAllSamples]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
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
			where id = OBJECT_ID(N''allsamples_clean'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allsamples_clean]
	/*	
		if exists (
		select * from sysobjects 
			where id = OBJECT_ID(N''allsamples_a'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
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
' 
END
GO
