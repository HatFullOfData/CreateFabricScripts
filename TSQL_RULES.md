# T-SQL Rules for Microsoft Fabric Warehouse

## Overview

This document outlines the T-SQL restrictions and limitations when writing SQL for Microsoft Fabric Warehouse. Unlike traditional SQL Server or Azure Synapse, Fabric Warehouse has a reduced T-SQL surface area optimized for cloud-native scalability and performance.

## ⚠️ Critical Limitations

### Unsupported Commands & Features

#### Data Modification
- ❌ **MERGE**: Not supported - use INSERT, UPDATE, DELETE separately
- ❌ **BULK LOAD**: Not available
- ❌ **TRIGGERS**: Not supported at all
- ❌ **PREDICT**: Machine learning predictions not available

#### Schema Management
- ❌ **IDENTITY Columns**: Not natively supported
  - ✅ **Workaround**: Use `ROW_NUMBER()` or `NEWID()` for surrogate keys
- ❌ **Materialized Views**: Not supported
- ❌ **Synonyms**: Not available
- ⚠️ **ALTER TABLE**: Limited support
  - ✅ Allowed: Adding/dropping nullable columns
  - ✅ Allowed: Adding/dropping non-enforced constraints
  - ❌ Not Allowed: Complex alterations

#### Query Features
- ❌ **Recursive Queries (CTEs with recursion)**: Not supported
- ❌ **FOR JSON in subqueries**: Not allowed
- ❌ **FOR XML in subqueries**: Not allowed

#### Statistics & Optimization
- ❌ **Manual Statistics**: Only automatic statistics available
- ❌ **Manual creation/update**: Not allowed
- ❌ **sp_showspaceused**: Not available

#### Session & Transaction Control
- ❌ **SET ROWCOUNT**: Not supported
- ❌ **SET TRANSACTION ISOLATION LEVEL**: Cannot be explicitly set
- ℹ️ Default isolation: **Snapshot Isolation (SI)**

#### Security & Users
- ❌ **CREATE USER**: Not supported via T-SQL
- ❌ User management done through Fabric workspace security

---

## 📊 Data Type Restrictions

### ✅ Supported Data Types
- `INT`, `BIGINT`, `SMALLINT`, `TINYINT`
- `DECIMAL`, `NUMERIC`
- `FLOAT`, `REAL`
- `DATE`, `DATETIME2`, `TIME`
- `VARCHAR`, `CHAR`
- `VARBINARY`, `BINARY`
- `BIT`
- `UNIQUEIDENTIFIER`

### ❌ Unsupported Data Types
- ❌ `MONEY`, `SMALLMONEY` → Use `DECIMAL` instead
- ❌ `NCHAR`, `NVARCHAR` → Use `VARCHAR` instead
- ❌ `TEXT`, `NTEXT` → Use `VARCHAR(MAX)` instead
- ❌ `IMAGE` → Use `VARBINARY(MAX)` instead
- ❌ `DATETIME`, `SMALLDATETIME` → Use `DATETIME2` instead
- ❌ `TIMESTAMP`/`ROWVERSION` → Not available

---

## 🔒 Constraints & Keys

### Primary Keys
- ✅ Supported with `NOT ENFORCED` clause
```sql
CREATE TABLE Products (
    ProductID INT NOT NULL,
    ProductName VARCHAR(100),
    CONSTRAINT PK_Products PRIMARY KEY NONCLUSTERED (ProductID) NOT ENFORCED
);
```

### Foreign Keys
- ⚠️ Supported with `NOT ENFORCED` clause only
- ⚠️ **Warning**: Adding foreign keys blocks further schema changes until removed
```sql
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) NOT ENFORCED;
```

### Check Constraints
- ⚠️ Must be `NOT ENFORCED`

### Unique Constraints
- ⚠️ Must be `NOT ENFORCED`

---

## 🗂️ Temporary Tables

### ✅ Supported
- **Session-scoped temp tables**: `#TempTable`
```sql
CREATE TABLE #TempSales (
    SaleID INT,
    Amount DECIMAL(10,2)
);
```

### ❌ Not Supported
- Global temp tables: `##GlobalTemp`
- Manual temp table management with specific database options

---

## 📝 Naming Conventions

### Schema & Table Names
- ❌ **Cannot contain**: `/` (forward slash)
- ❌ **Cannot contain**: `\` (backslash)
- ✅ Use alphanumeric and underscores only

```sql
-- ❌ Invalid
CREATE TABLE Sales/Data (ID INT);

-- ✅ Valid
CREATE TABLE Sales_Data (ID INT);
```

---

## 🔄 Concurrency & Transactions

### Default Behavior
- **Snapshot Isolation (SI)** is the default and only isolation level
- No fine-grained locking control
- Optimized for high-read, analytical workloads

### Implications
- ⚠️ Different behavior from traditional SQL Server
- ⚠️ Limited support for high-concurrency OLTP patterns
- ✅ Better for analytical and reporting workloads

---

## 📖 SQL Analytics Endpoint vs Warehouse

### SQL Analytics Endpoint (Read-Only)
- ❌ **No DML**: No INSERT, UPDATE, DELETE
- ❌ **No DDL**: No CREATE, ALTER, DROP
- ✅ **Read-only queries** on Lakehouse Delta tables
- ✅ SELECT queries only

### Warehouse (Full DML/DDL)
- ✅ Full INSERT, UPDATE, DELETE support
- ✅ CREATE, ALTER (limited), DROP support
- ✅ Stored procedures, views, functions
- Use this for data modifications

---

## 🛠️ Workarounds & Best Practices

### 1. Replacing IDENTITY Columns
```sql
-- ❌ Not Supported
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1),
    CustomerID INT
);

-- ✅ Workaround: Use ROW_NUMBER in a view or during INSERT
CREATE TABLE Orders (
    OrderID INT NOT NULL,
    CustomerID INT
);

-- Generate IDs during insert
INSERT INTO Orders (OrderID, CustomerID)
SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + (SELECT ISNULL(MAX(OrderID), 0) FROM Orders),
       CustomerID
FROM SourceTable;
```

### 2. Replacing MERGE
```sql
-- ❌ Not Supported
MERGE INTO Target USING Source ON ...;

-- ✅ Workaround: Separate UPDATE and INSERT
UPDATE Target
SET Target.Column = Source.Column
FROM Target
INNER JOIN Source ON Target.ID = Source.ID;

INSERT INTO Target
SELECT * FROM Source
WHERE NOT EXISTS (SELECT 1 FROM Target WHERE Target.ID = Source.ID);
```

### 3. Using Modern Data Types
```sql
-- ❌ Avoid
CREATE TABLE Products (
    Price MONEY,
    Description NVARCHAR(100),
    CreateDate DATETIME
);

-- ✅ Use Instead
CREATE TABLE Products (
    Price DECIMAL(18,2),
    Description VARCHAR(100),
    CreateDate DATETIME2
);
```

---

## 🌍 Regional Limitations

- ❌ **Cross-region connections**: Not supported
- ⚠️ Source and target must be in the **same geographical region**
- Applies to data integration and connection tasks

---

## ✅ General Best Practices

1. **Always specify NOT ENFORCED** for constraints
2. **Use DATETIME2** instead of DATETIME
3. **Use DECIMAL** instead of MONEY
4. **Use VARCHAR** instead of NVARCHAR (unless Unicode required)
5. **Avoid recursive CTEs** - redesign queries with iterative approaches
6. **Design for analytical workloads** - Fabric Warehouse is optimized for reporting, not OLTP
7. **Test schema changes carefully** - some operations block further modifications
8. **Use automatic statistics** - manual stats management not available
9. **Leverage temp tables (#)** for intermediate results
10. **Plan surrogate keys without IDENTITY** - use sequences or ROW_NUMBER patterns

---

## 📚 Additional Resources

- [Microsoft Learn: T-SQL Surface Area in Fabric Data Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/tsql-surface-area)
- [Microsoft Learn: Limitations of Fabric Data Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/limitations)
- [Microsoft Fabric Documentation](https://learn.microsoft.com/en-us/fabric/)

---

## 🔄 Document Version

**Last Updated**: 2026-02-26 14:41:31  
**Fabric Version**: Current as of February 2026

> **Note**: Microsoft Fabric is continuously evolving. Check official documentation for the latest updates and feature additions.