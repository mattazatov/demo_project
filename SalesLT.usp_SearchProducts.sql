CREATE PROCEDURE SalesLT.usp_SearchProducts
    @SearchTerm VARCHAR(100),
    @CategoryName VARCHAR(50) = NULL
AS

DECLARE @sql NVARCHAR(MAX);

SET @sql = 'SELECT p.ProductID, p.Name, p.ListPrice, p.Color, c.Name as CategoryName
FROM SalesLT.Product p
LEFT JOIN SalesLT.ProductCategory c ON p.ProductCategoryID = c.ProductCategoryID
WHERE p.Name LIKE ''%' + @SearchTerm + '%''';

IF @CategoryName IS NOT NULL
    SET @sql = @sql + ' AND c.Name = ''' + @CategoryName + '''';

SET @sql = @sql + ' ORDER BY p.ListPrice DESC';

EXEC(@sql);
