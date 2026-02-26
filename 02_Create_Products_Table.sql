-- =============================================
-- Create Products Table for Party Supply Company
-- Microsoft Fabric Warehouse Compatible
-- =============================================
-- Products include party supplies across multiple categories
-- No stock levels included (as requested)
-- =============================================

-- Drop table if exists (for re-running script)
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO

-- Create Products Table
-- Note: PRIMARY KEY constraints cannot be defined inline in Fabric Warehouse CREATE TABLE
-- Note: DATETIME2 requires precision specification (0-6) in Fabric Warehouse
CREATE TABLE dbo.Products (
    ProductID INT NOT NULL,
    ProductName VARCHAR(200) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Description VARCHAR(500),
    UnitPrice DECIMAL(10,2) NOT NULL,
    UnitOfMeasure VARCHAR(50),
    SupplierCode VARCHAR(50),
    SKU VARCHAR(50),
    IsActive BIT NOT NULL,
    DateAdded DATETIME2(3) NOT NULL,
    Notes VARCHAR(500)
);
GO

-- Add Primary Key constraint after table creation
ALTER TABLE dbo.Products
ADD CONSTRAINT PK_Products PRIMARY KEY NONCLUSTERED (ProductID) NOT ENFORCED;
GO

-- Insert realistic party supply product data
INSERT INTO dbo.Products (
    ProductID,
    ProductName,
    Category,
    Description,
    UnitPrice,
    UnitOfMeasure,
    SupplierCode,
    SKU,
    IsActive,
    DateAdded,
    Notes
)
VALUES
-- Balloons
(1, 'Latex Balloons - Assorted Colours (Pack of 50)', 'Balloons', 'High quality latex balloons in assorted bright colours', 12.99, 'Pack', 'SUPP001', 'BAL-LAT-50', 1, '2024-01-10', 'Best seller, popular for all events'),
(2, 'Foil Number Balloons - Gold (Each)', 'Balloons', 'Large foil number balloons, gold finish, 34 inch', 4.50, 'Each', 'SUPP001', 'BAL-NUM-GLD', 1, '2024-01-10', 'Available numbers 0-9'),
(3, 'Foil Number Balloons - Silver (Each)', 'Balloons', 'Large foil number balloons, silver finish, 34 inch', 4.50, 'Each', 'SUPP001', 'BAL-NUM-SLV', 1, '2024-01-10', 'Available numbers 0-9'),
(4, 'Heart Shaped Foil Balloons - Red (Pack of 10)', 'Balloons', 'Red heart shaped foil balloons, perfect for weddings', 15.99, 'Pack', 'SUPP001', 'BAL-HRT-RED', 1, '2024-01-15', 'Popular for Valentine''s Day and weddings'),
(5, 'Giant Round Balloon - Clear (36 inch)', 'Balloons', 'Giant clear latex balloon, can be filled with confetti', 8.99, 'Each', 'SUPP001', 'BAL-GNT-CLR', 1, '2024-01-15', 'Great for photo backdrops'),

-- Tableware
(6, 'Paper Plates - White (Pack of 100)', 'Tableware', 'Disposable paper plates, 9 inch diameter', 8.50, 'Pack', 'SUPP002', 'TAB-PLT-WHT', 1, '2024-01-12', 'Biodegradable option available'),
(7, 'Paper Cups - Assorted Colours (Pack of 50)', 'Tableware', 'Colourful paper cups, 250ml capacity', 6.99, 'Pack', 'SUPP002', 'TAB-CUP-AST', 1, '2024-01-12', 'Available in 8 colours'),
(8, 'Plastic Cutlery Set (Pack of 100)', 'Tableware', 'Complete cutlery set: forks, knives, spoons', 11.99, 'Pack', 'SUPP002', 'TAB-CUT-SET', 1, '2024-01-12', 'Recyclable plastic'),
(9, 'Paper Napkins - White (Pack of 100)', 'Tableware', '3-ply paper napkins, premium quality', 4.50, 'Pack', 'SUPP002', 'TAB-NAP-WHT', 1, '2024-01-12', 'Suitable for all events'),
(10, 'Party Tablecloth - Red (Each)', 'Tableware', 'Plastic tablecloth, 137cm x 274cm', 3.99, 'Each', 'SUPP002', 'TAB-CLT-RED', 1, '2024-01-18', 'Disposable, wipe-clean surface'),

-- Decorations
(11, 'Happy Birthday Banner - Gold', 'Decorations', 'Foil letter banner spelling Happy Birthday, gold', 9.99, 'Each', 'SUPP003', 'DEC-BAN-GLD', 1, '2024-01-20', 'Self-inflating, reusable'),
(12, 'Paper Pom Poms - Assorted (Pack of 10)', 'Decorations', 'Tissue paper pom poms in various sizes and colours', 14.99, 'Pack', 'SUPP003', 'DEC-POM-AST', 1, '2024-01-20', 'Easy to assemble'),
(13, 'Hanging Swirls - Silver (Pack of 12)', 'Decorations', 'Metallic hanging swirl decorations with stars', 7.50, 'Pack', 'SUPP003', 'DEC-SWL-SLV', 1, '2024-01-20', 'Great for ceilings'),
(14, 'Confetti - Metallic Mix (200g)', 'Decorations', 'Metallic confetti in gold, silver and rose gold', 5.99, 'Pack', 'SUPP003', 'DEC-CON-MET', 1, '2024-01-22', 'Biodegradable option'),
(15, 'Fairy Lights - Warm White (10m)', 'Decorations', 'Battery operated LED fairy lights, 100 bulbs', 12.99, 'Each', 'SUPP003', 'DEC-LGT-WWH', 1, '2024-01-22', 'Indoor and outdoor use'),

-- Themed Party Supplies
(16, 'Unicorn Party Pack', 'Themed Supplies', 'Complete unicorn themed party pack for 8 guests', 24.99, 'Pack', 'SUPP004', 'THM-UNI-PK8', 1, '2024-02-01', 'Includes plates, cups, napkins, decorations'),
(17, 'Superhero Party Pack', 'Themed Supplies', 'Superhero themed party pack for 8 guests', 24.99, 'Pack', 'SUPP004', 'THM-SUP-PK8', 1, '2024-02-01', 'Includes plates, cups, napkins, decorations'),
(18, 'Princess Party Pack', 'Themed Supplies', 'Princess themed party pack for 8 guests', 24.99, 'Pack', 'SUPP004', 'THM-PRI-PK8', 1, '2024-02-01', 'Includes plates, cups, napkins, decorations'),
(19, 'Dinosaur Party Pack', 'Themed Supplies', 'Dinosaur themed party pack for 8 guests', 24.99, 'Pack', 'SUPP004', 'THM-DIN-PK8', 1, '2024-02-01', 'Includes plates, cups, napkins, decorations'),
(20, 'Mermaid Party Pack', 'Themed Supplies', 'Mermaid themed party pack for 8 guests', 24.99, 'Pack', 'SUPP004', 'THM-MER-PK8', 1, '2024-02-01', 'Includes plates, cups, napkins, decorations'),

-- Party Bags and Favours
(21, 'Paper Party Bags - Assorted (Pack of 24)', 'Party Favours', 'Colourful paper party bags with handles', 6.99, 'Pack', 'SUPP005', 'FAV-BAG-AST', 1, '2024-02-05', 'Perfect for party favours'),
(22, 'Sticker Sheets - Assorted (Pack of 50)', 'Party Favours', 'Fun sticker sheets for party bag fillers', 8.99, 'Pack', 'SUPP005', 'FAV-STK-AST', 1, '2024-02-05', 'Various designs'),
(23, 'Mini Bubbles (Pack of 24)', 'Party Favours', 'Mini bubble bottles, 30ml each', 9.99, 'Pack', 'SUPP005', 'FAV-BUB-MIN', 1, '2024-02-05', 'Non-toxic formula'),
(24, 'Party Poppers (Pack of 20)', 'Party Favours', 'Celebration party poppers with streamers', 7.50, 'Pack', 'SUPP005', 'FAV-POP-20', 1, '2024-02-05', 'Safe for ages 8+'),
(25, 'Chocolate Coins - Gold Wrap (500g)', 'Party Favours', 'Chocolate coins in gold foil wrapping', 12.99, 'Pack', 'SUPP005', 'FAV-CHC-GLD', 1, '2024-02-05', 'Suitable for vegetarians'),

-- Candles
(26, 'Number Candles - Glitter (Each)', 'Candles', 'Large glitter number candles for birthday cakes', 2.99, 'Each', 'SUPP006', 'CAN-NUM-GLT', 1, '2024-02-10', 'Available numbers 0-9'),
(27, 'Spiral Birthday Candles (Pack of 24)', 'Candles', 'Colourful spiral birthday candles', 3.50, 'Pack', 'SUPP006', 'CAN-SPI-24', 1, '2024-02-10', 'Burns for approximately 10 minutes'),
(28, 'Sparkler Candles - Fountain (Pack of 6)', 'Candles', 'Indoor safe sparkler fountain candles', 5.99, 'Pack', 'SUPP006', 'CAN-SPK-FTN', 1, '2024-02-10', 'Creates spectacular fountain effect'),

-- Costumes and Accessories
(29, 'Party Hats - Cone Style (Pack of 12)', 'Accessories', 'Classic cone shaped party hats with elastic', 5.50, 'Pack', 'SUPP007', 'ACC-HAT-CON', 1, '2024-02-15', 'Assorted colours and patterns'),
(30, 'Feather Boa - Pink (Each)', 'Accessories', 'Fluffy feather boa, 180cm length', 8.99, 'Each', 'SUPP007', 'ACC-BOA-PNK', 1, '2024-02-15', 'Perfect for dress-up and photos');
GO

-- Verify data insertion
SELECT 
    ProductID,
    ProductName,
    Category,
    UnitPrice,
    SKU,
    IsActive
FROM dbo.Products
ORDER BY Category, ProductName;
GO

-- Summary statistics by category
SELECT 
    Category,
    COUNT(*) AS ProductCount,
    MIN(UnitPrice) AS MinPrice,
    MAX(UnitPrice) AS MaxPrice,
    AVG(UnitPrice) AS AvgPrice
FROM dbo.Products
WHERE IsActive = 1
GROUP BY Category
ORDER BY Category;
GO

-- List all active products with pricing
SELECT 
    ProductID,
    ProductName,
    Category,
    UnitPrice,
    UnitOfMeasure,
    SKU
FROM dbo.Products
WHERE IsActive = 1
ORDER BY Category, UnitPrice;
GO