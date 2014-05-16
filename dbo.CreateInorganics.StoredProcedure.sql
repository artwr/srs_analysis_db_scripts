USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateInorganics]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateInorganics]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
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
			where id = OBJECT_ID(N''allinorganics'')
				and OBJECTPROPERTY(id,N''IsUserTable'') = 1
	)
		drop table [SRSAnalysis].[dbo].[allinorganics]
    
	--Create allresults table
	select ar.*
    into [SRSAnalysis].[dbo].[allinorganics]
    from [SRSAnalysis].[dbo].[allresults] as ar
    join [BEIDMS].[dbo].[VBEIDMS_ANALYTES] as a
    on ar.analyte_name=a.analyte_name
    where a.chemical_class=''I''
		
END
' 
END
GO
