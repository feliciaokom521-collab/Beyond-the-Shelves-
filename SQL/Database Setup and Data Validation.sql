CREATE DATABASE beyond_the_shelves;

USE  beyond_the_shelves; ;

SELECT DATABASE ();
SHOW TABLES;

CREATE TABLE DimCategory (
CategoryID INT PRIMARY KEY, 
CategoryName VARCHAR (100) NOT NULL,
CategoryDescription VARCHAR (255)
);

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    `Day` TINYINT,
    MonthNumber TINYINT,
    MonthName VARCHAR(20),
    `Quarter` TINYINT,
    `Year` SMALLINT,
    DayOfWeek VARCHAR(20),
    IsWeekend VARCHAR(5),
    SeasonPeriod VARCHAR(50)
);

CREATE TABLE DimDistributionCentre (
    DistributionCentreID INT PRIMARY KEY,
    DistributionCentreName VARCHAR(150),
    State VARCHAR(50),
    CentreType VARCHAR(50),
    DistributionCentreStatus VARCHAR(30)
);

CREATE TABLE DimSupplier (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(150),
    SupplierState VARCHAR(50),
    StandardLeadTimeDays INT,
    SupplierTier VARCHAR(50),
    SupplierStatus VARCHAR(30)
);

CREATE TABLE DimStore (
    StoreID INT PRIMARY KEY,
    StoreName VARCHAR(150),
    State VARCHAR(50),
    GeopoliticalZone VARCHAR(50),
    StoreType VARCHAR(50),
    DistributionCentreID INT,
    StoreOpeningDate DATE,
    StoreStatus VARCHAR(30)
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(150),
    CategoryID INT,
    Brand VARCHAR(100),
    UnitCostNGN DECIMAL(12,2),
    UnitPriceNGN DECIMAL(12,2),
    SupplierID INT,
    ShelfLifeDays INT NULL,
    IsPerishable VARCHAR(5),
    ProductStatus VARCHAR(30),
    DemandClass VARCHAR(30)
);

CREATE TABLE DimInventoryPolicy (
    PolicyID INT PRIMARY KEY,
    ProductID INT,
    StoreID INT,
    EffectiveStartDate DATE,
    EffectiveEndDate DATE NULL,
    ReorderPoint INT,
    SafetyStock INT,
    MaximumStock INT,
    TargetServiceLevel DECIMAL(5,2),
    HoldingCostRateAnnual DECIMAL(5,2)
);

CREATE TABLE DimLocation (
    LocationID INT PRIMARY KEY,
    LocationName VARCHAR(150),
    LocationType VARCHAR(50),
    State VARCHAR(50),
    GeopoliticalZone VARCHAR(50),
    StoreID INT NULL,
    DistributionCentreID INT NULL,
    LocationStatus VARCHAR(30)
);

-- FACTS
CREATE TABLE FactPurchaseOrderLine (
    PurchaseOrderLineID INT PRIMARY KEY,
    PurchaseOrderID VARCHAR(30),
    ProductID INT,
    SupplierID INT,
    DestinationLocationID INT,
    OrderDateKey INT,
    ExpectedDeliveryDate DATE,
    OrderedQuantity INT,
    UnitPurchaseCostNGN DECIMAL(12,2),
    OrderStatus VARCHAR(30)
);

CREATE TABLE FactDeliveryLine (
    DeliveryLineID INT PRIMARY KEY,
    PurchaseOrderLineID INT,
    DeliveryDate DATE,
    QuantityDelivered INT,
    QuantityRejected INT,
    DeliveryStatus VARCHAR(30)
);

CREATE TABLE FactDemand (
    DemandRecordID INT PRIMARY KEY,
    DateKey INT,
    ProductID INT,
    StoreID INT,
    PotentialDemandUnits INT,
    FulfilledUnits INT,
    UnfulfilledUnits INT,
    UnitSellingPriceNGN DECIMAL(12,2)
);

CREATE TABLE FactInventoryMovement (
    MovementID INT PRIMARY KEY,
    DateKey INT,
    ProductID INT,
    LocationID INT,
    MovementType VARCHAR(50),
    QuantityChange INT,
    ReferenceID VARCHAR(30),
    MovementReason VARCHAR(200)
);

CREATE TABLE FactInventorySnapshot (
    InventorySnapshotID INT PRIMARY KEY,
    DateKey INT,
    ProductID INT,
    StoreID INT,
    OpeningStock INT,
    QuantityReceived INT,
    UnitsSold INT,
    NetAdjustments INT,
    ClosingStock INT,
    UnitCostNGN DECIMAL(12,2),
    ClosingInventoryValueNGN DECIMAL(16,2),
    StockoutFlag TINYINT,
    DemandObservedFlag TINYINT
);

CREATE TABLE FactSales (
    SalesLineID INT PRIMARY KEY,
    TransactionID VARCHAR(30),
    DateKey INT,
    ProductID INT,
    StoreID INT,
    QuantitySold INT,
    UnitSellingPriceNGN DECIMAL(12,2),
    DiscountAmountNGN DECIMAL(12,2),
    UnitCostNGN DECIMAL(12,2),
    GrossSalesNGN DECIMAL(14,2),
    NetSalesNGN DECIMAL(14,2),
    COGSNGN DECIMAL(14,2)
);


USE beyond_the_shelves;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/DimInventoryPolicy.csv'
INTO TABLE diminventorypolicy
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(PolicyID, ProductID, StoreID, EffectiveStartDate, @EndDate, ReorderPoint,
 SafetyStock, MaximumStock, TargetServiceLevel, HoldingCostRateAnnual)
SET EffectiveEndDate = NULLIF(@EndDate, '');

SELECT COUNT(*) AS total_rows,
       SUM(EffectiveEndDate IS NULL) AS blank_end_dates
FROM beyond_the_shelves.DimInventoryPolicy;

SELECT DATABASE ();
SHOW TABLES;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/DimInventoryPolicy.csv'
INTO TABLE beyond_the_shelves.DimInventoryPolicy
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(PolicyID, ProductID, StoreID, EffectiveStartDate, @EndDate, ReorderPoint,
 SafetyStock, MaximumStock, TargetServiceLevel, HoldingCostRateAnnual)
SET EffectiveEndDate = NULLIF(@EndDate, '');

SELECT COUNT(*)
FROM beyond_the_shelves.diminventorypolicy;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/DimProduct.csv'
INTO TABLE beyond_the_shelves.DimProduct
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ProductID, ProductName, CategoryID, Brand, UnitCostNGN, UnitPriceNGN,
SupplierID, @ShelfLifeDays, IsPerishable, ProductStatus, DemandClass)
SET ShelfLifeDays = NULLIF(@ShelfLifeDays, '');

SELECT COUNT(*) AS total_rows,
 SUM(ShelfLifeDays IS NULL) AS blank_shelflife
 FROM beyond_the_shelves.dimproduct;
 
 SELECT 'DimDistributionCentre' AS tbl, COUNT(*) AS total_rows FROM beyond_the_shelves.DimDistributionCentre
UNION ALL SELECT 'DimSupplier', COUNT(*) FROM beyond_the_shelves.DimSupplier
UNION ALL SELECT 'DimStore', COUNT(*) FROM beyond_the_shelves.DimStore
UNION ALL SELECT 'DimProduct', COUNT(*) FROM beyond_the_shelves.DimProduct;

SELECT count(*)
FROM beyond_the_shelves.dimcategory;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/DimSupplier.csv'
INTO TABLE beyond_the_shelves.DimSupplier
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(SupplierID, SupplierName, SupplierState, SupplierLeadTimeDay, SupplierTier, SupplierStaus);

SELECT count(*) AS row_now
FROM beyond_the_shelves.factinventorysnapshot;

TRUNCATE TABLE beyond_the_shelves.FactInventorySnapshot;

SET GLOBAL local_Infile = 1;
SELECT @@local_infile;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/FactInventorySnapshot.csv'
INTO TABLE beyond_the_shelves.FactInventorySnapshot
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(InventorySnapshotID, DateKey, ProductID, StoreID, OpeningStock, QuantityReceived,
 UnitsSold, NetAdjustments, ClosingStock, UnitCostNGN, ClosingInventoryValueNGN,
 StockoutFlag, DemandObservedFlag);
 
 SELECT COUNT(*) AS total_rows FROM beyond_the_shelves.FactInventorySnapshot;
 
 
 SELECT 'DimDate' AS tbl, COUNT(*) AS total_rows FROM beyond_the_shelves.DimDate
 UNION ALL SELECT 'DimCategory', COUNT(*) FROM beyond_the_shelves.DimCategory
UNION ALL SELECT 'DimDistributionCentre', COUNT(*) FROM beyond_the_shelves.DimDistributionCentre
UNION ALL SELECT 'DimIventory', COUNT(*) FROM beyond_the_shelves.DimIventoryPolicy
UNION ALL SELECT 'DimSupplier', COUNT(*) FROM beyond_the_shelves.DimSupplier
UNION ALL SELECT 'DimStore', COUNT(*) FROM beyond_the_shelves.DimStore
UNION ALL SELECT 'DimProduct', COUNT(*) FROM beyond_the_shelves.DimProduct
UNION ALL SELECT 'DimLocation', COUNT(*) FROM beyond_the_shelves.DimLocation
UNION ALL SELECT 'FactPurchaseOrderLine', COUNT(*) FROM beyond_the_shelves.FactPurchaseOrderLine
UNION ALL SELECT 'FactDeliveryLine', COUNT(*) FROM beyond_the_shelves.FactDeliveryLine
UNION ALL SELECT 'FactDemand', COUNT(*) FROM beyond_the_shelves.FactDemand
UNION ALL SELECT 'FactInventoryMovement', COUNT(*) FROM beyond_the_shelves.FactInventoryMovement
UNION ALL SELECT 'FactSales', COUNT(*) FROM beyond_the_shelves.FactSales;

SELECT 'DimCategory' AS tbl, COUNT(*) AS total_rows FROM beyond_the_shelves.DimCategory
UNION ALL SELECT 'DimDate', COUNT(*) FROM beyond_the_shelves.DimDate
UNION ALL SELECT 'DimDistributionCentre', COUNT(*) FROM beyond_the_shelves.DimDistributionCentre
UNION ALL SELECT 'DimInventoryPolicy', COUNT(*) FROM beyond_the_shelves.DimInventoryPolicy
UNION ALL SELECT 'DimLocation', COUNT(*) FROM beyond_the_shelves.DimLocation
UNION ALL SELECT 'DimProduct', COUNT(*) FROM beyond_the_shelves.DimProduct
UNION ALL SELECT 'DimStore', COUNT(*) FROM beyond_the_shelves.DimStore
UNION ALL SELECT 'DimSupplier', COUNT(*) FROM beyond_the_shelves.DimSupplier
UNION ALL SELECT 'FactDeliveryLine', COUNT(*) FROM beyond_the_shelves.FactDeliveryLine
UNION ALL SELECT 'FactDemand', COUNT(*) FROM beyond_the_shelves.FactDemand
UNION ALL SELECT 'FactInventoryMovement', COUNT(*) FROM beyond_the_shelves.FactInventoryMovement
UNION ALL SELECT 'FactInventorySnapshot', COUNT(*) FROM beyond_the_shelves.FactInventorySnapshot
UNION ALL SELECT 'FactPurchaseOrderLine', COUNT(*) FROM beyond_the_shelves.FactPurchaseOrderLine
UNION ALL SELECT 'FactSales', COUNT(*) FROM beyond_the_shelves.FactSales;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/DimLocation.csv'
INTO TABLE beyond_the_shelves.DimLocation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(LocationID, LocationName, LocationType, State, GeopoliticalZone,
 @StoreID, @DCID, LocationStatus)
SET StoreID = IF(@StoreID = '', NULL, CAST(@StoreID AS DECIMAL(10,0))),
    DistributionCentreID = IF(@DCID = '', NULL, CAST(@DCID AS DECIMAL(10,0)));
    
    SELECT COUNT(*) AS total_rows,
       SUM(StoreID IS NULL) AS no_store,
       SUM(DistributionCentreID IS NULL) AS no_dc
FROM beyond_the_shelves.DimLocation;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/FactPurchaseOrderLine.csv'
INTO TABLE beyond_the_shelves.FactPurchaseOrderLine
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(PurchaseOrderLineID, PurchaseOrderID, ProductID, SupplierID, DestinationLocationID,
 OrderDateKey, @ExpDate, OrderedQuantity, UnitPurchaseCostNGN, OrderStatus)
SET ExpectedDeliveryDate = NULLIF(@ExpDate, '');

SELECT COUNT(*) AS total_rows,
       SUM(ExpectedDeliveryDate IS NULL) AS no_expected_date
FROM beyond_the_shelves.FactPurchaseOrderLine;

TRUNCATE TABLE beyond_the_shelves.FactDeliveryLine;
SELECT COUNT(*) AS rows_now FROM beyond_the_shelves.FactDeliveryLine;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/FactDeliveryLine.csv'
INTO TABLE beyond_the_shelves.FactDeliveryLine
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DeliveryLineID, PurchaseOrderLineID, @DelDate, QuantityDelivered,
 QuantityRejected, DeliveryStatus)
SET DeliveryDate = NULLIF(@DelDate, '');

SHOW WARNINGS;

SELECT COUNT(*) AS total_rows 
FROM beyond_the_shelves.factdeliveryline;

SHOW WARNINGS;

SELECT COUNT(*) AS total_rows,
       SUM(DeliveryDate IS NULL) AS no_delivery_date,
       MIN(DeliveryDate) AS earliest,
       MAX(DeliveryDate) AS latest
FROM beyond_the_shelves.FactDeliveryLine;

SELECT *
FROM beyond_the_shelves.factdemand;

TRUNCATE TABLE beyond_the_shelves.FactDeliveryLine;
SELECT COUNT(*) AS rows_now FROM beyond_the_shelves.FactDeliveryLine;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/FactDeliveryLine.csv'
INTO TABLE beyond_the_shelves.FactDeliveryLine
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DeliveryLineID, PurchaseOrderLineID, @DelDate, QuantityDelivered,
 QuantityRejected, DeliveryStatus)
SET DeliveryDate = IF(@DelDate = '', NULL, STR_TO_DATE(@DelDate, '%m/%d/%Y'));

SELECT COUNT(*) AS total_rows,
       SUM(DeliveryDate IS NULL) AS no_delivery_date,
       MIN(DeliveryDate) AS earliest,
       MAX(DeliveryDate) AS latest
FROM beyond_the_shelves.FactDeliveryLine;

SELECT MIN(ExpectedDeliveryDate) AS earliest, MAX(ExpectedDeliveryDate) AS latest
FROM beyond_the_shelves.FactPurchaseOrderLine;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Desktop/BTS PROJECT/clean_data/FactSales.csv'
INTO TABLE beyond_the_shelves.FactSales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(SalesLineID, TransactionID, DateKey, ProductID, StoreID, QuantitySold,
 UnitSellingPriceNGN, DiscountAmountNGN, UnitCostNGN, GrossSalesNGN,
 NetSalesNGN, COGSNGN);
 
 SELECT COUNT(*) AS total_rows,
       MIN(DateKey) AS earliest,
       MAX(DateKey) AS latest,
       SUM(NetSalesNGN) AS total_net_sales
FROM beyond_the_shelves.FactSales;

SELECT COUNT(*) AS total_rows,
MAX(SalesLineID) AS latest_id
FROM beyond_the_shelves.FactSales;

SELECT MIN(ExpectedDeliveryDate) AS earliest,
MAX(ExpectedDeliveryDate) AS latest
FROM beyond_the_shelves.factpurchaseorderline;


SELECT 'DimDate' AS tbl,
MIN(FullDate) AS earliest,
MAX(FullDate) AS latest
FROM beyond_the_shelves.dimdate
UNION ALL SELECT 'DimStore', 
MIN(StoreOpeningDate),
MAX(StoreOpeningDate)
FROM beyond_the_shelves.dimstore
UNION ALL SELECT 'diminventorypolicy',
MIN(EffectiveStartDate),
MAX(EffectiveStartDate)
FROM beyond_the_shelves.diminventorypolicy;

SELECT COUNT(*) AS orphan_sales
FROM beyond_the_shelves.factsales s
LEFT JOIN beyond_the_shelves.dimproduct p ON s. ProductID
WHERE p. ProductID IS NULL;

SELECT COUNT(*) AS orphan_sales_stores
FROM beyond_the_shelves.factsales s
LEFT JOIN beyond_the_shelves.dimstore st ON s. StoreID = st. StoreID
WHERE st. StoreID IS NULL;

SHOW TABLES;
DESCRIBE dimcategory;

SELECT
TABLE_NAME,
COLUMN_NAME,
COLUMN_TYPE,
IS_NULLABLE,
COLUMN_KEY,
ORDINAL_POSITION
FROM INFORMATION_SCHEMA . COLUMNS
WHERE TABLE_SCHEMA = DATABASE ()
ORDER BY 
TABLE_NAME, 
ORDINAL_POSITION;

SELECT *
FROM factinventorysnapshot
LIMIT 10;

SELECT 
Datekey,
ProductID,
StoreID,
COUNT(*) AS RecordCount
FROM factinventorysnapshot
GROUP BY
Datekey,
ProductID,
StoreID
HAVING COUNT(*) >1;

SELECT 
COUNT(*) AS TotalRecords,
COUNT(DISTINCT DateKey) AS UniqueDates,
 COUNT(DISTINCT ProductID) AS UniqueProducts,
 COUNT(DISTINCT StoreID) AS UniqueStores,
 COUNT(DISTINCT CONCAT(DateKey, '-', ProductID, '-', StoreID)) AS UniqueCombinations
 FROM factinventorysnapshot;
 
 SELECT 
 COUNT(*) AS Total_Records,
 SUM(
 CASE
      WHEN ClosingStock = 
      OpeningStock
      + QuantityReceived
      + NetAdjustments
      - UnitsSold
      THEN 1
      ELSE 0
      END
      ) AS ReconcileRecords,
	  SUM(
 CASE
      WHEN ClosingStock <>
      OpeningStock
      + QuantityReceived
      + NetAdjustments
      - UnitsSold
      THEN 1
      ELSE 0
      END
      ) AS UnreconcileRecords
      FROM factinventorysnapshot;
      
      SELECT
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS MissingDateKey,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS MissingProductID,
    SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS MissingStoreID,
    SUM(CASE WHEN OpeningStock IS NULL THEN 1 ELSE 0 END) AS MissingOpeningStock,
    SUM(CASE WHEN QuantityReceived IS NULL THEN 1 ELSE 0 END) AS MissingQuantityReceived,
    SUM(CASE WHEN UnitsSold IS NULL THEN 1 ELSE 0 END) AS MissingUnitsSold,
    SUM(CASE WHEN ClosingStock IS NULL THEN 1 ELSE 0 END) AS MissingClosingStock
FROM FactInventorySnapshot;

SELECT
COUNT(*) AS 
UnmatchedProductRecords
FROM factinventorysnapshot AS fis
LEFT JOIN dimproduct AS dp
ON fis. ProductID = dp.ProductID
WHERE dp . ProductID IS NULL;

SELECT
COUNT(*) AS 
UnmatchedStoreRecords
FROM factinventorysnapshot AS fis
LEFT JOIN dimstore AS ds
ON fis. StoreID = ds.StoreID
WHERE ds . StoreID IS NULL;

SELECT
COUNT(*) AS 
UnmatchedDateKeyRecords
FROM factinventorysnapshot AS fis
LEFT JOIN dimdate AS dd
ON fis. DateKey = dd. DateKey
WHERE dd . DateKey IS NULL;

DESCRIBE factsales;


SELECT
COLUMN_NAME,
COLUMN_TYPE,
IS_NULLABLE,
COLUMN_KEY
FROM INFORMATION_SCHEMA . COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'FactSales'
ORDER BY ORDINAL_POSITION;

SELECT
    COUNT(*) AS TotalRecords,

    SUM(
        CASE
            WHEN ABS(
                GrossSalesNGN -
                (QuantitySold * UnitSellingPriceNGN)
            ) > 0.01
            THEN 1 ELSE 0
        END
    ) AS GrossSalesDiscrepancies,

    SUM(
        CASE
            WHEN ABS(
                NetSalesNGN -
                (GrossSalesNGN - DiscountAmountNGN)
            ) > 0.01
            THEN 1 ELSE 0
        END
    ) AS NetSalesDiscrepancies,

    SUM(
        CASE
            WHEN ABS(
                COGSNGN -
                (QuantitySold * UnitCostNGN)
            ) > 0.01
            THEN 1 ELSE 0
        END
    ) AS COGSDiscrepancies

FROM FactSales;


SELECT
    COUNT(*) AS TotalRecords,
    SUM(SalesLineID IS NULL) AS MissingSalesLineID,
    SUM(TransactionID IS NULL) AS MissingTransactionID,
    SUM(DateKey IS NULL) AS MissingDateKey,
    SUM(ProductID IS NULL) AS MissingProductID,
    SUM(StoreID IS NULL) AS MissingStoreID,
    SUM(QuantitySold IS NULL) AS MissingQuantitySold,
    SUM(UnitSellingPriceNGN IS NULL) AS MissingSellingPrice,
    SUM(DiscountAmountNGN IS NULL) AS MissingDiscount,
    SUM(UnitCostNGN IS NULL) AS MissingUnitCost,
    SUM(GrossSalesNGN IS NULL) AS MissingGrossSales,
    SUM(NetSalesNGN IS NULL) AS MissingNetSales,
    SUM(COGSNGN IS NULL) AS MissingCOGS
FROM FactSales;

SELECT
COUNT(*) AS UnmatchedRecors
FROM factsales AS fs
LEFT JOIN dimdate AS dd 
ON fs. DateKey = dd. DateKey
WHERE dd. DateKey IS NULL;

SELECT COUNT(*) AS TotalRecords,
COUNT(DISTINCT SalesLineID) AS UniqueSalesLineIDS,
COUNT(*) - COUNT(DISTINCT SalesLineID) AS DuplicateSalesLineIDs
FROM FactSales;

SELECT 
TransactionID,
COUNT(*) AS NumberOfSalesLines
FROM factsales
GROUP BY TransactionID
HAVING COUNT(*) > 1 
ORDER BY NumberOfSalesLines DESC
LIMIT 10;
