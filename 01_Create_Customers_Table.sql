-- =============================================
-- Create Customers Table for Party Supply Company
-- Microsoft Fabric Warehouse Compatible
-- =============================================
-- Customers include both retail shops and event organisers
-- who purchase party supplies for resale or event planning
-- =============================================

-- Drop table if exists (for re-running script)
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;
GO

-- Create Customers Table
-- Note: PRIMARY KEY constraints cannot be defined inline in Fabric Warehouse CREATE TABLE
-- Note: DATETIME2 requires precision specification (0-6) in Fabric Warehouse
CREATE TABLE dbo.Customers (
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(200) NOT NULL,
    CustomerType VARCHAR(50) NOT NULL, -- 'Shop' or 'Event Organiser'
    ContactPerson VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    AddressLine1 VARCHAR(200),
    AddressLine2 VARCHAR(200),
    City VARCHAR(100),
    County VARCHAR(100),
    PostCode VARCHAR(20),
    Country VARCHAR(100),
    DateRegistered DATETIME2(3) NOT NULL,
    IsActive BIT NOT NULL,
    CreditLimit DECIMAL(10,2),
    Notes VARCHAR(500)
);
GO

-- Add Primary Key constraint after table creation
ALTER TABLE dbo.Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY NONCLUSTERED (CustomerID) NOT ENFORCED;
GO

-- Insert 10 rows of realistic customer data
INSERT INTO dbo.Customers (
    CustomerID, 
    CustomerName, 
    CustomerType, 
    ContactPerson, 
    Email, 
    Phone, 
    AddressLine1, 
    AddressLine2, 
    City, 
    County, 
    PostCode, 
    Country, 
    DateRegistered, 
    IsActive, 
    CreditLimit, 
    Notes
)
VALUES
-- Retail Shops (Party Supply Stores)
(1, 
 'Party Paradise Ltd', 
 'Shop', 
 'Sarah Mitchell', 
 'sarah.mitchell@partyparadise.co.uk', 
 '020 7946 0123', 
 '45-47 High Street', 
 NULL, 
 'London', 
 'Greater London', 
 'SW1A 1AA', 
 'United Kingdom', 
 '2024-01-15', 
 1, 
 5000.00, 
 'Large retail store, orders weekly'),

(2, 
 'Celebration Station', 
 'Shop', 
 'James O''Connor', 
 'james@celebrationstation.co.uk', 
 '0161 496 0234', 
 '12 Market Square', 
 NULL, 
 'Manchester', 
 'Greater Manchester', 
 'M1 1AD', 
 'United Kingdom', 
 '2024-02-20', 
 1, 
 3500.00, 
 'Medium-sized shop, specializes in children''s parties'),

(3, 
 'The Party Shop Birmingham', 
 'Shop', 
 'Emma Thompson', 
 'emma.t@partyshopbham.co.uk', 
 '0121 496 0345', 
 '78 Bull Street', 
 'City Centre', 
 'Birmingham', 
 'West Midlands', 
 'B4 6AF', 
 'United Kingdom', 
 '2023-11-10', 
 1, 
 4000.00, 
 'Established customer, excellent payment record'),

(4, 
 'Balloons & More Edinburgh', 
 'Shop', 
 'Fiona MacLeod', 
 'fiona@balloonsmore.scot', 
 '0131 496 0456', 
 '23 Princes Street', 
 NULL, 
 'Edinburgh', 
 'Midlothian', 
 'EH2 2ER', 
 'United Kingdom', 
 '2024-03-05', 
 1, 
 2500.00, 
 'Focus on balloon decorations and themed parties'),

(5, 
 'Festive Supplies Cardiff', 
 'Shop', 
 'David Evans', 
 'david@festivesupplies.wales', 
 '029 2046 0567', 
 '156 Queen Street', 
 NULL, 
 'Cardiff', 
 'South Glamorgan', 
 'CF10 2BH', 
 'United Kingdom', 
 '2024-01-28', 
 1, 
 3000.00, 
 'New customer, growing rapidly'),

-- Event Organisers
(6, 
 'Premier Events Ltd', 
 'Event Organiser', 
 'Charlotte Williams', 
 'charlotte@premierevents.co.uk', 
 '020 7946 0678', 
 '100 Oxford Street', 
 'Suite 5', 
 'London', 
 'Greater London', 
 'W1D 1LL', 
 'United Kingdom', 
 '2023-09-12', 
 1, 
 10000.00, 
 'Large corporate events, high volume orders'),

(7, 
 'Dream Weddings & Events', 
 'Event Organiser', 
 'Sophie Bennett', 
 'sophie@dreamweddings.co.uk', 
 '01273 555 0789', 
 '45 Preston Road', 
 NULL, 
 'Brighton', 
 'East Sussex', 
 'BN1 4QF', 
 'United Kingdom', 
 '2024-02-14', 
 1, 
 7500.00, 
 'Wedding specialist, orders seasonal'),

(8, 
 'Kids Party Magic', 
 'Event Organiser', 
 'Rachel Green', 
 'rachel@kidspartymagic.co.uk', 
 '0117 496 0890', 
 '67 Park Street', 
 NULL, 
 'Bristol', 
 'Bristol', 
 'BS1 5PB', 
 'United Kingdom', 
 '2023-12-01', 
 1, 
 4500.00, 
 'Children''s party entertainment, regular customer'),

(9, 
 'Corporate Celebrations Co', 
 'Event Organiser', 
 'Michael Brown', 
 'michael.brown@corpcelebrations.co.uk', 
 '0113 496 0901', 
 '25 City Square', 
 'Floor 3', 
 'Leeds', 
 'West Yorkshire', 
 'LS1 2AG', 
 'United Kingdom', 
 '2024-01-20', 
 1, 
 8500.00, 
 'B2B events, team building, conferences'),

(10, 
 'Elegant Affairs Event Planning', 
 'Event Organiser', 
 'Victoria Clarke', 
 'victoria@elegantaffairs.co.uk', 
 '01865 555 1012', 
 '89 High Street', 
 NULL, 
 'Oxford', 
 'Oxfordshire', 
 'OX1 4BG', 
 'United Kingdom', 
 '2023-10-30', 
 1, 
 6000.00, 
 'Upscale events, galas, charity functions');
GO

-- Verify data insertion
SELECT 
    CustomerID,
    CustomerName,
    CustomerType,
    ContactPerson,
    City,
    PostCode,
    CreditLimit,
    DateRegistered
FROM dbo.Customers
ORDER BY CustomerType, CustomerName;
GO

-- Summary statistics
SELECT 
    CustomerType,
    COUNT(*) AS CustomerCount,
    SUM(CreditLimit) AS TotalCreditLimit,
    AVG(CreditLimit) AS AvgCreditLimit
FROM dbo.Customers
GROUP BY CustomerType;
GO