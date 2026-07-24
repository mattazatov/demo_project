/*
    View:       SalesLT.vw_CustomerOrderSummary
    Purpose:    Provides a summary of each customer order including
                item count and total revenue per order.
    Author:     Farrux
    Created:    2026-07-24
*/
CREATE VIEW SalesLT.vw_CustomerOrderSummary
AS
SELECT
    cust.CustomerID,
    cust.FirstName,
    cust.LastName,
    cust.CompanyName,
    ordr.SalesOrderID,
    ordr.OrderDate,
    ordr.DueDate,
    ordr.ShipDate,
    ordr.Status,
    ordr.SubTotal,
    ordr.TaxAmt,
    ordr.Freight,
    ordr.TotalDue,
    COUNT(detail.SalesOrderDetailID)    AS ItemCount,
    SUM(detail.LineTotal)               AS ComputedTotal
FROM SalesLT.SalesOrderHeader       AS ordr
INNER JOIN SalesLT.Customer         AS cust
    ON ordr.CustomerID = cust.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS detail
    ON ordr.SalesOrderID = detail.SalesOrderID
GROUP BY
    cust.CustomerID,
    cust.FirstName,
    cust.LastName,
    cust.CompanyName,
    ordr.SalesOrderID,
    ordr.OrderDate,
    ordr.DueDate,
    ordr.ShipDate,
    ordr.Status,
    ordr.SubTotal,
    ordr.TaxAmt,
    ordr.Freight,
    ordr.TotalDue;
