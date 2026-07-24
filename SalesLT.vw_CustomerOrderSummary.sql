CREATE VIEW SalesLT.vw_CustomerOrderSummary
AS
select *,
    (select count(*) from SalesLT.SalesOrderDetail d where d.SalesOrderID = h.SalesOrderID) as ItemCount,
    (select sum(LineTotal) from SalesLT.SalesOrderDetail d where d.SalesOrderID = h.SalesOrderID) as ComputedTotal
from SalesLT.SalesOrderHeader h, SalesLT.Customer c
where h.CustomerID = c.CustomerID;
