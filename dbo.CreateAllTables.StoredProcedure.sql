USE [SRSAnalysis]
GO
/****** Object:  StoredProcedure [dbo].[CreateAllTables]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateAllTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
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
' 
END
GO
