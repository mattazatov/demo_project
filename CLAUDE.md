# CLAUDE.md — SQL Code Review Guidelines

## Project Overview

This repository contains SQL scripts for a Microsoft Fabric SQL Database using the **SalesLT** schema (AdventureWorks Lightweight sample). The scripts define tables, views, stored procedures, and functions that support sales, product, and customer analytics.

## Repository Structure

```
/schemas        — Schema definitions
/tables         — Table DDL scripts (CREATE TABLE)
/views          — View definitions
/stored-procedures — Stored procedures
/functions      — User-defined functions
/migrations     — Incremental schema change scripts
```

Each `.sql` file should contain exactly one database object. File naming follows the pattern `SchemaName.ObjectName.sql` (e.g., `SalesLT.Product.sql`).

## Platform Constraints — Microsoft Fabric SQL Database

When reviewing SQL code, keep these Fabric-specific constraints in mind:

- **T-SQL only** — Fabric SQL Database supports T-SQL. No PL/SQL, MySQL, or PostgreSQL syntax.
- **No cross-database queries** — Fabric SQL databases are single-database scoped. Three-part names referencing other databases are not supported.
- **No CLR, linked servers, or SQL Agent jobs** — These traditional SQL Server features are unavailable in Fabric.
- **No native T-SQL encryption functions** — `ENCRYPTBYKEY`, `DECRYPTBYKEY`, etc. are not available. Flag any usage.
- **Limited system stored procedures** — Many `sp_` system procedures are unsupported. Flag reliance on them.
- **Delta format underneath** — Tables are stored as Delta Parquet. This affects partitioning and indexing strategies.

## SQL Coding Standards

### Naming Conventions

- **PascalCase** for all object names (tables, columns, views, procedures) — aligns with Power BI conventions.
- **Prefix views** with `vw_` (e.g., `vw_CustomerOrders`).
- **Prefix stored procedures** with `usp_` (e.g., `usp_GetTopCustomers`).
- **Prefix functions** with `fn_` (e.g., `fn_CalculateDiscount`).
- **No Hungarian notation** on columns — use `OrderDate` not `dtOrderDate`.

### Formatting

- **Uppercase SQL keywords** — `SELECT`, `FROM`, `WHERE`, `JOIN`, not `select`, `from`, `where`.
- **One column per line** in SELECT lists for readability.
- **Explicit column lists** — never use `SELECT *` in views, procedures, or production queries.
- **Always alias tables** in joins using meaningful short names, not single letters.
- **Terminate statements with semicolons.**

### Data Types

- Use `NVARCHAR` over `VARCHAR` when the column may contain Unicode data.
- Prefer `DATETIME2` over `DATETIME` for new date/time columns.
- Use `DECIMAL(p, s)` with explicit precision/scale for monetary values — never `FLOAT` or `MONEY`.

## Code Review Checklist

When reviewing pull requests, evaluate for:

### Correctness
- Does the query logic match the stated intent?
- Are JOIN conditions complete (no accidental cross joins)?
- Are WHERE clauses correct and not overly restrictive or permissive?
- Are NULLs handled properly (`IS NULL` / `COALESCE` / `ISNULL`)?

### Performance
- Flag `SELECT *` usage.
- Flag missing WHERE clauses on UPDATE/DELETE statements.
- Flag correlated subqueries that could be rewritten as JOINs or window functions.
- Flag DISTINCT used to mask a bad JOIN rather than fix the root cause.
- Flag implicit type conversions in JOIN or WHERE predicates.
- Recommend `EXISTS` over `IN` for subqueries returning large result sets.

### Security
- Flag dynamic SQL without parameterization (`sp_executesql` with parameters is acceptable; string concatenation of user input is not).
- Flag `GRANT` / `DENY` / `REVOKE` statements — these should be reviewed carefully.
- Flag any hardcoded credentials, connection strings, or secrets.

### Best Practices
- Every table should have a primary key defined.
- Foreign key relationships should be explicit where applicable.
- Default constraints and NOT NULL constraints should be intentional, not missing by accident.
- Stored procedures should include error handling (`TRY...CATCH`) for DML operations.
- Use `SET NOCOUNT ON` at the top of stored procedures.
- Include a header comment block on every object with purpose, author, and date.

### SalesLT Schema Awareness

The SalesLT schema contains these core entities — review for referential integrity:

- **SalesLT.Customer** — CustomerID (PK)
- **SalesLT.Address** — AddressID (PK)
- **SalesLT.CustomerAddress** — bridge table (CustomerID, AddressID)
- **SalesLT.Product** — ProductID (PK), linked to ProductCategory, ProductModel
- **SalesLT.ProductCategory** — ParentProductCategoryID (self-referencing hierarchy)
- **SalesLT.SalesOrderHeader** — SalesOrderID (PK), CustomerID (FK)
- **SalesLT.SalesOrderDetail** — SalesOrderID + SalesOrderDetailID (PK), ProductID (FK)

Flag any query that joins these tables incorrectly or misses a necessary join condition.

## Review Tone

- Be constructive and specific — explain *why* something is an issue, not just that it is.
- Suggest the corrected code when flagging a problem.
- Distinguish between **blocking issues** (must fix before merge) and **suggestions** (nice to have).
- Acknowledge good patterns when you see them.
