USE [SRSAnalysis]
GO
/****** Object:  UserDefinedFunction [dbo].[is_in_d]    Script Date: 05/16/2014 16:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[is_in_d]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
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
        SET @fharea = ''POLYGON((-81.69916545891509 33.29691707038678,
		-81.69582803811416 33.26220562703161, 
		-81.62808524032883 33.26608313233162, 
		-81.63056277012669 33.29962470503676,
		-81.69916545891509 33.29691707038678))'';
		*/
		
		DECLARE @d geometry 
		SET @d = ''POLYGON((-81.69959850412471 33.25157883545753,
		-81.67044897936366 33.27019298584946,
		-81.67168817516688 33.27837760341561,
		-81.69388086898707 33.28329777530127,
		-81.69959850412471 33.25157883545753))'';

        --Create the intermediate string object
        DECLARE @strgeom1 varchar(255)
        SET @strgeom1 = ''POINT (''+CONVERT(VARCHAR(50),@long)+'' ''+CONVERT(VARCHAR(50),@lat)+'' NULL NULL)''

        DECLARE @p1 geometry
        SET @p1 = geometry::Parse(@strgeom1);

    SELECT @Result = @d.STIntersects(@p1);

        -- Return the result of the function
        RETURN @Result

END' 
END
GO
