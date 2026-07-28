CREATE VIEW SalesLT.vw_ProductAndCategory
AS
SELECT
    *
FROM SalesLT.Product p
INNER JOIN SalesLT.ProductCategory pc
    ON p.ProductCategoryID = pc.ProductCategoryID;