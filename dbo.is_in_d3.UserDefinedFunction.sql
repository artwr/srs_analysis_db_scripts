USE [SRSAnalysis]
GO
/****** Object:  UserDefinedFunction [dbo].[is_in_d3]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[is_in_d3]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:              AWiedmer
-- Create date:
-- Description: Determines whether the point defined by lat,long is in
-- a polygon defined in the function body. Returns bit 1 if TRUE
-- =============================================
CREATE FUNCTION [dbo].[is_in_d3]
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
		
		DECLARE @d3 geometry 
		SET @d3 = ''POLYGON((-81.69959850412471 33.25157883545753,
                            -81.66893076363978 33.27075529497145,
                            -81.66874375846673 33.2797255736357,
                            -81.69341116073315 33.28833045113768,
                            -81.69959850412471 33.25157883545753))'';

        --Create the intermediate string object
        DECLARE @strgeom1 varchar(255)
        SET @strgeom1 = ''POINT (''+CONVERT(VARCHAR(50),@long)+'' ''+CONVERT(VARCHAR(50),@lat)+'' NULL NULL)''

        DECLARE @p1 geometry
        SET @p1 = geometry::Parse(@strgeom1);

    SELECT @Result = @d3.STIntersects(@p1);

        -- Return the result of the function
        RETURN @Result

END' 
END
GO
