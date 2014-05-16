USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateAllResults]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateAllResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
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
			where id = OBJECT_ID(N''allresults'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
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
		,[LAB_QUALIFIER]
        ,[REVIEW_QUALIFIER]
        ,NULL as [QC1]
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
		,[LAB_QUALIFIER]
        ,[REVIEW_QUALIFIER]
        ,NULL as [QC1]
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
where[ANALYSIS_DATE]=''NULL'' 

update allresults
set[ANALYSIS_TIME]=NULL 
where[ANALYSIS_TIME]=''NULL'' 

update allresults
set[ANALYTE_ID]=NULL 
where[ANALYTE_ID]=''NULL'' 

update allresults
set[ANALYTE_NAME]=NULL 
where[ANALYTE_NAME]=''NULL'' 

update allresults
set[RESULT]=NULL 
where[RESULT]=''NULL'' 

update allresults
set[RESULT_UNITS]=NULL 
where[RESULT_UNITS]=''NULL'' 

update allresults
set[ERROR]=NULL 
where[ERROR]=''NULL'' 

update allresults
set[DILUTION_FACTOR]=NULL 
where[DILUTION_FACTOR]=''NULL'' 

update allresults
set[ANALYTE_TYPE]=NULL 
where[ANALYTE_TYPE]=''NULL'' 

update allresults
set[DETECTION_LIMIT]=NULL 
where[DETECTION_LIMIT]=''NULL'' 

update allresults
set[DETECTION_UNITS]=NULL 
where[DETECTION_UNITS]=''NULL'' 

update allresults
set[INSTRUMENT_DETECTION_LIMIT]=NULL 
where[INSTRUMENT_DETECTION_LIMIT]=''NULL'' 

update allresults
set[INSTRUMENT_DETECTION_UNITS]=NULL 
where[INSTRUMENT_DETECTION_UNITS]=''NULL'' 

update allresults
set [LAB_QUALIFIER]=NULL 
where [LAB_QUALIFIER]=''NULL'' 

update allresults
set [REVIEW_QUALIFIER]=NULL 
where [REVIEW_QUALIFIER]=''NULL'' 

update allresults
set[PREP_DATE]=NULL 
where[PREP_DATE]=''NULL'' 

update allresults
set[PREP_TIME]=NULL 
where[PREP_TIME]=''NULL'' 

update allresults
set[SAMPLE_QUANTITATION_LIMIT]=NULL 
where[SAMPLE_QUANTITATION_LIMIT]=''NULL'' 

update allresults
set[SAMPLE_QUANTITATION_UNITS]=NULL 
where[SAMPLE_QUANTITATION_UNITS]=''NULL'' 

update allresults
set[SAMPLE_SEQ]=NULL 
where[SAMPLE_SEQ]=''NULL'' 

update allresults
set[RESULT_SEQ]=NULL 
where[RESULT_SEQ]=''NULL'' 

update allresults
set[RESULT_TYPE]=NULL 
where[RESULT_TYPE]=''NULL'' 
	
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
