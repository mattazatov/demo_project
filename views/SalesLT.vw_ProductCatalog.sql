CREATE VIEW SalesLT.vw_ProductCatalog
AS
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.Color,
    p.ListPrice,
    p.Size,
    p.Weight,
    pc.Name AS CategoryName,
    COALESCE(parent.Name, 'Uncategorized') AS ParentCategoryName,
    pm.Name AS ModelName,
    pmd.Description AS ModelDescription,
    1 as test
FROM SalesLT.Product p
INNER JOIN SalesLT.ProductCategory pc
    ON p.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN SalesLT.ProductCategory parent
    ON pc.ParentProductCategoryID = parent.ProductCategoryID
LEFT JOIN SalesLT.ProductModel pm
    ON p.ProductModelID = pm.ProductModelID
LEFT JOIN SalesLT.ProductModelProductDescription pmd
    ON pm.ProductModelID = pmd.ProductModelID
    AND pmd.Culture = 'en'
WHERE p.SellEndDate IS NULL
