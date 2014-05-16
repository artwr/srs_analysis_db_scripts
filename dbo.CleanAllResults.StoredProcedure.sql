USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CleanAllResults]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CleanAllResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
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
			where id = OBJECT_ID(N''allresults_clean'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
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
      ,[LAB_QUALIFIER]
      ,[REVIEW_QUALIFIER]
      ,[QC1]
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
	where t.RESULT_UNITS<>''%'' and t.RESULT_UNITS is not NULL and t.RESULT is not NULL
	
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
	    result_units = ''ug/L''
	from allresults_clean analytes
	where result_units = ''ng/L''
	--
	update analytes
	set mdl = convert(float(53), mdl) / 1000.0,
	    mdl_units = ''ug/L''
	from allresults_clean analytes
	where mdl_units = ''ng/L''	
	--
	update analytes
	set pql = convert(float(53), pql) / 1000.0,
	    pql_units = ''ug/L''
	from allresults_clean analytes
	where pql_units = ''ng/L''	
	--
	update analytes
	set idl = convert(float(53), idl) / 1000.0,
	    idl_units = ''ug/L''
	from allresults_clean analytes
	where idl_units = ''ng/L''

	-- mg/L --> ug/L
		
	update analytes
	set result = convert(float(53), result) * 1000.0,
	    result_units = ''ug/L''
	from allresults_clean analytes
	where result_units = ''mg/L''
	--
	update analytes
	set mdl = convert(float(53), mdl) * 1000.0,
	    mdl_units = ''ug/L''
	from allresults_clean analytes
	where mdl_units = ''mg/L''	
	--
	update analytes
	set pql = convert(float(53), pql) * 1000.0,
	    pql_units = ''ug/L''
	from allresults_clean analytes
	where pql_units = ''mg/L''
	--
	update analytes
	set idl = convert(float(53), idl) * 1000.0,
	    idl_units = ''ug/L''
	from allresults_clean analytes
	where idl_units = ''mg/L''	
	
	-- mg/kg --> ug/kg
	
	update analytes
	set result = convert(float(53), result) * 1000.0,
	    result_units = ''ug/kg''
	from allresults_clean analytes
	where result_units = ''mg/kg''
	--
	update analytes
	set mdl = convert(float(53), mdl) * 1000.0,
	    mdl_units = ''ug/kg''
	from allresults_clean analytes
	where mdl_units = ''mg/kg''	
	--
	update analytes
	set pql = convert(float(53), pql) * 1000.0,
	    pql_units = ''ug/kg''
	from allresults_clean analytes
	where pql_units = ''mg/kg''
	--
	update analytes
	set idl = convert(float(53), idl) * 1000.0,
	    idl_units = ''ug/kg''
	from allresults_clean analytes
	where idl_units = ''mg/kg''		
	
	-- pCi/ml --> pCi/L
		
	update analytes
	set result = convert(float(53), result) * 1000.0,
	    error = convert(float(53), error) * 1000.0,
	    result_units = ''pCi/L''
	from allresults_clean analytes
	where result_units = ''pCi/mL''
	--
	update analytes
	set mdl = convert(float(53), mdl) * 1000.0,
	    mdl_units = ''pCi/L''
	from allresults_clean analytes
	where mdl_units = ''pCi/mL''	
	--
	update analytes
	set pql = convert(float(53), pql) * 1000.0,
	    pql_units = ''pCi/L''
	from allresults_clean analytes
	where pql_units = ''pCi/mL''
	--
	update analytes
	set idl = convert(float(53), idl) * 1000.0,
	    idl_units = ''pCi/L''
	from allresults_clean analytes
	where idl_units = ''pCi/mL''
		
	
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
