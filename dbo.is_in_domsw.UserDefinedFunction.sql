USE [SRSAnalysis]
GO
/****** Object:  UserDefinedFunction [dbo].[is_in_domsw]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[is_in_domsw]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:              AWiedmer
-- Create date:
-- Description: Determines whether the point defined by lat,long is in
-- a polygon defined in the function body. Returns bit 1 if TRUE
-- =============================================
CREATE FUNCTION [dbo].[is_in_domsw]
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
        SET @fharea = ''POLYGON((-81.69916545891509 33.29691707038678,
		-81.69582803811416 33.26220562703161, 
		-81.62808524032883 33.26608313233162, 
		-81.63056277012669 33.29962470503676,
		-81.69916545891509 33.29691707038678))'';
		*/
		
		DECLARE @domsw geometry 
		SET @domsw = ''POLYGON((-81.67342011502086 33.27412830059227,
-81.6881594534144 33.26734937151401,
-81.70253681844591 33.24825807896895,
-81.70844474510946 33.23157094503826,
-81.71986167838985 33.21659899220063,
-81.72424879020606 33.20137136871541,
-81.73513953751666 33.18509628937944,
-81.72635983382969 33.17871986826946,
-81.71672310989713 33.18747398375963,
-81.7088428374758 33.20165615868603,
-81.70218910063393 33.21435899960756,
-81.69207187900808 33.22649585995794,
-81.67776651031819 33.23596281422702,
-81.68684385757045 33.24163948629321,
-81.67865267568968 33.25800812155567,
-81.65393065713857 33.26027316795537,
-81.60032625937568 33.25473248655025,
-81.59742512314453 33.28467153397545,
-81.67342011502086 33.27412830059227))'';

        --Create the intermediate string object
        DECLARE @strgeom1 varchar(255)
        SET @strgeom1 = ''POINT (''+CONVERT(VARCHAR(50),@long)+'' ''+CONVERT(VARCHAR(50),@lat)+'' NULL NULL)''

        DECLARE @p1 geometry
        SET @p1 = geometry::Parse(@strgeom1);

        SELECT @Result = @domsw.STIntersects(@p1);

        -- Return the result of the function
        RETURN @Result

END' 
END
GO
